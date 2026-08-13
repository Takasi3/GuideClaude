# Playbook: Postgres store (refcursor) → API endpoint (mwg.logistics.core)

> Mục đích: AI đọc file này là đủ để **tái tạo nhanh** một API đọc dữ liệu từ **stored function Postgres trả `refcursor`**, theo đúng convention dự án `mwg.logistics.core`. Có sẵn **template code** (điền chỗ trống) + **case mẫu Delivery on-time status** đã chạy thật.

---

## 0. Khi nào dùng playbook này

Kích hoạt khi yêu cầu có dạng: "viết API gọi store `schema.func(...)` trên Postgres, nhận input X, trả JSON list". Đặc biệt khi store **trả `refcursor`** (pattern chuẩn của dự án).

Đầu vào cần có:
- **Spec request/response** (field name, type, not null) — thường 1 bảng.
- **Store SQL** (hoặc spec RULES để tự viết store).
- Loại DB + **connection key** (xem mục 2).

---

## 1. Bối cảnh dự án

- Root code: `C:\Source\mwg.logistics.core`
- .NET 8, cấu trúc project:
  | Project | Vai trò |
  |---|---|
  | `MWG.Logistics.Core.Api` | Controller, DI (`Program.cs`), config |
  | `MWG.Logistics.Core.BLL` | Service (business logic) |
  | `MWG.Logistics.Core.DAO` | DAO + DbHelper (gọi DB) |
  | `MWG.Logistics.Core.Models` | Request/Response models |
- Tham chiếu: Api → BLL → DAO → Models.
- **Luôn loại trừ `.vshistory`** khi search (`glob: "!**/.vshistory/**"`).

---

## 2. Connection & DB helper (điểm mấu chốt)

- Connection string khai báo trong **`MWG.Logistics.Core.Api\app.config`** (`<connectionStrings>`), đọc qua `System.Configuration.ConfigurationManager`.
- Các key Postgres có sẵn: `ConnectionStringWMS`, `ConnectionToWHSPostgre`, `ConnectionStringMAPortgres` (+ `_RO`). ⚠️ `ConnectionStringToCRM` là **Oracle** — không dùng cho store Postgres.
- DAO kế thừa `PostgresBaseDao(factory, "<ConnectionKey>")`.
- **`ExecuteListAsync<T>("schema.func", params)` tự xử lý toàn bộ refcursor**: mở transaction → `SELECT * FROM func(...)` → đọc tên cursor → `FETCH ALL IN` → map DataTable → `List<T>`. ⇒ **Không cần viết code refcursor thủ công.** Store trả `refcursor` chạy thẳng.
  - File: `MWG.Logistics.Core.DAO\DbHelper\IDbHelper\PostgreSQL\PostgreSqlDbHelper.cs`
- Tham số: `PostgreSqlParameterHelper.BuildNpgsqlParameters(("p_name", value), ...)` — tuple `(string, object)`.

---

## 3. Kiến trúc chuẩn (luồng 5 tầng)

```
Controller  →  IService  →  Service  →  IDao  →  PostgresDao  →  ExecuteListAsync(store)
```

Mọi tầng có interface (phục vụ DI + đổi Oracle/Postgres + mock). DAO chạm DB **bắt buộc** có interface.

### Quy ước namespace (QUAN TRỌNG — không nhất quán theo folder)

| Tầng | Folder | Namespace |
|---|---|---|
| Models | `Requests\Logistics\{Feature}\` | `MWG.Logistics.Core.Models.Requests.{Feature}` — **BỎ chữ `Logistics`** |
| DAO | `Logistics\{Feature}\` | `MWG.Logistics.Core.DAO.{Feature}` — **BỎ chữ `Logistics`** |
| BLL | `Service\Logistics\{Feature}\` | `MWG.Logistics.Core.BLL.Service.Logistics.{Feature}` — **GIỮ chữ `Logistics`** |

(Theo đúng feature mẫu `HistoryUpdateLog`.)

---

## 4. Checklist file cần tạo/sửa

Với feature tên `{Feature}` (VD `Delivery`), method `{Method}`, store `{schema.func}`, connection `{ConnKey}`:

**Tạo 5 file + sửa 2 file.** Thứ tự: Models → DAO → Service → Controller → DI → build.

### 4.1 Model request — `Models\Requests\Logistics\{Feature}\{Feature}Query.cs`
```csharp
namespace MWG.Logistics.Core.Models.Requests.{Feature};

