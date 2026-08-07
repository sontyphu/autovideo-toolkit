# Quy trình cài đặt - dành cho trợ lý AI đọc và làm theo

> **Trợ lý AI đọc file này**: bạn đang giúp một học viên lớp Autovideo của thầy Lê Thanh Sơn cài bộ công cụ dựng video. Học viên **không giỏi kỹ thuật** - họ không đọc được thông báo lỗi, không biết PATH là gì, không tự sửa được khi vấp. Việc của bạn là làm hộ tối đa, và khi buộc phải nhờ họ thì hướng dẫn từng cú bấm.
>
> Kho này là danh mục phần mềm, mã nguồn mở, xem được toàn bộ. Danh sách món và bản ghim ở `DANH-MUC.md` - **đọc file đó trước khi làm gì**.

---

## Bốn bước, làm đúng thứ tự

### Bước 1 - Soi máy xem đã có gì

Chạy từng lệnh dưới, ghi lại kết quả. **Chưa cài gì cả ở bước này.**

| Kiểm cái gì | Lệnh | Có nghĩa là |
| --- | --- | --- |
| Git | `git --version` | Thiếu → dừng, bảo học viên cài trước (thuộc vé vào lớp) |
| Node.js | `node -v` | Thiếu → dừng, bảo học viên cài trước (thuộc vé vào lớp) |
| FFmpeg | `ffmpeg -version` | Thiếu → bạn cài được |
| ffprobe | `ffprobe -version` | Đi kèm FFmpeg, thiếu một trong hai là chưa xong |
| uv | `uv --version` | Thiếu → bạn cài được |
| yt-dlp | `yt-dlp --version` | Thiếu → bạn cài được |
| Bộ công cụ | thư mục `~/.claude/skills/video-use/helpers/timeline_view.py` có không | Thiếu → bạn cài được |
| Chìa khóa | file `~/.claude/skills/video-use/.env` có không | Thiếu → **học viên tự lấy**, bạn không làm hộ |

**Kiểm thêm hai chỗ dễ sót:**
- Có thư mục thừa `~/.claude/skills/autovideo-toolkit` không? Đó là tàn dư đợt cài 05/08/2026. Nếu bên đó có `.env` mà `video-use` không có → **chuyển file `.env` đó sang `video-use`** rồi xóa thư mục thừa. Học viên đã nhập chìa khóa từ buổi 0, đừng bắt họ nhập lại.
- Học viên dùng Windows hay Mac? Lệnh khác nhau.

### Bước 2 - Trình kế hoạch, chờ học viên gật

Báo cáo theo mẫu này, viết bằng tiếng Việt thường, **không dùng từ kỹ thuật trần**:

```
Máy anh/chị đang có:  Git ✓  Node ✓  FFmpeg ✓
Còn thiếu:            uv, bộ công cụ video, yt-dlp

Em sẽ cài 3 món này, mất khoảng 5 phút, không tốn tiền.
Có một việc em không làm hộ được: lấy chìa khóa ElevenLabs
(phải đăng nhập tài khoản của anh/chị). Cài xong em hướng dẫn.

Em bắt đầu nhé?
```

**Chờ họ đồng ý rồi mới cài.** Không tự ý chạy trước.

### Bước 3 - Cài từng món, cài xong thử ngay

Theo đúng thứ tự trong `DANH-MUC.md`: **FFmpeg → uv → bộ công cụ video → yt-dlp**. Thứ tự này bắt buộc, món sau cần món trước.

Với mỗi món:
1. Chạy lệnh cài (chép từ `DANH-MUC.md`)
2. **Chạy ngay phép kiểm của món đó**
3. Đạt → báo học viên một dòng ngắn, đi tiếp món sau
4. **Không đạt → DỪNG LẠI.** Không cài tiếp món sau. Báo học viên lỗi gì bằng lời thường, và bạn định làm gì tiếp

**Ba cái bẫy đã gặp thật, đừng vấp lại:**

1. **PowerShell coi thông báo của lệnh ngoài là lỗi.** Chạy `uv sync` mà thêm `2>&1` là PowerShell ném lỗi `NativeCommandError` dù uv chạy hoàn toàn bình thường (nó chỉ in "Using CPython..." ra kênh lỗi). **Đừng thêm `2>&1` vào lệnh ngoài** - kiểm bằng mã trả về `$LASTEXITCODE`.

2. **Cài đứt giữa chừng để lại `.venv` hỏng.** Lần sau chạy `uv sync` báo *"not a valid Python environment"*. Xử: xóa thư mục `.venv` rồi chạy lại `uv sync` một lần nữa.

