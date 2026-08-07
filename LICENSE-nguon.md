# Ghi công nguồn mở

Bộ công cụ lớp Autovideo đứng trên vai vài dự án mã nguồn mở. Kho này **không chứa mã của họ** - bộ cài tải thẳng từ kho gốc của từng dự án. Dưới đây là ghi công đầy đủ.

## Thư viện nền

| Dự án | Của ai | Giấy phép | Kho gốc |
| --- | --- | --- | --- |
| **video-use** | Browser Use | MIT | https://github.com/browser-use/video-use |
| **FFmpeg** | FFmpeg team | LGPL/GPL | https://ffmpeg.org |
| **uv** | Astral | MIT / Apache-2.0 | https://github.com/astral-sh/uv |
| **yt-dlp** | yt-dlp team | Unlicense | https://github.com/yt-dlp/yt-dlp |

Bản ghim của từng món ghi trong `DANH-MUC.md`.

## Phần của Lê Thanh Sơn

Mười file trong `viet-hoa/` do Lê Thanh Sơn viết, không thuộc dự án nào ở trên:

`tim_tu_dem.py` · `cat_video.py` · `chia_clip.py` · `tai_video.py` · `transcript_hyperframes.py` · `transcribe_assemblyai.py` · `transcribe_groq.py` · `extract_transcript.py` · `kiem_chat_luong.py` · `lam_thumbnail.py`

Chúng lấp phần bản gốc không có: bóc lời tiếng Việt, tìm tiếng ậm ừ, tải video từ mạng xã hội, và nối sang bộ chèn hiệu ứng.

## Giấy phép MIT của video-use

Giấy phép MIT cho phép dùng, sửa, đóng gói lại và phát hành, kèm một điều kiện: **giữ nguyên dòng bản quyền gốc**. Bộ cài giữ nguyên file `LICENSE` khi tải thư viện về, nên điều kiện này được tôn trọng.
