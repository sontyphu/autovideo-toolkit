#!/bin/bash
# Autovideo Toolkit - cai dat tu dong (Mac)
# Chay bang 1 dong:
#   curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.sh | bash

set -u
KHO="https://github.com/sontyphu/autovideo-toolkit"
DICH="$HOME/autovideo-toolkit"
SKILL="$HOME/.claude/skills/autovideo-toolkit"

tieu_de() { printf "\n\033[36m=== %s ===\033[0m\n" "$1"; }
dat()     { printf "  \033[32m[DAT]\033[0m %s\n" "$1"; }
thieu()   { printf "  \033[33m[THIEU]\033[0m %s\n" "$1"; }
hong()    { printf "  \033[31m[HONG]\033[0m %s\n" "$1"; }
co_lenh() { command -v "$1" >/dev/null 2>&1; }

printf "\n  XUONG VIDEO AI - BO CONG CU LOP AUTOVIDEO\n  Le Thanh Son\n\n"

# ---------------------------------------------------------------- 1. Do nen
tieu_de "Buoc 1/5 - Kiem do nen"
if co_lenh git; then dat "Git da co"; else hong "Git chua co - cai Xcode Command Line Tools: xcode-select --install"; exit 1; fi

# ---------------------------------------------------------------- 2. FFmpeg
tieu_de "Buoc 2/5 - FFmpeg"
if co_lenh ffmpeg; then
  dat "Bo qua, da co san"
elif co_lenh brew; then
  echo "  Dang cai FFmpeg bang Homebrew..."
  brew install ffmpeg >/dev/null 2>&1 && dat "FFmpeg da cai" || hong "Cai FFmpeg that bai, chay tay: brew install ffmpeg"
else
  hong "Chua co Homebrew. Cai o brew.sh roi chay lai lenh nay."
  exit 1
fi

# ---------------------------------------------------------------- 3. uv
tieu_de "Buoc 3/5 - uv (quan kho phan mem nen)"
if co_lenh uv; then
  dat "uv da co: $(uv --version)"
else
  echo "  Dang cai uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1
  export PATH="$HOME/.local/bin:$PATH"
  if co_lenh uv; then dat "uv da cai"; else hong "uv cai xong ma may chua nhan - dong Terminal mo lai roi chay lai"; exit 1; fi
fi

# ---------------------------------------------------------------- 4. Tai bo cong cu
tieu_de "Buoc 4/5 - Tai bo cong cu ve may"
if [ -d "$DICH/.git" ]; then
  echo "  Da co san, dang lay ban moi nhat..."
  git -C "$DICH" pull --quiet >/dev/null 2>&1
  dat "Da cap nhat: $DICH"
else
  rm -rf "$DICH"
  git clone --quiet "$KHO" "$DICH" >/dev/null 2>&1
  dat "Da tai ve: $DICH"
fi

echo "  Dang cai cac thu no can (2-5 phut, cu de chay)..."
(cd "$DICH" && uv sync >/dev/null 2>&1)
dat "Xong phan cai dat ben trong"

# ---------------------------------------------------------------- 5. Nap vao tro ly
tieu_de "Buoc 5/5 - Nap vao tro ly AI"
mkdir -p "$HOME/.claude/skills"

GIU_ENV=""
[ -f "$SKILL/.env" ] && GIU_ENV="$(cat "$SKILL/.env")"

rm -rf "$SKILL"
cp -R "$DICH" "$SKILL"
dat "Da nap vao: $SKILL"

if [ -n "$GIU_ENV" ]; then
  printf '%s' "$GIU_ENV" > "$SKILL/.env"
  dat "Giu lai chia khoa ElevenLabs da co"
fi

# ---------------------------------------------------------------- Kiem tra
tieu_de "Kiem tra"
DIEM=0
co_lenh ffmpeg && { dat "Cat ghep video (ffmpeg)"; DIEM=$((DIEM+1)); } || thieu "ffmpeg"
co_lenh uv     && { dat "Quan kho phan mem (uv)"; DIEM=$((DIEM+1)); } || thieu "uv"
[ -f "$SKILL/helpers/timeline_view.py" ] && { dat "Bo cong cu da vao dung cho"; DIEM=$((DIEM+1)); } || thieu "bo cong cu"
[ -f "$SKILL/.env" ] && { dat "Chia khoa ElevenLabs"; DIEM=$((DIEM+1)); } || thieu "Chua co chia khoa ElevenLabs"

printf "\n  %s/4 muc dat\n" "$DIEM"

if [ ! -f "$SKILL/.env" ]; then
  printf "\n  \033[33mCON MOT VIEC: chia khoa ElevenLabs\033[0m\n"
  echo "  1. Vao elevenlabs.io/app/settings/api-keys, tao key moi, BAT TAT CA QUYEN"
  echo "  2. Chay lenh duoi, thay DAN_KEY_VAO_DAY bang chuoi vua copy:"
  printf "\n     \033[36mecho \"ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY\" > %s/.env\033[0m\n\n" "$SKILL"
  printf "  \033[33mKHONG gui chuoi nay cho ai, khong chup man hinh dua len nhom.\033[0m\n"
fi

printf "\n  \033[32mXONG. Dong Terminal mo lai, roi mo Claude Code go:\033[0m\n"
printf "     \033[36mban co skill autovideo-toolkit khong\033[0m\n\n"
