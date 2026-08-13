-- DROP FUNCTION crm.lsm_deliveryontimestatus_byso(text);

CREATE OR REPLACE FUNCTION crm.lsm_deliveryontimestatus_byso(i_saleorders text DEFAULT NULL::text)
 RETURNS refcursor
 LANGUAGE plpgsql
AS $function$
DECLARE
    ref          refcursor := 'crm.lsm_deliveryontimestatus_byso';
    v_saleorders text := i_saleorders;
BEGIN
    -- Chuẩn hóa input
    v_saleorders := trim(v_saleorders);
    v_saleorders := regexp_replace(v_saleorders, '^,+', '');          -- bỏ dấu phẩy ở đầu
    v_saleorders := regexp_replace(v_saleorders, ',+$', '');          -- bỏ dấu phẩy ở cuối
    v_saleorders := regexp_replace(v_saleorders, ',{2,}', ',', 'g');  -- gộp dấu phẩy liên tiếp

    -- Input rỗng/null => trả cursor rỗng
    IF v_saleorders IS NULL OR v_saleorders = '' THEN
        OPEN ref FOR SELECT NULL::text AS "SO", NULL::text AS "status", NULL::text AS "reason" WHERE false;
        RETURN ref;
    END IF;

    OPEN ref FOR
    WITH input(so, ord) AS (
        SELECT trim(x.so)::char(20), x.ord
        FROM unnest(string_to_array(v_saleorders, ',')) WITH ORDINALITY AS x(so, ord)
    ),
    matched AS (
        SELECT d.saleorderid, d.beforedeliverytime, d.afterdeliverytime,
               d.finaldeliverytime, d.reasonchangetimeid
        FROM crm.lsm_delivery d
        WHERE d.saleorderid = ANY (ARRAY(SELECT so FROM input))
    )
    SELECT
        rtrim(i.so) AS "SO",
        CASE
            WHEN i.so IS NULL OR trim(i.so) = ''  THEN ''
            WHEN d.saleorderid IS NULL            THEN ''
            WHEN d.finaldeliverytime IS NULL      THEN ''
            WHEN d.afterdeliverytime IS NULL THEN
                CASE WHEN d.finaldeliverytime > d.beforedeliverytime THEN 'Trễ' ELSE 'Đúng giờ' END
            WHEN d.reasonchangetimeid IN (2, 5) THEN
                CASE WHEN d.finaldeliverytime > d.afterdeliverytime  THEN 'Trễ' ELSE 'Đúng giờ' END
            ELSE 'Trễ'
        END AS "status",
        CASE
            WHEN i.so IS NULL OR trim(i.so) = ''  THEN 'SO rỗng'
            WHEN d.saleorderid IS NULL            THEN 'SO không tồn tại'
            WHEN d.finaldeliverytime IS NULL      THEN 'Chưa có thời gian giao thực tế'
            WHEN d.afterdeliverytime IS NULL THEN
                CASE WHEN d.finaldeliverytime > d.beforedeliverytime
                     THEN 'Giao thực tế > hẹn giao đầu'
                     ELSE 'Giao thực tế <= hẹn giao đầu' END
            WHEN d.reasonchangetimeid IN (2, 5) THEN
                CASE WHEN d.finaldeliverytime > d.afterdeliverytime
                     THEN 'Giao thực tế > hẹn giao cuối (lý do chỉnh = 2/5)'
                     ELSE 'Giao thực tế <= hẹn giao cuối (lý do chỉnh = 2/5)' END
            ELSE 'Có hẹn giao cuối nhưng lý do chỉnh <> 2/5'
        END AS "reason"
    FROM input i
    LEFT JOIN matched d ON d.saleorderid = i.so
    ORDER BY i.ord;

    RETURN ref;
END;
$function$
;
