#!/bin/bash
# Goi Cat + Giong - lop Autovideo (Mac)
# Chay bang 1 dong:
#   curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.sh | bash

set -u

# Phien ban ghim, kiem chung tren may tac gia 07/08/2026
KHO_GOC="https://github.com/browser-use/video-use"
BAN_GHIM="cf12ac35143caa48db76efa35b1cb439582333bb"
KHO_COMBO="https://github.com/sontyphu/autovideo-toolkit"

DICH="$HOME/video-use"
SKILL="$HOME/.claude/skills/video-use"
SKILL_CU="$HOME/.claude/skills/autovideo-toolkit"

tieu_de() { printf "\n\033[36m=== %s ===\033[0m\n" "$1"; }
dat()     { printf "  \033[32m[DAT]\033[0m %s\n" "$1"; }
thieu()   { printf "  \033[33m[THIEU]\033[0m %s\n" "$1"; }
hong()    { printf "  \033[31m[HONG]\033[0m %s\n" "$1"; }
co_lenh() { command -v "$1" >/dev/null 2>&1; }

printf "\n  AUTOVIDEO TOOLKIT - GOI CAT VA GIONG\n  Le Thanh Son\n\n"

# ------------------------------------------------- 1. Ve vao lop
tieu_de "Buoc 1/6 - Kiem dieu kien tien quyet"
THIEU_GI=""
if co_lenh git; then dat "Git da co"; else THIEU_GI="$THIEU_GI\n     - Git: chay xcode-select --install"; fi
if co_lenh node; then dat "Node.js da co"; else THIEU_GI="$THIEU_GI\n     - Node.js: tai o nodejs.org"; fi

if [ -n "$THIEU_GI" ]; then
  printf "\n"; hong "Thieu thanh phan bat buoc:"
  printf "%b\n\n" "$THIEU_GI"
  echo "  Huong dan: https://sontyphu.github.io/hoc-auto-video/chuan-bi/"
  exit 1
fi

# ------------------------------------------------- 2. FFmpeg
tieu_de "Buoc 2/6 - FFmpeg (cat ghep video)"
if co_lenh ffmpeg; then
  dat "Da co san"
elif co_lenh brew; then
  echo "  Dang cai FFmpeg bang Homebrew..."
  if brew install ffmpeg >/dev/null 2>&1; then dat "FFmpeg da cai"; else hong "Cai FFmpeg that bai. Chay thu cong: brew install ffmpeg"; exit 1; fi
else
  hong "Thieu Homebrew. Cai tai brew.sh roi chay lai lenh nay."
  exit 1
fi

# ------------------------------------------------- 3. uv
tieu_de "Buoc 3/6 - uv (quan kho phan mem nen)"
if co_lenh uv; then
  dat "Da co: $(uv --version)"
else
  echo "  Dang cai uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1
  export PATH="$HOME/.local/bin:$PATH"
  if co_lenh uv; then dat "uv da cai"; else hong "uv da cai nhung he thong chua nhan. Dong Terminal, mo lai va chay lai lenh nay"; exit 1; fi
fi

# ------------------------------------------------- 4. Bo cong cu video
tieu_de "Buoc 4/6 - Bo cong cu video (ban ghim)"
if [ -d "$DICH/.git" ]; then
  git -C "$DICH" fetch --quiet origin >/dev/null 2>&1
  git -C "$DICH" checkout --quiet "$BAN_GHIM" >/dev/null 2>&1
  dat "Da dua ve ban ghim: $DICH"
else
  rm -rf "$DICH"
  if ! git clone --quiet "$KHO_GOC" "$DICH" >/dev/null 2>&1; then
    hong "Tai bo cong cu that bai. Kiem tra ket noi mang va chay lai"; exit 1
  fi
  git -C "$DICH" checkout --quiet "$BAN_GHIM" >/dev/null 2>&1
  dat "Da tai ve ban ghim: $DICH"
fi

# Sao chep 10 cong cu bo sung cho tieng Viet
echo "  Dang lay 10 cong cu tieng Viet..."
TAM="${TMPDIR:-/tmp}/autovideo-combo"
rm -rf "$TAM"
if ! git clone --quiet --depth 1 "$KHO_COMBO" "$TAM" >/dev/null 2>&1; then
  hong "Tai phan bo sung tieng Viet that bai. Kiem tra ket noi mang"; exit 1
