# Kịch bản Seminar — Dùng Claude tiết kiệm và đúng hướng

**Thời lượng:** 60 phút · **Đối tượng:** 20 người, dev/IT đã quen terminal
**Người trình bày cầm file này.** Tài liệu chi tiết từng phần nằm ở các file `01` → `06`.

---

## Bản đồ 60 phút

| Phút | Phần | Trọng số |
|---|---|---|
| 0–5 | Mở đầu — đặt vấn đề | Khởi động |
| 5–12 | ① CLAUDE.md global | Nền |
| 12–26 | ② Ra đề bài đúng ngay từ đầu | ⭐ **Trọng tâm 1** |
| 26–39 | ③ Quản lý context | ⭐ **Trọng tâm 2** |
| 39–46 | ④ Project CLAUDE.md | Đòn bẩy team |
| 46–52 | ⑤ Project Skill | Mở rộng |
| 52–57 | ⑥ Permission & bảo mật | Trách nhiệm IT |
| 57–60 | Chốt — 3 việc làm ngay | Hành động |

> **Nguyên tắc dẫn buổi:** phần ② và ③ là lý do cả buổi tồn tại. Bốn phần còn lại phục vụ hai phần đó. Thiếu giờ thì cắt ④⑤⑥, **không bao giờ cắt ②③**.

---

## Chuẩn bị trước buổi

- [ ] Mở sẵn **một repo thật của công ty** trong terminal — demo trên code thật thuyết phục hơn demo trên project mẫu
- [ ] Chuẩn bị sẵn một phiên đã chat lộn xộn ~15 lượt (để demo `/context` cho ra con số xấu)
- [ ] Font terminal cỡ lớn, kiểm tra người ngồi cuối phòng đọc được
- [ ] Nhắc mọi người **mang laptop** — có 2 chỗ cả phòng làm theo tại chỗ
- [ ] In hoặc chiếu sẵn **mẫu ra đề bài 5 phần** (phần ②)

---

## 0–5' · Mở đầu

**🎯 Mục tiêu:** làm cả phòng thừa nhận vấn đề trước khi nghe giải pháp.

**💬 Mở bằng câu hỏi giơ tay** (đừng mở bằng slide):

> "Ai từng bảo Claude sửa một thứ, nó sửa sai, mình bảo sửa lại, vẫn sai, rồi cứ thế 10 lần?"

*(Chờ tay giơ. Sẽ gần như cả phòng.)*

> "Ai từng thấy buổi chiều Claude ngu hơn buổi sáng?"

**Nói ba câu này rồi đi tiếp — đừng giải thích vội:**

1. Cả hai chuyện đó **không phải do Claude dở**. Chúng có nguyên nhân kỹ thuật cụ thể.
2. Và cả hai đều **đang tốn tiền của công ty** nhiều hơn mọi người tưởng.
3. Hôm nay có 6 bước. Hai bước giữa quan trọng nhất, bốn bước còn lại là để hỗ trợ hai bước đó.

**⚠️ Bẫy:** đừng mở đầu bằng "AI rất mạnh mẽ...". Cả phòng đã dùng rồi, họ cần biết **vì sao nó không như kỳ vọng**.

---

## 5–12' · ① CLAUDE.md global

**🎯 Mục tiêu duy nhất:** ai về cũng tạo được file global cho mình.
📄 Chi tiết: `01-cau-hinh-global.md`

**💬 Câu dẫn:**

> "Mỗi phiên Claude bắt đầu với trí nhớ trắng tinh. Nó không nhớ gì từ hôm qua. Vậy nên ngày nào ta cũng gõ lại 'trả lời tiếng Việt', 'đừng tự commit'."

### Ba ý — không hơn

**1. Bốn tầng, nhớ hai tầng là đủ**

| Tầng | Vị trí | Là gì |
|---|---|---|
| **User (global)** | `C:\Users\<user>\.claude\CLAUDE.md` | Thói quen của **anh**, mọi project |
| **Project** | `./CLAUDE.md` | Kiến thức của **dự án**, commit vào git |

