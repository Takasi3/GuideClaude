# Bước 3 — Quản lý Context (phần tiết kiệm)

> Mục tiêu: hiểu **cái gì đang tốn tiền**, và dùng đúng công cụ để cắt nó.
> Đây là bước duy nhất trong bộ tài liệu này **đo được bằng số**.

---

## 1. Giải thích đơn giản: cái bàn làm việc

Hãy hình dung Claude ngồi làm việc trên một **cái bàn**.

Mọi thứ nó cần đều phải đặt trên bàn: hướng dẫn của anh, các file nó đã mở, kết quả lệnh nó vừa chạy, và **toàn bộ cuộc trò chuyện từ đầu tới giờ**.

Cái bàn đó có kích thước cố định — khoảng **200.000 token** (tạm hiểu: ~150.000 từ).

Ba điều cần nhớ về cái bàn này:

**① Bàn không tự dọn.** Anh mở một file lúc 9h sáng, tới 4h chiều nó vẫn nằm đó, dù việc đã xong từ lâu.

**② Mỗi lần anh nói một câu, Claude phải đọc lại CẢ CÁI BÀN.** Không phải đọc mỗi câu anh vừa nói. Đây là lý do quan trọng nhất.

**③ Bàn càng bừa, Claude càng làm dở.** Không phải nó "chậm hơn" — nó thực sự **quên** những chỉ dẫn ở đầu buổi, kể cả rule trong `CLAUDE.md`.

> Cả bước 3 chỉ nhằm dạy một thói quen: **dọn bàn thường xuyên**.

---

## 2. Cái gì đang nằm trên bàn?

Con số thực tế từ tài liệu Anthropic, cho một phiên làm việc bình thường:

**Ngay khi vừa mở, chưa làm gì cả — bàn đã có sẵn ~7.850 token:**

| Thứ | Token | Ghi chú |
|---|---:|---|
| System prompt | 4.200 | Cố định, không đổi được |
| Project CLAUDE.md | 1.800 | ⚠️ **Anh kiểm soát được** |
| Auto memory | 680 | Ghi chú Claude tự lưu |
| Skill descriptions | 450 | Chỉ mô tả, chưa phải nội dung skill |
| `~/.claude/CLAUDE.md` | 320 | ⚠️ **Anh kiểm soát được** |
| Environment info | 280 | Thư mục, OS, git branch |
| MCP tool names | 120 | Chỉ tên, schema nạp sau khi cần |

**Rồi bắt đầu làm việc — đọc 4 file và chạy test:**

| Thao tác | Token |
|---|---:|
| Đọc `src/api/auth.ts` | 2.400 |
| Đọc `middleware.ts` | 1.800 |
| Đọc `auth.test.ts` | 1.600 |
| Đọc `src/lib/tokens.ts` | 1.100 |
| Chạy `npm test` (output) | 1.200 |
| Grep tìm chuỗi | 600 |

Chỉ 4 file + 1 lần test đã ăn thêm **~8.700 token** — nhiều hơn cả phần khởi động.

> **Bài học số 1:** thứ tốn nhiều nhất không phải câu anh gõ, mà là **file Claude đọc** và **output lệnh nó chạy**.

---

## 3. Vì sao phiên chiều tốn hơn phiên sáng

Ba nguyên nhân, tài liệu Anthropic nêu đích danh:

**Context dài.** Claude gửi lại toàn bộ hội thoại mỗi lần request. Một câu hỏi một dòng trong phiên đã mở cả ngày vẫn phải kéo theo cả ngày lịch sử đó.

**Cache miss.** Sau khi nghỉ quá lâu (1 tiếng với gói thuê bao), lần gõ đầu tiên **mất cache** và phải xử lý lại toàn bộ context với giá đầy đủ. Đi ăn trưa về mà tiếp tục phiên cũ chính là tình huống này.

**`/compact` cũng tốn tiền.** Nó phải *đọc* toàn bộ cuộc trò chuyện để tóm tắt. Nén một context lớn bản thân nó đã là một request lớn.

> **Bài học số 2:** `/clear` **miễn phí**, `/compact` thì không.
> Nếu không cần giữ mạch việc, luôn chọn `/clear`.

---

## 4. Nhìn thấy trước đã

Không đo được thì không cải thiện được. Ba cách nhìn:

| Lệnh | Cho biết |
|---|---|
| `/context` | **Bàn đang có gì** — bóc tách từng phần đang chiếm bao nhiêu |
| `/usage` | Token và chi phí phiên này; trên gói Team/Enterprise còn chia theo skill, subagent, MCP server |
| **Statusline** | Mức dùng context hiện ngay trên thanh trạng thái, **không cần gõ gì** |

