# Bước 4 — Project CLAUDE.md

> Bước 1 cấu hình cho **một người**. Bước 4 cấu hình cho **cả team**.
> Một file commit vào repo, 20 người khỏi phải giải thích lại dự án cho Claude mỗi ngày.

---

## 1. Vì sao cần, khi đã có global rồi

File global ở bước 1 là **thói quen của anh**: trả lời tiếng Việt, dùng pnpm, đừng tự commit. Nó theo anh sang mọi project.

Nhưng những thứ này thì global không giải quyết được:

- Dự án này build bằng lệnh gì? Test bằng lệnh gì?
- Code service mới thì đặt ở thư mục nào, theo pattern nào?
- Kết nối DB staging lấy biến môi trường ở đâu?
- Cái module thanh toán kia vì sao viết kỳ lạ vậy, đụng vào có sao không?

Đây là **kiến thức của dự án**, và hiện tại nó nằm trong đầu 2-3 người trong team. Mỗi thành viên mới — hoặc mỗi phiên Claude mới — đều phải hỏi lại từ đầu.

> **Project CLAUDE.md là chỗ đóng gói kiến thức đó một lần, commit vào git, cả team dùng chung.**

Đây cũng là bước có **đòn bẩy tiết kiệm lớn nhất**: global tiết kiệm cho một người, project tiết kiệm cho hai mươi người, mỗi phiên.

---

## 2. Đặt ở đâu

| File | Vai trò | Git |
|---|---|---|
| `./CLAUDE.md` hoặc `./.claude/CLAUDE.md` | ⭐ Chuẩn chung của dự án | **Commit** |
| `./CLAUDE.local.md` | Ghi chú riêng của anh trong project này | **`.gitignore`** |

Hai vị trí của file project là tương đương — chọn một. Đặt trong `.claude/` thì gốc repo gọn hơn; đặt ở gốc thì dễ thấy hơn với người mới.

**Thứ tự nạp** (nhắc lại từ bước 1): managed policy → user global → project → local. Tất cả **nối lại**, không ghi đè. File gần thư mục làm việc nhất đọc sau cùng.

Với monorepo: Claude Code đi ngược lên cây thư mục, nạp mọi `CLAUDE.md` trên đường đi. File ở thư mục **con** thì nạp theo nhu cầu — khi Claude đọc file trong thư mục đó.

---

## 3. Tạo bằng `/init`

Đừng ngồi viết từ đầu. Trong thư mục dự án:

```
/init
```

Claude quét codebase, phát hiện build system, test framework, pattern code, rồi sinh ra một `CLAUDE.md` khởi đầu.

**Nếu file đã tồn tại**, `/init` không ghi đè — nó **đề xuất cải thiện**.

`/init` còn tự đọc cấu hình của công cụ AI khác nếu repo đã có: `.cursor/rules/`, `.cursorrules`, `.github/copilot-instructions.md` — và gộp phần liên quan vào.

### Chế độ tương tác (khuyên dùng)

Đặt biến môi trường `CLAUDE_CODE_NEW_INIT=1` trước khi chạy `/init`:

```powershell
$env:CLAUDE_CODE_NEW_INIT=1; claude
```

Lúc này `/init` chạy nhiều pha:

1. Hỏi anh muốn thiết lập những gì — `CLAUDE.md`, skill, hook
2. Cử một **subagent** đi khảo sát codebase (không tốn context chính)
3. Hỏi thêm để lấp chỗ trống
4. Trình một **bản đề xuất để anh duyệt** trước khi ghi bất cứ file nào

Chế độ này còn đọc thêm `AGENTS.md`, `.devin/rules/`, `.windsurf/rules/`, `.clinerules`.

> **Quan trọng:** `/init` chỉ là bản nháp. Nó chỉ biết những gì **đọc được từ code**. Giá trị thật của CLAUDE.md nằm ở những thứ Claude **không thể tự đoán** — anh phải tự thêm vào (xem mục 4).

Kiểm tra đã nạp: `/context` → mục **Memory files**.

