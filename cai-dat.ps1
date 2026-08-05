# Autovideo Toolkit - cai dat tu dong (Windows)
# Chay bang 1 dong:
#   irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.ps1 | iex

$ErrorActionPreference = "Stop"
$KHO   = "https://github.com/sontyphu/autovideo-toolkit"
$DICH  = Join-Path $env:USERPROFILE "autovideo-toolkit"
$SKILL = Join-Path $env:USERPROFILE ".claude\skills\autovideo-toolkit"

# PowerShell 5.1 coi moi dong stderr cua lenh ngoai la LOI. uv/git in tien trinh
# ra stderr nen phai chay chung trong che do "Continue" roi tu kiem ma tra ve.
function Chay-Ngoai {
    param([scriptblock]$Lenh)
    $cu = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try { & $Lenh 2>&1 | Out-Null; return $LASTEXITCODE }
    finally { $ErrorActionPreference = $cu }
}

function Tieu-De($chu) { Write-Host "`n=== $chu ===" -ForegroundColor Cyan }
function Dat($chu)     { Write-Host "  [DAT] $chu" -ForegroundColor Green }
function Thieu($chu)   { Write-Host "  [THIEU] $chu" -ForegroundColor Yellow }
function Hong($chu)    { Write-Host "  [HONG] $chu" -ForegroundColor Red }
function Co-Lenh($ten) { $null -ne (Get-Command $ten -ErrorAction SilentlyContinue) }

Write-Host ""
Write-Host "  XUONG VIDEO AI - BO CONG CU LOP AUTOVIDEO" -ForegroundColor White
Write-Host "  Le Thanh Son" -ForegroundColor DarkGray
Write-Host ""

# ---------------------------------------------------------------- 1. Do nen
Tieu-De "Buoc 1/5 - Kiem do nen"

$thieuGi = @()

if (Co-Lenh git) { Dat "Git da co" } else { Thieu "Git chua co"; $thieuGi += "Git (tai o git-scm.com)" }

if (Co-Lenh ffmpeg) {
    Dat "FFmpeg da co"
} else {
    Thieu "FFmpeg chua co - se cai o buoc 2"
}

if ($thieuGi.Count -gt 0) {
    Write-Host ""
    Hong "Thieu phan mem nen, chua cai tiep duoc:"
    $thieuGi | ForEach-Object { Write-Host "     - $_" -ForegroundColor Yellow }
    Write-Host ""
    Write-Host "  Xem huong dan chuan bi: https://sontyphu.github.io/hoc-auto-video/chuan-bi/" -ForegroundColor Cyan
    Write-Host ""
    return
}

# ---------------------------------------------------------------- 2. FFmpeg
Tieu-De "Buoc 2/5 - FFmpeg"