*(Còn managed policy và local — nhắc một câu rồi bỏ qua, để dành cho phần ⑥ và ④.)*

**2. Tạo bằng `/memory`, không cần nhớ đường dẫn**

**3. Ba quy tắc viết**
- **Dưới 200 dòng** — dài hơn thì Claude bắt đầu bỏ sót
- **Cụ thể**: "indent 2 space" thắng "format cho đẹp"
- **Không mâu thuẫn** — hai rule chọi nhau thì Claude chọn bừa

### 🖥 Hành động tại chỗ (2 phút)

> "Mọi người mở terminal, gõ `/memory`, chọn **User CLAUDE.md**."

Chiếu template lên màn hình cho cả phòng chép:

```markdown
# Preferences
- Trả lời bằng tiếng Việt, ngắn gọn, không rào đón.
- Không tự chạy git commit/push khi tôi chưa yêu cầu.
- Trước khi sửa >3 file, trình bày kế hoạch rồi chờ tôi duyệt.
```

Rồi: `/context` → chỉ vào mục **Memory files**.

> "Không thấy tên file ở đây nghĩa là Claude không đọc được nó. Đây là cách kiểm tra duy nhất."

**✅ Câu chốt:** *"Thứ gì mình gõ lại lần thứ hai là thứ nên nằm trong file này."*

**⚠️ Bẫy hay gặp:** ai đó sẽ hỏi *"viết vào đây thì nó có chắc chắn nghe không?"* — Trả lời thẳng: **không**. Đây là gợi ý, không phải ràng buộc. Muốn ràng buộc thì chờ phần ⑥.

---

## 12–26' · ② Ra đề bài đúng ngay từ đầu ⭐

**🎯 Mục tiêu:** cả phòng đổi thói quen từ "chat rồi sửa dần" sang "giao việc rồi nghiệm thu".
📄 Chi tiết: `02-ra-de-bai.md`

**💬 Câu dẫn** — chiếu đoạn hội thoại này lên và đọc to:

```
Bạn:    Sửa lại màn hình tồn kho cho đẹp hơn
Claude: [sửa 8 file]
Bạn:    Không phải, tôi chỉ muốn sửa phần bảng
Claude: [sửa lại]
Bạn:    Bảng phải có phân trang nữa
Bạn:    Ủa sao cái filter cũ mất rồi?
...
```

> "Ai thấy quen tay giơ lên."

### Ý 1 — Vì sao nó đắt gấp bội (4')

Đây là phần **giải thích cơ chế**. Nói chậm, đây là kiến thức mới với đa số.

**Ba chi phí chồng nhau:**

**① Token tăng lũy tiến.** Mỗi lượt chat gửi lại **toàn bộ** hội thoại.

```
Lượt 1:  gửi  2.000 token
Lượt 5:  gửi 25.000 token   ← vẫn chỉ gõ 1 câu
Lượt 12: gửi 80.000 token   ← vẫn chỉ gõ 1 câu
```

**② Context bị nhiễm.** Các phiên bản sai vẫn nằm nguyên đó. Claude vẫn nhìn thấy chúng.

> "Đây là lý do nó hay quay lại đúng cái lỗi mình vừa sửa."

**③ Bàn bừa thì Claude làm dở.** Hiệu năng giảm khi context đầy — nó quên cả rule ở đầu phiên.

> **Câu đắt nhất phần này:** *"Sửa 10 lần không phải là chậm gấp 10. Nó vừa chậm hơn, vừa cho kết quả tệ hơn."*

### Ý 2 — Luật 2 lần (2')

Trích thẳng tài liệu Anthropic, họ liệt kê đây là failure pattern có tên:

> **Correcting over and over.** Sau **hai** lần sửa thất bại → `/clear` và viết lại đề bài.
>
> *"Một session sạch với prompt tốt hơn gần như luôn thắng một session dài với đống chỉnh sửa tích tụ."*

