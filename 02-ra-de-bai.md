# Bước 2 — Ra đề bài đúng ngay từ đầu

> Mục tiêu: chuyển từ thói quen **"chat rồi sửa dần"** sang **"giao việc rồi nghiệm thu"**.
> Đây là bước có tác động lớn nhất tới cả hai mục tiêu: *tiết kiệm* và *đúng hướng*.

---

## 1. Tình huống chúng ta đang gặp

```
Bạn:    Sửa lại màn hình quản lý tồn kho cho đẹp hơn
Claude: [sửa 8 file]
Bạn:    Không phải, tôi chỉ muốn sửa phần bảng thôi
Claude: [sửa lại]
Bạn:    Bảng phải có phân trang nữa
Claude: [thêm phân trang]
Bạn:    Ủa sao cái filter cũ mất rồi?
Claude: [khôi phục filter]
Bạn:    Giờ nó lại lỗi khi tồn kho = 0
...
```

Vòng lặp này quen thuộc với tất cả mọi người. Vấn đề không nằm ở Claude — nằm ở chỗ **yêu cầu được khám phá dần dần bằng cách nhìn kết quả sai**.

Anthropic liệt kê đây là một trong năm failure pattern phổ biến nhất, có tên hẳn hoi:

> **Correcting over and over.** Claude làm sai, bạn sửa, vẫn sai, bạn sửa tiếp. Context bị ô nhiễm bởi các phương án hỏng.
>
> **Fix:** Sau **hai** lần sửa thất bại → `/clear` và viết lại đề bài tốt hơn, tích hợp những gì vừa học được.

Và câu đáng nhớ nhất trong toàn bộ tài liệu:

> *"Một session sạch với prompt tốt hơn gần như luôn thắng một session dài với đống chỉnh sửa tích tụ."*

---

## 2. Vì sao vòng lặp sửa lại đắt gấp bội

Không phải "sửa 10 lần thì chậm gấp 10". Nó tệ hơn thế, vì ba chi phí chồng lên nhau:

### 2.1 Token tăng lũy tiến

Mỗi lượt chat gửi lại **toàn bộ** hội thoại từ đầu. Anh chỉ gõ một câu 10 chữ, nhưng hệ thống gửi lại tất cả những gì đã có.

```
Lượt 1:  gửi  2.000 token
Lượt 5:  gửi 25.000 token   ← vẫn chỉ gõ 1 câu
Lượt 12: gửi 80.000 token   ← vẫn chỉ gõ 1 câu
```

Tổng chi phí của một phiên 12 lượt lộn xộn có thể gấp **hàng chục lần** một phiên 2 lượt gọn gàng, dù công việc giống hệt nhau.

### 2.2 Context bị ô nhiễm

Các phiên bản sai **vẫn nằm nguyên** trong context. Claude vẫn "nhìn thấy" chúng.

Hệ quả: nó hay quay lại đúng cái lỗi vừa sửa, hoặc trộn lẫn hai phương án mâu thuẫn. Ai cũng từng gặp cảnh *"ơ nãy sửa rồi mà sao nó làm lại?"* — đây chính là nguyên nhân.

### 2.3 Context đầy làm Claude kém đi

Hiệu năng mô hình **giảm khi context đầy**. Nó bắt đầu quên chỉ dẫn ở đầu phiên — kể cả những rule trong `CLAUDE.md`.

> **Kết luận:** sửa nhiều vòng không chỉ tốn tiền hơn, mà còn cho kết quả **tệ hơn**. Đây là điểm phản trực giác cần nhấn mạnh.

---

## 3. Bốn kỹ thuật, xếp theo độ dễ áp dụng

### 3.1 Plan mode — duyệt kế hoạch trước khi duyệt code

Bấm `Shift+Tab` cho tới khi thanh trạng thái hiện `⏸ plan mode on`.

Ở chế độ này Claude **đọc file, phân tích, lập kế hoạch — nhưng không sửa gì cả**. Anh đọc kế hoạch, duyệt hoặc bắt sửa. Duyệt xong mới cho chạy.

```
[plan mode]
Đọc src/inventory/ và hiểu cách màn hình tồn kho đang hiển thị dữ liệu.
Tôi muốn thêm phân trang cho bảng. Cần sửa những file nào? Lập kế hoạch.
```

Bấm `Ctrl+G` để mở kế hoạch trong editor và **sửa trực tiếp** trước khi Claude thực thi.

**Vì sao hiệu quả:** sửa một dòng trong kế hoạch tốn vài giây. Sửa cùng lỗi đó sau khi Claude đã viết 8 file tốn nửa buổi.

**Khi nào KHÔNG dùng** — plan mode cũng có chi phí của nó:
- Sửa typo, thêm một dòng log, đổi tên biến → làm thẳng
- Nguyên tắc: *nếu anh mô tả được nguyên cái diff trong một câu, bỏ qua plan mode*
- Plan mode đáng giá khi: chưa chắc cách làm, sửa nhiều file, hoặc code lạ chưa quen

### 3.2 Để Claude phỏng vấn ngược — thuốc đặc trị cho "chưa rõ ngay từ đầu"

