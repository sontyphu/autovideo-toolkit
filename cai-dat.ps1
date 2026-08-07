# Goi Cat + Giong - lop Autovideo (Windows)
# Chay bang 1 dong:
#   irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.ps1 | iex

$ErrorActionPreference = "Stop"

# Phien ban ghim, kiem chung tren may tac gia 07/08/2026.
$KHO_GOC   = "https://github.com/browser-use/video-use"
$BAN_GHIM  = "cf12ac35143caa48db76efa35b1cb439582333bb"
$KHO_COMBO = "https://github.com/sontyphu/autovideo-toolkit"

$DICH   = Join-Path $env:USERPROFILE "video-use"
$COMBO  = Join-Path $env:USERPROFILE "autovideo-toolkit"
$SKILL  = Join-Path $env:USERPROFILE ".claude\skills\video-use"
$SKILL_CU = Join-Path $env:USERPROFILE ".claude\skills\autovideo-toolkit"

# PowerShell 5.1 coi moi dong stderr cua lenh ngoai la LOI. uv/git in tien trinh
# ra stderr nen phai chay chung o che do "Continue" roi tu kiem ma tra ve.
function Chay-Ngoai {
    param([scriptblock]$Lenh)
    $cu = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try { & $Lenh 2>&1 | Out-Null; return $LASTEXITCODE }
    finally { $ErrorActionPreference = $cu }
}

# Ghi file .env KHONG CO BOM.
# `Set-Content -Encoding utf8` va `Out-File -Encoding utf8` cua PowerShell 5.1 chen
# 3 byte vo hinh vao dau file -> ten bien thanh "<BOM>ELEVENLABS_API_KEY", bo cong cu
# so sanh khong khop nen bao KHONG TIM THAY CHIA KHOA. Da gap that 08/08/2026.
function Ghi-Env {
    param([string]$DuongDan, [string]$NoiDung)
    $NoiDung = $NoiDung -replace "^﻿", ""
    [System.IO.File]::WriteAllText($DuongDan, $NoiDung, (New-Object System.Text.UTF8Encoding $false))
}

function Tieu-De($chu) { Write-Host "`n=== $chu ===" -ForegroundColor Cyan }
function Dat($chu)     { Write-Host "  [DAT] $chu" -ForegroundColor Green }
function Thieu($chu)   { Write-Host "  [THIEU] $chu" -ForegroundColor Yellow }
function Hong($chu)    { Write-Host "  [HONG] $chu" -ForegroundColor Red }
function Co-Lenh($ten) { $null -ne (Get-Command $ten -ErrorAction SilentlyContinue) }

Write-Host ""
Write-Host "  AUTOVIDEO TOOLKIT - GOI CAT VA GIONG" -ForegroundColor White
Write-Host "  Le Thanh Son" -ForegroundColor DarkGray
Write-Host ""

# ------------------------------------------------- 1. Ve vao lop
Tieu-De "Buoc 1/6 - Kiem dieu kien tien quyet"

$thieuGi = @()
if (Co-Lenh git)  { Dat "Git da co" }     else { $thieuGi += "Git - tai o git-scm.com" }
if (Co-Lenh node) { Dat "Node.js da co" } else { $thieuGi += "Node.js - tai o nodejs.org" }

if ($thieuGi.Count -gt 0) {
    Write-Host ""
    Hong "Thieu thanh phan bat buoc, khong the tiep tuc:"
    $thieuGi | ForEach-Object { Write-Host "     - $_" -ForegroundColor Yellow }
    Write-Host ""
    Write-Host "  Huong dan chuan bi:" -ForegroundColor Cyan
    Write-Host "  https://sontyphu.github.io/hoc-auto-video/chuan-bi/" -ForegroundColor Cyan
    Write-Host ""
    return
}

# ------------------------------------------------- 2. FFmpeg
Tieu-De "Buoc 2/6 - FFmpeg (cat ghep video)"

if (Co-Lenh ffmpeg) {
    Dat "Da co san"
} else {
    Write-Host "  Dang tai FFmpeg (~90 MB), mang cham thi cho vai phut..."
    $dest = Join-Path $env:LOCALAPPDATA "ffmpeg"
    $zip  = Join-Path $env:TEMP "ffmpeg.zip"
    Invoke-WebRequest -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $dest -Force
    $bin = (Get-ChildItem "$dest\ffmpeg-*\bin" -Directory | Select-Object -First 1).FullName
    $pathCu = [Environment]::GetEnvironmentVariable('PATH','User')
    if ($pathCu -notlike "*$bin*") {
        [Environment]::SetEnvironmentVariable("PATH", "$pathCu;$bin", "User")
    }
    $env:PATH = "$env:PATH;$bin"
    Dat "FFmpeg da cai"
}

# ------------------------------------------------- 3. uv
Tieu-De "Buoc 3/6 - uv (quan kho phan mem nen)"

