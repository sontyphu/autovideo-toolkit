# Quy trình cài đặt

Tài liệu này dành cho trợ lý AI thực hiện cài đặt thay người dùng. Danh sách thành phần, phiên bản ghim và phép kiểm nằm ở `DANH-MUC.md` - đọc trước khi bắt đầu.

**Đặc điểm người dùng**: học viên khóa Autovideo, không có nền tảng kỹ thuật. Họ không đọc được thông báo lỗi và không tự khắc phục được sự cố. Thực hiện thay họ ở mức tối đa; với thao tác bắt buộc phải do họ làm, hướng dẫn theo từng thao tác cụ thể.

---

## Bước 1 - Kiểm tra hiện trạng

Chạy lần lượt các lệnh sau và ghi nhận kết quả. Chưa cài đặt gì ở bước này.

| Thành phần | Lệnh kiểm | Xử lý khi thiếu |
| --- | --- | --- |
| Git | `git --version` | Dừng quy trình, hướng dẫn về phần chuẩn bị trước khóa |
| Node.js | `node -v` | Dừng quy trình, hướng dẫn về phần chuẩn bị trước khóa |
| FFmpeg | `ffmpeg -version` | Cài được |
| ffprobe | `ffprobe -version` | Đi kèm FFmpeg; thiếu một trong hai là chưa hoàn tất |
| uv | `uv --version` | Cài được |
| yt-dlp | `yt-dlp --version` | Cài được |
| Bộ công cụ video | tồn tại `~/.claude/skills/video-use/helpers/timeline_view.py` | Cài được |
| Khóa API | tồn tại `~/.claude/skills/video-use/.env` | Người dùng tự lấy |

Kiểm tra thêm hai điểm:

**Thư mục tồn dư từ đợt cài 05/08/2026.** Nếu tồn tại `~/.claude/skills/autovideo-toolkit` và thư mục đó có `.env` trong khi `video-use` không có, chuyển tệp `.env` sang `video-use` rồi xóa thư mục tồn dư. Người dùng đã cấu hình khóa từ buổi 0; không yêu cầu họ nhập lại.

**Hệ điều hành.** Lệnh cài đặt khác nhau giữa Windows và macOS.

---

## Bước 2 - Trình bày kế hoạch và chờ xác nhận

Báo cáo theo cấu trúc sau, dùng ngôn ngữ thông thường, tránh thuật ngữ kỹ thuật:

```
Hiện trạng máy: Git, Node.js, FFmpeg đã có.
Còn thiếu: uv, bộ công cụ video, yt-dlp.

Thời gian cài đặt khoảng 5 phút, không phát sinh chi phí.

Có một thao tác cần bạn tự thực hiện: lấy khóa API ElevenLabs,
vì thao tác này yêu cầu đăng nhập tài khoản cá nhân. Tôi sẽ hướng
dẫn sau khi cài xong phần còn lại.

Bạn xác nhận để tôi bắt đầu?
```

Chỉ tiến hành sau khi người dùng xác nhận.

---

## Bước 3 - Cài đặt tuần tự, kiểm tra sau mỗi thành phần

Thứ tự bắt buộc: **FFmpeg, uv, bộ công cụ video, yt-dlp**. Thành phần sau phụ thuộc thành phần trước.

Với mỗi thành phần:

1. Chạy lệnh cài đặt theo `DANH-MUC.md`
2. Chạy phép kiểm tương ứng ngay sau đó
3. Đạt: thông báo ngắn gọn cho người dùng, chuyển sang thành phần kế tiếp
4. Không đạt: **dừng quy trình**. Không cài thành phần tiếp theo. Báo cáo nguyên nhân bằng ngôn ngữ thông thường và phương án xử lý

### Bốn lỗi đã ghi nhận trong thực tế

**Lỗi 1 - PowerShell diễn giải sai đầu ra của lệnh ngoài.** PowerShell 5.1 coi mọi dòng ghi ra luồng lỗi chuẩn là lỗi thực sự. Lệnh `uv sync` ghi thông tin tiến trình ra luồng này, nên thêm `2>&1` sẽ khiến PowerShell ném `NativeCommandError` dù lệnh chạy bình thường.

*Xử lý*: không thêm `2>&1` vào lệnh ngoài; kiểm tra kết quả qua `$LASTEXITCODE`.

**Lỗi 2 - Môi trường ảo hỏng do cài đặt gián đoạn.** Lần cài bị ngắt để lại thư mục `.venv` không hoàn chỉnh. Lần chạy sau, `uv sync` báo *"not a valid Python environment"*.

*Xử lý*: xóa thư mục `.venv`, chạy lại `uv sync`.

**Lỗi 3 - Tệp bị khóa khi Claude Code đang chạy.** Thao tác xóa hoặc ghi đè `~/.claude/skills/video-use/.venv/Scripts/python.exe` thất bại với thông báo *"Access to the path is denied"*.

