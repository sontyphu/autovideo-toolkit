# Danh mục phần mềm - Gói Cắt + Giọng

> Bản ghim: đây là **đúng phiên bản thầy Sơn đang chạy thật**, đọc từ máy thầy ngày **07/08/2026**.
> Thầy nâng bản thì cập nhật file này, cả lớp cài theo. Đừng tự nâng lên bản mới nhất - hãng sửa gì hỏng là cả lớp tắc cùng lúc.

## Trước khi cài gói này - phải xong "vé vào lớp"

Bốn thứ dưới đây học viên **tự cài trước khi tới lớp**, không nằm trong gói này. Chưa xong thì gói này cài cũng không chạy.

| Món | Bản thầy dùng | Vì sao cần |
| --- | --- | --- |
| Tài khoản **Claude Pro** | gói trả phí ~500.000đ/tháng | Bản miễn phí dùng một lúc là bị chặn giữa chừng |
| **Claude Desktop** | bản mới nhất | Ứng dụng chạy trên máy - nơi bạn ra lệnh cắt video |
| **Node.js** | v24.15.0 (LTS) | Phần nền để Claude Code chạy được |
| **Git** | 2.54.0 | Trợ lý cần để ghi nhớ thay đổi file, thiếu là nó không chịu làm |
| **Chìa khóa ElevenLabs** | - | Bóc lời chuẩn tên riêng + tạo giọng đọc |
| **Chìa khóa AssemblyAI** | - | Đường bóc lời miễn phí, dùng khi chưa trả phí ElevenLabs |

Hướng dẫn đầy đủ: https://sontyphu.github.io/hoc-auto-video/chuan-bi/

---

## Bốn món trong gói này

| # | Món | Để làm gì | Bản ghim | Ai cài |
| --- | --- | --- | --- | --- |
| 1 | **FFmpeg** (kèm ffprobe) | Phần mềm cắt, ghép, gắn phụ đề thật sự. Trợ lý ra lệnh, FFmpeg làm | 8.1.1 essentials (gyan.dev) | Trợ lý AI |
| 2 | **uv** | Quản kho phần mềm nền. Bộ công cụ viết bằng Python, uv tự lo phần Python - né lỗi Microsoft Store chặn lệnh `python` trên Windows | 0.11.21 | Trợ lý AI |
| 3 | **Bộ công cụ video** | Bóc lời có mốc thời gian tới từng từ, cho trợ lý nhìn được khung hình, cắt đúng ranh giới câu | commit `cf12ac3` (14/05/2026) | Trợ lý AI |
| 4 | **yt-dlp** | Tải video về từ link YouTube, TikTok, Facebook kèm lời thoại | 2026.07.04 | Trợ lý AI |

---

## Lệnh cài và phép kiểm từng món

### 1. FFmpeg

**Kiểm đã có chưa:** `ffmpeg -version`

**Windows** - dán nguyên khối:
```powershell
$dest = "$env:LOCALAPPDATA\ffmpeg"
$zip = "$env:TEMP\ffmpeg.zip"
Invoke-WebRequest -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $dest -Force
$bin = (Get-ChildItem "$dest\ffmpeg-*\bin" -Directory | Select-Object -First 1).FullName
[Environment]::SetEnvironmentVariable("PATH", "$([Environment]::GetEnvironmentVariable('PATH','User'));$bin", "User")
```

**Mac:** `brew install ffmpeg`

**Đạt khi:** `ffmpeg -version` VÀ `ffprobe -version` đều ra thông tin phiên bản. Hai cái đi cùng nhau, thiếu một là chưa xong.

*Tải khoảng 90 MB. Cài xong đóng hẳn PowerShell mở lại - máy chỉ nhận phần mềm mới khi cửa sổ mở mới.*

### 2. uv

**Kiểm đã có chưa:** `uv --version`

**Windows:**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**Mac:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Đạt khi:** `uv --version` ra dòng kiểu `uv 0.11.x`.

### 3. Bộ công cụ video

**Kiểm đã có chưa:** thư mục `~/.claude/skills/video-use/helpers/timeline_view.py` có tồn tại không

```bash
cd ~
git clone https://github.com/browser-use/video-use
cd video-use
git checkout cf12ac35143caa48db76efa35b1cb439582333bb
uv sync
```

Rồi **chép đè 10 file tiếng Việt** của thầy Sơn từ `viet-hoa/` vào `video-use/helpers/`, và chép cả thư mục sang `~/.claude/skills/video-use/`.

**Đạt khi:** chạy trong thư mục đó `uv run helpers/timeline_view.py --help` ra bảng hướng dẫn (mã trả về 0).

