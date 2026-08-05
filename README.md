# Xưởng Video AI - bộ công cụ lớp Autovideo

Bộ đồ nghề để trợ lý AI **nghe được lời** và **nhìn được hình** trong video của bạn - nền của mọi thao tác cắt ghép trong lớp.

> Bản đóng gói riêng cho học viên lớp **Autovideo - Lê Thanh Sơn**. Đã cài sẵn phần tiếng Việt: bóc băng bằng ElevenLabs Scribe (chuẩn tiếng Việt), tải video từ link, và hai đường bóc băng dự phòng miễn phí.

---

## Cài đặt - 4 bước

Mở **PowerShell** (Mac: Terminal). Gõ xong mỗi lệnh bấm Enter.

### Bước 1 - Cài uv

`uv` là người quản kho phần mềm nền. Bộ công cụ này viết bằng Python, `uv` tự lo phần Python cần thiết, bạn không phải đụng tới.

**Kiểm tra đã có chưa:**

```
uv --version
```

Hiện ra dòng kiểu `uv 0.11.x` là đã có, bỏ qua bước này.

**Windows:**

```
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**Mac:**

```
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Cài xong **đóng hẳn PowerShell rồi mở lại**.

### Bước 2 - Tải bộ công cụ về máy

```
cd $env:USERPROFILE
git clone https://github.com/sontyphu/xuong-video-ai
```

*(Mac: `cd ~` rồi cùng lệnh `git clone`)*

### Bước 3 - Cài các thứ nó cần

```
cd xuong-video-ai
uv sync
```

Bước này tải khá nhiều, mất 2-5 phút. Cứ để nó chạy xong.

### Bước 4 - Đặt vào đúng chỗ trợ lý đi tìm

```
mkdir "$env:USERPROFILE\.claude\skills" -Force
Copy-Item "$env:USERPROFILE\xuong-video-ai" "$env:USERPROFILE\.claude\skills\video-use" -Recurse -Force
```

*(Mac: `mkdir -p ~/.claude/skills && cp -R ~/xuong-video-ai ~/.claude/skills/video-use`)*

---

## Chìa khóa ElevenLabs

Bộ công cụ cần chìa khóa ElevenLabs để bóc lời nói trong video thành bản chữ. Lấy chìa khóa và đặt vào máy:

1. Vào **elevenlabs.io/app/settings/api-keys**, đăng nhập.
2. Bấm tạo key mới, **bật tất cả các quyền**, copy chuỗi mã hiện ra.
3. Chạy lệnh dưới, thay `DAN_KEY_VAO_DAY` bằng chuỗi vừa copy:

```
"ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY" | Out-File -FilePath "$env:USERPROFILE\.claude\skills\video-use\.env" -Encoding utf8 -NoNewline
```

*(Mac: `echo "ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY" > ~/.claude/skills/video-use/.env`)*

⚠️ **Không gửi chuỗi này cho ai, không chụp màn hình đưa lên nhóm.** Ai có nó là tiêu tiền được trong tài khoản bạn.

---

## Kiểm tra đã chạy được chưa

```
cd $env:USERPROFILE\.claude\skills\video-use
uv run helpers/timeline_view.py --help
```

Hiện ra bảng hướng dẫn là đạt.

Rồi mở Claude Code, gõ: *bạn có skill video-use không* - trợ lý nhận diện được là xong.

---

## Bộ công cụ này làm được gì

| Việc | Công cụ |
| --- | --- |
| Bóc lời nói thành bản chữ có mốc thời gian tới từng từ | ElevenLabs Scribe |
| Cho trợ lý nhìn được khung hình để chọn chỗ cắt | `timeline_view.py` |
| Cắt video theo ranh giới câu, không đứt giữa lời | `cat_video.py` |
| Chia video dài thành nhiều clip theo chủ đề | `chia_clip.py` |
| Tải video từ link YouTube, TikTok, Facebook kèm lời thoại | `tai_video.py` |
| Bóc băng dự phòng khi chưa mua ElevenLabs | AssemblyAI (50 đô miễn phí) hoặc Groq |

---

## Yêu cầu trước khi cài

Bộ này nằm ở **cấp 2** của xưởng. Trước đó máy bạn phải xong phần chuẩn bị: Claude Pro, Claude Desktop, Node.js, Git, **FFmpeg**.

Chưa làm thì xem hướng dẫn chuẩn bị: https://sontyphu.github.io/hoc-auto-video/chuan-bi/

---

## Bản quyền

Bộ công cụ lõi là phần mềm mã nguồn mở **video-use** của Browser Use, giấy phép MIT - xem file `LICENSE`. Bản này bổ sung phần tiếng Việt và các công cụ trợ giúp do Lê Thanh Sơn viết thêm, phát cho học viên lớp Autovideo.

Kho gốc: https://github.com/browser-use/video-use