public class {Feature}Query
{
    public string SOlst { get; set; }   // map tới field request; đổi theo spec
    // thêm field khác nếu spec có (VD: public bool isAdmin { get; set; })
}
```

### 4.2 Model response item — `Models\Requests\Logistics\{Feature}\{Feature}Item.cs`
```csharp
using Newtonsoft.Json;

namespace MWG.Logistics.Core.Models.Requests.{Feature};

public class {Feature}Item
{
    [JsonProperty("SO")]     public string SO { get; set; }
    [JsonProperty("status")] public string Status { get; set; }
    // ẩn field khỏi JSON khi null:
    [JsonProperty("reason", NullValueHandling = NullValueHandling.Ignore)]
    public string Reason { get; set; }
}
```
> **Casing JSON**: dự án dùng Newtonsoft. Muốn key đúng như spec (`SO`, `status`, `reason`) thì **bắt buộc** `[JsonProperty("...")]`, vì property C# là PascalCase. Tên cột alias trong store nên trùng property (Dapper map case-insensitive).

### 4.3 DAO interface — `DAO\Logistics\{Feature}\I{Feature}Dao.cs`
```csharp
using MWG.Logistics.Core.Models.Requests.{Feature};

namespace MWG.Logistics.Core.DAO.{Feature};

public interface I{Feature}Dao
{
    public Task<IEnumerable<{Feature}Item>> {Method}({Feature}Query query);
}
```

### 4.4 DAO impl — `DAO\Logistics\{Feature}\Postgres{Feature}Dao.cs`
```csharp
using MWG.Logistics.Core.DAO.IDbHelper.PostgreSQL;
using MWG.Logistics.Core.Models.Requests.{Feature};

namespace MWG.Logistics.Core.DAO.{Feature};

public class Postgres{Feature}Dao : PostgresBaseDao, I{Feature}Dao
{
    public Postgres{Feature}Dao(PostgreSqlDbHelperFactory dbHelperFactory)
        : base(dbHelperFactory, "{ConnKey}") { }

    public async Task<IEnumerable<{Feature}Item>> {Method}({Feature}Query query)
    {
        using var dbHelper = CreateDbHelper();
        return await dbHelper.ExecuteListAsync<{Feature}Item>("{schema.func}",
            PostgreSqlParameterHelper.BuildNpgsqlParameters(
                ("i_saleorders", query.SOlst)));   // tên param = tên tham số store
    }
}
```

### 4.5 Service — `BLL\Service\Logistics\{Feature}\I{Feature}Service.cs` + `{Feature}Service.cs`
```csharp
// I{Feature}Service.cs
using MWG.Logistics.Core.Models.Requests.{Feature};
namespace MWG.Logistics.Core.BLL.Service.Logistics.{Feature};
public interface I{Feature}Service
{
    public Task<IEnumerable<{Feature}Item>> {Method}({Feature}Query query);
}

// {Feature}Service.cs
using MWG.Logistics.Core.DAO.{Feature};
using MWG.Logistics.Core.Models.Requests.{Feature};
namespace MWG.Logistics.Core.BLL.Service.Logistics.{Feature};
public class {Feature}Service : I{Feature}Service
{
    private readonly I{Feature}Dao _dao;
    public {Feature}Service(I{Feature}Dao dao) => _dao = dao;

    public async Task<IEnumerable<{Feature}Item>> {Method}({Feature}Query query)
    {
        var result = await _dao.{Method}(query);
        // chèn business logic ở đây nếu cần (VD ẩn reason khi !isAdmin):
        // if (!query.isAdmin) foreach (var it in result) it.Reason = null;
        return result;
    }
}
```

### 4.6 Controller (SỬA) — `Api\Controllers\Logistics\{Feature}Controller.cs`
```csharp
using Microsoft.AspNetCore.Mvc;
using MWG.Logistics.Core.Api.Helper;
using MWG.Logistics.Core.BLL.Service.Logistics.{Feature};
using MWG.Logistics.Core.Models.Requests.{Feature};

namespace MWG.Logistics.Core.Api.Controllers.Logistics;