fi
cp "$TAM"/viet-hoa/*.py "$DICH/helpers/"
SO_FILE=$(ls -1 "$TAM"/viet-hoa/*.py | wc -l | tr -d ' ')
rm -rf "$TAM"
dat "Da chep $SO_FILE cong cu tieng Viet"

echo "  Dang cai cac thanh phan phu thuoc, khoang 2-5 phut..."
if ! (cd "$DICH" && uv sync >/dev/null 2>&1); then
  # Lan cai truoc bi dut giua chung se de lai .venv hong -> don sach lam lai
  echo "  Lan cai truoc bi gian doan. Dang don moi truong cu va cai lai..."
  rm -rf "$DICH/.venv"
  if ! (cd "$DICH" && uv sync >/dev/null 2>&1); then
    hong "Cai dat thanh phan phu thuoc that bai. Chup man hinh gui nhom ho tro cua khoa"; exit 1
  fi
fi
dat "Xong phan cai dat ben trong"

# ------------------------------------------------- 5. yt-dlp
tieu_de "Buoc 5/6 - yt-dlp (tai video tu link)"
if co_lenh yt-dlp; then
  dat "Da co: $(yt-dlp --version)"
else
  # KHONG dung `uvx yt-dlp` - lenh do chi chay tam, khong dat duoc vao may.
  echo "  Dang cai yt-dlp..."
  uv tool install yt-dlp >/dev/null 2>&1
  export PATH="$HOME/.local/bin:$PATH"
  if co_lenh yt-dlp; then dat "yt-dlp da cai"; else thieu "yt-dlp da cai nhung he thong chua nhan. Dong Terminal va mo lai"; fi
fi

# ------------------------------------------------- 6. Nap vao tro ly
tieu_de "Buoc 6/6 - Nap vao tro ly AI"
mkdir -p "$HOME/.claude/skills"

GIU_ENV=""
if   [ -f "$SKILL/.env" ];    then GIU_ENV="$(cat "$SKILL/.env")"
elif [ -f "$SKILL_CU/.env" ]; then GIU_ENV="$(cat "$SKILL_CU/.env")"; dat "Phat hien khoa API o thu muc cu, se chuyen sang thu muc moi"
fi

# Chep de len tren, CHUA RA .venv (co the dang bi tro ly dung) va .env (chia khoa).
# Tren Windows viec xoa thang .venv hay that bai vi python.exe bi khoa - Mac it gap
# hon nhung lam cung mot kieu cho hai ban giong nhau.
mkdir -p "$SKILL"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude ".venv" --exclude ".env" "$DICH/" "$SKILL/"
else
  cp -R "$DICH"/. "$SKILL"/ 2>/dev/null
fi
dat "Da nap vao: $SKILL"

if [ ! -d "$SKILL/.venv" ]; then
  echo "  Dang khoi tao moi truong chay..."
  if ! (cd "$SKILL" && uv sync >/dev/null 2>&1); then
    hong "Khoi tao moi truong that bai. Dong Claude Code va chay lai lenh nay"; exit 1
  fi
  dat "Xong moi truong chay"
fi

if [ -n "$GIU_ENV" ]; then
  printf '%s' "$GIU_ENV" > "$SKILL/.env"
  dat "Da giu nguyen khoa API hien co"
fi

# Don thu muc thua tu dot cai 05/08/2026
if [ -d "$SKILL_CU" ]; then rm -rf "$SKILL_CU"; dat "Da don thu muc ton du tu dot cai truoc"; fi

# ------------------------------------------------- Kiem tra
tieu_de "Kiem tra"
DIEM=0
co_lenh ffmpeg && { dat "Cat ghep video (ffmpeg)"; DIEM=$((DIEM+1)); } || thieu "ffmpeg"
co_lenh uv     && { dat "Quan kho phan mem (uv)"; DIEM=$((DIEM+1)); } || thieu "uv"
[ -f "$SKILL/helpers/timeline_view.py" ] && { dat "Bo cong cu da vao dung cho"; DIEM=$((DIEM+1)); } || thieu "bo cong cu"
[ -f "$SKILL/helpers/tim_tu_dem.py" ]    && { dat "10 cong cu tieng Viet"; DIEM=$((DIEM+1)); } || thieu "cong cu tieng Viet"
co_lenh yt-dlp && { dat "Tai video tu link (yt-dlp)"; DIEM=$((DIEM+1)); } || thieu "yt-dlp"
[ -f "$SKILL/.env" ] && { dat "Chia khoa ElevenLabs"; DIEM=$((DIEM+1)); } || thieu "Chua co chia khoa ElevenLabs"

printf "\n  %s/6 muc dat\n" "$DIEM"

if [ ! -f "$SKILL/.env" ]; then
  printf "\n  \033[33mTHAO TAC CAN BAN TU THUC HIEN: lay khoa API ElevenLabs\033[0m\n"
  echo "  1. Truy cap elevenlabs.io/app/settings/api-keys va dang nhap"
  echo "  2. Tao khoa moi, bat toan bo quyen"
  echo "  3. Chay lenh sau, thay DAN_KEY_VAO_DAY bang chuoi khoa vua sao chep:"
  printf "\n     \033[36mecho \"ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY\" > %s/.env\033[0m\n\n" "$SKILL"
  printf "  \033[33mKhong chia se chuoi khoa, khong dang anh chup man hinh chua khoa.\033[0m\n"
fi

printf "\n  \033[32mCai dat hoan tat. Dong Terminal, mo lai, sau do mo Claude Code va hoi:\033[0m\n"
printf "     \033[36mban co skill video-use khong\033[0m\n\n"
printf "  Goi tiep theo, cai truoc buoi 3:\n"
printf "  https://github.com/sontyphu/autovideo-effects\n\n"
