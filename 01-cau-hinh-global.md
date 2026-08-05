# Bước 1 — Cấu hình Global cho Claude

> Mục tiêu: mỗi người trong team cấu hình **một lần** trên máy mình, để mọi phiên làm việc sau đó tự động đúng chuẩn — không phải gõ lại yêu cầu mỗi ngày, không tốn token nhắc đi nhắc lại.

---

## 1. Vấn đề

Mỗi phiên Claude Code bắt đầu với context **rỗng hoàn toàn**. Nó không nhớ gì từ hôm qua.

Hệ quả điển hình mà cả team đang gặp:

- Ngày nào cũng phải gõ "trả lời bằng tiếng Việt", "đừng tự commit"
- Claude dùng `npm` trong khi dự án dùng `pnpm`
- Claude tự ý sửa 15 file rồi mới báo
- Claude đọc phải file rác (`.tmp`, `.vshistory`) → tốn token, kết quả nhiễu

Cả bốn vấn đề trên đều xử lý được ở tầng cấu hình global, làm một lần.

---

## 2. Hai file cần biết

Cùng nằm trong thư mục `C:\Users\<user>\.claude\` (tài liệu Anthropic ghi là `~/.claude/`):

| File | Vai trò | Bản chất |
|---|---|---|
| `CLAUDE.md` | **Hướng dẫn** cho Claude — nạp vào context mỗi phiên | Gợi ý mềm, Claude đọc và cố làm theo |
| `settings.json` | **Cấu hình** Claude Code — quyền hạn, giới hạn | Ràng buộc cứng, client enforce |

**Nguyên tắc chọn file** — đây là điểm nhiều người nhầm:

- Muốn Claude *cư xử* thế nào → `CLAUDE.md`
- Muốn *cấm* Claude làm gì đó → `settings.json`

Ví dụ: "đừng đọc thư mục secrets" viết vào CLAUDE.md thì Claude vẫn có thể đọc; phải viết deny rule trong `settings.json` mới chặn được thật.

---

## 3. File `CLAUDE.md`

### 3.1 Bốn tầng, nạp từ rộng đến hẹp

| Tầng | Vị trí | Dùng cho | Ai thấy |
|---|---|---|---|
| **Managed policy** | Windows: `C:\Program Files\ClaudeCode\CLAUDE.md`<br>macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`<br>Linux/WSL: `/etc/claude-code/CLAUDE.md` | Chuẩn toàn công ty, IT deploy qua GPO/MDM | Mọi user, **không tắt được** |
| **User (global)** ⭐ | `~/.claude/CLAUDE.md` | Thói quen cá nhân, áp cho mọi project | Chỉ mình anh |
| **Project** | `./CLAUDE.md` hoặc `./.claude/CLAUDE.md` | Chuẩn của repo, commit vào git | Cả team qua source control |
| **Local** | `./CLAUDE.local.md` | Riêng anh trong project đó | Chỉ mình anh — nhớ `.gitignore` |

Các file được **nối lại với nhau**, không ghi đè. Thứ tự: từ gốc filesystem xuống thư mục làm việc — file gần nhất được đọc sau cùng.

### 3.2 Cách tạo file global

**Cách A — trong session (khuyên dùng cho team)**

```
/memory
```

Chọn dòng **User CLAUDE.md**. File chưa tồn tại thì nó tự tạo rồi mở editor. Không cần nhớ đường dẫn.

**Cách B — Notepad**

```powershell
mkdir "$HOME\.claude" -Force; notepad "$HOME\.claude\CLAUDE.md"
```

Notepad hỏi tạo file mới → Yes → dán nội dung → Ctrl+S.
⚠️ Khi save phải chọn **Encoding: UTF-8**, nếu không tiếng Việt sẽ lỗi font.

**Cách C — một lệnh PowerShell, tạo luôn nội dung**