`/usage` còn tự cảnh báo khi một hành vi chiếm ≥10% mức dùng gần đây — ví dụ *"long context"* hoặc *"cache miss"* — kèm luôn gợi ý sửa.

> **Việc nên làm trong buổi training:** bảo cả team mở `/context` ngay tại chỗ. Nhìn con số của chính mình gây ấn tượng hơn mọi slide.

---

## 5. Bốn cách dọn bàn

Xếp từ nhẹ tới mạnh tay:

### `/btw` — hỏi vặt không để lại vết

Câu trả lời hiện trong một ô nổi rồi biến mất, **không vào lịch sử hội thoại**.

Dùng khi: *"cú pháp lệnh này là gì nhỉ?"*, *"file config nằm đâu?"* — những câu không liên quan tới việc chính.

### `/compact` — nén lại, giữ mạch việc

```
/compact Tập trung giữ lại các thay đổi API và output test
```

Claude tóm tắt hội thoại cũ, giữ những gì anh chỉ định. Dùng khi phiên đã dài **nhưng vẫn đang làm cùng một việc**.

Có thể đặt sẵn chỉ dẫn nén trong `CLAUDE.md`:

```markdown
# Compact instructions
Khi nén, luôn giữ lại danh sách file đã sửa và các lệnh test.
```

### `Esc` `Esc` → *Summarize from/up to here* — nén một đoạn

Chọn một checkpoint rồi chọn:
- **Summarize from here** → nén từ đó về sau, giữ nguyên phần đầu
- **Summarize up to here** → nén phần đầu, giữ nguyên phần gần đây

Dùng khi chỉ có một đoạn cụ thể bị rác (ví dụ đoạn debug lòng vòng).

### `/clear` — dọn sạch bàn

**Đây là thói quen quan trọng nhất của cả bước 3.**

Dùng khi:
- Chuyển sang việc **không liên quan**
- Đã sửa **2 lần** vẫn sai (luật ở bước 2)

Mẹo: gõ `/rename oauth-migration` **trước khi** clear để đặt tên phiên, sau này `/resume` quay lại dễ tìm.

---

## 6. Các công cụ giúp Claude tối ưu

Phần trên là *dọn dẹp thủ công*. Phần này là **cài đặt sẵn để bàn ít bẩn ngay từ đầu**.

### 6.1 Subagent — thứ đáng giá nhất mà ít người dùng

```
Dùng subagent để điều tra xem hệ thống xác thực đang xử lý refresh token
thế nào, và có sẵn tiện ích OAuth nào tôi nên tái sử dụng không.
```

Subagent chạy trong **một cái bàn riêng**. Nó đọc 30 file thoải mái, rồi chỉ trả về **bản tóm tắt** cho bàn chính.

Đây là cách duy nhất để "đọc nhiều mà không tốn nhiều". Ba tình huống nên dùng:

- **Điều tra codebase** — đọc rất nhiều file
- **Xử lý log/output dài** — chạy test, đọc log lỗi
- **Review chéo** — context sạch nên đánh giá khách quan hơn con vừa viết code

⚠️ Nhưng đừng lạm dụng: mỗi subagent là một context riêng, chạy nhiều cùng lúc thì tổng token vẫn tăng. Dùng cho việc **đọc nhiều, trả về ít**.

### 6.2 CLI tool thay vì MCP server

Tài liệu nói thẳng: **CLI tool tiết kiệm context hơn MCP server**, vì nó không thêm danh sách tool nào vào bàn cả.

Nên cài cho team:

| Công cụ | Dùng cho |
|---|---|
| `gh` | GitHub — tạo issue, mở PR, đọc comment |
| `az` / `aws` / `gcloud` | Hạ tầng cloud |
| CLI nội bộ của công ty | Hệ thống riêng |

Và Claude học được CLI lạ rất nhanh:

```
Dùng `foo-cli --help` để tìm hiểu công cụ foo, rồi dùng nó giải quyết A, B, C.
```

Đồng thời: gõ `/mcp` để xem MCP server nào đang bật, **tắt cái không dùng**.

### 6.3 Code intelligence plugin (ngôn ngữ có kiểu tĩnh)

Gõ `/plugin` để cài. Với TypeScript, Java, C#, Go…

Thay vì grep rồi mở 5 file để đoán, Claude gọi thẳng "go to definition" — **một lệnh thay cho năm lần đọc file**. Ngoài ra language server tự báo lỗi kiểu sau mỗi lần sửa, Claude không cần chạy compiler.

Đây là món có tỷ lệ lợi ích/công sức cao nhất nếu team dùng ngôn ngữ kiểu tĩnh.

### 6.4 Hook lọc output trước khi Claude nhìn thấy