---

## 4. Viết gì — và tuyệt đối đừng viết gì

Đây là phần quyết định file có tác dụng hay không.

| ✅ Nên có | ❌ Không nên có |
|---|---|
| Lệnh bash Claude không thể đoán | Bất cứ thứ gì Claude tự đọc code là biết |
| Quy tắc code **khác** với mặc định | Quy ước chuẩn của ngôn ngữ mà Claude đã biết |
| Cách chạy test, test runner ưa dùng | Tài liệu API chi tiết (trỏ link thay vì chép vào) |
| Quy tắc repo: đặt tên nhánh, quy ước PR | Thông tin hay thay đổi |
| Quyết định kiến trúc **riêng** của dự án | Mô tả từng file trong codebase |
| Quirk môi trường dev: biến env bắt buộc | Giải thích dài dòng, tutorial |
| Cạm bẫy, hành vi bất thường | Điều hiển nhiên kiểu "viết code sạch" |

**Phép thử cho từng dòng:**

> *"Bỏ dòng này đi thì Claude có làm sai không?"*
> Không → **xoá**.

### Ví dụ cho một dự án nội bộ

```markdown
# Dự án: Hệ thống quản lý tồn kho

## Lệnh
- Chạy dev: `pnpm dev` (cần Docker desktop đang chạy — Postgres + Redis)
- Test: `pnpm test <tên-file>`. **Đừng chạy `pnpm test` không tham số** — mất 8 phút.
- Type check: `pnpm typecheck` — chạy trước khi commit
- Migration: `pnpm db:migrate`. KHÔNG sửa file migration đã commit.

## Bố cục
- `src/api/` — controller, mỗi endpoint một file
- `src/services/` — nghiệp vụ, không đụng HTTP ở đây
- `src/repositories/` — truy cập DB, chỉ tầng này được import Prisma
- `src/legacy/` — code cũ từ hệ thống ERP. **Hỏi trước khi sửa.**

## Quy ước
- Endpoint mới: xem `src/api/orders/` làm mẫu
- Mọi query danh sách phải có phân trang, tối đa 200 dòng
- Tiền tệ lưu bằng số nguyên (đơn vị đồng), không dùng float

## Cạm bẫy
- `SyncService` chạy cron 5 phút/lần. Sửa nó phải kiểm tra idempotent.
- Bảng `inventory_snapshot` là view materialized, không insert trực tiếp.
- Tồn kho có thể **âm** (hàng đang về). Đừng thêm ràng buộc >= 0.

## Git
- Nhánh: `feat/<mã-ticket>-<mô-tả-ngắn>`
- KHÔNG push thẳng lên `main`
```

Ngắn, cụ thể, toàn thứ Claude không thể tự đoán. Đây là mẫu đáng chiếu lên màn hình.

### Ba mẹo nhỏ

**Nhấn mạnh có tác dụng.** Thêm `IMPORTANT` hoặc `YOU MUST` vào rule quan trọng làm Claude tuân thủ tốt hơn.

**Ghi chú cho người, không tốn token.** Comment HTML dạng khối bị **xoá trước khi** đưa vào context:

```markdown
<!-- Anh Nam thêm dòng dưới sau sự cố 12/03, đừng xoá -->
- KHÔNG chạy migration trên production ngoài giờ hành chính.
```

Dòng comment không tốn token nào, nhưng người đọc file vẫn thấy.

**Giới hạn 200 dòng.** Dài hơn thì Claude bắt đầu bỏ sót — chính rule quan trọng bị chìm trong nhiễu.

---

## 5. Khi file phình to: `.claude/rules/`

Dự án lớn thì nhét hết vào một file là hỏng. Tách theo chủ đề:

```
dự-án/
├── .claude/
│   ├── CLAUDE.md           # Chỉ dẫn chính, ngắn
│   └── rules/
│       ├── api-design.md
│       ├── testing.md
│       ├── database.md
│       └── security.md
```

Mọi file `.md` đều được tìm thấy, kể cả trong thư mục con.