> "Sửa hai lần vẫn sai thì vấn đề nằm ở **đề bài**, không nằm ở Claude."

### Ý 3 — Bốn kỹ thuật (4')

| | Kỹ thuật | Một câu giải thích |
|---|---|---|
| 1 | **Plan mode** — `Shift+Tab` tới khi thấy `⏸ plan mode on` | Duyệt kế hoạch bằng chữ rẻ hơn duyệt code |
| 2 | **Bảo nó phỏng vấn ngược mình** | Thuốc đặc trị cho "chưa rõ mình muốn gì" |
| 3 | **`Esc` sớm, `Esc Esc` quay lui** | Sửa đề bài gốc, đừng chồng thêm lời |
| 4 | **Định nghĩa "xong" trước** | "Không đúng ý" = chưa ai nói "đúng ý" là gì |

**Về kỹ thuật 2 — đọc to prompt này, đây là món nhiều người sẽ dùng nhất:**

```
Tôi muốn làm [X]. Hãy phỏng vấn tôi thật kỹ bằng công cụ AskUserQuestion.
Hỏi về triển khai kỹ thuật, UI/UX, trường hợp biên, rủi ro.
Đừng hỏi câu hiển nhiên — đào vào chỗ khó tôi có thể chưa nghĩ tới.
Cứ hỏi tới khi đủ, rồi viết spec vào SPEC.md.
```

> "Xong spec thì **mở phiên mới** để làm. Phiên mới context sạch, lại có spec bằng văn bản để đối chiếu."

### 🖥 Demo (4') — demo quan trọng nhất cả buổi

1. Mở repo thật, bấm `Shift+Tab` → chỉ vào `⏸ plan mode on` trên thanh trạng thái
2. Gõ một yêu cầu thật của dự án
3. Để Claude đọc code và trình kế hoạch
4. **Chỉ vào một dòng sai trong kế hoạch** và nói:

> "Chỗ này sai. Sửa bây giờ mất 10 giây. Nếu để nó code xong 8 file rồi mới phát hiện thì mất bao lâu?"

5. Bấm `Ctrl+G` mở kế hoạch trong editor, sửa trực tiếp, rồi cho chạy

### Ý 4 — Mẫu ra đề bài (2')

Chiếu lên và để nguyên đó suốt phần còn lại:

```
【BỐI CẢNH】  File nào — dùng @ để trỏ thẳng
【MỤC TIÊU】  Muốn đạt gì — kết quả, không phải cách làm
【RÀNG BUỘC】 Không được đụng gì, theo pattern nào
【XONG LÀ】   Tiêu chí nghiệm thu kiểm chứng được
【PHẠM VI】   Cái gì NGOÀI phạm vi lần này
```

> "Dài hơn thật. Nhưng nó thay thế 12 lượt chat."

**⚠️ Bẫy:** sẽ có người nói *"viết đề bài dài thế thì tôi tự code còn nhanh hơn."* Trả lời: mẫu này dành cho việc **>3 file hoặc chưa chắc cách làm**. Sửa typo thì làm thẳng — chính tài liệu Anthropic cũng nói vậy: *"nếu mô tả được nguyên cái diff trong một câu thì bỏ qua plan mode."*

**✅ Câu chốt phần ②:** *"`Shift+Tab` là phím đáng học nhất trong Claude Code."*

---

## 26–39' · ③ Quản lý context ⭐

**🎯 Mục tiêu:** cả phòng hiểu cái gì đang tốn tiền, và biết `/clear`.
📄 Chi tiết: `03-quan-ly-context.md`

**💬 Câu dẫn — vẽ ẩn dụ trước, đừng nói token vội:**

> "Hình dung Claude ngồi làm việc trên một cái bàn. Mọi thứ nó cần đều phải đặt trên bàn: hướng dẫn của mình, file nó đã mở, kết quả lệnh nó chạy, và toàn bộ cuộc trò chuyện."

**Ba điều về cái bàn — viết lên bảng:**