*Xử lý*: không xóa thư mục đích. Sao chép đè lên, loại trừ `.venv` và `.env`. Nếu thư mục đích chưa có `.venv`, chạy `uv sync` tại đó sau khi sao chép.

**Lỗi 4 - Máy chưa nhận phần mềm vừa cài.** Biến môi trường chỉ được nạp lại khi mở cửa sổ dòng lệnh mới.

*Xử lý*: yêu cầu người dùng đóng hẳn PowerShell hoặc Terminal rồi mở lại trước khi kết luận cài đặt thất bại.

---

## Bước 4 - Bàn giao thao tác thuộc về người dùng

Sau khi hoàn tất cài đặt, kiểm tra khóa API. Nếu chưa có, hướng dẫn theo từng thao tác:

```
1. Truy cập elevenlabs.io/app/settings/api-keys
2. Đăng nhập tài khoản đã đăng ký trước khóa học
3. Chọn tạo khóa mới
4. Bật toàn bộ quyền. Thiếu quyền sẽ gây lỗi khi tạo giọng đọc
5. Sao chép chuỗi khóa và gửi lại cho tôi
```

Người dùng cung cấp chuỗi khóa, trợ lý ghi vào `~/.claude/skills/video-use/.env`.

**Yêu cầu về định dạng tệp `.env`**: tệp phải được ghi ở dạng UTF-8 không có BOM.

Trên Windows, `Out-File -Encoding utf8` và `Set-Content -Encoding utf8` chèn ba byte đánh dấu vào đầu tệp. Tên biến khi đó trở thành `<BOM>ELEVENLABS_API_KEY`, không khớp với chuỗi so sánh trong `transcribe.py`, dẫn đến báo lỗi *không tìm thấy khóa* dù nội dung tệp nhìn bằng mắt hoàn toàn đúng. Ghi nhận ngày 08/08/2026.

Lệnh đúng trên Windows:

```powershell
[IO.File]::WriteAllText("$env:USERPROFILE\.claude\skills\video-use\.env", "ELEVENLABS_API_KEY=<chuỗi khóa>")
```

Trên macOS, `echo "..." > ~/.claude/skills/video-use/.env` không phát sinh BOM.

**Chẩn đoán**: người dùng báo lỗi *không tìm thấy khóa* trong khi tệp `.env` có đầy đủ nội dung, kiểm ba byte đầu tệp. Nếu là `EF BB BF`, ghi lại tệp bằng lệnh trên.

Kiểm tra tổng thể lần cuối và báo cáo kết quả:

```
Cài đặt hoàn tất. Máy bạn hiện có thể:
- Cắt video theo ranh giới câu
- Xác định và loại bỏ đoạn ngập ngừng
- Ghép video, gắn phụ đề
- Tải video từ liên kết mạng xã hội
- Tạo giọng đọc

Đóng PowerShell, mở lại, sau đó mở Claude Code và hỏi
"bạn có skill video-use không" để xác nhận.
```

---

## Thao tác không được thực hiện thay người dùng

| Thao tác | Lý do | Phương án |
| --- | --- | --- |
| Đăng ký tài khoản dịch vụ | Yêu cầu thông tin cá nhân và mật khẩu | Cung cấp liên kết và hướng dẫn từng thao tác |
| Thanh toán, nhập thông tin thẻ | Thuộc quyết định tài chính của người dùng | Nêu rõ chi phí, để người dùng quyết định |
| Lấy khóa API | Yêu cầu đăng nhập tài khoản cá nhân | Hướng dẫn từng thao tác, sau đó nhận chuỗi khóa |
| Cài Claude Desktop | Yêu cầu quyền quản trị | Cung cấp liên kết cài đặt |
| Cài phiên bản mới hơn phiên bản ghim | Phiên bản chưa được kiểm chứng | Cài đúng phiên bản trong `DANH-MUC.md` |

Ghi chuỗi khóa vào tệp `.env` khi người dùng đã cung cấp là được phép. Chỉ việc tự đi lấy khóa là không được phép.

---

## Trường hợp người dùng đã cài đặt từ trước

Không xóa dữ liệu hiện có. Thực hiện:

1. Giữ nguyên tệp `.env`
2. Cập nhật bộ công cụ về phiên bản ghim
3. Bổ sung thành phần còn thiếu. Thành phần hay thiếu nhất là `yt-dlp` do tài liệu phiên bản cũ hướng dẫn sai lệnh cài

---

## Sự cố ngoài phạm vi xử lý

Không phỏng đoán, không thử các phương án chưa được kiểm chứng. Hướng dẫn người dùng:

> Chụp màn hình thông báo lỗi, gửi vào nhóm hỗ trợ của khóa, kèm thông tin đang ở bước nào và hệ điều hành đang dùng.

Giữ nguyên hiện trạng máy để bộ phận hỗ trợ chẩn đoán.