Đây là kỹ thuật quan trọng nhất cho vấn đề của team. Thay vì cố nghĩ ra đề bài hoàn hảo, **bắt Claude moi yêu cầu ra khỏi đầu anh**:

```
Tôi muốn làm [mô tả ngắn]. Hãy phỏng vấn tôi thật kỹ bằng công cụ AskUserQuestion.

Hỏi về cách triển khai kỹ thuật, UI/UX, các trường hợp biên, rủi ro và đánh đổi.
Đừng hỏi những câu hiển nhiên — đào vào những chỗ khó mà tôi có thể chưa nghĩ tới.

Cứ hỏi tới khi đủ, rồi viết spec đầy đủ vào SPEC.md.
```

Claude sẽ hỏi những thứ anh chưa nghĩ tới: *"tồn kho âm thì hiển thị sao?"*, *"phân trang server-side hay client-side?"*, *"1000 dòng thì có cần virtual scroll không?"*

Sau khi có `SPEC.md`: **mở session mới hoàn toàn** để thực thi. Session mới có context sạch, chỉ tập trung vào việc code, và có spec bằng văn bản để đối chiếu.

**Spec tốt là spec tự đứng được một mình:**
- Nêu đích danh file và interface liên quan
- Nói rõ cái gì **ngoài phạm vi**
- Kết thúc bằng một bước nghiệm thu đầu-cuối chứng minh tính năng chạy được

> Thời gian bỏ ra làm spec cho chính xác đáng giá hơn thời gian ngồi canh Claude code.

### 3.3 Sửa đề bài — đừng chồng thêm lời

| Phím / lệnh | Tác dụng | Dùng khi |
|---|---|---|
| `Esc` | Dừng Claude giữa chừng, **giữ nguyên context** | Vừa thấy nó đi sai hướng — dừng ngay, đừng đợi nó chạy xong |
| `Esc` `Esc` hoặc `/rewind` | Mở menu quay lui: khôi phục hội thoại, khôi phục code, hoặc cả hai | Đã lỡ đi sai vài lượt — quay về checkpoint rồi **sửa lại prompt gốc** |
| `"Undo that"` | Bảo Claude hoàn tác thay đổi | Sai một thao tác cụ thể |
| `/clear` | Xoá sạch context, bắt đầu lại | **Sau 2 lần sửa thất bại**, hoặc khi chuyển sang việc không liên quan |

**Điểm mấu chốt:** mỗi prompt anh gửi đều tự động tạo một **checkpoint**. Claude chụp lại file trước mỗi lần sửa. Nghĩa là anh có thể mạnh dạn thử hướng liều — sai thì `Esc Esc` quay về, không mất gì.

Điều này đảo ngược thói quen: thay vì *"nói thêm câu nữa để sửa"*, hãy *"quay về sửa câu ban đầu"*. Cách sau cắt sạch context nhiễm; cách trước bồi thêm rác.

⚠️ Checkpoint chỉ theo dõi thay đổi qua công cụ sửa file của Claude. Thay đổi qua lệnh Bash hoặc tiến trình bên ngoài **không** được ghi lại. Đây không phải vật thay thế cho git.

### 3.4 Định nghĩa "xong" trước khi bắt đầu

*"Không đúng ý"* nghĩa là **chưa ai từng nói "đúng ý" là gì**.

Claude dừng lại khi công việc **trông có vẻ** xong. Không có thứ gì để kiểm chứng thì "trông có vẻ xong" là tín hiệu duy nhất nó có — và anh trở thành vòng lặp kiểm thử: mọi lỗi đều phải chờ anh phát hiện.

Hãy cho nó một thứ trả về pass/fail: test suite, exit code của build, linter, script so sánh output, ảnh chụp màn hình để đối chiếu.

| ❌ Trước | ✅ Sau |
|---|---|
| *"viết hàm validate email"* | *"viết hàm validateEmail. Test case: `user@example.com` → true, `invalid` → false, `user@.com` → false. Chạy test sau khi implement."* |
| *"làm dashboard đẹp hơn"* | *"[dán ảnh] implement theo thiết kế này. Chụp màn hình kết quả, so với ảnh gốc, liệt kê điểm khác rồi sửa."* |
| *"build đang lỗi"* | *"build lỗi với message này: [dán lỗi]. Sửa và xác nhận build thành công. Xử lý gốc rễ, đừng che lỗi đi."* |

Và luôn bắt Claude **trưng bằng chứng** thay vì tuyên bố thành công: output của test, lệnh đã chạy và nó trả về gì, ảnh chụp kết quả.

---

## 4. Mẫu ra đề bài 5 phần

Dán cái này lên tường. Không cần đủ cả 5 mỗi lần, nhưng thiếu phần nào là biết mình đang bỏ ngỏ chỗ nào.