1. **Bàn không tự dọn.** File mở lúc 9h sáng, 4h chiều vẫn nằm đó.
2. **Mỗi lần mình nói một câu, Claude đọc lại CẢ CÁI BÀN.**
3. **Bàn càng bừa, Claude càng làm dở.**

> "Câu số 2 giải thích được 90% chi phí. Cả phần này chỉ nhằm dạy một thói quen: **dọn bàn**."

### 🖥 Hành động tại chỗ (3')

> "Mọi người mở phiên Claude đang chạy dở của mình, gõ `/context`."

Để 30 giây cho họ nhìn. Rồi hỏi: *"Ai đang trên 50%?"*

Sau đó chiếu con số của **phiên lộn xộn** anh đã chuẩn bị sẵn.

### Ý 1 — Cái gì chiếm chỗ (3')

**Vừa mở, chưa làm gì: đã ~7.850 token**

| | Token |
|---|---:|
| System prompt | 4.200 |
| Project CLAUDE.md | 1.800 |
| Auto memory | 680 |
| Skill descriptions | 450 |
| CLAUDE.md global | 320 |

**Đọc 4 file + chạy 1 lần test: thêm ~8.700 token**

> "Đọc 4 file tốn nhiều hơn cả phần khởi động. Thứ tốn nhiều nhất không phải câu mình gõ — mà là **file Claude đọc** và **output lệnh nó chạy**."

### Ý 2 — Vì sao phiên chiều đắt hơn phiên sáng (2')

- **Context dài** — gửi lại toàn bộ mỗi request
- **Cache miss** — nghỉ quá 1 tiếng thì lần gõ đầu phải xử lý lại toàn bộ với **giá đầy đủ**. *Đi ăn trưa về mà tiếp phiên cũ chính là tình huống này.*
- **`/compact` cũng tốn tiền** — nó phải đọc cả cuộc trò chuyện để tóm tắt

> **Câu ít người biết:** *"`/clear` miễn phí, `/compact` thì không."*

### Ý 3 — Bốn cách dọn (2')

| Lệnh | Dùng khi |
|---|---|
| `/btw` | Hỏi vặt — không vào lịch sử |
| `/compact <chỉ dẫn>` | Phiên dài nhưng vẫn cùng một việc |
| `Esc Esc` → Summarize | Chỉ một đoạn bị rác |
| **`/clear`** | **Đổi việc. Thói quen quan trọng nhất.** |

### Ý 4 — Ba công cụ tối ưu (3')

Chỉ nói ba món, bỏ phần còn lại vào tài liệu phát tay:

**① Subagent** — thứ đáng giá nhất mà ít người dùng

```
Dùng subagent để điều tra cách hệ thống đồng bộ giá từ ERP.
```

> "Nó đọc 30 file trong **một cái bàn riêng**, rồi chỉ mang về bản tóm tắt. Bàn của mình không bẩn. Đây là cách duy nhất để đọc nhiều mà tốn ít."

**② CLI tool thay MCP** — cài `gh`, `az`, CLI nội bộ. Tiết kiệm context hơn MCP server vì không thêm danh sách tool nào vào bàn.

**③ Chọn đúng model** — Sonnet cho đa số việc code, Opus để dành cho kiến trúc.

> "Tài liệu nói thẳng: chi phí cao bất thường thường do hai thứ — **để Opus làm mặc định** và **không bao giờ `/clear`**."

**✅ Câu chốt phần ③:** *"Đừng để Claude tự đọc cả kho code. Subagent, CLI tool, đề bài cụ thể — cả ba đều nhằm một việc: đọc nhiều mà mang về ít."*

---

## 39–46' · ④ Project CLAUDE.md

**🎯 Mục tiêu:** team thấy đây là việc đáng làm chung, không phải việc cá nhân.
📄 Chi tiết: `04-project-claude-md.md`

**💬 Câu dẫn:**

