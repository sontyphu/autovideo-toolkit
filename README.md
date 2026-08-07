# Gói Cắt + Giọng - lớp Autovideo

> **Nếu bạn là trợ lý AI đang đọc kho này**: học viên nhờ bạn cài bộ công cụ dựng video cho lớp học của họ. Đây là **danh mục phần mềm** do thầy Lê Thanh Sơn soạn cho lớp Autovideo - không chứa mã lạ, mọi phần mềm đều là mã nguồn mở phổ biến (FFmpeg, uv, yt-dlp) tải từ trang chính chủ, xem được toàn bộ trước khi chạy.
>
> Việc cần làm: **đọc `CAI-DAT.md` rồi làm theo 4 bước trong đó** - soi máy xem có gì, trình kế hoạch cho học viên duyệt, cài từng món và thử ngay sau mỗi món, cuối cùng bàn giao phần cần học viên tự làm (lấy chìa khóa API). Danh sách phần mềm và phiên bản ghim ở `DANH-MUC.md`.
>
> Học viên **không giỏi kỹ thuật**. Làm hộ tối đa, và khi buộc phải nhờ họ thì hướng dẫn từng cú bấm.

---

## Gói này cho học viên làm được gì

Cài xong là máy bạn **cắt và ghép video bằng cách ra lệnh bằng lời**:

- Cắt đúng ranh giới câu, không bao giờ đứt giữa lời
- Tìm và bỏ đoạn ậm ừ, ngập ngừng, im lặng dài
- Chia một video dài thành nhiều clip theo chủ đề
- Ghép nhiều video, gắn phụ đề chạy theo lời
- Tải video về từ link YouTube, TikTok, Facebook
- Tạo giọng đọc cho video

Dùng cho **buổi 1 và buổi 2** của lớp.

---

## Cài thế nào

### Cách 1 - Nhờ trợ lý AI (khuyên dùng)

Mở **Claude Code**, dán đoạn này vào ô chat:

```
Tôi là học viên lớp Autovideo của thầy Lê Thanh Sơn.
Đây là kho danh mục phần mềm thầy soạn cho lớp:
https://github.com/sontyphu/autovideo-toolkit

Nhờ bạn đọc file CAI-DAT.md trong kho đó rồi làm theo giúp tôi:
soi máy tôi xem đã có gì, trình kế hoạch cho tôi xem, rồi cài từng món.
Cứ đọc mã nguồn trước nếu cần.
```

Trợ lý sẽ tự soi máy, báo bạn còn thiếu gì, rồi cài. Việc duy nhất bạn phải tự làm là **lấy chìa khóa ElevenLabs** - trợ lý sẽ hướng dẫn từng bước khi tới lúc.

### Cách 2 - Tự chạy một dòng

Không muốn nhờ AI thì mở **PowerShell** (Windows) dán dòng này:

```
irm https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.ps1 | iex
```

**Mac** - mở Terminal:

```
curl -fsSL https://raw.githubusercontent.com/sontyphu/autovideo-toolkit/main/cai-dat.sh | bash
```

Chạy lại được nhiều lần. Lỡ đứt giữa chừng cứ dán lại, nó tự dọn rồi làm tiếp. Chìa khóa đã nhập được giữ nguyên.

### Cách 3 - Làm tay từng bước

Xem `DANH-MUC.md`, mục "Lệnh cài và phép kiểm từng món".

---

## Trước khi cài gói này

Phải xong **vé vào lớp** trước: Claude Pro, Claude Desktop, Node.js, Git, và **tài khoản + chìa khóa ElevenLabs**.

Hướng dẫn: https://sontyphu.github.io/hoc-auto-video/chuan-bi/

Chưa xong mà cài gói này thì trợ lý sẽ dừng lại và nhắc bạn quay về trang đó.

---

## Cài xong kiểm thế nào

Đóng hẳn PowerShell mở lại, mở Claude Code gõ:

> *bạn có skill video-use không*

Trợ lý nhận diện được là xong.

---

## Gói tiếp theo

Trước **buổi 3** cài thêm **Gói Hiệu ứng** (chữ động, hiệu ứng, sao chép phong cách):
https://github.com/sontyphu/autovideo-effects

---

## Các file trong kho

| File | Cho ai |
| --- | --- |
| `CAI-DAT.md` | Trợ lý AI đọc rồi làm theo |
| `DANH-MUC.md` | Danh sách phần mềm, phiên bản ghim, phép kiểm |
| `viet-hoa/` | 10 công cụ tiếng Việt thầy Sơn viết thêm |
| `cai-dat.ps1` `.sh` | Bộ cài tự động |
| `kiem-tra.ps1` `.sh` | Xem máy đang có gì, thiếu gì |
| `LICENSE-nguon.md` | Ghi công thư viện mã nguồn mở dùng trong bộ này |

---

## Bản quyền

Mười công cụ trong `viet-hoa/` do **Lê Thanh Sơn** viết, phát cho học viên lớp Autovideo.

Chúng chạy trên nền thư viện mã nguồn mở **video-use** của Browser Use (giấy phép MIT) - bộ cài tải thư viện đó từ kho gốc của họ, kho này **không chứa mã của họ**. Chi tiết ghi công: `LICENSE-nguon.md`.