> ⚠️ **Cài đứt giữa chừng** (mất mạng, bấm Ctrl+C) sẽ để lại thư mục `.venv` hỏng. Chạy lại `uv sync` sẽ báo *"not a valid Python environment"*. Cách xử: xóa thư mục `.venv` rồi chạy `uv sync` lại.

### 4. yt-dlp

**Kiểm đã có chưa:** `yt-dlp --version`

```bash
uv tool install yt-dlp
```

**Đạt khi:** `yt-dlp --version` ra dòng ngày tháng kiểu `2026.07.04`.

> ⚠️ **KHÔNG dùng `uvx yt-dlp`.** Lệnh đó chỉ chạy tạm một lần, không đặt được vào máy. File `tai_video.py` gọi thẳng lệnh `yt-dlp` nên đòi nó phải nằm sẵn trong máy - thiếu là báo *"Thieu yt-dlp"* rồi dừng.

---

## Mười công cụ tiếng Việt của thầy Sơn

Nằm trong thư mục `viet-hoa/`, chép đè vào bộ công cụ sau khi cài. Đây là phần bản gốc **không có** - thầy viết thêm để chạy được với tiếng Việt và với cách dạy của lớp.

| File | Làm gì |
| --- | --- |
| `tim_tu_dem.py` | **Tìm chỗ ậm ừ, ngập ngừng** trong video - nền của bài "cắt bỏ quãng chết" buổi 1 |
| `cat_video.py` | Cắt video theo ranh giới câu, không đứt giữa lời |
| `chia_clip.py` | Chia video dài thành nhiều clip theo chủ đề |
| `tai_video.py` | Tải video từ link YouTube, TikTok, Facebook kèm lời thoại |
| `transcript_hyperframes.py` | Bóc lời bằng ElevenLabs Scribe rồi xuất đúng định dạng bộ chèn hiệu ứng cần - **cầu nối sang Gói Hiệu ứng** |
| `transcribe_assemblyai.py` | Bóc lời đường miễn phí (AssemblyAI) |
| `transcribe_groq.py` | Bóc lời đường miễn phí thứ hai (Groq) |
| `extract_transcript.py` | Rút bản chữ ra để đọc |
| `kiem_chat_luong.py` | Kiểm chất lượng video thành phẩm |
| `lam_thumbnail.py` | Chọn khung đẹp nhất trong video rồi làm ảnh bìa |

---

## Chìa khóa để ở đâu

File `.env` trong `~/.claude/skills/video-use/`, nội dung một dòng:

```
ELEVENLABS_API_KEY=chuỗi-mã-của-bạn
```

Muốn dùng thêm đường miễn phí thì thêm dòng `ASSEMBLYAI_API_KEY=...`.

**Lệnh ghi file này - Windows** (thay `DAN_KEY_VAO_DAY` bằng chuỗi của bạn):

```powershell
[IO.File]::WriteAllText("$env:USERPROFILE\.claude\skills\video-use\.env", "ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY")
```

**Mac:**

```bash
echo "ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY" > ~/.claude/skills/video-use/.env
```

> ⚠️ **Đừng dùng `Out-File -Encoding utf8` hay `Set-Content -Encoding utf8`.** Hai lệnh này của PowerShell chèn 3 byte vô hình vào đầu file, làm tên biến thành `<vô hình>ELEVENLABS_API_KEY` - bộ công cụ so không khớp nên báo **không tìm thấy chìa khóa** dù file có đủ chữ, nhìn mắt thường không thấy sai chỗ nào. Đã gặp thật 08/08/2026.
>
> Lỡ dùng nhầm rồi thì chạy lại bộ cài, nó tự vá.

⚠️ **Không gửi chuỗi này cho ai, không chụp màn hình đưa lên nhóm.** Ai có nó là tiêu tiền được trong tài khoản bạn.

---

## Bốn thứ KHÔNG cài - để khỏi băn khoăn

| Món | Vì sao không |
| --- | --- |
| **Whisper** | Nó tự làm mượt, **xóa mất tiếng ậm ừ** - đúng thứ buổi 1 cần tìm để cắt. Model gốc lại là model tiếng Anh, đọc tiếng Việt sai bét |
| **Python** | `uv` tự lo bản riêng. Cài Python thẳng trên Windows hay bị Microsoft Store chặn, tự sửa rất rối |
| **Manim** | Vẽ sơ đồ toán học - lớp không dùng |
| **Remotion** | Một cách dựng video khác - lớp đi đường Gói Hiệu ứng |

---

## Gói tiếp theo

Xong gói này là đủ cho **buổi 1 và buổi 2**. Trước buổi 3 cài thêm **Gói Hiệu ứng**: https://github.com/sontyphu/autovideo-effects