[ApiController]
[Route("api/[controller]")]
public class {Feature}Controller(I{Feature}Service {feature}Service)
{
    [HttpPost("{Method}")]
    public async Task<ApiResult<IEnumerable<{Feature}Item>>> {Method}({Feature}Query query)
    {
        var result = await {feature}Service.{Method}(query);
        return ApiResult<IEnumerable<{Feature}Item>>.Ok(result);
    }
}
```
> Controller trong dự án **không kế thừa `ControllerBase`**, trả thẳng object bọc.
> **Wrapper trả về**: dùng `ApiResult<T>.Ok(...)` (helper `MWG.Logistics.Core.Api.Helper`). Có `.Ok(data)` và `.Fail(msg,...)`. (Trước đây tên `ApiResponse`/`Response<T>` — kiểm tra tên helper hiện tại trong `Api\Helper\` trước khi dùng.)

### 4.7 DI (SỬA) — `Api\Program.cs`
Thêm `using`:
```csharp
using MWG.Logistics.Core.BLL.Service.Logistics.{Feature};
using MWG.Logistics.Core.DAO.{Feature};
```
Thêm đăng ký (cạnh các `AddScoped` khác):
```csharp
builder.Services.AddScoped<I{Feature}Dao, Postgres{Feature}Dao>();
builder.Services.AddScoped<I{Feature}Service, {Feature}Service>();
```

---

## 5. Build & verify

```bash
dotnet build "C:\Source\mwg.logistics.core\MWG.Logistics.Core.Api\MWG.Logistics.Core.Api.csproj" -nologo -clp:ErrorsOnly
```
Kỳ vọng `0 Error(s)` (warnings là baseline, bỏ qua).

Endpoint: `POST /logisticscoreapi/api/{Feature}/{Method}` — body theo model request.

---

## 6. CI/CD — commit message để build/deploy (`.gitlab-ci.yml`)

Điều khiển bằng **từ khóa trong commit message** + **nhánh**. Regex không neo → chỉ cần *chứa* từ khóa.

| Mục đích | Nhánh | Commit chứa |
|---|---|---|
| Build image API (`build_all`) | dev/master | `build`, `Merge`, hoặc `all` |
| Deploy beta API | dev | `deploy`, `Merge`, hoặc `all` |
| Deploy staging/prod | master | `deploy`/`all` (prod bấm tay) |

⚠️ **Bẫy**: job **Kafka Consumer** trigger khi message chứa literal `build`. Muốn **build+deploy API mà KHÔNG đụng consumer** → dùng từ khóa **`all`** (vì `all` khớp job API nhưng không chứa chuỗi `build`).
→ Khuyến nghị commit: `all: <mô tả>`.

---

## 7. Pattern viết STORE Postgres (refcursor) + tối ưu

Template store trả `refcursor` 3 cột `SO/status/reason`, tối ưu index:

```sql
CREATE OR REPLACE FUNCTION {schema.func}(i_saleorders text DEFAULT NULL::text)
 RETURNS refcursor LANGUAGE plpgsql AS $function$
DECLARE
    ref refcursor := '{schema.func}';
    v_saleorders text := i_saleorders;
BEGIN
    -- Chuẩn hóa input
    v_saleorders := trim(v_saleorders);
    v_saleorders := regexp_replace(v_saleorders, '^,+', '');
    v_saleorders := regexp_replace(v_saleorders, ',+$', '');
    v_saleorders := regexp_replace(v_saleorders, ',{2,}', ',', 'g');

    IF v_saleorders IS NULL OR v_saleorders = '' THEN
        OPEN ref FOR SELECT NULL::text AS "SO", NULL::text AS "status", NULL::text AS "reason" WHERE false;
        RETURN ref;
    END IF;

    OPEN ref FOR
    WITH input(so, ord) AS (
        SELECT trim(x.so)::char(20), x.ord        -- CAST đúng kiểu cột (xem GOTCHA)
        FROM unnest(string_to_array(v_saleorders, ',')) WITH ORDINALITY AS x(so, ord)
    ),
    matched AS (
        SELECT d.* FROM crm.lsm_delivery d
        WHERE d.saleorderid = ANY (ARRAY(SELECT so FROM input))
    )
    SELECT rtrim(i.so) AS "SO", ... AS "status", ... AS "reason"
    FROM input i LEFT JOIN matched d ON d.saleorderid = i.so
    ORDER BY i.ord;
    RETURN ref;
