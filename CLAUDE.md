# Bộ tài liệu: Hướng dẫn dùng Claude cho team

## Bối cảnh

Bộ tài liệu đào tạo nội bộ của **Phòng Ứng dụng CNTT, Điện Máy Xanh**.

- **Đối tượng:** 20 người, dev/IT đã quen terminal
- **Mục tiêu:** dùng Claude **tiết kiệm** (bớt token, bớt lãng phí) và **đúng hướng** (bớt vòng lặp sửa đi sửa lại)
- **Bối cảnh gốc:** một seminar 60 phút, kèm tài liệu đọc lại sau buổi
- **Vấn đề thật của team:** hay chat với AI kiểu "sửa A, sửa B", không đúng ý thì bảo sửa lại, nhiều lần, không rõ ràng ngay từ đầu

## Cấu trúc file

| File | Nội dung |
|---|---|
| `00-slide-trinh-chieu-team.md` | ⭐ Bản trình chiếu chính (Marp) — chiếu và phát cho team. **Không chứa ghi chú thuyết trình** |
| `00-slide-trinh-chieu.md` | Bản trình chiếu cũ, còn speaker notes trong comment HTML |
| `00-seminar.md` | Kịch bản dẫn buổi 60 phút: timing từng phần, câu dẫn, kịch bản demo, phụ lục "cắt gì nếu thiếu giờ" |
| `01-cau-hinh-global.md` | CLAUDE.md global (`~/.claude/CLAUDE.md`), settings.json, loại trừ `.tmp`/`.vshistory` khi tìm kiếm |
| `02-ra-de-bai.md` | ⭐ Luật 2 lần, plan mode, phỏng vấn ngược → SPEC.md, mẫu ra đề 5 phần |
| `03-quan-ly-context.md` | ⭐ Ẩn dụ "cái bàn", `/context`, `/clear` vs `/compact`, subagent, 7 công cụ tối ưu |
| `04-project-claude-md.md` | `/init`, viết gì/không viết gì, `.claude/rules/` với `paths`, triển khai theo tuần |
| `05-project-skill.md` | 3 loại skill, frontmatter, `context: fork`, bộ skill khởi đầu |
| `06-permission-bao-mat.md` | Deny rule, 6 permission mode, managed settings, hook, sandbox, prompt injection |

**Thứ tự đọc:** 01 → 06. Bước 02 và 03 là trọng tâm — bốn bước còn lại hỗ trợ hai bước đó.

## Quy ước khi sửa hoặc viết thêm

**Ngôn ngữ:** tiếng Việt. Thuật ngữ kỹ thuật giữ nguyên tiếng Anh (context, token, deny rule, plan mode, skill…). Xưng hô: gọi người đọc là "anh" hoặc "mình", không dùng "bạn".

**Ẩn dụ xuyên suốt — phải giữ nhất quán:**
- Context window = **cái bàn làm việc** (bàn không tự dọn · mỗi câu nói Claude đọc lại cả bàn · bàn bừa thì làm dở)
- `CLAUDE.md` = **tờ giấy dán trên bàn** (luôn nhìn thấy)
- Skill = **cuốn sách trên giá** (trên bàn chỉ có cái gáy sách = `description`)

**Cấu trúc mỗi file bước:** đặt vấn đề → giải thích cơ chế → kỹ thuật cụ thể kèm ví dụ → bảng tra nhanh → checklist → "3-4 câu chốt khi trình bày" → nguồn tham khảo.

**Giọng văn:** nói thẳng, không rào đón, không "AI rất mạnh mẽ". Ưu tiên câu ngắn có sức nặng để trích lên slide. Ví dụ phải dùng bối cảnh thật của công ty (hệ thống tồn kho, đồng bộ giá từ ERP, đơn hàng), không dùng foo/bar.

**Sự thật kỹ thuật:** mọi khẳng định về hành vi Claude Code phải kiểm chứng từ `code.claude.com/docs`, và ghi nguồn ở cuối file. Đừng viết theo trí nhớ — tài liệu thay đổi.

**Windows là môi trường mặc định.** Đường dẫn, lệnh PowerShell, và hai cái bẫy phải nhắc lại khi liên quan: viết `Read(...)` chứ không phải `Glob(...)`, và tiền tố `//` trong permission rule để khớp mọi ổ đĩa.

## Việc thường làm với thư mục này

- Cập nhật nội dung khi tài liệu Anthropic đổi → sửa file bước tương ứng **và** slide tương ứng, giữ hai bên khớp nhau
- Thêm bước mới → đánh số tiếp, cập nhật bảng chỉ mục trong file này và trong `00-seminar.md`
- Slide dùng cú pháp **Marp**: `---` ngăn slide, `<!-- _class: lead -->` cho slide nền tối, `<!-- _class: big -->` cho slide chữ to. Chiếu bằng VS Code + extension "Marp for VS Code"

<!-- Nếu sửa slide, nhớ đối chiếu lại với 00-seminar.md để timing không lệch -->