if (Co-Lenh uv) {
    Dat "Da co: $(uv --version)"
} else {
    Write-Host "  Dang cai uv..."
    Chay-Ngoai { powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex" } | Out-Null
    $uvBin = Join-Path $env:USERPROFILE ".local\bin"
    if (Test-Path $uvBin) { $env:PATH = "$env:PATH;$uvBin" }
    if (Co-Lenh uv) { Dat "uv da cai" }
    else { Hong "uv da cai nhung he thong chua nhan. Dong PowerShell, mo lai va chay lai lenh nay"; return }
}

# ------------------------------------------------- 4. Bo cong cu video
Tieu-De "Buoc 4/6 - Bo cong cu video (ban ghim)"

if (Test-Path (Join-Path $DICH ".git")) {
    Push-Location $DICH
    Chay-Ngoai { git fetch --quiet origin } | Out-Null
    Chay-Ngoai { git checkout --quiet $BAN_GHIM } | Out-Null
    Pop-Location
    Dat "Da dua ve ban ghim: $DICH"
} else {
    if (Test-Path $DICH) { Remove-Item $DICH -Recurse -Force }
    $ma = Chay-Ngoai { git clone --quiet $KHO_GOC $DICH }
    if ($ma -ne 0) { Hong "Tai bo cong cu that bai. Kiem tra ket noi mang va chay lai"; return }
    Push-Location $DICH
    Chay-Ngoai { git checkout --quiet $BAN_GHIM } | Out-Null
    Pop-Location
    Dat "Da tai ve ban ghim: $DICH"
}

# Sao chep 10 cong cu bo sung cho tieng Viet
Write-Host "  Dang lay 10 cong cu tieng Viet..."
$tamCombo = Join-Path $env:TEMP "autovideo-combo"
if (Test-Path $tamCombo) { Remove-Item $tamCombo -Recurse -Force }
$maC = Chay-Ngoai { git clone --quiet --depth 1 $KHO_COMBO $tamCombo }
if ($maC -ne 0) { Hong "Tai phan bo sung tieng Viet that bai. Kiem tra ket noi mang"; return }
Copy-Item (Join-Path $tamCombo "viet-hoa\*.py") (Join-Path $DICH "helpers") -Force
$soFile = (Get-ChildItem (Join-Path $tamCombo "viet-hoa") -Filter *.py).Count
Remove-Item $tamCombo -Recurse -Force
Dat "Da chep $soFile cong cu tieng Viet"

Write-Host "  Dang cai cac thanh phan phu thuoc, khoang 2-5 phut..."
Push-Location $DICH
$maSync = Chay-Ngoai { uv sync }

# Lan cai truoc bi dut giua chung se de lai .venv hong -> don sach lam lai
if ($maSync -ne 0) {
    Write-Host "  Lan cai truoc bi gian doan. Dang don moi truong cu va cai lai..." -ForegroundColor Yellow
    $venv = Join-Path $DICH ".venv"
    if (Test-Path $venv) { Remove-Item $venv -Recurse -Force -ErrorAction SilentlyContinue }
    $maSync = Chay-Ngoai { uv sync }
}
Pop-Location
if ($maSync -ne 0) { Hong "Cai dat thanh phan phu thuoc that bai. Chup man hinh gui nhom ho tro cua khoa"; return }
Dat "Xong phan cai dat ben trong"

# ------------------------------------------------- 5. yt-dlp
Tieu-De "Buoc 5/6 - yt-dlp (tai video tu link)"

if (Co-Lenh yt-dlp) {
    Dat "Da co: $(yt-dlp --version)"
} else {
    # KHONG dung `uvx yt-dlp` - lenh do chi chay tam, khong dat duoc vao may.
    # tai_video.py goi lenh tran `yt-dlp` nen doi no phai nam san trong may.
    Write-Host "  Dang cai yt-dlp..."
    $maY = Chay-Ngoai { uv tool install yt-dlp }
    $uvBin = Join-Path $env:USERPROFILE ".local\bin"
    if (Test-Path $uvBin) { $env:PATH = "$env:PATH;$uvBin" }
    if (Co-Lenh yt-dlp) { Dat "yt-dlp da cai" }
    else { Thieu "yt-dlp da cai nhung he thong chua nhan. Dong PowerShell va mo lai" }
}

# ------------------------------------------------- 6. Nap vao tro ly
Tieu-De "Buoc 6/6 - Nap vao tro ly AI"

New-Item -ItemType Directory -Path (Join-Path $env:USERPROFILE ".claude\skills") -Force | Out-Null

# Giu chia khoa dang co
$giuEnv = $null
$envMoi = Join-Path $SKILL ".env"
$envCu  = Join-Path $SKILL_CU ".env"
if (Test-Path $envMoi)      { $giuEnv = Get-Content $envMoi -Raw }
elseif (Test-Path $envCu)   { $giuEnv = Get-Content $envCu -Raw; Dat "Phat hien khoa API o thu muc cu, se chuyen sang thu muc moi" }

# KHONG xoa thu muc cu roi chep de. File python.exe trong .venv hay bi KHOA khi
# Claude Code dang mo -> Remove-Item that bai giua chung, cai dat do dang.
# (Da gap that 08/08/2026: "Access to the path 'python.exe' is denied")
# Cach ne: chep de len tren nhung CHUA RA hai thu - .venv (chua file dang khoa)
# va .env (chia khoa cua hoc vien). Xong moi dung .venv rieng neu chua co.
New-Item -ItemType Directory -Path $SKILL -Force | Out-Null
$maChep = Chay-Ngoai { robocopy $DICH $SKILL /MIR /NFL /NDL /NJH /NJS /NP /R:1 /W:1 /XD ".venv" /XF ".env" }
# robocopy tra ma < 8 la binh thuong; tu 8 tro len moi la that bai
if ($maChep -ge 8) {
    Hong "Sao chep vao thu muc tro ly that bai. Dong Claude Code va chay lai lenh nay"
    return
}
Dat "Da nap vao: $SKILL"

if (-not (Test-Path (Join-Path $SKILL ".venv"))) {
    Write-Host "  Dang khoi tao moi truong chay..."
    Push-Location $SKILL
    $maS2 = Chay-Ngoai { uv sync }
    Pop-Location
    if ($maS2 -ne 0) { Hong "Khoi tao moi truong that bai. Dong Claude Code va chay lai lenh nay"; return }
    Dat "Xong moi truong chay"
}

if ($giuEnv) {
    Ghi-Env (Join-Path $SKILL ".env") $giuEnv
    Dat "Da giu nguyen khoa API hien co"
}

# Don thu muc thua tu dot cai 05/08/2026
if (Test-Path $SKILL_CU) {
    Remove-Item $SKILL_CU -Recurse -Force -ErrorAction SilentlyContinue
    Dat "Da don thu muc ton du tu dot cai truoc"
}

# ------------------------------------------------- Kiem tra
Tieu-De "Kiem tra"

# Va file .env cu bi dinh BOM tu dot cai truoc (hoac tu lenh Out-File trong tai lieu cu)
$envHienCo = Join-Path $SKILL ".env"
if (Test-Path $envHienCo) {
    $byte = [System.IO.File]::ReadAllBytes($envHienCo)
    if ($byte.Length -ge 3 -and $byte[0] -eq 0xEF -and $byte[1] -eq 0xBB -and $byte[2] -eq 0xBF) {
        Ghi-Env $envHienCo ([System.Text.Encoding]::UTF8.GetString($byte, 3, $byte.Length - 3))
        Dat "Da khac phuc loi dinh dang tep khoa API"
    }
}

$diem = 0
if (Co-Lenh ffmpeg)  { Dat "Cat ghep video (ffmpeg)"; $diem++ }        else { Thieu "ffmpeg" }
if (Co-Lenh uv)      { Dat "Quan kho phan mem (uv)"; $diem++ }         else { Thieu "uv" }
if (Test-Path (Join-Path $SKILL "helpers\timeline_view.py")) { Dat "Bo cong cu da vao dung cho"; $diem++ } else { Thieu "bo cong cu" }
if (Test-Path (Join-Path $SKILL "helpers\tim_tu_dem.py"))    { Dat "10 cong cu tieng Viet"; $diem++ }      else { Thieu "cong cu tieng Viet" }
if (Co-Lenh yt-dlp)  { Dat "Tai video tu link (yt-dlp)"; $diem++ }     else { Thieu "yt-dlp" }
if (Test-Path (Join-Path $SKILL ".env")) { Dat "Chia khoa ElevenLabs"; $diem++ } else { Thieu "Chua co chia khoa ElevenLabs" }

Write-Host ""
Write-Host "  $diem/6 muc dat" -ForegroundColor White

if (-not (Test-Path (Join-Path $SKILL ".env"))) {
    Write-Host ""
    Write-Host "  THAO TAC CAN BAN TU THUC HIEN: lay khoa API ElevenLabs" -ForegroundColor Yellow
    Write-Host "  1. Truy cap elevenlabs.io/app/settings/api-keys va dang nhap"
    Write-Host "  2. Tao khoa moi, bat toan bo quyen. Thieu quyen se gay loi khi tao giong doc"
    Write-Host "  3. Chay lenh sau, thay DAN_KEY_VAO_DAY bang chuoi khoa vua sao chep:"
    Write-Host ""
    Write-Host "     [IO.File]::WriteAllText(`"$SKILL\.env`", `"ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY`")" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Khong chia se chuoi khoa, khong dang anh chup man hinh chua khoa." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Cai dat hoan tat. Dong PowerShell, mo lai, sau do mo Claude Code va hoi:" -ForegroundColor Green
Write-Host "     ban co skill video-use khong" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Goi tiep theo, cai truoc buoi 3:" -ForegroundColor DarkGray
Write-Host "  https://github.com/sontyphu/autovideo-effects" -ForegroundColor DarkGray
Write-Host ""

# robocopy tra ma 1-7 khi thanh cong, PowerShell hien "Exit code 3" lam hoc vien
# tuong la loi. Dat lai ve 0.
$global:LASTEXITCODE = 0
