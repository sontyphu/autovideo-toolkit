# Danh mục thành phần - Gói Cắt và Giọng

Phiên bản trong tài liệu này là phiên bản đã kiểm chứng trên máy tác giả ngày **07/08/2026**. Khi tác giả nâng cấp, tài liệu được cập nhật và toàn bộ học viên cài theo phiên bản mới.

Không tự nâng lên phiên bản mới nhất. Thay đổi từ nhà phát hành có thể phá vỡ quy trình đang vận hành, và sự cố sẽ xảy ra đồng loạt trên toàn lớp.

---

## Điều kiện tiên quyết

Các thành phần sau thuộc phần chuẩn bị trước khóa học, do học viên tự cài đặt. Gói này không cài chúng và sẽ dừng lại nếu thiếu.

| Thành phần | Phiên bản tham chiếu | Vai trò |
| --- | --- | --- |
| Tài khoản Claude Pro | gói trả phí, khoảng 500.000đ/tháng | Bản miễn phí bị giới hạn dung lượng xử lý trong phiên làm việc dài |
| Claude Desktop | bản mới nhất | Môi trường thực thi trên máy cục bộ |
| Node.js | v24.15.0 (LTS) | Nền tảng để Claude Code hoạt động |
| Git | 2.54.0 | Cơ chế theo dõi thay đổi tệp mà trợ lý yêu cầu |
| Khóa API ElevenLabs | - | Bóc lời và tổng hợp giọng đọc |
| Khóa API AssemblyAI | - | Phương án bóc lời miễn phí, dùng khi chưa đăng ký ElevenLabs |

Hướng dẫn: https://sontyphu.github.io/hoc-auto-video/chuan-bi/

---

## Thành phần trong gói

| Thành phần | Vai trò | Phiên bản ghim | Người thực hiện |
| --- | --- | --- | --- |
| FFmpeg (kèm ffprobe) | Thực thi cắt, ghép, gắn phụ đề. Trợ lý điều phối, FFmpeg xử lý | 8.1.1 essentials (gyan.dev) | Trợ lý AI |
| uv | Quản lý môi trường Python. Loại bỏ xung đột với cơ chế chặn lệnh `python` của Microsoft Store trên Windows | 0.11.21 | Trợ lý AI |
| Bộ công cụ video | Bóc lời với mốc thời gian cấp từ, đọc khung hình, cắt theo ranh giới câu | commit `cf12ac3` (14/05/2026) | Trợ lý AI |
| yt-dlp | Tải video từ liên kết YouTube, TikTok, Facebook | 2026.07.04 | Trợ lý AI |

---

## Cài đặt và kiểm tra từng thành phần

### FFmpeg

Kiểm tra hiện trạng: `ffmpeg -version`

Windows:

```powershell
$dest = "$env:LOCALAPPDATA\ffmpeg"
$zip = "$env:TEMP\ffmpeg.zip"
Invoke-WebRequest -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $dest -Force
$bin = (Get-ChildItem "$dest\ffmpeg-*\bin" -Directory | Select-Object -First 1).FullName
[Environment]::SetEnvironmentVariable("PATH", "$([Environment]::GetEnvironmentVariable('PATH','User'));$bin", "User")
```

macOS:

```bash
brew install ffmpeg
```

**Phép kiểm**: `ffmpeg -version` và `ffprobe -version` đều trả về thông tin phiên bản. Hai thành phần đi kèm nhau; thiếu một trong hai là chưa hoàn tất.

Dung lượng tải khoảng 90 MB. Sau khi cài, đóng cửa sổ dòng lệnh và mở lại để hệ thống nạp biến môi trường mới.

### uv

Kiểm tra hiện trạng: `uv --version`

Windows:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

macOS:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Phép kiểm**: `uv --version` trả về chuỗi phiên bản dạng `uv 0.11.x`.

### Bộ công cụ video

Kiểm tra hiện trạng: tồn tại `~/.claude/skills/video-use/helpers/timeline_view.py`

```bash
cd ~
git clone https://github.com/browser-use/video-use
cd video-use
git checkout cf12ac35143caa48db76efa35b1cb439582333bb
uv sync
```

Sau đó sao chép mười công cụ trong `viet-hoa/` vào `video-use/helpers/`, và sao chép toàn bộ thư mục sang `~/.claude/skills/video-use/`.

**Phép kiểm**: chạy `uv run helpers/timeline_view.py --help` trong thư mục đó, mã trả về bằng 0 và in ra bảng tham số.

**Lưu ý**: cài đặt bị gián đoạn để lại thư mục `.venv` không hoàn chỉnh. Lần chạy sau, `uv sync` báo *"not a valid Python environment"*. Xóa thư mục `.venv` và chạy lại.