END; $function$;
```

### ⚠️ GOTCHA hiệu năng #1 — CHAR(n) + lệch kiểu = full scan
- Nếu cột join là **`CHAR(20)` (bpchar)** mà so với `text`, Postgres cast cột → **bỏ index → Seq Scan** (bảng `lsm_delivery` ~41M dòng → chậm hàng giây/phút).
- **Fix**: cast input về **đúng kiểu cột** (`::char(20)`) để `bpchar = bpchar` (bỏ qua khoảng trắng đệm, dùng được index). `rtrim(...)` khi output cho sạch.
- Cần index: `CREATE INDEX IF NOT EXISTS idx_lsm_delivery_saleorderid ON crm.lsm_delivery (saleorderid);`
- Verify: `EXPLAIN ANALYZE` → phải thấy `Index Scan`, không phải `Seq Scan`.

### Nguyên tắc chung
- Muốn dùng index: **vế so sánh cùng kiểu với cột**, đừng bọc cột trong hàm/cast (`trim(col)`, `col::text`). Nếu buộc phải biến đổi → tạo *expression index*.
- `= ANY(ARRAY(...))` với index → N lần index lookup, thay vì hash cả bảng.
- `col IN (2,5)` với `col = NULL` → không-true → rơi vào nhánh `ELSE` (đúng ý "khác 2/5 thì Trễ").

---

## 8. Test store trực tiếp
```sql
BEGIN;
SELECT {schema.func}('SO1,SO2');
FETCH ALL IN "{schema.func}";
COMMIT;
```

---

## 9. Gotchas tổng hợp
1. Namespace Models/DAO **bỏ** `Logistics`, BLL **giữ** — sai là lỗi build/DI.
2. JSON key phải `[JsonProperty]` (Newtonsoft, không camelCase tự động vì `ContractResolver = null`).
3. `NullValueHandling.Ignore` để ẩn field theo điều kiện (VD `reason` chỉ trả khi admin).
4. `ExecuteListAsync` tự lo refcursor — đừng tự viết FETCH.
5. Chọn đúng connection key (Postgres, không nhầm `ConnectionStringToCRM` Oracle).
6. Store optimize: CHAR + index + cast đúng kiểu.
7. Commit `all` để build API không kéo theo Kafka consumer.

---

## 10. CASE MẪU ĐÃ CHẠY THẬT — Delivery on-time status

**Spec (request.txt):**
- Request: `SOlst CHAR` — 150 SO, cách nhau dấu phẩy.
- Response: `SO CHAR`, `status NVARCHAR2` (Trễ/Đúng giờ, rỗng nếu chưa giao thành công). (+ `reason` bổ sung.)
- RULES (map cột `crm.lsm_delivery` trên Postgres):
  - `beforedeliverytime` = hẹn giao đầu; `afterdeliverytime` = hẹn giao cuối; `finaldeliverytime` = giao thực tế; `reasonchangetimeid` = lý do chỉnh.
  - `afterdeliverytime` NULL → so `final` vs `before`: `>` Trễ, `<=` Đúng giờ.
  - `afterdeliverytime` NOT NULL & `reasonchangetimeid IN (2,5)` → so `final` vs `after`: `>` Trễ, `<=` Đúng giờ.
  - `afterdeliverytime` NOT NULL & `reasonchangetimeid NOT IN (2,5)` → Trễ.
  - `final` NULL hoặc SO rỗng/không tồn tại → `status = ""`.

**Tham số cụ thể đã dùng:**
- `{Feature}` = `Delivery`; `{Method}` = `lsm_deliveryontimestatus_byso`
- `{schema.func}` = `crm.lsm_deliveryontimestatus_byso`, param `i_saleorders text`
- `{ConnKey}` = `ConnectionStringWMS`
- Model có thêm `bool isAdmin` → `!isAdmin` thì service set `Reason = null` (ẩn khỏi JSON).
- Store đầy đủ: xem `D:\AI\GuideClaude\CodeTmp\store.sql`.

**Request/Response mẫu:**
```json
// POST api/Delivery/lsm_deliveryontimestatus_byso
{ "SOlst": "11467SO26070430814,11467SO26079991211", "isAdmin": true }

// →
{ "Status":"Success","Data":[
  { "SO":"11467SO26070430814","status":"","reason":"Chưa có thời gian giao thực tế" },
  { "SO":"11467SO26079991211","status":"Đúng giờ","reason":"..." }
], "IsError":false, "Success":true }
```
(Khi `isAdmin=false` → cột `reason` biến mất.)
