# ==================== 配置非敏感环境变量 ====================

$env:ALIYUN_REGISTRY_DOMAIN     = "<aliyun_registry_domain>"
$env:ALIYUN_REGISTRY_SPACE_NAME = "<spacename>"
$env:LOCAL_REGISTRY_DIMAIN      = "<local_registry_domain>"



# ==================== 账号密码强制交互输入 ====================

$inputUser = Read-Host -Prompt "👤 请输入 Aliyun 私有仓库用户名"

if ([string]::IsNullOrWhiteSpace($inputUser)) {
    Write-Warning "🛑 未检测到用户名输入，脚本已安全终止！"
    return
}
$env:ALIYUN_USERNAME = $inputUser.Trim()


$secPass   = Read-Host -Prompt "🔐 请输入 Aliyun 私有仓库密码" -AsSecureString
$BSTR      = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secPass)
$inputPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

if ([string]::IsNullOrWhiteSpace($inputPass)) {
    Write-Warning "🛑 未检测到密码输入，脚本已安全终止！"
    $env:ALIYUN_USERNAME = $null
    return
}
$env:ALIYUN_PASSWORD = $inputPass


# ==================== 匹配并渲染所有 *.tmp 模板 ====================

$templateFiles = Get-ChildItem -Path "." -Filter "*.tmp" -File

if (-not $templateFiles) {
    Write-Warning "⚠️ 未找到任何 *.tmp 模版文件！"
    $env:ALIYUN_USERNAME = $null
    $env:ALIYUN_PASSWORD = $null
    return
}

$tempGeneratedFiles = [System.Collections.Generic.List[string]]::new()


try {
    foreach ($file in $templateFiles) {
        $outputFile = $file.FullName -replace '(\.yaml)?\.tmp$', '.yaml'
        
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # 替换 ${VAR} 环境变量
        $newContent = [regex]::Replace($content, '\$\{([^}]+)\}', {
            param($m)
            $val = [Environment]::GetEnvironmentVariable($m.Groups[1].Value)
            if ([string]::IsNullOrEmpty($val)) { $m.Value } else { $val }
        })

        # 精准匹配引号内的完整 Key/Value，完美保留版本号冒号
        if ($file.Name -like "*images*") {
            $prefix = $env:LOCAL_REGISTRY_DIMAIN
            $lines = $newContent -split '\r?\n'
            $processedLines = [System.Collections.Generic.List[string]]::new()

            foreach ($line in $lines) {
                $trimmed = $line.Trim()

                # 忽略 JSON 的大括号
                if ($trimmed -eq '{' -or $trimmed -eq '}') {
                    continue
                }

                # 保留空行和注释
                if ([string]::IsNullOrWhiteSpace($trimmed) -or $trimmed.StartsWith('#')) {
                    $processedLines.Add($line)
                    continue
                }

                # 优先匹配双引号包裹的 "Key": "Value"（完整提取包含冒号的 Tag）
                if ($trimmed -match '^\s*"([^"]+)"\s*:\s*"([^"]+)"\s*,?\s*$') {
                    $oldKey   = $Matches[1].Trim()
                    $oldVal   = $Matches[2].Trim()
                    $cleanKey = $oldKey -replace '^\/', ''
                    
                    $processedLines.Add("`"$oldVal`": `"$prefix/$cleanKey`"")
                } 
                # 兜底匹配无引号格式
                elseif ($trimmed -match '^\s*([^:\s]+(?::[^:\s]+)?)\s*:\s*(.+)$') {
                    $oldKey   = $Matches[1].Trim().Trim('"')
                    $oldVal   = $Matches[2].Trim().Trim('"').TrimEnd(',')
                    $cleanKey = $oldKey -replace '^\/', ''
                    
                    $processedLines.Add("`"$oldVal`": `"$prefix/$cleanKey`"")
                } else {
                    $processedLines.Add($line)
                }
            }

            $newContent = $processedLines -join "`r`n"
            Write-Host "🔄 已自动翻转 [$($file.Name)] 映射并追加前缀 [$prefix/] ！" -ForegroundColor Yellow
        }

        [System.IO.File]::WriteAllText($outputFile, $newContent, [System.Text.Encoding]::UTF8)
        $tempGeneratedFiles.Add($outputFile)
        Write-Host "⚙️ 已生成临时配置 ➜ [$([System.IO.Path]::GetFileName($outputFile))]" -ForegroundColor Cyan
    }

    # 智能识别 auth 和 images 配置文件路径
    $authFile   = $tempGeneratedFiles | Where-Object { $_ -like "*auth*" } | Select-Object -First 1
    $imagesFile = $tempGeneratedFiles | Where-Object { $_ -notlike "*auth*" } | Select-Object -First 1

    if (-not $authFile -or -not $imagesFile) {
        Write-Warning "❌ 无法自动识别配置文件！请确保模板文件名中包含 'auth'，另一个包含镜像列表。"
        return
    }

    # ==================== 打印预览 + 人工确认卡口 ====================
    Write-Host "`n📋 【临时镜像映射配置预览 ($([System.IO.Path]::GetFileName($imagesFile)))】" -ForegroundColor Magenta
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkGray
    Get-Content -Path $imagesFile -Encoding UTF8
    Write-Host "--------------------------------------------------------------------------------`n" -ForegroundColor DarkGray

    # 交互确认：输入 Y 或直接按 Enter 默认确认；输入 N 或其他字符终止
    $confirm = Read-Host -Prompt "❓ 确认上述映射无误并启动同步？[Y/n]"
    if ($confirm.Trim() -and $confirm.Trim() -notmatch '^[Yy]$') {
        Write-Warning "🛑 已取消同步！正在清理现场并安全退出..."
        return
    }

    # ==================== 调用 image-syncer ====================
    Write-Host "🚀 正在启动 image-syncer 开始镜像同步..." -ForegroundColor Green
    
    .\image-syncer.exe --proc=6 --auth="$authFile" --images="$imagesFile" --retries=1 --arch amd64 --os linux

} finally {
    # ==================== 用完即焚 (物理粉碎文件 + 内存清零) ====================
    foreach ($tempFile in $tempGeneratedFiles) {
        if (Test-Path $tempFile) {
            Remove-Item -Path $tempFile -Force
            Write-Host "🧹 痕迹清理完毕：已彻底抹除 ➜ [$([System.IO.Path]::GetFileName($tempFile))]" -ForegroundColor Yellow
        }
    }
    
    # 彻底擦除内存里的账号与密码
    $env:ALIYUN_USERNAME = $null
    $env:ALIYUN_PASSWORD = $null
}