```
【BỐI CẢNH】  File/thư mục nào. Dùng @ để trỏ thẳng: @src/inventory/table.tsx
【MỤC TIÊU】  Muốn đạt được gì — mô tả kết quả, không mô tả cách làm
【RÀNG BUỘC】 Không được đụng vào gì. Thư viện được/không được dùng. Theo pattern nào
【XONG LÀ】   Tiêu chí nghiệm thu kiểm chứng được
【PHẠM VI】   Cái gì NGOÀI phạm vi lần này
```

### Ví dụ đối chiếu

**❌ Kiểu cũ**

```
Sửa lại màn hình quản lý tồn kho cho đẹp hơn
```

**✅ Kiểu mới**

```
【BỐI CẢNH】 @src/inventory/InventoryTable.tsx — bảng tồn kho hiện đang render
             toàn bộ 3000 dòng một lúc, load rất chậm.
【MỤC TIÊU】 Thêm phân trang server-side, 50 dòng/trang.
【RÀNG BUỘC】 Theo đúng pattern của @src/orders/OrderTable.tsx.
             Không thêm thư viện mới. Giữ nguyên bộ filter hiện có.
【XONG LÀ】   - Chuyển trang không reload cả trang
             - Filter vẫn giữ khi đổi trang
             - Tồn kho = 0 và tồn kho âm vẫn hiển thị đúng
             - `pnpm test inventory` pass
【PHẠM VI】   Chỉ bảng. Không đụng form nhập kho, không đổi API.
```

Dài hơn thật. Nhưng nó thay thế 12 lượt chat qua lại.

---

## 5. So sánh chi phí thực tế

Cùng một yêu cầu, hai cách làm:

| | Kiểu cũ | Kiểu mới |
|---|---|---|
| Số lượt chat | ~12 | 2 (plan → duyệt → chạy) |
| Token gửi đi | Tăng lũy tiến, phiên cuối rất nặng | Gần như tuyến tính |
| Context lúc kết thúc | Đầy rác, đầy phương án hỏng | Sạch |
| Chất lượng code | Chồng lớp vá víu | Một mạch, theo kế hoạch |
| Cảm giác người dùng | *"AI này ngu"* | *"làm được việc"* |
| Thời gian anh bỏ ra | Ngồi canh liên tục | Viết đề 5 phút, duyệt kế hoạch, đi làm việc khác |

---

## 6. Chốt chặn tự động — nối lại với bước 1

Không thể trông chờ 20 người nhớ bật plan mode mỗi lần. Nên đặt chốt chặn ngay trong `~/.claude/CLAUDE.md`:

```markdown
# Workflow
- Trước khi sửa >3 file, trình bày kế hoạch rồi chờ tôi duyệt.
- Nếu yêu cầu của tôi mơ hồ, hỏi lại tối đa 3 câu trước khi bắt tay làm.
- Sau khi sửa xong, chạy test liên quan và đưa output ra làm bằng chứng.
- Không tự ý mở rộng phạm vi ngoài những gì tôi yêu cầu.
```

Ba dòng này biến những kỹ thuật ở trên thành **mặc định**, không phải thứ phải nhớ.

> Đây cũng là chỗ chứng minh bước 1 không phải lý thuyết suông: file global chính là nơi cài đặt kỷ luật làm việc.

---

## 7. Checklist thực hành

Trước khi gõ prompt:

- [ ] Tôi có nói rõ **file nào** không? (dùng `@` để trỏ)
- [ ] Tôi có nói **"xong" nghĩa là gì** không?
- [ ] Tôi có nói cái gì **ngoài phạm vi** không?
- [ ] Việc này có đáng bật **plan mode** không? (>3 file, hoặc chưa chắc cách làm → có)
- [ ] Nếu tôi cũng chưa rõ mình muốn gì → **bảo Claude phỏng vấn tôi trước**

Trong lúc làm:

- [ ] Thấy đi sai hướng → `Esc` **ngay**, đừng đợi nó chạy xong
- [ ] Đã sửa **2 lần** mà vẫn sai → dừng. `/clear`, viết lại đề bài
- [ ] Chuyển sang việc khác → `/clear`

---

## 8. Bốn câu chốt khi trình bày

1. **Sửa nhiều vòng không phải chậm hơn — mà là vừa chậm hơn vừa dở hơn.** Context bẩn làm Claude kém đi.
2. **Luật 2 lần.** Sửa hai lần vẫn sai thì vấn đề nằm ở đề bài, không nằm ở Claude. `/clear` rồi viết lại.
3. **Duyệt kế hoạch rẻ hơn duyệt code.** `Shift+Tab` là phím đáng học nhất trong Claude Code.
4. **Chưa rõ mình muốn gì thì đừng đoán — bảo nó phỏng vấn mình.** Đó là lúc AI hữu ích nhất.

---

## Nguồn tham khảo

- [Best practices for Claude Code](https://code.claude.com/docs/en/best-practices) — mục *Avoid common failure patterns*, *Explore first then plan*, *Course-correct early and often*
- [Interactive mode](https://code.claude.com/docs/en/interactive-mode) — phím tắt
- [Checkpointing](https://code.claude.com/docs/en/checkpointing) — cơ chế rewind
- [Permission modes](https://code.claude.com/docs/en/permission-modes) — plan mode