### yt-dlp

Kiểm tra hiện trạng: `yt-dlp --version`

```bash
uv tool install yt-dlp
```

**Phép kiểm**: `yt-dlp --version` trả về chuỗi ngày tháng dạng `2026.07.04`.

**Lưu ý**: không dùng `uvx yt-dlp`. Lệnh đó thực thi trong môi trường tạm và không cài đặt vào hệ thống. Tệp `tai_video.py` gọi lệnh `yt-dlp` trực tiếp qua `shutil.which`, yêu cầu chương trình phải có trong PATH.

---

## Mười công cụ bổ sung cho tiếng Việt

Nằm trong thư mục `viet-hoa/`, sao chép vào bộ công cụ sau khi cài đặt. Đây là phần thư viện gốc không có, do Lê Thanh Sơn phát triển để đáp ứng yêu cầu xử lý tiếng Việt và giáo trình của khóa học.

| Tệp | Chức năng |
| --- | --- |
| `tim_tu_dem.py` | Xác định vị trí từ đệm và đoạn ngập ngừng - cơ sở của bài loại bỏ quãng chết ở buổi 1 |
| `cat_video.py` | Cắt theo ranh giới câu, không đứt giữa lời |
| `chia_clip.py` | Tách video dài thành nhiều đoạn theo chủ đề |
| `tai_video.py` | Tải video từ liên kết mạng xã hội kèm lời thoại |
| `transcript_hyperframes.py` | Bóc lời qua ElevenLabs Scribe, xuất theo định dạng bộ chèn hiệu ứng yêu cầu. Là thành phần liên kết sang Gói Hiệu ứng |
| `transcribe_assemblyai.py` | Bóc lời qua AssemblyAI, phương án miễn phí |
| `transcribe_groq.py` | Bóc lời qua Groq, phương án miễn phí thứ hai |
| `extract_transcript.py` | Trích xuất bản chữ để đọc |
| `kiem_chat_luong.py` | Kiểm tra chất lượng video thành phẩm |
| `lam_thumbnail.py` | Chọn khung hình đại diện và tạo ảnh bìa |

---

## Cấu hình khóa API

Tệp `.env` đặt tại `~/.claude/skills/video-use/`, nội dung:

```
ELEVENLABS_API_KEY=<chuỗi khóa>
```

Thêm dòng `ASSEMBLYAI_API_KEY=<chuỗi khóa>` nếu dùng phương án bóc lời miễn phí.

Lệnh ghi tệp trên Windows:

```powershell
[IO.File]::WriteAllText("$env:USERPROFILE\.claude\skills\video-use\.env", "ELEVENLABS_API_KEY=<chuỗi khóa>")
```

macOS:

```bash
echo "ELEVENLABS_API_KEY=<chuỗi khóa>" > ~/.claude/skills/video-use/.env
```

**Yêu cầu định dạng**: tệp phải là UTF-8 không có BOM.

Trên Windows, `Out-File -Encoding utf8` và `Set-Content -Encoding utf8` chèn ba byte đánh dấu vào đầu tệp. Tên biến khi đó trở thành `<BOM>ELEVENLABS_API_KEY` và không khớp với chuỗi so sánh trong thư viện, dẫn đến báo lỗi *không tìm thấy khóa* trong khi nội dung tệp nhìn bằng mắt hoàn toàn đúng. Ghi nhận ngày 08/08/2026. Trường hợp đã ghi nhầm, chạy lại bộ cài để tự khắc phục.

**Bảo mật**: không chia sẻ chuỗi khóa, không đăng ảnh chụp màn hình chứa khóa. Người nắm giữ khóa có thể phát sinh chi phí trên tài khoản của bạn.

---

## Thành phần không thuộc phạm vi cài đặt

| Thành phần | Lý do loại trừ |
| --- | --- |
| Whisper | Mô hình chuẩn hóa từ đệm, làm mất chính dữ liệu mà bài loại bỏ quãng chết cần xử lý. Mô hình mặc định là mô hình tiếng Anh, độ chính xác với tiếng Việt không đạt yêu cầu |
| Python cài trực tiếp | uv quản lý phiên bản riêng. Cài trực tiếp trên Windows thường xung đột với cơ chế chuyển hướng của Microsoft Store |
| Manim | Thư viện dựng sơ đồ toán học, không nằm trong giáo trình |
| Remotion | Khung dựng video thay thế; giáo trình sử dụng phương án khác ở Gói Hiệu ứng |

---

## Gói tiếp theo

Gói này đáp ứng buổi 1 và buổi 2. Trước buổi 3, cài Gói Hiệu ứng: https://github.com/sontyphu/autovideo-effects