```powershell
$p = "$HOME\.claude\CLAUDE.md"
New-Item -ItemType Directory -Force -Path (Split-Path $p) | Out-Null
$c = @'
# Preferences
- Trả lời bằng tiếng Việt, ngắn gọn, không rào đón.
- Không tự chạy git commit/push khi tôi chưa yêu cầu.
- Dùng pnpm, không dùng npm.
- Trước khi sửa >3 file, trình bày kế hoạch rồi chờ tôi duyệt.

# Style
- Python: type hints đầy đủ, format bằng ruff.
- Không viết comment giải thích code hiển nhiên.
'@
[System.IO.File]::WriteAllText($p, $c, [System.Text.UTF8Encoding]::new($false))
```

### 3.3 Kiểm chứng đã nạp chưa

```
/context
```

Xem mục **Memory files** — phải thấy tên file. Không thấy nghĩa là Claude không đọc được nó.

> Bước này nhất định phải demo trước team. Đa số trường hợp "sao Claude không nghe lời tôi" là do file đặt sai chỗ, không phải do Claude.

### 3.4 Viết gì vào global

Global là **thói quen của anh**, không phải kiến thức của dự án.

```markdown
# Preferences
- Trả lời bằng tiếng Việt, ngắn gọn, không rào đón.
- Không tự chạy git commit/push khi tôi chưa yêu cầu.
- Dùng pnpm, không dùng npm.
- Trước khi sửa >3 file, trình bày kế hoạch rồi chờ tôi duyệt.

# Style
- Python: type hints đầy đủ, format bằng ruff.
- Không viết comment giải thích code hiển nhiên.
```

**Quy tắc viết — phần này liên quan trực tiếp đến tiết kiệm token:**

| Quy tắc | Lý do |
|---|---|
| **Dưới 200 dòng** | File nạp lại **mỗi phiên**. Dài = tốn token liên tục + Claude tuân thủ kém hơn |
| **Cụ thể, kiểm chứng được** | "Dùng indent 2 space" ✅ thắng "Format code cho đẹp" ❌ |
| **Không mâu thuẫn** | Hai rule chọi nhau → Claude chọn bừa một cái |
| **Việc thỉnh thoảng mới dùng → làm Skill** | Skill chỉ nạp khi cần, CLAUDE.md nạp mọi lúc |

### 3.5 Giới hạn cần nói thẳng với team

CLAUDE.md được đưa vào như một **user message sau system prompt** — là *context*, không phải *config được enforce*. Claude đọc và cố làm theo, nhưng **không đảm bảo 100%**, nhất là với chỉ dẫn mơ hồ hoặc mâu thuẫn.

Việc bắt buộc phải xảy ra ở thời điểm cố định (ví dụ: luôn chạy lint trước commit) → dùng **hook**, không dùng CLAUDE.md.

---

## 4. File `settings.json` — loại trừ file rác khi tìm kiếm

Yêu cầu thực tế: **bỏ qua `*.tmp` và `.vshistory` trong mọi thao tác tìm kiếm.**

Đây là việc của cấu hình, **không** viết vào CLAUDE.md.

### 4.1 Cách 1 — `.gitignore` (đơn giản nhất, làm trước)

Tool **Grep** của Claude Code chạy trên ripgrep và **tự động bỏ qua file bị gitignore**.

```gitignore
*.tmp
.vshistory/
```

Hai thứ này vốn cũng không nên commit — một mũi tên trúng hai đích.

Áp cho **mọi repo trên máy**:

