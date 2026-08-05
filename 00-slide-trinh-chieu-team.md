---
marp: true
theme: default
paginate: true
size: 16:9
style: |
  section {
    font-family: "Segoe UI", Arial, sans-serif;
    font-size: 26px;
    padding: 60px 70px;
  }
  h1 { font-size: 52px; color: #1a1a1a; }
  h2 { font-size: 40px; color: #1a1a1a; margin-bottom: 0.4em; }
  h3 { font-size: 30px; color: #444; }
  strong { color: #0b6e4f; }
  code { background: #f2f2f2; font-size: 0.92em; }
  pre { font-size: 20px; line-height: 1.45; }
  table { font-size: 24px; }
  blockquote {
    border-left: 5px solid #0b6e4f;
    padding-left: 24px;
    color: #333;
    font-size: 30px;
  }
  section.lead {
    background: #16211d;
    color: #f5f5f5;
  }
  section.lead h1, section.lead h2 { color: #ffffff; }
  section.lead strong { color: #6fcf97; }
  section.big { font-size: 40px; }
  .huge { font-size: 84px; font-weight: 700; color: #0b6e4f; }
  .muted { color: #777; font-size: 22px; }
---

<!-- _class: lead -->

# Dùng Claude tiết kiệm và đúng hướng

### 6 bước cho team IT Applications

<br>

<span class="muted">Seminar 60 phút · Phòng Ứng dụng CNTT</span>

---

<!-- _class: big -->

## Hai câu hỏi

<br>

**1.** Ai từng bảo Claude sửa một thứ — nó sửa sai — mình bảo sửa lại — vẫn sai — rồi cứ thế 10 lần?

<br>

**2.** Ai từng thấy buổi chiều Claude "ngu" hơn buổi sáng?

---

## Ba điều trước khi bắt đầu

<br>

**1.** Cả hai chuyện đó **không phải do Claude dở**. Chúng có nguyên nhân kỹ thuật cụ thể.

**2.** Và cả hai **đang tốn token và thời gian** nhiều hơn mọi người tưởng.

**3.** Hôm nay có 6 bước. **Hai bước giữa** quan trọng nhất — bốn bước còn lại là để hỗ trợ hai bước đó.

---

## Lộ trình

| | Bước | |
|---|---|---|
| ① | CLAUDE.md global | Nền |
| ② | **Ra đề bài đúng ngay từ đầu** | ⭐ |
| ③ | **Quản lý context** | ⭐ |
| ④ | Project CLAUDE.md | Đòn bẩy team |
| ⑤ | Project Skill | Mở rộng |
| ⑥ | Permission & bảo mật | Trách nhiệm IT |

---

<!-- _class: lead -->

# ①
## CLAUDE.md global

<span class="muted">5 → 12 phút</span>

---

<!-- _class: big -->

> Mỗi phiên Claude bắt đầu với **trí nhớ trắng tinh**.

<br>

Nó không nhớ gì từ hôm qua.

Vậy nên ngày nào ta cũng gõ lại *"trả lời tiếng Việt"*, *"đừng tự commit"*.

---

## Bốn tầng — nhớ hai tầng là đủ

<br>

| Tầng | Vị trí | Là gì |
|---|---|---|
| **User (global)** | `C:\Users\<user>\.claude\CLAUDE.md` | Thói quen của **anh**<br>Mọi project |
| **Project** | `./CLAUDE.md` | Kiến thức của **dự án**<br>Commit vào git |

<br>

<span class="muted">Còn managed policy (IT deploy) và CLAUDE.local.md — nói ở bước ⑥ và ④</span>

---

## Tạo file: gõ `/memory`

<br>

Chọn **User CLAUDE.md** → file chưa có thì nó tự tạo rồi mở editor.

<br>

Không cần nhớ đường dẫn. Không cần mở File Explorer.

---

## 🖥 Thử ngay

Gõ `/memory` → chọn **User CLAUDE.md** → dán:

```markdown
# Preferences
- Trả lời bằng tiếng Việt, ngắn gọn, không rào đón.
- Không tự chạy git commit/push khi tôi chưa yêu cầu.
- Trước khi sửa >3 file, trình bày kế hoạch rồi chờ tôi duyệt.

# Style
- Không viết comment giải thích code hiển nhiên.
```

<span class="muted">Notepad: khi save nhớ chọn Encoding UTF-8, không thì lỗi font tiếng Việt.</span>

---

## Kiểm tra: gõ `/context`

<br>

Nhìn mục **Memory files** — phải thấy tên file.

<br>

> Không thấy ở đây nghĩa là **Claude không đọc được nó**.

<br>

Đây là cách kiểm tra duy nhất.

---

## Ba quy tắc viết

<br>

**Dưới 200 dòng** — dài hơn thì Claude bắt đầu bỏ sót, chính rule quan trọng bị chìm

**Cụ thể** — *"dùng indent 2 space"* thắng *"format code cho đẹp"*

**Không mâu thuẫn** — hai rule chọi nhau thì Claude chọn bừa một cái

<br>

> **Chốt:** thứ gì mình gõ lại **lần thứ hai** là thứ nên nằm trong file này.

---

<!-- _class: lead -->

# ②
## Ra đề bài đúng ngay từ đầu

<span class="muted">12 → 26 phút · Trọng tâm 1</span>

---

## Quen không?

```
Bạn:    Sửa lại màn hình tồn kho cho đẹp hơn
Claude: [sửa 8 file]
Bạn:    Không phải, tôi chỉ muốn sửa phần bảng
Claude: [sửa lại]
Bạn:    Bảng phải có phân trang nữa
Claude: [thêm phân trang]
Bạn:    Ủa sao cái filter cũ mất rồi?
Claude: [khôi phục filter]
Bạn:    Giờ nó lại lỗi khi tồn kho = 0
...
```

---

<!-- _class: big -->

## Vấn đề không nằm ở Claude

<br>

Nó nằm ở chỗ yêu cầu được **khám phá dần dần**

bằng cách **nhìn kết quả sai**.

---

## Ba chi phí chồng nhau

### ① Token tăng lũy tiến

Mỗi lượt chat gửi lại **toàn bộ** hội thoại từ đầu:

```
Lượt 1:  gửi  2.000 token
Lượt 5:  gửi 25.000 token   ← vẫn chỉ gõ 1 câu
Lượt 12: gửi 80.000 token   ← vẫn chỉ gõ 1 câu
```

---

## Ba chi phí chồng nhau

### ② Context bị ô nhiễm

Các phiên bản **sai** vẫn nằm nguyên trong context.

Claude vẫn "nhìn thấy" chúng.

<br>

> Đây là lý do nó hay quay lại **đúng cái lỗi mình vừa sửa**.

---

## Ba chi phí chồng nhau

### ③ Context đầy làm Claude kém đi

Hiệu năng mô hình **giảm** khi context đầy.

Nó bắt đầu quên chỉ dẫn ở đầu buổi — kể cả rule trong `CLAUDE.md`.

---

<!-- _class: lead -->

<div class="huge">≠ chậm gấp 10</div>

<br>

## Sửa 10 lần không phải là chậm gấp 10.

## Nó **vừa chậm hơn, vừa cho kết quả tệ hơn**.

---

## Anthropic gọi tên nó

> **Correcting over and over.**
> Claude làm sai, bạn sửa, vẫn sai, bạn sửa tiếp.
> Context bị ô nhiễm bởi các phương án hỏng.
>
> **Fix:** Sau **hai** lần sửa thất bại → `/clear` và viết lại đề bài.

<br>

<span class="muted">Một trong năm failure pattern phổ biến nhất trong tài liệu chính thức</span>

---

<!-- _class: lead big -->

> *"Một session sạch với prompt tốt hơn*
> *gần như luôn thắng*
> *một session dài với đống chỉnh sửa tích tụ."*

<br>

<span class="muted">— Claude Code Best Practices</span>

---

<!-- _class: big -->

## Luật 2 lần

<br>

Sửa **hai lần** vẫn sai

→ vấn đề nằm ở **đề bài**, không nằm ở Claude.

<br>

`/clear` rồi viết lại.

---

## Bốn kỹ thuật

| | | |
|---|---|---|
| **1** | **Plan mode** — `Shift+Tab` | Duyệt kế hoạch bằng chữ rẻ hơn duyệt code |
| **2** | **Bảo nó phỏng vấn ngược mình** | Thuốc đặc trị "chưa rõ mình muốn gì" |
| **3** | **`Esc` sớm · `Esc Esc` quay lui** | Sửa đề bài gốc, đừng chồng thêm lời |
| **4** | **Định nghĩa "xong" trước** | "Không đúng ý" = chưa ai nói "đúng ý" là gì |

---

## Kỹ thuật 1 — Plan mode

Bấm `Shift+Tab` cho tới khi thanh trạng thái hiện:

```
⏸ plan mode on
```

<br>

Claude **đọc file, phân tích, lập kế hoạch — không sửa gì cả**.

Đọc kế hoạch → duyệt hoặc bắt sửa → xong mới cho chạy.

<br>

`Ctrl+G` mở kế hoạch trong editor để sửa trực tiếp.

---

<!-- _class: lead -->

# 🖥 Demo — Plan mode

<br>

**1.** `Shift+Tab` → thanh trạng thái hiện `⏸ plan mode on`
**2.** Gõ yêu cầu → Claude đọc code, trình kế hoạch
**3.** Đọc kế hoạch, tìm chỗ sai
**4.** `Ctrl+G` sửa trực tiếp → duyệt → cho chạy

<br>

> Sửa một dòng sai trong kế hoạch mất **10 giây**.
> Để nó code xong 8 file rồi mới phát hiện thì mất bao lâu?

---

## Khi nào KHÔNG cần plan mode

<br>

Sửa typo · thêm một dòng log · đổi tên biến → **làm thẳng**

<br>

> **Nguyên tắc:** nếu mô tả được nguyên cái diff trong **một câu**, bỏ qua plan mode.

<br>

Plan mode đáng giá khi: **>3 file**, chưa chắc cách làm, hoặc code lạ chưa quen.

---

## Kỹ thuật 2 — Để nó phỏng vấn ngược

```
Tôi muốn làm [X]. Hãy phỏng vấn tôi thật kỹ
bằng công cụ AskUserQuestion.

Hỏi về triển khai kỹ thuật, UI/UX, trường hợp biên, rủi ro.
Đừng hỏi câu hiển nhiên — đào vào chỗ khó tôi chưa nghĩ tới.

Cứ hỏi tới khi đủ, rồi viết spec vào SPEC.md.
```

Xong spec → **mở phiên mới** để thực thi.

---

## Kỹ thuật 3 — Sửa đề bài, đừng chồng lời

<br>

| Phím | Tác dụng |
|---|---|
| `Esc` | Dừng ngay khi thấy đi sai — giữ nguyên context |
| `Esc` `Esc` | Quay về checkpoint cũ, **sửa lại prompt gốc** |
| `/clear` | Sau 2 lần sửa thất bại, hoặc khi đổi việc |

<br>

Mỗi prompt tự tạo một **checkpoint** → mạnh dạn thử hướng liều, sai thì quay về.

---

## Kỹ thuật 4 — Định nghĩa "xong"

| ❌ Trước | ✅ Sau |
|---|---|
| *"viết hàm validate email"* | *"...test case: `a@b.com`→true, `invalid`→false. Chạy test sau khi implement."* |
| *"làm dashboard đẹp hơn"* | *"[ảnh] implement theo thiết kế này. Chụp màn hình, so với ảnh gốc, liệt kê điểm khác."* |
| *"build đang lỗi"* | *"build lỗi: [dán lỗi]. Sửa và xác nhận build thành công. Xử lý gốc rễ."* |

---

## Mẫu ra đề bài 5 phần

```
【BỐI CẢNH】  File nào — dùng @ để trỏ thẳng
【MỤC TIÊU】  Muốn đạt gì — kết quả, không phải cách làm
【RÀNG BUỘC】 Không được đụng gì, theo pattern nào
【XONG LÀ】   Tiêu chí nghiệm thu kiểm chứng được
【PHẠM VI】   Cái gì NGOÀI phạm vi lần này
```

<br>

> Dài hơn thật. Nhưng nó thay thế **12 lượt chat**.

---

## Ví dụ đối chiếu

**❌** `Sửa lại màn hình quản lý tồn kho cho đẹp hơn`

**✅**
```
【BỐI CẢNH】 @src/inventory/InventoryTable.tsx — render 3000 dòng
             một lúc, load rất chậm.
【MỤC TIÊU】 Thêm phân trang server-side, 50 dòng/trang.
【RÀNG BUỘC】 Theo pattern @src/orders/OrderTable.tsx.
             Không thêm thư viện. Giữ nguyên filter hiện có.
【XONG LÀ】   Chuyển trang không reload · filter giữ nguyên
             · tồn kho = 0 và âm vẫn đúng · pnpm test inventory pass
【PHẠM VI】   Chỉ bảng. Không đụng form nhập kho, không đổi API.
```

---

<!-- _class: lead big -->

## `Shift+Tab`

<br>

là phím đáng học nhất trong Claude Code.

---

<!-- _class: lead -->

# ③
## Quản lý context

<span class="muted">26 → 39 phút · Trọng tâm 2</span>

---

<!-- _class: big -->

## Hình dung Claude ngồi làm việc trên một **cái bàn**

<br>

Mọi thứ nó cần đều phải đặt trên bàn:

hướng dẫn của mình · file nó đã mở · kết quả lệnh nó chạy

· và **toàn bộ cuộc trò chuyện**

---

## Ba điều về cái bàn

<br>

**① Bàn không tự dọn.**
File mở lúc 9h sáng, 4h chiều vẫn nằm đó.

**② Mỗi lần mình nói một câu, Claude đọc lại CẢ CÁI BÀN.**
Không phải chỉ đọc câu mình vừa nói.

**③ Bàn càng bừa, Claude càng làm dở.**
Nó thực sự *quên* chỉ dẫn ở đầu buổi.

---

<!-- _class: lead -->

# 🖥 Thử ngay

## Mở phiên đang chạy dở → gõ `/context`

<br>

Xem mục **Memory files** — file nào đang được nạp

Xem tổng % context đã dùng — **đang trên 50% chưa?**

---

## Vừa mở, chưa làm gì: **~7.850 token**

| | Token |
|---|---:|
| System prompt | 4.200 |
| Project CLAUDE.md | 1.800 |
| Auto memory | 680 |
| Skill descriptions | 450 |
| CLAUDE.md global | 320 |
| Environment info | 280 |

---

## Đọc 4 file + 1 lần test: **thêm ~8.700**

| | Token |
|---|---:|
| Đọc `src/api/auth.ts` | 2.400 |
| Đọc `middleware.ts` | 1.800 |
| Đọc `auth.test.ts` | 1.600 |
| Chạy `npm test` (output) | 1.200 |
| Đọc `src/lib/tokens.ts` | 1.100 |
| Grep tìm chuỗi | 600 |

> Nhiều hơn cả phần khởi động.

---

## Vì sao phiên chiều đắt hơn phiên sáng

<br>

**Context dài** — gửi lại toàn bộ hội thoại mỗi request

**Cache miss** — nghỉ quá 1 tiếng thì lần gõ đầu phải xử lý lại toàn bộ với **giá đầy đủ**

<span class="muted">Đi ăn trưa về mà tiếp phiên cũ chính là tình huống này.</span>

**`/compact` cũng tốn tiền** — nó phải *đọc* cả cuộc trò chuyện để tóm tắt

---

<!-- _class: lead big -->

## `/clear` **miễn phí**

## `/compact` thì **không**

<br>

Không cần giữ mạch việc thì đừng nén — dọn sạch.

---

## Bốn cách dọn bàn

<br>

| Lệnh | Dùng khi |
|---|---|
| `/btw` | Hỏi vặt — câu trả lời **không vào lịch sử** |
| `/compact <chỉ dẫn>` | Phiên dài nhưng vẫn cùng một việc |
| `Esc Esc` → *Summarize* | Chỉ một đoạn cụ thể bị rác |
| **`/clear`** | **Đổi việc. Thói quen quan trọng nhất.** |

<br>

<span class="muted">Mẹo: `/rename oauth-migration` trước khi clear để sau này `/resume` dễ tìm</span>

---

## Công cụ 1 — Subagent

```
Dùng subagent để điều tra cách hệ thống
đồng bộ giá từ ERP.
```

<br>

Nó đọc 30 file trong **một cái bàn riêng**, rồi chỉ mang về **bản tóm tắt**.

Bàn của mình không bẩn.

<br>

> Đây là cách **duy nhất** để đọc nhiều mà tốn ít.

---

## Công cụ 2 & 3

### CLI tool thay MCP server

Cài `gh`, `az`, `aws`, CLI nội bộ.

Tiết kiệm context hơn MCP vì **không thêm danh sách tool nào** vào bàn.

<br>

### Chọn đúng model

**Sonnet** cho đa số việc code · **Opus** để dành cho kiến trúc

---

## Tra nhanh: triệu chứng → thuốc

| Triệu chứng | Xử lý |
|---|---|
| Phiên mở cả ngày, càng lúc càng chậm | `/clear` |
| Cần đọc nhiều file để tìm hiểu | **Subagent** |
| Output test/log quá dài | Hook lọc hoặc subagent |
| Đi ăn trưa về, phiên cũ đắt bất thường | `/clear` mở phiên mới |
| Hỏi một câu vặt | `/btw` |
| Không biết gì đang tốn | `/context` · `/usage` |

---

<!-- _class: lead big -->

## Đừng để Claude tự đọc cả kho code

<br>

Subagent · CLI tool · đề bài cụ thể

đều nhằm **một việc**: đọc nhiều mà mang về ít.

---

<!-- _class: lead -->

# ④
## Project CLAUDE.md

<span class="muted">39 → 46 phút</span>

---

## Global không giải quyết được những thứ này

<br>

- Dự án này build bằng lệnh gì? Test bằng lệnh gì?
- Service mới thì đặt ở thư mục nào, theo pattern nào?
- Cái module thanh toán kia vì sao viết kỳ lạ vậy?

<br>

> Kiến thức đó đang nằm trong đầu **2-3 người** trong phòng này.

---

<!-- _class: lead big -->

## Global tiết kiệm cho **một người**

## Project tiết kiệm cho **hai mươi người**

<br>

mỗi phiên.

---

## Tạo bằng `/init`

<br>

Claude quét codebase → phát hiện build system, test framework, pattern code
→ sinh ra `CLAUDE.md` khởi đầu.

<br>

File đã có sẵn thì nó **đề xuất cải thiện**, không ghi đè.

<br>

<span class="muted">Bật chế độ tương tác: đặt biến `CLAUDE_CODE_NEW_INIT=1` — nó sẽ hỏi, khảo sát bằng subagent, rồi trình bản đề xuất để duyệt</span>

---

<!-- _class: big -->

## `/init` chỉ là **bản nháp**

<br>

Nó chỉ biết những gì **đọc được từ code**.

<br>

Giá trị thật nằm ở phần nó **không thể đoán**.

---

## Thứ chỉ người đã dính mới biết

```markdown
## Cạm bẫy
- `SyncService` chạy cron 5 phút/lần.
  Sửa phải kiểm tra idempotent.
- Tồn kho có thể ÂM (hàng đang về).
  Đừng thêm ràng buộc >= 0.
- `src/legacy/` là code từ ERP cũ. HỎI TRƯỚC KHI SỬA.
- Đừng chạy `pnpm test` không tham số — mất 8 phút.
```

> Không AI nào đoán được. Đây chính là lý do file này đáng làm.

---

## Phép thử cho từng dòng

<br>

<!-- _class: big -->

> *"Bỏ dòng này đi thì Claude có làm sai không?"*

<br>

**Không → xoá.**

<br>

<span class="muted">Giới hạn 200 dòng. Dài hơn thì rule quan trọng bị chìm trong nhiễu.</span>

---

## Hai mẹo

### `.claude/rules/` với `paths`

```markdown
---
paths: ["src/api/**/*.ts"]
---
# Quy tắc API
- Mọi endpoint phải validate input
```

Sửa frontend → **không tốn một token nào**. Đụng `src/api/` → nó xuất hiện.

### Comment HTML không tốn token

```markdown
```

---

<!-- _class: lead big -->

## Sửa kiến trúc mà không cập nhật CLAUDE.md

## = sửa API mà không cập nhật tài liệu

<br>

Đưa nó vào checklist review PR.

---

<!-- _class: lead -->

# ⑤
## Project Skill

<span class="muted">46 → 52 phút</span>

---

<!-- _class: big -->

## `CLAUDE.md` là **tờ giấy dán trên bàn**

Luôn nhìn thấy, mọi lúc. Tốn chỗ suốt phiên.

<br>

## Skill là **cuốn sách trên giá**

Trên bàn chỉ có cái **gáy sách** — một dòng mô tả.
Khi nào cần mới với tay lấy xuống.

---

## Hệ quả

<br>

Viết được một skill **400 dòng** về quy trình release —

và nó **gần như không tốn gì** cho tới ngày thực sự release.

<br>

**Quy tắc phân biệt:**

- Sự thật ngắn, áp dụng mọi lúc → `CLAUDE.md`
- Quy trình nhiều bước, thỉnh thoảng dùng → **Skill**

---

## Một thư mục + một file

```
.claude/skills/review-pr/SKILL.md   →   gõ /review-pr
```

```markdown
---
description: Review PR theo chuẩn team. Dùng khi cần review code,
  kiểm tra PR trước khi merge, hoặc tự soát lại thay đổi của mình.
---

1. Chạy `git diff main...HEAD`
2. Kiểm tra: có test không? có hardcode key không?
   query có index chưa? có nuốt exception ở đâu không?
3. Mỗi vấn đề nêu file:dòng, rủi ro cụ thể, cách sửa
4. Không góp ý style — đã có linter lo
```

---

## Một cảnh báo

Việc có **tác dụng phụ** — deploy, commit, gửi tin nhắn — luôn thêm:

```yaml
disable-model-invocation: true
```

<br>

> Mình không muốn Claude tự quyết định deploy
> chỉ vì thấy code **có vẻ** xong.

---

## Bộ khởi đầu — đừng làm 10 cái ngay

<br>

| Skill | Loại |
|---|---|
| `/review-pr` | Quy trình |
| `/commit` | Quy trình · `disable-model-invocation` |
| `api-conventions` | Kiến thức · có `paths` |

<br>

<span class="muted">Skill ít mà dùng thật hơn skill nhiều mà bỏ xó</span>

---

<!-- _class: lead big -->

## Skill commit vào repo =

## kinh nghiệm của người giỏi nhất phòng
## trở thành **mặc định cho cả 20 người**

<br>

Tiết kiệm token chỉ là hệ quả phụ.

---

<!-- _class: lead -->

# ⑥
## Permission & bảo mật

<span class="muted">52 → 57 phút</span>

---

<!-- _class: big -->

## `CLAUDE.md` **gợi ý**

## `settings.json` **ràng buộc**

<br>

<span class="muted">Permission rule được thực thi bởi Claude Code, không phải bởi model.</span>

---

## Ba tầng

```json
{
  "permissions": {
    "deny": [
      "Read(//**/.env)",
      "Read(//**/*.pem)",
      "Bash(git push --force *)"
    ],
    "ask":   ["Bash(git push *)"],
    "allow": ["Bash(pnpm test *)", "Bash(git status)"]
  }
}
```

**deny** = không bao giờ · **ask** = phải xác nhận · **allow** = làm suốt ngày, đừng hỏi nữa

---

<!-- _class: big -->

## Ý phản trực giác

<br>

Viết `allow` cho việc an toàn **là một biện pháp bảo mật** —
không phải sự đánh đổi.

<br>

Vì sau lần bấm **"Yes" thứ mười**, không ai còn đọc nữa.

---

## Hai điều nhớ ngay

<br>

### `Ctrl+E` ở màn hình hỏi quyền

Claude giải thích lệnh đó làm gì, có thể hỏng ra sao — kèm nhãn **Low / Med / High risk**

<br>

### Không dùng `bypassPermissions` ngoài container

Chế độ này bỏ qua cả việc ghi vào `.git`, `.claude`, `.vscode`

<span class="muted">Phòng IT sẽ khoá chế độ này ở tầng managed settings</span>

---

<!-- _class: lead big -->

## Lớp phòng thủ cuối cùng

## vẫn là **con người đọc lệnh trước khi bấm duyệt**

<br>

Không cấu hình nào thay thế được việc đó.

---

<!-- _class: lead -->

# Chốt

---

## Ba câu mang về

<br>

**1.** Sửa nhiều vòng không phải chậm hơn — mà là **vừa chậm hơn, vừa dở hơn**.

<br>

**2.** Mỗi câu mình gõ, Claude **đọc lại cả cuộc trò chuyện**. Nên `/clear` khi đổi việc.

<br>

**3.** Thứ gì gõ lại **lần thứ hai** là thứ nên nằm trong `CLAUDE.md`.

---

## Ba việc làm trước thứ Sáu

<br>

| | Việc | Mất bao lâu |
|---|---|---|
| **1** | Tạo `~/.claude/CLAUDE.md` bằng `/memory` | **5 phút** |
| **2** | Lần tới sửa >3 file → thử **plan mode** một lần | 0 phút |
| **3** | Tập phản xạ **`/clear` khi đổi việc** | 0 phút |

<br>

> Chỉ ba việc. Hai việc cuối **không mất phút nào** — chỉ là đổi thói quen.

---

<!-- _class: lead -->

# Tài liệu chi tiết

## `F:\AI\Guide\`

<br>

`01` Cấu hình global · `02` Ra đề bài · `03` Quản lý context
`04` Project CLAUDE.md · `05` Project Skill · `06` Permission & bảo mật

<br>

<span class="muted">Câu hỏi?</span>

---

<!-- _class: lead -->

# Phụ lục
## Câu hỏi thường gặp

---

## Câu hỏi thường gặp (1/2)

**"Viết vào CLAUDE.md nó có chắc chắn nghe không?"**
Không. Đó là context, không phải config được enforce. Muốn chắc → deny rule hoặc hook.

**"Viết đề bài dài thế thì tự code còn nhanh hơn."**
Mẫu 5 phần chỉ dành cho việc >3 file hoặc chưa chắc cách làm. Sửa typo thì làm thẳng.

**"`/clear` xong mất hết context, phải giải thích lại từ đầu à?"**
Đúng — đó là lý do phải có CLAUDE.md và SPEC.md. Cái cần giữ thì **viết ra file**, đừng giữ trong hội thoại.

---

## Câu hỏi thường gặp (2/2)

**"Sao không để nó tự làm hết, mình duyệt cuối?"**
Được, nhưng phải cho nó thứ **kiểm chứng được** — test, build, screenshot. Không có gì để kiểm thì "trông có vẻ xong" là tín hiệu duy nhất nó có.

**"Cowork có dùng CLAUDE.md không?"**
Không đọc file trên máy. Tương đương là **Project instructions** và **Personal preferences** trong UI.

**"Dữ liệu công ty có bị dùng để train không?"**
Tuỳ theo gói và điều khoản áp dụng cho tài khoản công ty. Xem **Commercial Terms** và **Privacy Center** của Anthropic, hoặc hỏi phòng IT.
