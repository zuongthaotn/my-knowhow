# 🔎 Magento 2 Indexer

## 1. Indexer là gì?
**Indexer** trong Magento 2 là cơ chế **tiền xử lý (pre-compute)** dữ liệu phức tạp và lưu kết quả vào **index tables** để Magento đọc nhanh hơn khi render frontend hoặc admin.

> Thay vì tính toán nhiều bảng EAV mỗi request, Magento đọc dữ liệu đã được index sẵn.

---

## 2. Vì sao Magento cần Indexer?
Magento sử dụng **EAV model**, dẫn đến:
- Nhiều bảng
- Nhiều JOIN
- Truy vấn chậm nếu tính realtime

**Indexer giúp:**
- Tăng hiệu năng
- Giảm DB load
- Đảm bảo dữ liệu hiển thị chính xác (price, stock, search)

---

## 3. Các Indexer quan trọng trong Magento 2

| Indexer | Chức năng |
|------|-----------|
| `catalog_product_price` | Tính giá sản phẩm |
| `cataloginventory_stock` | Tồn kho |
| `catalog_category_product` | Quan hệ category–product |
| `catalogsearch_fulltext` | Search (Elastic/OpenSearch) |
| `customer_grid` | Grid customer |
| `sales_order_grid` | Grid order |
| `catalogrule_product` | Catalog price rules |

---

## 4. Cách Indexer hoạt động

### Step 1: Dữ liệu thay đổi
- Update product
- Import CSV
- Thay đổi giá / rule

### Step 2: Indexer bị đánh dấu **invalid**
```bash
bin/magento indexer:status
```

### Step 3: Reindex chạy
- Tính toán lại dữ liệu
- Ghi vào index tables

## 5. Chế độ chạy Indexer (Rất hay hỏi)

### 1️⃣ Update on Save
- Reindex ngay khi save
- ❌ Chậm admin
- ❌ Không phù hợp production

### 2️⃣ Update by Schedule (Recommended)
- Đánh dấu invalid
- Cron chạy reindex

```bash
bin/magento indexer:set-mode schedule
```

## 6. Cách Reindex

**Reindex tất cả**
```bash
bin/magento indexer:reindex
```

**Reindex một indexer**
```bash
bin/magento indexer:reindex catalog_product_price
```

**Kiểm tra trạng thái**
```bash
bin/magento indexer:status
```

**Reset indexer (cẩn thận)**
```bash
bin/magento indexer:reset
```

## 7. Khi nào cần Reindex?
- Giá configurable hiển thị sai
- Sản phẩm không xuất hiện trong category
- Search không ra kết quả
- Sau import dữ liệu lớn
- Sau deploy module ảnh hưởng product/price

## 8. Sai lầm thường gặp
- ❌ Chạy reindex trong request
- ❌ Update on Save cho production
- ❌ Reindex trên tất cả node autoscale
- ❌ Chạy reindex giờ cao điểm