```powershell
"*.tmp`n.vshistory/" | Set-Content "$HOME\.gitignore_global"
git config --global core.excludesfile "$HOME/.gitignore_global"
```

⚠️ **Glob mặc định KHÔNG theo `.gitignore`** (khác Grep). Muốn Glob cũng theo, set biến môi trường trước khi mở Claude Code:

```
CLAUDE_CODE_GLOB_NO_IGNORE=false
```

### 4.2 Cách 2 — deny rule (chặn cứng)

File `C:\Users\<user>\.claude\settings.json`:

```json
{
  "permissions": {
    "deny": [
      "Read(//**/.vshistory/**)",
      "Read(//**/*.tmp)",
      "Read(//**/*.temp)"
    ]
  }
}
```

Chặn ở tầng permission: Read, Grep, Glob đều không đụng tới được, không phụ thuộc git.

### 4.3 Ba cái bẫy

**1. Phải viết `Read(...)`, không phải `Glob(...)`**
Claude Code chỉ đối chiếu đường dẫn file với rule `Read()` và `Edit()`. Viết `Glob(...)` thì nó nhận rule nhưng **không bao giờ dùng**, chỉ in cảnh báo lúc khởi động.

**2. Trên Windows phải dùng tiền tố `//`**
Đường dẫn được chuẩn hoá về dạng POSIX: `C:\Users\dai` → `/c/Users/dai`.

- `//**/*.tmp` → khớp mọi ổ đĩa ✅
- `/**/*.tmp` trong settings global → neo vào `~/.claude/`, **không** phải project ❌

**3. `Read` deny kéo theo chặn `Edit`** trên cùng đường dẫn (từ v2.1.208).
Với `.tmp`/`.vshistory` thì đúng ý, nhưng cần biết để khỏi ngạc nhiên.

### 4.4 So sánh phạm vi

| | Grep | Glob | Read / Edit | Bash (`rg`, script) |
|---|:---:|:---:|:---:|:---:|
| `.gitignore` | ✅ | ❌ (trừ khi set env) | ❌ | ✅ |
| `deny Read()` | ✅ | ✅ | ✅ | ❌ |

**Khuyến nghị:** dùng cả hai.
- `.gitignore` → mặc định cho cả team, xử lý file rác
- `deny Read()` → dành cho file nhạy cảm (`.env`, `secrets/`, key, credential)

---

## 5. Với Cowork (Claude desktop app)

Cowork **không đọc** `~/.claude/CLAUDE.md`. Cơ chế tương đương:

| Claude Code | Cowork |
|---|---|
| `~/.claude/CLAUDE.md` | Settings → Personal preferences |
| `./CLAUDE.md` | Project → Instructions |
| `.claude/skills/` | Skills |

Cùng triết lý "viết một lần, nạp mọi phiên" — chỉ khác chỗ đặt: Claude Code là file trên đĩa, Cowork là ô nhập trong UI.

---

## 6. Checklist cho từng người (5 phút)

- [ ] Mở Claude Code bất kỳ đâu, gõ `/memory` → chọn **User CLAUDE.md**
- [ ] Dán template ở mục 3.4, sửa lại theo thói quen của mình
- [ ] Giữ file **dưới 200 dòng**
- [ ] Gõ `/context` → xác nhận thấy `CLAUDE.md` trong **Memory files**
- [ ] Tạo `~/.gitignore_global` với `*.tmp` và `.vshistory/`, chạy `git config --global core.excludesfile`
- [ ] (Tuỳ chọn) Thêm `permissions.deny` vào `~/.claude/settings.json` cho `.env` và `secrets/`

---

## 7. Ba câu chốt khi trình bày

1. **Global = viết một lần, áp mọi project.** Thứ gì gõ lại lần thứ hai là thứ nên nằm trong CLAUDE.md.
2. **CLAUDE.md gợi ý, settings.json ràng buộc.** Nhầm chỗ là mất tác dụng.
3. **Ngắn thắng dài.** File 200 dòng tốn token mỗi phiên và làm Claude tuân thủ *kém hơn* file 50 dòng.

---

## Nguồn tham khảo

- [How Claude remembers your project](https://code.claude.com/docs/en/memory) — Claude Code docs
- [Configure permissions](https://code.claude.com/docs/en/permissions) — Claude Code docs
- [Tools reference](https://code.claude.com/docs/en/tools-reference) — Claude Code docs
- [Claude Code settings](https://code.claude.com/docs/en/settings) — Claude Code docs