### Rule theo đường dẫn — kỹ thuật đáng giá nhất

Thêm frontmatter `paths`, rule **chỉ nạp khi Claude đụng vào file khớp pattern**:

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# Quy tắc API

- Mọi endpoint phải validate input
- Dùng định dạng response lỗi chuẩn
- Có comment OpenAPI
```

Anh sửa frontend → rule này **không tốn một token nào**. Đụng vào `src/api/` → nó xuất hiện.

Đây là cách viết được **nhiều** hướng dẫn mà **không** làm phình context mỗi phiên.

| Pattern | Khớp với |
|---|---|
| `**/*.ts` | Mọi file TypeScript |
| `src/**/*` | Mọi file dưới `src/` |
| `*.md` | File markdown ở gốc |
| `src/**/*.{ts,tsx}` | Nhiều đuôi trong một pattern |

Rule **không có** `paths` thì nạp mọi lúc, ưu tiên ngang `.claude/CLAUDE.md`.

Cũng có rule cấp cá nhân ở `~/.claude/rules/` — nạp **trước** rule project, nên rule project được ưu tiên cao hơn.

---

## 6. Import file khác — `@đường/dẫn`

```markdown
Xem @README.md để hiểu tổng quan và @package.json để biết các lệnh npm.

# Hướng dẫn thêm
- Quy trình git: @docs/git-instructions.md
```

Ba điều cần biết:

1. **Import không tiết kiệm context.** File được import vẫn nạp đầy đủ lúc khởi động. Nó giúp **tổ chức**, không giúp tiết kiệm. Muốn tiết kiệm thì dùng `paths` ở mục 5.
2. **Tối đa 4 tầng** import lồng nhau. Đường dẫn tương đối tính từ file chứa nó.
3. **Muốn nhắc đường dẫn mà không import**, bọc trong dấu backtick: `` `@README` `` là chữ, `@README` là import.

⚠️ Import trỏ ra **ngoài** thư mục làm việc (ví dụ `@~/.claude/...`) sẽ hiện hộp thoại xác nhận lần đầu. Đây là lớp bảo vệ trước file do người khác commit vào repo chung.

---

## 7. Nếu repo đã có `AGENTS.md`

Claude Code đọc `CLAUDE.md`, **không** đọc `AGENTS.md`. Nếu team đã dùng công cụ AI khác, đừng chép đôi — import:

```markdown
@AGENTS.md

