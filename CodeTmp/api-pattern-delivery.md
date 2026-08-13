# Pattern viết API mới trong MWG.Logistics.Core

Tài liệu này phân tích cách project viết một API, lấy `DeliveryController` (route `lsm_deliveryontimestatus_byso`) làm ví dụ minh họa xuyên suốt.

## 1. Tổng quan luồng

```
Controller (Api) → Service (BLL) → Dao (DAO) → Stored Procedure (Postgres/Oracle)
```

Mỗi lớp có interface riêng (`IDeliveryService`, `IDeliveryDao`...), đăng ký DI thủ công trong `Program.cs` (không có `*ServiceCollectionExtensions.cs` riêng theo feature).

## 2. Controller

File: `MWG.Logistics.Core.Api\Controllers\Logistics\DeliveryController.cs`

```csharp
using Microsoft.AspNetCore.Mvc;
using MWG.Logistics.Core.Api.Helper;
using MWG.Logistics.Core.BLL.Service.Logistics.Delivery;
using MWG.Logistics.Core.Models.Requests.Delivery;

namespace MWG.Logistics.Core.Api.Controllers.Logistics;

[ApiController]
[Route("api/[controller]")]
public class DeliveryController(IDeliveryService deliveryService)
{
    [HttpPost("lsm_deliveryontimestatus_byso")]
    public async Task<ApiResult<IEnumerable<DeliveryOnTimeStatusItem>>> lsm_deliveryontimestatus_byso(DeliveryOnTimeStatusQuery query)
    {
        var result = await deliveryService.GetOnTimeStatusBySo(query);

        return ApiResult<IEnumerable<DeliveryOnTimeStatusItem>>.Ok(result);
    }
}
```

Điểm mấu chốt:

- `[ApiController]` + `[Route("api/[controller]")]` ở cấp class — pattern chuẩn xuyên suốt project.
- Dùng **primary constructor** (C# 12) để nhận service qua DI: `DeliveryController(IDeliveryService deliveryService)`.
- **Không bắt buộc kế thừa `ControllerBase`**. Project không đồng nhất ở điểm này:
  - Nhóm không kế thừa gì (giống `DeliveryController`): `TransportVoucherController`, `HistoryUpdateLogController`, `SystemConfigController`, `UserController`, `StoreController`, `CageController`, `WarehouseLayoutController`, `StoreTypeController`, `StorePrinterController`, `CompanyController`, `BrandController`, `StoreChangeOrderTypeController`.
  - Nhóm kế thừa `ControllerBase`: `WeatherForecastController`, `HealthcheckController`, `JobReportController`, `HomeController`, `TestController`, `MwgAppController`, `LogisticReportController`, `RequestPickupController`, `UserCacheController`, `StoreCacheController`, `ProductCacheController`.
  - Khi API mới không cần các helper của `ControllerBase` (`Ok()`, `BadRequest()`...), có thể bỏ kế thừa như `DeliveryController`.
- Action trả trực tiếp `Task<ApiResult<T>>` (POCO), không qua `IActionResult`/`ActionResult<T>`.
- Route action đặt riêng theo `[HttpPost("...")]`, không theo REST resource mặc định của MVC.
- Không có `[Authorize]`/`[AllowAnonymous]` gắn trên controller/action — auth cấu hình global qua middleware `app.UseAuthentication()/UseAuthorization()` trong `Program.cs`.
- Không dùng API versioning attribute nào.

## 3. Request/Response model

Namespace vật lý (folder) và namespace khai báo trong code **lệch nhau** — cần lưu ý khi tạo model mới:

- Folder: `MWG.Logistics.Core.Models\Requests\Logistics\Delivery\`
- Namespace khai báo: `MWG.Logistics.Core.Models.Requests.Delivery` (thiếu segment `Logistics`)

Request (`DeliveryOnTimeStatusQuery.cs`):

```csharp
namespace MWG.Logistics.Core.Models.Requests.Delivery;

public class DeliveryOnTimeStatusQuery
{
    public string SOlst { get; set; }
    public bool isAdmin { get; set; }
}
```

Response item (`DeliveryOnTimeStatusItem.cs`) — dùng Newtonsoft `[JsonProperty]`, **không** dùng DataAnnotations:

```csharp
using Newtonsoft.Json;
namespace MWG.Logistics.Core.Models.Requests.Delivery;

public class DeliveryOnTimeStatusItem
{
    [JsonProperty("SO")] public string SO { get; set; }
    [JsonProperty("status")] public string Status { get; set; }
    [JsonProperty("reason", NullValueHandling = NullValueHandling.Ignore)] public string Reason { get; set; }
}
```

## 4. Service (BLL)

`IDeliveryService` (`MWG.Logistics.Core.BLL\Service\Logistics\Delivery\IDeliveryService.cs`): interface đơn giản, 1 method.

`DeliveryService`: implement interface, inject `IDeliveryDao` qua **constructor thường** (khác controller — layer BLL/DAO không dùng primary constructor). Có thể chứa business rule đơn giản, ví dụ Delivery ẩn field `Reason` khi `!query.isAdmin` trước khi trả kết quả.

## 5. DAO

`IDeliveryDao` / `PostgresDeliveryDao` (`MWG.Logistics.Core.DAO\Logistics\Delivery\`):

- Kế thừa `PostgresBaseDao` (hoặc DAO base tương ứng cho Oracle nếu dùng DB khác), constructor gọi `base(dbHelperFactory, "ConnectionStringWMS")` — connection string key truyền lên base, đọc qua `ConfigurationManager.ConnectionStrings` (từ `app.config`, **không phải** `appsettings.json`).
- Method DAO: `using var dbHelper = CreateDbHelper();` rồi gọi trực tiếp stored procedure/function (ví dụ `crm.lsm_deliveryontimestatus_byso` — trùng tên route action) qua `dbHelper.ExecuteListAsync<T>("schema.proc_name", PostgreSqlParameterHelper.BuildNpgsqlParameters(("param_name", value), ...))`. Bên trong, `ExecuteListAsync` build `SELECT * FROM proc_name(@params)`, đọc refcursor, nạp `DataTable` rồi convert `dt.ToListDapper<T>()` — dùng ADO.NET (Npgsql) trực tiếp, chỉ mượn Dapper để map `DataTable` → object, **không dùng EF Core**.
- Chỉ truyền xuống DB những tham số mà stored procedure thực sự cần. Ví dụ Delivery: DAO chỉ truyền `i_saleorders = query.SOlst`; `query.isAdmin` (flag ẩn/hiện field ở output) **không** truyền xuống DB, được lọc hoàn toàn ở tầng Service (xem mục 4).

## 6. Đăng ký DI

Không có extension method riêng theo feature — thêm trực tiếp 2 dòng vào `Program.cs` (danh sách `AddScoped<IXxxDao,...>`/`AddScoped<IXxxService,...>` kéo dài từ đầu đến cuối phần khai báo service):

```csharp
builder.Services.AddScoped<IDeliveryDao, PostgresDeliveryDao>();
builder.Services.AddScoped<IDeliveryService, DeliveryService>();
```

Đa số đăng ký là `Scoped`; một vài chỗ dùng `Transient` (`IStorePrinterDao`, `IHistoryUpdateLogDao`).

## 7. Response wrapper chung

`ApiResult<T>` (`MWG.Logistics.Core.Api\Helper\ApiResult.cs`): wrapper chuẩn cho mọi API nội bộ, có `Status`, `Message`, `MessageDetail`, `Data`, `IsError`, `errorCode`, `Success`, factory tĩnh `Ok(data, message = null)` / `Fail(message, errorCode = -1, messageDetail = null)`.

Cùng file còn có `ApiResponseExtensions` (static class riêng) với `ToSuccessResponse<T>`/`ToSuccessResponse()`/`ToErrorResponse<T>`/`ToErrorResponse()`/`ToDataTableResponse` — trả `IActionResult` (`OkObjectResult`/`BadRequestObjectResult`), dùng cho action nào cần `IActionResult` thay vì POCO `ApiResult<T>`.

**Cảnh báo:** tồn tại một `ApiResponse<T>` **khác**, không liên quan, tại `MWG.Logistics.Core.Models\Integration\Common\ApiResponse.cs`, dùng cho model tích hợp hệ thống bên ngoài. Khi viết `using` cho controller nội bộ, phải chắc chắn dùng `ApiResult<T>` từ `MWG.Logistics.Core.Api.Helper`, không nhầm sang `ApiResponse<T>` đó.

## 8. Xử lý exception toàn cục

`ExceptionHandlingMiddleware` (`MWG.Logistics.Core.Api\Extensions\ExceptionHandlingMiddleware.cs`) đăng ký sớm trong pipeline (`app.UseMiddleware<ExceptionHandlingMiddleware>()`, trước Swagger/routing). Middleware:

- Buffer request body (<100KB, content-type JSON) để log khi có lỗi.
- Luôn set `StatusCode = 200` (kể cả khi lỗi), trả JSON `{ Success, IsError, Message, MessageDetail, Data }`.
- Phân loại theo exception type:
  - `BusinessException` — lấy `Code` riêng, dùng cho lỗi nghiệp vụ có message tùy biến.
  - `InvalidException` — từ FluentValidation, trả kèm list `Errors`.
  - `ThirdPartyException` — dùng message gốc, cho lỗi gọi hệ thống bên thứ 3.
  - `PostgresException` với `SqlState == "P0001"` — dùng message custom raise từ DB.
  - Còn lại: log qua `WriteLog(...)` (kế thừa `BaseClass`) và trả message chung.

=> **Controller/Service không cần try/catch thủ công** — chỉ cần `throw` đúng loại exception, middleware xử lý phần còn lại.

## 9. Validate input

- Có sẵn hạ tầng FluentValidation (`InvalidException` nhận `IList<FluentValidation.Results.ValidationFailure>`), nhưng **chưa có class nào kế thừa `AbstractValidator<T>` được implement trong toàn repo** — hạ tầng có, chưa dùng.
- `Program.cs`: `builder.Services.Configure<ApiBehaviorOptions>(options => { options.SuppressModelStateInvalidFilter = true; });` — tắt validate DataAnnotations tự động của ASP.NET Core.
- `DeliveryController` hiện **không validate input** (không FluentValidation, không DataAnnotations, không check tay) — nhận `query` rồi gọi thẳng service.
- Nếu API mới cần validate, đây là chỗ cần tự bổ sung (viết `AbstractValidator<T>` rồi throw `InvalidException` khi fail), vì infra exception đã sẵn sàng nhận nhưng chưa ai dùng.

## 10. Naming convention route & HTTP method

Không có convention bắt buộc thống nhất toàn project — tùy nhóm tính năng/tác giả:

- **Snake_case theo tên stored procedure gốc**: `DeliveryController` → `[Route("api/[controller]")]` cấp class + `[HttpPost("lsm_deliveryontimestatus_byso")]` cấp action → route cuối `api/Delivery/lsm_deliveryontimestatus_byso`.
- **Kebab-case, override route tuyệt đối bằng `~/`** (bỏ qua prefix `api/[controller]`): `TransportVoucherController` → `[HttpPost("~/api/transport-vouchers/batch")]`, `[HttpGet("~/api/transport-types/subgroups")]`.
- **Kebab-case, override route ở cấp class** (không dùng token `[controller]`): `BonusClaimController` → `[Route("api/bonus-claim")]`, action chỉ thêm segment ngắn: `[HttpGet("form")]`, `[HttpPost("")]`, `[HttpGet("list")]`.

HTTP method: **POST được dùng phổ biến kể cả cho truy vấn đọc dữ liệu** (ví dụ `lsm_deliveryontimestatus_byso` về bản chất là GET nhưng dùng `HttpPost`, có thể vì payload là list dài không phù hợp query string). Dùng `HttpGet` khi tham số đơn giản (`[FromQuery]`). `BonusClaimController` có 1 action job scheduler (`expire-overdue`) cố tình dùng `HttpPost` dù không có payload thật — comment trong code giải thích: tránh bị proxy/crawler gọi nhầm (GET dễ bị prefetch/crawl hơn POST).

## 11. Swagger & Logging

- Không có annotation Swagger riêng theo controller/action (`[SwaggerOperation]`, `[ProducesResponseType]`...). Chỉ cấu hình chung ở `Program.cs` (`AddSwaggerGen`, `PathPrefixInsertDocumentFilter`, Bearer security scheme), UI chỉ bật ở Development/Beta.
- Logging nghiệp vụ **không nhất quán**:
  - Luồng Delivery không dùng `ILogger` ở controller/service/DAO.
  - Một số controller khác dùng `ILogger<T>` chuẩn ASP.NET Core (`WeatherForecastController`, `StoreCacheController`, `UserCacheController`, `ProductCacheController`).
  - Có cơ chế log lỗi tập trung riêng qua `BaseClass.WriteLog(...)`, dùng trong `ExceptionHandlingMiddleware` — không phải log nghiệp vụ thông thường.

## 12. Test

Solution không có project test nào (`*.Tests`), không có file `*Tests.cs` nào trong repo. Không có pattern unit test để tham khảo khi viết API mới.

## 13. Checklist thêm một API mới theo pattern hiện tại

1. Tạo request/response model tại `MWG.Logistics.Core.Models\Requests\Logistics\<Feature>\` (namespace `MWG.Logistics.Core.Models.Requests.<Feature>`).
2. Tạo `I<Feature>Dao` + implementation kế thừa `PostgresBaseDao`, gọi stored procedure qua `dbHelper.ExecuteListAsync<T>()`.
3. Tạo `I<Feature>Service` + implementation, inject DAO qua constructor thường, xử lý business rule nếu có.
4. Tạo controller: `[ApiController]`, `[Route("api/[controller]")]`, primary constructor nhận service, action `[HttpPost("route-name")]` trả `Task<ApiResult<T>>` gọi `ApiResult<T>.Ok(result)`.
5. Đăng ký DI trong `Program.cs`: `AddScoped<IXxxDao, XxxDao>()` và `AddScoped<IXxxService, XxxService>()`.
6. Lỗi nghiệp vụ thì `throw new BusinessException(...)` (hoặc `ThirdPartyException`/`InvalidException` tùy loại) — không tự try/catch, để middleware xử lý.

**Các điểm KHÔNG đồng nhất cần tự quyết định theo ngữ cảnh** (không có chuẩn cứng trong project):

- Kế thừa `ControllerBase` hay không.
- Route action: snake_case theo SP gốc hay kebab-case.
- Có validate input bằng FluentValidation hay không (hạ tầng có sẵn nhưng chưa ai dùng).
- Có dùng `ILogger<T>` hay không.
