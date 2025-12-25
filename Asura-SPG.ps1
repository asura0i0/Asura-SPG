function Get-PasswordStrength($Password) {
    $pool = 0
    if ($Password -match '[a-z]') { $pool += 26 }
    if ($Password -match '[A-Z]') { $pool += 26 }
    if ($Password -match '[0-9]') { $pool += 10 }
    if ($Password -match '[@#$_-]') { $pool += 5 }

    if ($pool -eq 0) { $pool = 1 }
    $entropy = [math]::Round($Password.Length * [math]::Log($pool,2),1)

    if ($entropy -lt 50) {
        return @{ Label="Weak"; Color="Red"; Entropy=$entropy }
    } elseif ($entropy -lt 80) {
        return @{ Label="Medium"; Color="Yellow"; Entropy=$entropy }
    } else {
        return @{ Label="Strong"; Color="Green"; Entropy=$entropy }
    }
}

# ===== SIMPLE HEADER (NO ANIMATION) =====
function Show-Header {
    Clear-Host
    Write-Host "Asura{SPG}" -ForegroundColor Red
    Write-Host "Secure Password Generator" -ForegroundColor Yellow
    Write-Host "Made by Asura" -ForegroundColor Green
    Write-Host ""
}

# ===== PROGRESS BAR (STABLE) =====
function Show-Progress {
    $colors = @("Red","Yellow","Green")
    $total = 20

    for ($i = 1; $i -le $total; $i++) {
        $bar = "#" * $i
        $space = "." * ($total - $i)
        $color = $colors[[int](($i / $total) * ($colors.Count - 1))]

        Write-Host -NoNewline "`rGenerating password [$bar$space] $($i*5)%" -ForegroundColor $color
        Start-Sleep -Milliseconds 60
    }
    Write-Host ""
}

function Ask-YesNo($q) {
    while ($true) {
        Write-Host $q -ForegroundColor Cyan -NoNewline
        $a = Read-Host " "
        if ($a -match '^[Yy]$') { return $true }
        if ($a -match '^[Nn]$') { return $false }
        Write-Host "Enter Y or N only." -ForegroundColor Red
    }
}

function Mutate-Name($name,$useSymbols) {
    $name = ($name -replace '\s','')

    $map = @{
        'a'='@'; 's'='$'; 'o'='0'; 'e'='3'
    }

    $out = ""
    foreach ($c in $name.ToLower().ToCharArray()) {
        if ($useSymbols -and $map.ContainsKey($c)) {
            $char = $map[$c]
        } else {
            $char = $c
        }

        if (Get-Random -Minimum 0 -Maximum 2) {
            $char = $char.ToString().ToUpper()
        }
        $out += $char
    }

    if ($out.Length -gt 10) { $out = $out.Substring(0,10) }
    return $out
}

function New-Password($Site,$Length,$Rules) {
    $base = Mutate-Name $Site $Rules.Symbol

    $pool = ""
    if ($Rules.Lower)  { $pool += "abcdefghijklmnopqrstuvwxyz" }
    if ($Rules.Upper)  { $pool += "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    if ($Rules.Number) { $pool += "0123456789" }
    if ($Rules.Symbol) { $pool += "@#$_-" }

    if ($pool.Length -eq 0) { return "" }

    $pass = $base
    while ($pass.Length -lt $Length) {
        $pass += $pool[(Get-Random -Minimum 0 -Maximum $pool.Length)]
    }

    return ($pass -replace '\s','')
}

function asuragg {

    $Rules = @{
        Upper=$true
        Lower=$true
        Number=$true
        Symbol=$true
    }

    Show-Header

    Write-Host "Name" -ForegroundColor Cyan -NoNewline
    $site = Read-Host " "

    Write-Host "Password length" -ForegroundColor Cyan -NoNewline
    $length = [int](Read-Host " ")

    Show-Progress

    while ($true) {

        $password = New-Password $site $length $Rules
        $strength = Get-PasswordStrength $password

        Write-Host ""
        Write-Host "Password:" -ForegroundColor Green
        Write-Host " $password" -ForegroundColor Green
        Write-Host "Strength: $($strength.Label) ($($strength.Entropy) bits)" -ForegroundColor $strength.Color
        Write-Host ""

        Write-Host "[G]enerate again" -ForegroundColor Cyan -NoNewline
        Write-Host " | " -NoNewline
        Write-Host "[N]ew" -ForegroundColor Yellow -NoNewline
        Write-Host " | " -NoNewline
        Write-Host "[C]opy" -ForegroundColor Green -NoNewline
        Write-Host " | " -NoNewline
        Write-Host "[E]dit" -ForegroundColor Magenta

        $choice = Read-Host " "

        if ($choice -match '^[Gg]$') {
            Show-Progress
        }
        elseif ($choice -match '^[Cc]$') {
            $password | Set-Clipboard
            Write-Host "Copied to clipboard." -ForegroundColor Green
        }
        elseif ($choice -match '^[Nn]$') {
            asuragg
            return
        }
        elseif ($choice -match '^[Ee]$') {
            Write-Host ""
            Write-Host "Edit Rules" -ForegroundColor Magenta
            $Rules.Upper  = Ask-YesNo "Allow UPPERCASE letters? (Y/N): "
            $Rules.Lower  = Ask-YesNo "Allow lowercase letters? (Y/N): "
            $Rules.Number = Ask-YesNo "Allow numbers? (Y/N): "
            $Rules.Symbol = Ask-YesNo "Allow symbols? (Y/N): "
            Write-Host "Rules updated." -ForegroundColor Green
        }
        else {
            Write-Host "Invalid key! Use G, N, C, or E." -ForegroundColor Red
        }
    }
}

asuragg
