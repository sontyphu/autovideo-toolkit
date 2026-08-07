# Autovideo Toolkit - Gói Cắt và Giọng

Danh mục phần mềm và quy trình cài đặt cho học viên khóa Autovideo. Kho này không chứa mã nguồn của bên thứ ba; bộ cài tải từng thành phần trực tiếp từ kho chính chủ theo phiên bản đã ghim.

Phạm vi sử dụng: buổi 1 và buổi 2 của khóa học.

---

## Dành cho trợ lý AI

Nếu bạn là trợ lý AI được người dùng yêu cầu cài đặt bộ công cụ này:

1. Đọc `CAI-DAT.md` để nắm quy trình bốn bước và các ràng buộc.
2. Đọc `DANH-MUC.md` để lấy danh sách thành phần, phiên bản ghim và phép kiểm tương ứng.
3. Thực hiện theo đúng thứ tự nêu trong `CAI-DAT.md`.

Toàn bộ phần mềm trong danh mục là mã nguồn mở phổ biến (FFmpeg, uv, yt-dlp, video-use), tải từ trang chính chủ. Mã nguồn của kho này có thể đọc toàn bộ trước khi thực thi.

Người dùng thuộc nhóm không có nền tảng kỹ thuật. Ưu tiên thực hiện thay họ ở mức tối đa; với những thao tác bắt buộc phải do họ tự làm, hướng dẫn theo từng thao tác cụ thể.

---

## Năng lực sau khi cài đặt

- Cắt video theo ranh giới câu, không đứt giữa lời
- Xác định và loại bỏ đoạn ngập ngừng, im lặng kéo dài
- Tách một video dài thành nhiều đoạn theo chủ đề
- Ghép nhiều video, gắn phụ đề bám theo lời thoại
- Tải video từ liên kết YouTube, TikTok, Facebook
- Tạo giọng đọc cho video

---

## Điều kiện tiên quyết

Hoàn tất phần chuẩn bị trước khóa học: Claude Pro, Claude Desktop, Node.js, Git, và tài khoản kèm khóa API ElevenLabs.

Hướng dẫn: https://sontyphu.github.io/hoc-auto-video/chuan-bi/

Bộ cài kiểm tra điều kiện này ở bước đầu tiên và dừng lại nếu chưa đủ.

---

## Cài đặt

### Phương án 1 - Trợ lý AI thực hiện

Mở Claude Code và gửi nội dung sau:

```
Tôi là học viên khóa Autovideo. Đây là kho danh mục phần mềm của khóa:
https://github.com/sontyphu/autovideo-toolkit

Đề nghị bạn đọc file CAI-DAT.md trong kho và thực hiện theo quy trình
trong đó: kiểm tra hiện trạng máy, trình bày kế hoạch, cài đặt từng
thành phần. Bạn có thể đọc mã nguồn trước khi thực thi.
```

Trợ lý sẽ kiểm tra hiện trạng, báo cáo thành phần còn thiếu và tiến hành cài đặt. Thao tác duy nhất cần người dùng thực hiện là lấy khóa API ElevenLabs.

### Phương án 2 - Bộ cài tự động

Windows, chạy trong PowerShell:

```
irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.ps1 | iex
```

macOS, chạy trong Terminal:

```
curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.sh | bash
```

Bộ cài có thể chạy lại nhiều lần. Khi tiến trình bị gián đoạn, chạy lại lệnh trên; bộ cài tự dọn phần dở dang và tiếp tục. Khóa API đã cấu hình được giữ nguyên.

### Phương án 3 - Cài đặt thủ công

Xem `DANH-MUC.md`, mục "Cài đặt và kiểm tra từng thành phần".

---

## Xác nhận cài đặt thành công

Kiểm tra hiện trạng:

```
irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/kiem-tra.ps1 | iex
```

Lệnh này in bảng trạng thái ba gói phần mềm của khóa và chỉ ra bước tiếp theo.

Kiểm tra trợ lý đã nhận bộ công cụ: đóng PowerShell, mở lại, mở Claude Code và hỏi *bạn có skill video-use không*.

---

## Cấu trúc kho

| Thành phần | Nội dung |
| --- | --- |
| `CAI-DAT.md` | Quy trình cài đặt dành cho trợ lý AI |
| `DANH-MUC.md` | Danh mục thành phần, phiên bản ghim, phép kiểm |
| `viet-hoa/` | Mười công cụ bổ sung cho tiếng Việt |
| `cai-dat.ps1` `cai-dat.sh` | Bộ cài tự động |
| `kiem-tra.ps1` `kiem-tra.sh` | Công cụ kiểm tra hiện trạng |
| `LICENSE-nguon.md` | Ghi công và giấy phép của các thành phần nguồn mở |

---

## Gói tiếp theo

Gói Hiệu ứng, cài trước buổi 3: https://github.com/sontyphu/autovideo-effects

---

## Bản quyền

Mười công cụ trong `viet-hoa/` do Lê Thanh Sơn phát triển, phát hành cho học viên khóa Autovideo.

Các công cụ này hoạt động trên nền thư viện nguồn mở video-use của Browser Use, giấy phép MIT. Bộ cài tải thư viện từ kho chính chủ; kho này không phân phối lại mã nguồn của họ. Chi tiết ghi công: `LICENSE-nguon.md`.