## Riêng cho Claude Code
Dùng plan mode khi sửa trong `src/billing/`.
```

Hoặc symlink nếu không cần thêm gì:

```bash
ln -s AGENTS.md CLAUDE.md
```

⚠️ Trên Windows, tạo symlink cần quyền Administrator hoặc Developer Mode — dùng cách import `@AGENTS.md` cho tiện.

---

## 8. Monorepo

Claude Code nạp mọi `CLAUDE.md` trên đường từ gốc filesystem xuống thư mục làm việc. Trong monorepo lớn, điều này kéo theo cả file của team khác.

Loại trừ bằng `claudeMdExcludes` — đặt trong `.claude/settings.local.json` để chỉ áp cho máy anh:

```json
{
  "claudeMdExcludes": [
    "**/monorepo/CLAUDE.md",
    "/home/user/monorepo/team-khac/.claude/rules/**"
  ]
}
```

Riêng CLAUDE.md từ managed policy thì **không loại trừ được** — đó là chủ ý, để chuẩn công ty luôn có hiệu lực.

---

## 9. Bảo trì: đối xử với nó như code

Đây là phần hay bị bỏ quên, và là lý do phổ biến nhất khiến CLAUDE.md mất tác dụng sau vài tháng.

**Review khi có sự cố.** Claude làm sai chuyện gì đó lẽ ra phải biết → thêm vào file. Code review bắt được lỗi Claude nên tránh → thêm vào file.

**Cắt tỉa định kỳ.** Chạy `/doctor` — nó đề xuất cắt bớt: bỏ những thứ Claude tự suy ra được từ code (bố cục thư mục, danh sách dependency, tổng quan kiến trúc), giữ lại cạm bẫy, lý do, và quy ước khác với mặc định.

**Ba dấu hiệu file đang có vấn đề:**

| Dấu hiệu | Nguyên nhân |
|---|---|
| Claude cứ làm sai dù đã có rule | File quá dài, rule bị chìm → cắt bớt |
| Claude hỏi thứ đã ghi trong file | Câu chữ mơ hồ → viết cụ thể hơn |
| Claude làm khác nhau giữa các phiên | Có hai rule mâu thuẫn → rà lại toàn bộ, kể cả file trong thư mục con |

**Sau `/compact`:** CLAUDE.md ở gốc project **sống sót** — Claude đọc lại từ đĩa và đưa vào lại. File trong thư mục con thì **không** tự đưa lại, phải chờ Claude đọc file trong thư mục đó lần nữa.

---

## 10. Triển khai cho team 20 người

Quy trình đề xuất:

**Tuần 1 — Dựng bản đầu**
1. Một người (người thạo repo nhất) chạy `/init` với `CLAUDE_CODE_NEW_INIT=1`
2. Bổ sung tay phần **cạm bẫy** và **quyết định kiến trúc** — đây là thứ `/init` không đoán được
3. Cắt xuống dưới 200 dòng
4. Mở PR như một PR code bình thường, để cả team review

**Tuần 2-4 — Bồi đắp**
5. Ai bị Claude làm sai chuyện gì → mở PR thêm một dòng vào CLAUDE.md
6. Mỗi dòng thêm vào phải qua phép thử *"bỏ đi thì Claude có sai không?"*

**Hằng tháng**
7. Chạy `/doctor`, cắt bớt phần đã lỗi thời
8. Phần nào đã thành **quy trình nhiều bước** → chuyển sang **Skill** (bước 5)

> Đưa CLAUDE.md vào checklist review PR. Sửa kiến trúc mà không cập nhật CLAUDE.md thì cũng như sửa API mà không cập nhật tài liệu.

---

## 11. Checklist

- [ ] Đã chạy `/init` trong repo chính chưa?
- [ ] Đã bổ sung tay phần **cạm bẫy** và **quyết định kiến trúc** chưa?
- [ ] Đã áp phép thử *"bỏ dòng này Claude có sai không?"* cho từng dòng chưa?
- [ ] File có dưới **200 dòng** không?
- [ ] Có rule nào mâu thuẫn nhau không?
- [ ] Hướng dẫn chỉ liên quan một phần code → đã chuyển sang `.claude/rules/` với `paths` chưa?
- [ ] Đã commit vào git chưa? (Không commit thì cả bước này vô nghĩa)
- [ ] Đã chạy `/context` xác nhận nó thật sự được nạp chưa?
- [ ] `CLAUDE.local.md` đã nằm trong `.gitignore` chưa?

---

## 12. Ba câu chốt khi trình bày

1. **Global tiết kiệm cho một người, project tiết kiệm cho hai mươi người.** Đây là bước có đòn bẩy cao nhất trong cả bộ tài liệu.
2. **`/init` chỉ là bản nháp.** Nó viết được những gì đọc từ code. Giá trị thật nằm ở phần *cạm bẫy* — thứ chỉ người đã dính mới biết.
3. **Đối xử với CLAUDE.md như code:** review khi có sự cố, cắt tỉa định kỳ, và đưa vào checklist PR.

---

## Nguồn tham khảo

- [How Claude remembers your project](https://code.claude.com/docs/en/memory) — CLAUDE.md, `.claude/rules/`, import, monorepo
- [Best practices](https://code.claude.com/docs/en/best-practices) — mục *Write an effective CLAUDE.md*
- [Commands reference](https://code.claude.com/docs/en/commands) — `/init`, `/doctor`, `/context`, `/memory`
- [Settings](https://code.claude.com/docs/en/settings) — `claudeMdExcludes`