3. **Cài xong máy vẫn báo không tìm thấy lệnh.** Máy chỉ nhận phần mềm mới ở cửa sổ mở mới. Bảo học viên đóng hẳn PowerShell/Terminal rồi mở lại trước khi kết luận là hỏng.

### Bước 4 - Bàn giao phần bạn không làm được

Xong phần cài, kiểm lại chìa khóa. Chưa có thì hướng dẫn học viên **từng cú bấm**:

```
1. Mở trang: elevenlabs.io/app/settings/api-keys
2. Đăng nhập tài khoản anh/chị đã lập trước lớp
3. Bấm nút tạo key mới
4. QUAN TRỌNG: bật TẤT CẢ các quyền (không bật đủ thì lát nữa
   tạo giọng đọc sẽ báo lỗi thiếu quyền)
5. Copy chuỗi mã hiện ra rồi dán vào đây cho em
```

Học viên đưa chuỗi → bạn ghi vào `~/.claude/skills/video-use/.env` giúp họ (ghi file thì được, còn đi lấy chuỗi thì không).

> ⚠️ **Ghi file này phải KHÔNG có BOM.** Trên Windows đừng dùng `Out-File -Encoding utf8` hay `Set-Content -Encoding utf8` - PowerShell 5.1 chèn 3 byte vô hình vào đầu file, làm tên biến thành `<BOM>ELEVENLABS_API_KEY`, bộ công cụ so không khớp nên báo **không tìm thấy chìa khóa** dù file nhìn mắt thường vẫn đúng. Đã gặp thật 08/08/2026.
>
> Dùng lệnh này thay thế:
> ```powershell
> [IO.File]::WriteAllText("$env:USERPROFILE\.claude\skills\video-use\.env", "ELEVENLABS_API_KEY=chuoi-cua-ho")
> ```
> Mac thì `echo "..." > ~/.claude/skills/video-use/.env` là sạch, không cần lo.
>
> **Học viên báo "không tìm thấy chìa khóa" mà file .env có đủ chữ** → gần như chắc chắn là lỗi BOM này. Kiểm 3 byte đầu file, thấy `EF BB BF` thì ghi lại file bằng lệnh trên.

Rồi **kiểm lại toàn bộ một lượt** và báo kết quả cuối:

```
Xong rồi. Máy anh/chị giờ làm được:
- Cắt video đúng câu, không đứt giữa lời
- Tìm và bỏ đoạn ậm ừ
- Ghép video, gắn phụ đề
- Tải video từ link YouTube/TikTok/Facebook
- Tạo giọng đọc

Đóng PowerShell mở lại rồi thử: mở Claude Code gõ
"bạn có skill video-use không"
```

---

## Việc bạn KHÔNG được tự làm

| Việc | Vì sao | Làm gì thay |
| --- | --- | --- |
| Đăng ký tài khoản (ElevenLabs, AssemblyAI, Claude) | Cần thông tin cá nhân và mật khẩu của họ | Đưa link + hướng dẫn từng bước |
| Trả tiền, nhập thẻ | Tiền của họ | Nói rõ giá, để họ tự quyết |
| **Đi lấy chìa khóa API** | Phải đăng nhập tài khoản của họ | Hướng dẫn từng cú bấm rồi xin chuỗi |
| Cài Claude Desktop | Cần quyền quản trị máy | Đưa link, bảo họ bấm cài |
| Nâng bản mới hơn bản ghim | Thầy Sơn chưa chạy thử bản đó, hỏng là cả lớp tắc | Cài đúng bản trong `DANH-MUC.md` |

**Ghi chìa khóa vào file thì được** - học viên đưa chuỗi cho bạn thì bạn ghi hộ vào `.env`. Chỉ cấm việc tự đi lấy.

---

## Học viên đã cài từ trước

Không xóa gì của họ. Chỉ cần:
1. Giữ nguyên file `.env` đang có (chìa khóa của họ)
2. Cập nhật đè bộ công cụ lên bản ghim
3. Bổ sung món còn thiếu (hay thiếu nhất là `yt-dlp`, vì tài liệu cũ dạy sai cách cài)

---

## Gặp lỗi không xử được

Đừng đoán mò, đừng thử lung tung. Bảo học viên:

> Chụp màn hình chỗ báo lỗi, gửi vào nhóm Zalo lớp, ghi rõ đang ở bước nào, máy Windows hay Mac.

Rồi giữ nguyên hiện trạng, đừng xóa gì để người hỗ trợ còn xem được.