> "Phần ① là thói quen của mỗi người. Nhưng những thứ này thì global không giải quyết được: dự án này build bằng lệnh gì? Service mới đặt ở đâu? Cái module thanh toán kia vì sao viết kỳ lạ vậy?"
>
> "Kiến thức đó đang nằm trong đầu 2-3 người trong phòng này."

### Ý 1 — Đòn bẩy (1')

> "Global tiết kiệm cho **một người**. Project tiết kiệm cho **hai mươi người**, mỗi phiên."

### 🖥 Demo (2')

Chạy `/init` trên repo thật. Vừa chạy vừa nói:

> "Nó quét codebase, phát hiện build system, test framework, pattern code. Nếu file đã có sẵn thì nó **đề xuất cải thiện** chứ không ghi đè."

### Ý 2 — `/init` chỉ là bản nháp (2')

**Đây là ý quan trọng nhất của phần ④.**

> "`/init` chỉ biết những gì **đọc được từ code**. Giá trị thật nằm ở phần nó **không thể đoán**."

Chiếu ví dụ này lên:

```markdown
## Cạm bẫy
- `SyncService` chạy cron 5 phút/lần. Sửa phải kiểm tra idempotent.
- Tồn kho có thể ÂM (hàng đang về). Đừng thêm ràng buộc >= 0.
- `src/legacy/` là code từ ERP cũ. HỎI TRƯỚC KHI SỬA.
- Đừng chạy `pnpm test` không tham số — mất 8 phút.
```

> "Đây là thứ chỉ người đã dính mới biết. Không AI nào đoán được. Và đây chính là lý do file này đáng làm."

### Ý 3 — Hai mẹo (2')

**`.claude/rules/` với `paths`** — giải quyết mâu thuẫn "muốn viết nhiều nhưng phải dưới 200 dòng":

```markdown
---
paths: ["src/api/**/*.ts"]
---
# Quy tắc API
- Mọi endpoint phải validate input
```

> "Sửa frontend thì rule này **không tốn một token nào**. Đụng vào `src/api/` thì nó xuất hiện."

**Comment HTML không tốn token** — bị xoá trước khi vào context:

```markdown
<!-- Anh Nam thêm sau sự cố 12/03, đừng xoá -->
```

**✅ Câu chốt phần ④:** *"Sửa kiến trúc mà không cập nhật CLAUDE.md thì cũng như sửa API mà không cập nhật tài liệu. Đưa nó vào checklist review PR."*

---

## 46–52' · ⑤ Project Skill

**🎯 Mục tiêu:** biết khi nào nên tách ra thành skill. Không cần ai viết skill ngay hôm nay.
📄 Chi tiết: `05-project-skill.md`

**💬 Câu dẫn — nối tiếp ẩn dụ cái bàn:**

> "CLAUDE.md là **tờ giấy dán trên bàn** — luôn nhìn thấy, mọi lúc, tốn chỗ suốt phiên."
>
> "Skill là **cuốn sách trên giá**. Trên bàn chỉ có cái **gáy sách** — một dòng mô tả. Khi nào cần mới với tay lấy xuống."

### Ý 1 — Hệ quả (1')

> "Nghĩa là mình viết được một skill 400 dòng về quy trình release, và nó **gần như không tốn gì** cho tới ngày thực sự release."

**Quy tắc phân biệt:**
- Sự thật ngắn, áp dụng mọi lúc → `CLAUDE.md`
- Quy trình nhiều bước, thỉnh thoảng dùng → **Skill**

### Ý 2 — Tạo skill (2')

Một thư mục + một file. Tên thư mục là lệnh.

```
.claude/skills/review-pr/SKILL.md   →   gõ /review-pr
```

```markdown
---
description: Review PR theo chuẩn team. Dùng khi cần review code,
  kiểm tra PR trước khi merge, hoặc tự soát lại thay đổi của mình.
---

1. Chạy `git diff main...HEAD`
2. Kiểm tra: có test không? có hardcode key không? query có index chưa?
3. Mỗi vấn đề nêu file:dòng, rủi ro cụ thể, cách sửa
4. Không góp ý style — đã có linter lo
```

