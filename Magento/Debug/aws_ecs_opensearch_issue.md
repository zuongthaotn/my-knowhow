# Know-how: Magento 2 trên ECS không hiển thị sản phẩm do cấu hình OpenSearch và cache

## Mô tả sự cố

Sau khi deploy Magento Backend lên ECS:

- FE (NextJS) login/logout hoạt động bình thường.
- Tuy nhiên danh sách sản phẩm không hiển thị.
- API lấy product trả về rỗng hoặc lỗi search.

Trong khi đó:

- Magento Admin hoạt động bình thường.
- Catalog > Products vẫn hiển thị đầy đủ.
- Có thể edit sản phẩm bình thường.

=> Điều này dễ khiến nghĩ rằng dữ liệu DB bị lỗi, nhưng thực tế database hoàn toàn bình thường.

---

# Quá trình điều tra

## Bước 1 - Kiểm tra OpenSearch

Test connection từ Magento Backend tới OpenSearch.

Kết quả:

```
Could not validate a connection to the OpenSearch.
Unknown 400 error from OpenSearch null
```

=> Nghi ngờ OpenSearch hoặc network.

---

## Bước 2 - Build lại Docker Image

Trong quá trình build image:

```
php bin/magento setup:upgrade
```

fail với lỗi OpenSearch.

=> Có vẻ vấn đề xảy ra ngay từ bước build chứ không phải runtime.

---

## Bước 3 - Nghi ngờ OpenSearch

Đã thử:

- Xóa toàn bộ OpenSearch domain trên AWS.
- Tạo domain mới.
- Đổi version:
    - 2.9
    - 2.10
    - 2.11
- Cấu hình giống hệt local.

Kết quả:

Vẫn không hiển thị sản phẩm.

=> Không phải do version OpenSearch.

---

## Bước 4 - Kiểm tra hostname

Ban đầu config:

```
vpc-snec-stg-es-fk7onwbyabdupfa5q3ww3yudja.ap-northeast-1.es.amazonaws.com
```

Sau đó đổi thành:

```
https://vpc-snec-stg-es-fk7onwbyabdupfa5q3ww3yudja.ap-northeast-1.es.amazonaws.com
```

Sau khi build lại:

```
setup:upgrade
```

đã chạy thành công.

Tuy nhiên:

```
indexer:reindex
```

vẫn fail.

---

## Bước 5 - Tối giản Dockerfile

Để loại bỏ ảnh hưởng của các bước khác.

Dockerfile chỉ còn:

```
setup:upgrade

indexer:reindex

cache:flush
```

Thậm chí tiếp tục giảm xuống:

```
indexer:reindex

cache:flush
```

Nhưng vẫn lỗi.

=> Không phải do setup:upgrade.

---

## Bước 6 - Debug Magento Core

Đã debug rất nhiều vị trí:

- Magento OpenSearch module
- opensearch-php
- Elasticsearch adapter
- Transport
- Connection

Thêm:

```
var_dump()

print_r()

exit()

die()
```

để xem request.

Phát hiện Magento gửi:

```
HEAD /
```

Tiếp tục debug response.

---

## Bước 7 - Phát hiện nguyên nhân

Ban đầu log cho thấy:

```
effective_url

http://vpc-xxxxx...
```

Trong khi curl test:

```
https://...
```

Điều này dẫn đến nghi ngờ Magento đang dùng HTTP.

Sau khi debug sâu hơn:

- Amazon OpenSearch chỉ chấp nhận HTTPS.
- Request HTTP sẽ bị AWS Load Balancer trả:

```
400 Bad Request
```

=> Đây chính là nguyên nhân của lỗi:

```
Could not ping search engine
Unknown 400 error from OpenSearch null
```

---

## Bước 8 - Sau khi sửa HTTPS

Hostname đổi thành:

```
https://vpc-xxxxx...
```

Magento đã:

- ping OpenSearch thành công
- setup:upgrade thành công

Nhưng:

```
indexer:reindex
```

vẫn fail.

---

## Bước 9 - Điều tra cache

Kiểm tra:

```
app/etc/env.php
```

Phát hiện:

Magento đang dùng Redis để lưu cache.

Trong Redis vẫn còn cache cũ từ lần deploy trước.

Dockerfile đang chạy:

```
indexer:reindex

cache:flush
```

Điều này khiến Magento reindex khi vẫn sử dụng cache cũ.

Đổi thứ tự thành:

```
cache:flush

indexer:reindex
```

Build image thành công.

---

# Root Cause

Có **2 nguyên nhân** kết hợp với nhau.

## 1. OpenSearch hostname thiếu HTTPS

Sai:

```
vpc-xxxxx.ap-northeast-1.es.amazonaws.com
```

Đúng:

```
https://vpc-xxxxx.ap-northeast-1.es.amazonaws.com
```

Nếu không có HTTPS:

- Magento sử dụng HTTP
- AWS ALB trả 400
- OpenSearch ping fail
- setup:upgrade hoặc reindex fail

---

## 2. Redis cache chưa được flush

Magento sử dụng Redis làm cache backend.

Trong quá trình build:

```
cache:flush
```

phải chạy trước:

```
indexer:reindex
```

Nếu không:

- Magento có thể đọc cache cũ
- Reindex thất bại hoặc tạo index sai

---

# Kết luận

Để build thành công trên ECS cần:

1.

OpenSearch hostname phải có:

```
https://
```

Ví dụ:

```
https://vpc-xxxxx.ap-northeast-1.es.amazonaws.com
```

2.

Thứ tự command trong Dockerfile nên là:

```
php bin/magento cache:flush

php bin/magento indexer:reindex
```

Không nên reindex trước khi flush cache nếu đang sử dụng Redis.

---

# Bài học rút ra

- Magento Admin hiển thị sản phẩm không đồng nghĩa OpenSearch hoạt động bình thường.
- FE không hiển thị product thường nên kiểm tra OpenSearch trước tiên.
- `Could not ping search engine` không phải lúc nào cũng do OpenSearch bị hỏng, có thể chỉ là cấu hình HTTP/HTTPS.
- Khi dùng Redis cache trong môi trường CI/CD hoặc Docker build, cần chú ý thứ tự `cache:flush` và `indexer:reindex`.
- Khi debug OpenSearch:
    - kiểm tra request thực tế Magento gửi
    - kiểm tra HTTP method
    - kiểm tra response code
    - kiểm tra `effective_url`
    - không chỉ dựa vào `curl` CLI vì request của PHP client có thể khác.