if (Co-Lenh ffmpeg) {
    Dat "Bo qua, da co san"
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

# ---------------------------------------------------------------- 3. uv
Tieu-De "Buoc 3/5 - uv (quan kho phan mem nen)"

if (Co-Lenh uv) {
    Dat "uv da co: $(uv --version)"
} else {
    Write-Host "  Dang cai uv..."
    Chay-Ngoai { powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex" } | Out-Null
    $uvBin = Join-Path $env:USERPROFILE ".local\bin"
    if (Test-Path $uvBin) { $env:PATH = "$env:PATH;$uvBin" }
    if (Co-Lenh uv) { Dat "uv da cai" } else { Hong "uv cai xong ma may chua nhan - dong PowerShell mo lai roi chay lai lenh nay"; return }
}

# ---------------------------------------------------------------- 4. Tai bo cong cu
Tieu-De "Buoc 4/5 - Tai bo cong cu ve may"

if (Test-Path (Join-Path $DICH ".git")) {
    Write-Host "  Da co san, dang lay ban moi nhat..."
    Push-Location $DICH
    Chay-Ngoai { git pull --quiet } | Out-Null
    Pop-Location
    Dat "Da cap nhat: $DICH"
} else {
    if (Test-Path $DICH) { Remove-Item $DICH -Recurse -Force }
    $maClone = Chay-Ngoai { git clone --quiet $KHO $DICH }
    if ($maClone -ne 0) { Hong "Tai ve that bai - kiem lai mang roi chay lai lenh nay"; return }
    Dat "Da tai ve: $DICH"
}

Write-Host "  Dang cai cac thu no can (2-5 phut, cu de chay)..."
Push-Location $DICH
$maSync = Chay-Ngoai { uv sync }

# Lan cai truoc bi dut giua chung se de lai thu muc .venv hong. uv tu choi dung
# no va bao loi kho hieu -> don sach roi lam lai mot lan nua.
if ($maSync -ne 0) {
    Write-Host "  Lan truoc cai do dang, dang don sach roi lam lai..." -ForegroundColor Yellow
    $venv = Join-Path $DICH ".venv"
    if (Test-Path $venv) { Remove-Item $venv -Recurse -Force -ErrorAction SilentlyContinue }
    $maSync = Chay-Ngoai { uv sync }
}

Pop-Location
if ($maSync -ne 0) { Hong "Cai dat ben trong that bai - chup man hinh gui nhom Zalo lop"; return }
Dat "Xong phan cai dat ben trong"

# ---------------------------------------------------------------- 5. Nap vao tro ly
Tieu-De "Buoc 5/5 - Nap vao tro ly AI"

$thuMucSkill = Join-Path $env:USERPROFILE ".claude\skills"
New-Item -ItemType Directory -Path $thuMucSkill -Force | Out-Null

# Giu lai chia khoa cu neu da co, khoi phai nhap lai
$envCu = Join-Path $SKILL ".env"
$giuEnv = $null
if (Test-Path $envCu) { $giuEnv = Get-Content $envCu -Raw }

if (Test-Path $SKILL) { Remove-Item $SKILL -Recurse -Force }
Copy-Item $DICH $SKILL -Recurse -Force
Dat "Da nap vao: $SKILL"

if ($giuEnv) {
    Set-Content -Path (Join-Path $SKILL ".env") -Value $giuEnv -Encoding utf8 -NoNewline
    Dat "Giu lai chia khoa ElevenLabs da co"
}

# ---------------------------------------------------------------- Kiem tra
Tieu-De "Kiem tra"

$diem = 0; $tong = 4

if (Co-Lenh ffmpeg) { Dat "Cat ghep video (ffmpeg)"; $diem++ } else { Thieu "ffmpeg" }
if (Co-Lenh uv)     { Dat "Quan kho phan mem (uv)"; $diem++ } else { Thieu "uv" }
if (Test-Path (Join-Path $SKILL "helpers\timeline_view.py")) { Dat "Bo cong cu da vao dung cho"; $diem++ } else { Thieu "bo cong cu" }
if (Test-Path (Join-Path $SKILL ".env")) { Dat "Chia khoa ElevenLabs"; $diem++ } else { Thieu "Chua co chia khoa ElevenLabs" }

Write-Host ""
Write-Host "  $diem/$tong muc dat" -ForegroundColor White

if (-not (Test-Path (Join-Path $SKILL ".env"))) {
    Write-Host ""
    Write-Host "  CON MOT VIEC: chia khoa ElevenLabs" -ForegroundColor Yellow
    Write-Host "  1. Vao elevenlabs.io/app/settings/api-keys, tao key moi, BAT TAT CA QUYEN"
    Write-Host "  2. Chay lenh duoi, thay DAN_KEY_VAO_DAY bang chuoi vua copy:"
    Write-Host ""
    Write-Host "     `"ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY`" | Out-File -FilePath `"$SKILL\.env`" -Encoding utf8 -NoNewline" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  KHONG gui chuoi nay cho ai, khong chup man hinh dua len nhom." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  XONG. Dong PowerShell mo lai, roi mo Claude Code go:" -ForegroundColor Green
Write-Host "     ban co skill autovideo-toolkit khong" -ForegroundColor Cyan
Write-Host ""
