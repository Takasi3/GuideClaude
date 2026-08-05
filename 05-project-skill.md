# Bước 5 — Project Skill

> Mục tiêu: chuyển những quy trình lặp đi lặp lại của team thành **skill dùng chung**, commit vào repo — thay vì mỗi người tự gõ lại mỗi ngày.

---

## 1. Giải thích đơn giản: giá sách và tờ giấy dán bàn

Nhớ lại ẩn dụ ở bước 3 — Claude làm việc trên một cái bàn.

**`CLAUDE.md` là tờ giấy dán trên bàn.** Luôn nhìn thấy, mọi lúc. Tiện, nhưng mỗi dòng đều chiếm chỗ **suốt cả phiên**, kể cả khi chẳng liên quan.

**Skill là cuốn cẩm nang trên giá sách.** Trên bàn chỉ có **cái gáy sách** — một dòng mô tả để Claude biết cuốn này nói về gì. Khi nào cần, nó mới với tay lấy xuống và mở ra.

Cụ thể trong tài liệu Anthropic:

> Trong phiên làm việc bình thường, **mô tả** skill được nạp vào context để Claude biết có những gì, nhưng **nội dung đầy đủ chỉ nạp khi được gọi**.

Nghĩa là anh có thể viết một skill dài 400 dòng về quy trình release, và nó **gần như không tốn gì** cho tới ngày anh thực sự release.

> **Quy tắc phân biệt:**
> — Sự thật ngắn, áp dụng mọi lúc → `CLAUDE.md`
> — Quy trình nhiều bước, thỉnh thoảng mới dùng → **Skill**

---

## 2. Khi nào dùng cái gì

Bốn cơ chế, hay bị nhầm lẫn:

| Cơ chế | Nạp khi nào | Tính chất | Dùng cho |
|---|---|---|---|
| **CLAUDE.md** | Mọi phiên | Gợi ý mềm | Quy ước code, lệnh build, kiến trúc |
| **Skill** | Khi được gọi | Gợi ý mềm | Quy trình nhiều bước: release, migration, review PR |
| **Subagent** | Khi được giao việc | Context riêng | Đọc nhiều file, xử lý output dài |
| **Hook** | Tự động tại thời điểm cố định | **Bắt buộc** | Việc không được phép bỏ sót: lint, chặn ghi file |

Dấu hiệu một đoạn trong `CLAUDE.md` nên tách thành skill:

- Nó đã trở thành **một quy trình** chứ không còn là một sự thật
- Nó chỉ liên quan tới **một phần** công việc
- Nó dài hơn 20 dòng
- Anh thấy mình dán cùng một checklist vào chat lần thứ ba

---

## 3. Tạo skill đầu tiên

Skill là **một thư mục** chứa file `SKILL.md`. Tên thư mục chính là lệnh anh gõ.

```
.claude/skills/review-pr/SKILL.md   →   gõ /review-pr
```

### 3.1 Cấu trúc tối thiểu

```bash
mkdir -p .claude/skills/review-pr
```

Nội dung `.claude/skills/review-pr/SKILL.md`:

```markdown
---
description: Review pull request theo chuẩn của team. Dùng khi cần review code,
  kiểm tra PR trước khi merge, hoặc tự soát lại thay đổi của mình.
---

## Quy trình review

1. Chạy `git diff main...HEAD` để xem toàn bộ thay đổi
2. Kiểm tra theo thứ tự:
   - Có test cho phần logic mới không?
   - Có hardcode config, connection string, key không?
   - Query DB có index chưa? Có N+1 không?
   - Xử lý lỗi: có nuốt exception ở đâu không?
   - Đặt tên theo chuẩn của repo chưa?
3. Với mỗi vấn đề: nêu **file:dòng**, mô tả rủi ro cụ thể, đề xuất cách sửa
4. Không góp ý về style — đã có linter lo

Chỉ báo những vấn đề ảnh hưởng tới tính đúng đắn hoặc yêu cầu nghiệp vụ.
Bỏ qua sở thích cá nhân.
```

Vậy là xong. Không cần khai báo ở đâu khác.

### 3.2 Hai cách gọi

**Gọi thẳng:**

```
/review-pr
```

**Hoặc để Claude tự nhận ra** — nhờ trường `description`:

```
Xem giúp tôi PR này có vấn đề gì không
```

> `description` là phần **quan trọng nhất** của skill. Nó là thứ duy nhất luôn nằm trong context, và là căn cứ để Claude quyết định có dùng skill hay không. Viết bằng **từ ngữ mà người dùng thật sự sẽ gõ**.

### 3.3 Kiểm tra