> "`description` quan trọng hơn nội dung. Nội dung hay mà mô tả dở thì Claude không bao giờ mở tới. Viết bằng **từ ngữ mà người dùng thật sự sẽ gõ**."

### Ý 3 — Một cảnh báo (1')

Với việc có tác dụng phụ — deploy, commit, gửi tin nhắn — **luôn** thêm:

```yaml
disable-model-invocation: true
```

> "Mình không muốn Claude tự quyết định deploy chỉ vì thấy code **có vẻ** xong."

### Ý 4 — Bộ khởi đầu (1')

> "Đừng làm 10 skill ngay. Làm **2-3 cái** thôi: `/review-pr`, `/commit`, và một skill kiến thức về quy ước API."

**✅ Câu chốt phần ⑤:** *"Skill commit vào repo = kinh nghiệm của người giỏi nhất phòng trở thành mặc định cho cả 20 người. Chuyện tiết kiệm token chỉ là hệ quả phụ."*

---

## 52–57' · ⑥ Permission & bảo mật

**🎯 Mục tiêu:** cả phòng hiểu ranh giới gợi ý vs ràng buộc. Chi tiết để phòng IT làm sau.
📄 Chi tiết: `06-permission-bao-mat.md`

**💬 Câu dẫn:**

> "Năm phần trước nói về dùng cho hiệu quả. Phần này nói về dùng cho an toàn."

### Ý 1 — Ranh giới quan trọng nhất (2')

> **`CLAUDE.md` gợi ý. `settings.json` ràng buộc.**
>
> "Tài liệu ghi thẳng: permission rule được thực thi bởi **Claude Code**, không phải bởi model. Viết 'đừng đọc thư mục secrets' vào CLAUDE.md thì Claude vẫn đọc được. Muốn cấm thật thì phải viết deny rule."

Chiếu ví dụ:

```json
{
  "permissions": {
    "deny": [
      "Read(//**/.env)",
      "Read(//**/*.pem)",
      "Bash(git push --force *)"
    ],
    "ask": ["Bash(git push *)"],
    "allow": ["Bash(pnpm test *)", "Bash(git status)"]
  }
}
```

**Ba tầng:** deny = không bao giờ · ask = phải xác nhận · allow = làm suốt ngày, đừng hỏi nữa.

### Ý 2 — Một ý phản trực giác (1')

> "Viết `allow` cho việc an toàn **là một biện pháp bảo mật**, không phải sự đánh đổi."
>
> "Vì sau lần bấm 'Yes' thứ mười, không ai còn đọc nữa — chỉ bấm cho xong. Giảm số lần hỏi là để dành sự chú ý cho thứ thật sự nguy hiểm."

### Ý 3 — Hai điều nhớ ngay (2')

**`Ctrl+E` ở màn hình hỏi quyền** — Claude giải thích lệnh đó làm gì, có thể hỏng ra sao, kèm nhãn Low/Med/High risk.

**Không dùng `bypassPermissions` ngoài container.** Chế độ này bỏ qua cả việc ghi vào `.git`, `.claude`, `.vscode`.

> "Phòng IT sẽ khoá chế độ này ở tầng managed settings. Chi tiết trong tài liệu, mình sẽ triển khai riêng."

**✅ Câu chốt phần ⑥:** *"Lớp phòng thủ cuối cùng vẫn là con người đọc lệnh trước khi bấm duyệt. Không cấu hình nào thay thế được việc đó."*

---

## 57–60' · Chốt

**Đừng tóm tắt lại 6 bước.** Cả phòng vừa nghe xong. Thay vào đó:

### Ba câu để họ mang về

1. **Sửa nhiều vòng không phải chậm hơn — mà là vừa chậm hơn, vừa dở hơn.**
2. **Mỗi câu mình gõ, Claude đọc lại cả cuộc trò chuyện.** Nên `/clear` khi đổi việc.
3. **Thứ gì gõ lại lần thứ hai là thứ nên nằm trong CLAUDE.md.**