Ví dụ trong tài liệu: thay vì để Claude đọc file log 10.000 dòng, một hook grep sẵn dòng `ERROR` và **chỉ trả về những dòng khớp**.

> Giảm từ hàng chục nghìn token xuống còn vài trăm.

Claude tự viết hook được: *"Viết cho tôi một hook lọc output test, chỉ hiện phần FAIL."*

### 6.5 Chuyển bớt từ CLAUDE.md sang Skill

`CLAUDE.md` nạp **mỗi phiên**, kể cả khi anh đang làm việc chẳng liên quan. Skill chỉ nạp **khi cần**.

| Nên nằm ở CLAUDE.md | Nên chuyển thành Skill |
|---|---|
| Quy ước code, lệnh build, kiến trúc | Quy trình review PR |
| Rule ngắn áp dụng mọi lúc | Cách chạy migration database |
| | Quy trình release |

Ngưỡng: **giữ CLAUDE.md dưới 200 dòng**.

### 6.6 Chọn đúng model và mức suy nghĩ

| Việc | Nên dùng |
|---|---|
| Đa số việc code | **Sonnet** — đủ tốt, rẻ hơn Opus nhiều |
| Quyết định kiến trúc, suy luận nhiều bước | Opus |
| Subagent làm việc đơn giản | Haiku (`model: haiku` trong cấu hình subagent) |

Đổi bằng `/model`, đặt mặc định trong `/config`.

**Extended thinking** bật mặc định và token suy nghĩ tính như output. Việc đơn giản thì hạ mức bằng `/effort`. Tài liệu ghi rõ: chi phí cao bất thường thường do **để Opus làm mặc định** và **không bao giờ `/clear`**.

### 6.7 Đề bài cụ thể (nối lại bước 2)

> *"Cải thiện codebase này"* → Claude quét diện rộng, đọc hàng trăm file.
> *"Thêm validate input cho hàm login trong auth.ts"* → đọc đúng một file.

Đây là lý do bước 2 đứng trước bước 3: đề bài mơ hồ là nguồn tốn token lớn nhất, và không công cụ nào cứu được.

---

## 7. Tra nhanh: triệu chứng → thuốc

| Triệu chứng | Xử lý |
|---|---|
| Phiên mở cả ngày, càng lúc càng chậm | `/clear` — mỗi việc một phiên |
| Cần Claude đọc nhiều file để tìm hiểu | Giao cho **subagent** |
| Output test/log quá dài | **Hook lọc** hoặc giao subagent |
| `CLAUDE.md` phình to | Chuyển bớt sang **Skill** |
| Đi ăn trưa về, phiên cũ đắt bất thường | Cache miss → `/clear` mở phiên mới |
| Hỏi một câu vặt | `/btw` |
| Đang giữa việc nhưng bàn đầy | `/compact <chỉ dẫn>` |
| Việc đơn giản mà vẫn đắt | `/model` sang Sonnet, `/effort` hạ xuống |
| Không biết gì đang tốn | `/context` và `/usage` |

---

## 8. Thói quen hằng ngày (dán lên tường)

**Đầu buổi**
- [ ] Mỗi việc → một phiên riêng. Đặt tên bằng `/rename`

**Trong lúc làm**
- [ ] Đọc nhiều file → bảo nó dùng **subagent**
- [ ] Hỏi vặt → `/btw`
- [ ] Thấy đi sai → `Esc` ngay

**Chuyển việc**
- [ ] `/clear`. Luôn luôn. Không ngoại lệ

**Mỗi tuần**
- [ ] Mở `/context` xem có gì đang chiếm chỗ vô ích
- [ ] Rà lại `CLAUDE.md` — dòng nào bỏ đi mà Claude vẫn làm đúng thì xoá

---

## 9. Ba câu chốt khi trình bày

1. **Mỗi câu anh gõ, Claude đọc lại cả cuộc trò chuyện.** Đây là câu giải thích được 90% chi phí.
2. **`/clear` miễn phí, `/compact` thì không.** Không cần giữ mạch việc thì đừng nén — dọn sạch.
3. **Đừng để Claude tự đọc cả kho code.** Subagent, CLI tool, code intelligence plugin — cả ba đều nhằm một việc: đọc nhiều mà mang về ít.

---

## Nguồn tham khảo

- [Manage costs effectively](https://code.claude.com/docs/en/costs) — mục *Reduce token usage*, *Why usage climbs in a long session*
- [Explore the context window](https://code.claude.com/docs/en/context-window) — con số token khởi động
- [Best practices](https://code.claude.com/docs/en/best-practices) — subagent, quản lý phiên
- [Subagents](https://code.claude.com/docs/en/sub-agents) · [Hooks](https://code.claude.com/docs/en/hooks) · [Statusline](https://code.claude.com/docs/en/statusline)