```
Có những skill nào đang dùng được?
```

Hoặc gõ `/` rồi xem danh sách gợi ý.

---

## 4. Đặt skill ở đâu

| Nơi đặt | Đường dẫn | Áp dụng cho |
|---|---|---|
| **Project** ⭐ | `.claude/skills/<tên>/SKILL.md` | Repo này — **commit vào git, cả team dùng** |
| Cá nhân | `~/.claude/skills/<tên>/SKILL.md` | Mọi project của riêng anh |
| Plugin | `<plugin>/skills/<tên>/SKILL.md` | Nơi plugin được bật |
| Enterprise | Qua managed settings | Toàn tổ chức |

Trùng tên thì: **enterprise > cá nhân > project**.

**Với team 20 người, đặt ở `project` là chính** — commit vào repo thì mọi người có ngay, không ai phải cài gì.

### Ba điểm cần biết

**Live reload.** Claude Code theo dõi thư mục skill. Thêm/sửa/xoá skill là nhận ngay trong phiên đang chạy, không cần khởi động lại.

**Monorepo.** Skill trong thư mục con tự nạp khi Claude đụng vào file ở đó. `apps/web/.claude/skills/deploy/` sẽ thành `/apps/web:deploy` nếu trùng tên với skill ở gốc.

**⚠️ Cowork không đọc skill trên máy.** Phiên Cowork và phiên cloud **không** đọc `~/.claude/skills/`. Chúng nạp skill đã bật cho tài khoản claude.ai — quản lý ở mục **Customize** trong sidebar app Desktop. Skill trong repo (`.claude/skills/`) thì phiên cloud vẫn đọc được.

---

## 5. Frontmatter — 8 trường hay dùng

Tất cả đều tuỳ chọn, chỉ `description` là nên có.

```yaml
---
description: Việc này làm gì và khi nào dùng
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *)
argument-hint: [số-issue]
context: fork
agent: Explore
model: haiku
paths: ["src/api/**/*.ts"]
---
```

| Trường | Tác dụng |
|---|---|
| `description` | ⭐ Claude dựa vào đây để quyết định dùng skill. Đặt use case chính lên **đầu** — text bị cắt ở 1.536 ký tự |
| `disable-model-invocation` | `true` = **chỉ anh** gọi được, Claude không tự chạy. Bắt buộc với việc có tác dụng phụ: deploy, commit, gửi tin nhắn |
| `user-invocable` | `false` = chỉ Claude gọi. Dùng cho kiến thức nền không phải hành động |
| `allowed-tools` | Cho phép chạy sẵn một số lệnh không cần hỏi, **chỉ trong lượt gọi skill** |
| `argument-hint` | Gợi ý tham số khi autocomplete |
| `context: fork` | Chạy skill trong **subagent riêng** — không bẩn context chính |
| `model` / `effort` | Đổi model hoặc mức suy nghĩ khi skill này chạy. Việc nhẹ → `haiku` |
| `paths` | Chỉ tự kích hoạt khi đang làm với file khớp pattern |

---

## 6. Ba loại skill, kèm ví dụ thật

### 6.1 Skill kiến thức — Claude tự dùng khi liên quan

Dùng cho quy ước nội bộ mà Claude không thể tự đoán.

`.claude/skills/api-conventions/SKILL.md`:

```markdown
---
description: Quy ước thiết kế API nội bộ. Dùng khi viết hoặc sửa endpoint,
  controller, hoặc định nghĩa response.
paths: ["src/api/**", "src/controllers/**"]
---

# Quy ước API

- URL dùng kebab-case, số nhiều: `/api/v1/purchase-orders`
- JSON property dùng camelCase
- Mọi endpoint danh sách **bắt buộc** có phân trang: `?page=&size=` (size mặc định 50, tối đa 200)
- Version nằm trong path: `/v1/`, `/v2/`
- Response lỗi luôn theo dạng:
  ```json
  { "code": "ORDER_NOT_FOUND", "message": "...", "traceId": "..." }
  ```
- Không trả HTTP 200 kèm lỗi trong body
- Timestamp dùng ISO 8601 kèm timezone
```

Có `paths` nên nó chỉ tự nạp khi Claude đụng vào file API — không làm phiền lúc anh sửa frontend.

### 6.2 Skill quy trình — chỉ anh gọi

Dùng cho việc có tác dụng phụ. **Luôn đặt `disable-model-invocation: true`** — anh không muốn Claude tự quyết định deploy vì thấy code "có vẻ xong".

`.claude/skills/commit/SKILL.md`:

```markdown
---
description: Stage và commit thay đổi hiện tại theo chuẩn của team
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git status *) Bash(git diff *)
---

1. Chạy `git status` và `git diff` để xem đang có gì
2. Nhóm các thay đổi liên quan vào cùng một commit
3. Message theo Conventional Commits: `feat(inventory): thêm phân trang cho bảng tồn kho`
4. Thân message giải thích **tại sao**, không mô tả lại **cái gì** (diff đã nói rồi)
5. Nếu có thay đổi không liên quan lẫn vào, hỏi tôi trước khi commit chung
```

`allowed-tools` giúp Claude chạy lệnh git mà không phải hỏi từng cái — nhưng chỉ trong lượt anh gọi skill, hết lượt là hết quyền.

### 6.3 Skill chạy trong subagent — điều tra không bẩn bàn

Nối thẳng với bước 3: `context: fork` cho skill chạy trong **context riêng**.

`.claude/skills/dieu-tra/SKILL.md`:

```markdown
---
description: Điều tra sâu một chủ đề trong codebase
context: fork
agent: Explore
argument-hint: [chủ đề]
---

Điều tra kỹ về: $ARGUMENTS

1. Dùng Glob và Grep tìm file liên quan
2. Đọc và phân tích code
3. Tóm tắt phát hiện, trích dẫn cụ thể file:dòng
4. Nêu rõ chỗ nào anh chưa chắc chắn
```

Gọi: `/dieu-tra cách hệ thống đồng bộ giá từ ERP`

Subagent đọc 30 file trong bàn riêng, chỉ trả về bản tóm tắt. Agent `Explore` còn **bỏ qua cả CLAUDE.md** để context nó gọn hơn nữa.

⚠️ `context: fork` chỉ hợp với skill có **nhiệm vụ rõ ràng**. Skill kiểu "đây là quy ước API" mà fork thì subagent nhận được hướng dẫn nhưng không có việc để làm.

---

## 7. Hai kỹ thuật nâng cấp skill

### 7.1 Tham số `$ARGUMENTS`

```markdown
---
description: Sửa một issue trên GitHub
argument-hint: [số-issue]
disable-model-invocation: true
---

Phân tích và sửa issue: $ARGUMENTS

1. Dùng `gh issue view $ARGUMENTS` lấy chi tiết
2. Tìm file liên quan trong codebase
3. Sửa, viết test
4. Chạy lint và type check
5. Tạo commit và mở PR
```

Gọi: `/fix-issue 1234`

Còn có `$0`, `$1` cho từng tham số, `${CLAUDE_SKILL_DIR}` trỏ tới thư mục skill, `${CLAUDE_PROJECT_DIR}` trỏ tới gốc project.

### 7.2 Nhúng kết quả lệnh — `` !`lệnh` ``

Claude Code **chạy lệnh trước**, rồi thay dòng đó bằng kết quả, **sau đó** Claude mới đọc:

```markdown
---
description: Tóm tắt thay đổi chưa commit và cảnh báo rủi ro
---

## Thay đổi hiện tại

!`git diff HEAD`

## Việc cần làm

Tóm tắt các thay đổi trên trong 2-3 gạch đầu dòng, rồi liệt kê rủi ro:
thiếu xử lý lỗi, giá trị hardcode, test cần cập nhật.
```

Rất mạnh: skill đến tay Claude đã kèm sẵn dữ liệu thật, không phải đoán.

---

## 8. File phụ trợ — cho skill lớn

Skill là **thư mục**, nên có thể mang theo file khác:

```
release/
├── SKILL.md          # Bắt buộc — tổng quan và điều hướng
├── checklist.md      # Chi tiết, chỉ đọc khi cần
├── rollback.md       # Quy trình rollback
└── scripts/
    └── verify.sh     # Script để chạy, không phải để đọc
```

Trong `SKILL.md` trỏ tới chúng:

```markdown
## Tài liệu thêm

- Checklist đầy đủ: [checklist.md](checklist.md)
- Khi cần rollback: [rollback.md](rollback.md)
```

Claude chỉ mở file nào nó thật sự cần.

> **Giữ `SKILL.md` dưới 500 dòng.** Chi tiết dài chuyển sang file riêng.

---

## 9. Điều quan trọng nhất về chi phí

Skill **không miễn phí** — nó chỉ **trả tiền khi dùng**:

> Khi skill được gọi, nội dung `SKILL.md` đã render vào context như một tin nhắn và **ở lại đó suốt phần còn lại của phiên**.

Ba hệ quả:

1. **Viết thân skill thật gọn.** Mỗi dòng là chi phí lặp lại. Nói *làm gì*, đừng kể lể *tại sao*.
2. **Gọi nhầm skill lớn thì phải `/clear`** mới dọn được.
3. Gọi lại cùng skill với nội dung y hệt thì Claude Code chỉ ghi chú "đã nạp rồi", không nhân đôi.

Sau khi auto-compact, skill được gắn lại nhưng chỉ **5.000 token đầu mỗi skill**, tổng ngân sách **25.000 token**, ưu tiên skill gọi gần nhất. Gọi nhiều skill trong một phiên thì skill cũ có thể bị bỏ hẳn.

---

## 10. Xử lý sự cố

| Triệu chứng | Nguyên nhân & cách sửa |
|---|---|
| **Claude không tự dùng skill** | `description` thiếu từ khoá người dùng hay gõ. Hỏi *"Có skill nào đang dùng được?"* để kiểm tra nó có được nạp không. Thử gọi thẳng `/tên-skill` |
| **Claude dùng skill quá nhiều** | Viết `description` cụ thể hơn, hoặc thêm `disable-model-invocation: true` |
| **Mô tả skill bị cắt cụt** | Danh sách skill có ngân sách ~1% context window. Nhiều skill quá thì mô tả bị cắt. Chạy `/doctor` để xem skill nào chiếm nhiều nhất. Đặt use case chính lên **đầu** mô tả |
| **Skill có vẻ hết tác dụng sau lượt đầu** | Nội dung vẫn còn trong context, chỉ là model chọn cách khác. Viết `description` và hướng dẫn mạnh hơn, hoặc dùng **hook** nếu bắt buộc phải xảy ra |
| **YAML lỗi** | Skill vẫn gọi được bằng `/tên` nhưng Claude không có mô tả để tự nhận. Chạy `--debug` xem lỗi parse |

Dòng **Skills** trong `/context` cho biết danh sách skill đang chiếm bao nhiêu.

---

## 11. Bộ skill khởi đầu cho team

Đề xuất commit sẵn vào repo chính, mỗi cái 20-40 dòng:

| Skill | Loại | Ghi chú |
|---|---|---|
| `/review-pr` | Quy trình | Checklist review theo chuẩn team |
| `/commit` | Quy trình | `disable-model-invocation: true` |
| `api-conventions` | Kiến thức | Có `paths`, tự nạp khi sửa API |
| `db-migration` | Quy trình | `disable-model-invocation: true` — việc nguy hiểm |
| `/dieu-tra` | Fork | Điều tra codebase không bẩn context |
| `codebase-overview` | Kiến thức | `user-invocable: false` — kiến thức nền |

Bắt đầu bằng **2-3 cái**, đừng làm 10 cái ngay. Skill ít mà dùng thật hơn skill nhiều mà bỏ xó — và mỗi skill đều ăn một phần ngân sách mô tả.

---

## 12. Checklist tạo skill

- [ ] Việc này có lặp lại **từ 3 lần** trở lên chưa? Chưa thì đừng làm skill
- [ ] Nó là **quy trình** hay chỉ là một **sự thật**? Sự thật ngắn → để `CLAUDE.md`
- [ ] `description` có chứa từ ngữ mà người dùng **thật sự sẽ gõ** không?
- [ ] Có tác dụng phụ (deploy, commit, gửi tin) không? → `disable-model-invocation: true`
- [ ] Thân skill có dưới 500 dòng không? Chi tiết dài → tách file riêng
- [ ] Chỉ liên quan tới một phần codebase? → thêm `paths`
- [ ] Đọc nhiều file, trả về ít? → thêm `context: fork`
- [ ] Đã commit vào repo để cả team dùng chưa?

---

## 13. Ba câu chốt khi trình bày

1. **CLAUDE.md là tờ giấy dán bàn, skill là sách trên giá.** Trên bàn chỉ để thứ cần mọi lúc.
2. **`description` quan trọng hơn nội dung.** Nội dung hay mà mô tả dở thì Claude không bao giờ mở tới.
3. **Skill commit vào repo = kinh nghiệm của người giỏi nhất team trở thành mặc định cho cả 20 người.** Đây mới là giá trị thật, không phải chuyện tiết kiệm token.

---

## Nguồn tham khảo

- [Extend Claude with skills](https://code.claude.com/docs/en/skills) — tài liệu chính
- [Subagents](https://code.claude.com/docs/en/sub-agents) — `context: fork`, preload skill
- [Manage costs](https://code.claude.com/docs/en/costs) — chuyển hướng dẫn từ CLAUDE.md sang skill
- [Agent Skills standard](https://agentskills.io) — chuẩn mở, dùng được với nhiều công cụ AI
