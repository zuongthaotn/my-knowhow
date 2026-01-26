# ✅ Tổng quan: Around Plugin vs Override

| | Around Plugin | Override (Preference) |
|---|---|---|
| **Mục đích** | Bao quanh (wrap) một method cụ thể | Ghi đè toàn bộ class, bao gồm tất cả method |
| **Phạm vi ảnh hưởng** | Chỉ ảnh hưởng đến một method cụ thể | Ảnh hưởng đến tất cả logic của class |
| **Tính an toàn** | Cao hơn (Magento tự sắp xếp nếu có nhiều plugin) | Dễ gây xung đột nếu có nhiều module override |
| **Tính linh hoạt** | Có thể gọi tiếp `$proceed()` hoặc không | Ghi đè hoàn toàn – không thể gọi lại logic cũ nếu không copy |
| **Khả năng kết hợp** | Có thể có nhiều plugin cùng lúc | Chỉ một preference có hiệu lực |

## 🔍 Around Plugin – hoạt động thế nào?

Plugin dạng around hoạt động như một wrapper cho method gốc, bạn có quyền:
- Chặn method gốc bằng cách không gọi `$proceed()`.
- Thay đổi logic đầu vào/ra.
- Gọi hoặc không gọi method gốc.

**Ví dụ:**

```php
public function aroundSave(\Magento\Catalog\Model\Product $subject, callable $proceed)
{
    // logic trước khi gọi hàm gốc
    $result = $proceed(); // gọi method gốc
    // logic sau khi gọi hàm gốc
    return $result;
}
```

## ⚠️ Override (Preference) – hoạt động thế nào?

Override (preference) ghi đè hoàn toàn class gốc. Bạn phải:
- Viết lại method bạn cần sửa.
- Gọi lại method cha nếu cần (`parent::method()`).
- Nếu logic thay đổi ở nhiều method hoặc liên quan tới constructor, override mới khả thi.

**Ví dụ:**

```php
class MyProduct extends \Magento\Catalog\Model\Product {
    public function save() {
        // ghi đè hoàn toàn hàm save()
    }
}
```

## 💡 So sánh thực tế

| Tình huống thực tế | Dùng cái gì? | Lý do |
|---|---|---|
| Thêm log khi gọi `save()` product | **around plugin** | Không thay đổi logic gốc |
| Chặn method `save()` của class | **around plugin** | Không gọi `$proceed()` |
| Cần viết lại constructor và toàn bộ business logic | **override** | Plugin không can thiệp constructor |
| Chỉ muốn thêm tiền tố vào tên sản phẩm khi save | **before plugin** | Nhanh, an toàn |
| Cần thay đổi logic của nhiều method trong class | **override** | Không khả thi với plugin |

## ⚠️ Lưu ý khi dùng around plugin:
- Dễ gây lỗi nếu quên gọi `$proceed()` (sẽ làm method gốc không chạy).
- Nên được dùng cẩn trọng, tránh lạm dụng – vì plugin around phức tạp hơn before / after.