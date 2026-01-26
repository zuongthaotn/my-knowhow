# ✅ Cách tiếp cận chuyên nghiệp: Debug Configurable Product Price

## 🧭 1. Hiểu vấn đề cụ thể
Trước khi code hay sửa gì, bạn cần đặt câu hỏi:
- Giá hiển thị sai ở đâu? (category page, product page, cart, checkout?)
- Giá sai là giá nào? (giá cha, giá con, giá option được chọn?)
- Giá sai là cao hơn hay thấp hơn mong đợi?

## 🛠 2. Kiểm tra cấu hình sản phẩm
Vào Admin:
- **Kiểm tra sản phẩm cha:**
  - Có đặt giá không? (configurable thường không nên có giá nếu giá theo biến thể).
- **Kiểm tra các sản phẩm con (simple product):**
  - Có giá đầy đủ không?
  - Tình trạng enable/disable?
  - Có thuộc cùng website không?

> 💡 **Magento thường hiển thị giá của simple product rẻ nhất nếu cấu hình đúng.**

## 🔎 3. Kiểm tra template hiển thị
- File `Magento_ConfigurableProduct/templates/product/price/final_price.phtml`
- File `Magento_Catalog/templates/product/price/final_price.phtml`

Kiểm tra xem giá được render từ đâu:
```php
$block->getProduct()->getFinalPrice()
```
Hoặc:
```php
$block->getProduct()->getPriceInfo()->getPrice('final_price')->getValue()
```

## 📦 4. Kiểm tra dữ liệu trong database
- Bảng `catalog_product_entity`, `catalog_product_entity_decimal`, `catalog_product_super_link`
- Check giá các simple con của configurable

## 🔍 5. Kiểm tra Observer/Plugin can thiệp
Nhiều module 3rd-party hoặc custom có thể dùng plugin/event để:
- Can thiệp giá hiển thị
- Ghi đè `getFinalPrice()` hoặc `getPrice()`.

**Dò:**
- `di.xml` → plugin trên `Magento\Catalog\Model\Product`
- Observer lắng nghe `catalog_product_get_final_price`, `product_load_after`, v.v.

## 🧪 6. Test với theme Luma mặc định
- Nếu bạn dùng theme tùy chỉnh → có thể override template hiển thị giá sai.
- Switch về theme **Magento Luma** để xác nhận.

## 🔁 7. Clear cache + reindex
- Luôn chạy:
```bash
bin/magento indexer:reindex
bin/magento cache:flush
```
- Check lại kết quả sau khi làm sạch.

## 🎯 Tóm lại: Flow xử lý chuyên nghiệp
1. Hỏi rõ vị trí + dạng sai của giá
2. Kiểm tra cấu hình sản phẩm cha/con
3. Xem giá đang hiển thị từ đâu (template hoặc block)
4. Kiểm tra module/plugin/observer có can thiệp không
5. So sánh với theme Luma để loại trừ lỗi frontend
6. Kiểm tra DB và reindex/cache