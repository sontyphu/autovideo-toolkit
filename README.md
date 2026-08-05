# Xưởng Video AI - bộ công cụ lớp Autovideo

Bộ đồ nghề để trợ lý AI **nghe được lời** và **nhìn được hình** trong video của bạn - nền của mọi thao tác cắt ghép trong lớp.

> Bản đóng gói riêng cho học viên lớp **Autovideo - Lê Thanh Sơn**. Đã cài sẵn phần tiếng Việt: bóc băng bằng ElevenLabs Scribe (chuẩn tiếng Việt), tải video từ link, và hai đường bóc băng dự phòng miễn phí.

---

## Cách 1 - Nhờ trợ lý AI cài hộ (dễ nhất)

Mở **Claude Code**, dán nguyên đoạn dưới đây vào ô chat:

```
Tôi là học viên lớp Autovideo của Lê Thanh Sơn. Đây là bộ công cụ giảng viên
phát cho lớp, mã nguồn mở giấy phép MIT:
https://github.com/sontyphu/autovideo-toolkit

Cài giúp tôi theo đúng mục "Cách 3 - Cài bằng tay, từng bước" trong README của kho đó:
1. Đọc README trước để biết các bước
2. Clone kho về thư mục nhà của tôi
3. Chạy uv sync
4. Chép vào .claude/skills/autovideo-toolkit
5. Kiểm tra lại rồi báo tôi còn thiếu gì

Cứ đọc mã nguồn trước nếu cần, rồi làm từng bước và báo tôi kết quả.
```

Trợ lý sẽ đọc kho, xem các bước, rồi làm. Bước cuối là lấy chìa khóa ElevenLabs - phần đó bạn tự làm, xem mục bên dưới.

> **Trợ lý từ chối thì vì sao?** Nếu bạn chỉ dán mỗi cái link kèm câu "cài cho tôi", trợ lý sẽ từ chối - nó không biết kho này là gì, ai làm, bên trong có gì. Dán nguyên đoạn ở trên là nó có đủ bối cảnh để làm. Đây là tính năng an toàn, không phải lỗi.

---

## Cách 2 - Dán 1 dòng, máy tự làm hết

Mở **PowerShell** (Windows), dán dòng này rồi bấm Enter:

```
irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.ps1 | iex
```

**Máy Mac** - mở Terminal, dán dòng này:

```
curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.sh | bash
```

Máy sẽ tự: kiểm đồ nền → cài FFmpeg nếu thiếu → cài uv → tải bộ công cụ → nạp vào trợ lý → chấm điểm 4 mục và báo rõ còn thiếu gì. Mất khoảng 3-6 phút tùy mạng.

**Chạy lại được nhiều lần** - lỡ đứt giữa chừng thì cứ dán lại dòng đó, nó tự dọn rồi làm tiếp. Chìa khóa ElevenLabs đã nhập thì được giữ nguyên, không phải nhập lại.

Xong rồi **đóng hẳn PowerShell mở lại**, mở Claude Code gõ: *bạn có skill autovideo-toolkit không*.

---

## Cách 3 - Cài bằng tay, từng bước

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
git clone https://github.com/sontyphu/autovideo-toolkit
```

*(Mac: `cd ~` rồi cùng lệnh `git clone`)*

### Bước 3 - Cài các thứ nó cần

```
cd autovideo-toolkit
uv sync
```

Bước này tải khá nhiều, mất 2-5 phút. Cứ để nó chạy xong.

### Bước 4 - Đặt vào đúng chỗ trợ lý đi tìm

```
mkdir "$env:USERPROFILE\.claude\skills" -Force
Copy-Item "$env:USERPROFILE\autovideo-toolkit" "$env:USERPROFILE\.claude\skills\autovideo-toolkit" -Recurse -Force
```

*(Mac: `mkdir -p ~/.claude/skills && cp -R ~/autovideo-toolkit ~/.claude/skills/autovideo-toolkit`)*

---

## Chìa khóa ElevenLabs

Bộ công cụ cần chìa khóa ElevenLabs để bóc lời nói trong video thành bản chữ. Lấy chìa khóa và đặt vào máy:

1. Vào **elevenlabs.io/app/settings/api-keys**, đăng nhập.
2. Bấm tạo key mới, **bật tất cả các quyền**, copy chuỗi mã hiện ra.
3. Chạy lệnh dưới, thay `DAN_KEY_VAO_DAY` bằng chuỗi vừa copy:

```
"ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY" | Out-File -FilePath "$env:USERPROFILE\.claude\skills\autovideo-toolkit\.env" -Encoding utf8 -NoNewline
```

*(Mac: `echo "ELEVENLABS_API_KEY=DAN_KEY_VAO_DAY" > ~/.claude/skills/autovideo-toolkit/.env`)*

⚠️ **Không gửi chuỗi này cho ai, không chụp màn hình đưa lên nhóm.** Ai có nó là tiêu tiền được trong tài khoản bạn.

---

## Kiểm tra đã chạy được chưa

```
cd $env:USERPROFILE\.claude\skills\autovideo-toolkit
uv run helpers/timeline_view.py --help
```

Hiện ra bảng hướng dẫn là đạt.

Rồi mở Claude Code, gõ: *bạn có skill autovideo-toolkit không* - trợ lý nhận diện được là xong.

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

Bộ **Autovideo Toolkit** do **Lê Thanh Sơn** đóng gói và phát cho học viên lớp Autovideo: phần bóc băng tiếng Việt, tải video từ link, bộ khởi động chữ tiếng Việt và các công cụ trợ giúp đều do anh viết thêm.

Phần lõi xử lý video dựng trên một thư viện mã nguồn mở giấy phép MIT - giấy phép này cho phép đóng gói lại và phát hành, đổi lại phải giữ nguyên file `LICENSE`. Đó là lý do file đó có mặt trong bộ này.