### Ba việc làm trước thứ Sáu

| # | Việc | Mất bao lâu |
|---|---|---|
| 1 | Tạo `~/.claude/CLAUDE.md` bằng `/memory` | 5 phút |
| 2 | Lần tới sửa >3 file → thử **plan mode** một lần | 0 phút |
| 3 | Tập phản xạ **`/clear` khi đổi việc** | 0 phút |

> "Chỉ ba việc. Việc số 1 mất 5 phút, hai việc còn lại không mất phút nào — chỉ là đổi thói quen."

### Việc của phòng IT (nói riêng, không cần cả phòng nghe kỹ)

- Dựng `CLAUDE.md` cho repo chính, mở PR để cả team review
- Deploy managed settings khoá `bypassPermissions` + deny rule cho secret
- Lập danh sách MCP server được duyệt

**Tài liệu chi tiết 6 phần nằm ở `F:\AI\Guide\`.**

---

## Phụ lục A — Nếu thiếu giờ, cắt theo thứ tự này

| Ưu tiên cắt | Phần | Tiết kiệm |
|---|---|---|
| 1 | ⑤ Skill — chỉ nói ẩn dụ "sách trên giá" rồi chuyển | 4' |
| 2 | ⑥ Bảo mật — chỉ nói ý 1 (gợi ý vs ràng buộc) | 3' |
| 3 | ④ Bỏ demo `/init`, chỉ chiếu ví dụ "Cạm bẫy" | 2' |
| 4 | ① Bỏ phần hành động tại chỗ, chỉ chiếu template | 2' |

**Tuyệt đối không cắt:** ② và ③, và hai demo của chúng.

---

## Phụ lục B — Câu hỏi sẽ gặp

| Câu hỏi | Trả lời |
|---|---|
| *"Viết vào CLAUDE.md nó có chắc chắn nghe không?"* | Không. Đó là context, không phải config được enforce. Muốn chắc thì dùng deny rule hoặc hook. |
| *"Viết đề bài dài thế thì tự code còn nhanh hơn."* | Mẫu 5 phần chỉ dành cho việc >3 file hoặc chưa chắc cách làm. Sửa typo thì làm thẳng. |
| *"`/clear` xong mất hết context, phải giải thích lại từ đầu à?"* | Đúng — nhưng đó là lý do phải có CLAUDE.md và SPEC.md. Cái cần giữ thì viết ra file, đừng giữ trong hội thoại. |
| *"Sao không để nó tự làm hết, mình duyệt cuối?"* | Được, nhưng phải cho nó thứ tự kiểm chứng được — test, build, screenshot. Không có gì để kiểm thì "trông có vẻ xong" là tín hiệu duy nhất nó có. |
| *"Cowork có dùng CLAUDE.md không?"* | Không đọc file trên máy. Tương đương là Project instructions và Personal preferences trong UI. |
| *"Dữ liệu công ty có bị dùng để train không?"* | Xem điều khoản Commercial Terms và Privacy Center — dẫn link, đừng trả lời ứng khẩu. |

---

## Phụ lục C — Chỉ mục tài liệu

| File | Nội dung | Dành cho |
|---|---|---|
| `01-cau-hinh-global.md` | CLAUDE.md global, settings.json, loại trừ file rác | Mọi người |
| `02-ra-de-bai.md` | Luật 2 lần, plan mode, phỏng vấn ngược, mẫu 5 phần | ⭐ Mọi người |
| `03-quan-ly-context.md` | Cái bàn làm việc, `/clear`, subagent, 7 công cụ tối ưu | ⭐ Mọi người |
| `04-project-claude-md.md` | `/init`, viết gì, `.claude/rules/`, triển khai theo tuần | Tech lead |
| `05-project-skill.md` | 3 loại skill, frontmatter, bộ khởi đầu | Tech lead |
| `06-permission-bao-mat.md` | Deny rule, managed settings, hook, sandbox, injection | Phòng IT |
