# 🧠 Tổng quan nhanh:

| Khái niệm | Mục đích chính | Khi nào dùng |
|---|---|---|
| **VirtualType** | Tạo "biến thể" của 1 class có sẵn | Tái sử dụng class gốc với cấu hình khác |
| **Proxy** | Trì hoãn khởi tạo class cho đến khi thực sự dùng | Tối ưu hiệu năng – dùng với class nặng hoặc không phải lúc nào cũng dùng |
| **Factory** | Tạo object runtime có thể truyền tham số | Khi bạn cần khởi tạo object nhiều lần với dữ liệu khác nhau |
| **ObjectManager** | Tạo object thủ công (service locator pattern) | Tránh dùng trực tiếp, trừ trường hợp đặc biệt |

## 🔎 1. VirtualType

VirtualType là một "alias" (tên ảo) đại diện cho một class gốc, nhưng có thể cấu hình constructor khác.

- Không cần tạo class mới!

**Ví dụ:**

```xml
<virtualType name="MyLogger" type="Magento\Framework\Logger\Monolog">
    <arguments>
        <argument name="name" xsi:type="string">my_custom_logger</argument>
    </arguments>
</virtualType>
```

**Dùng khi:**
- Bạn cần nhiều biến thể khác nhau của cùng một class (ví dụ nhiều loại logger, processor, validator...).

## 🕹 2. Proxy

Proxy là lớp trung gian giữa class A và class B.
- Magento tự tạo file Proxy trong `generated/`.
- Chỉ khởi tạo đối tượng thực sự khi bạn gọi method.

**Ví dụ:**

```xml
<argument name="productRepository" xsi:type="object">Magento\Catalog\Api\ProductRepositoryInterface\Proxy</argument>
```

**Dùng khi:**
- Inject class nặng (như ProductRepository) mà bạn không gọi trong mọi tình huống.
- Giảm hiệu năng khởi tạo lúc đầu.

## ⚙️ 3. Factory

Magento tự động tạo các lớp Factory nếu bạn gọi `\Vendor\Module\Model\SomethingFactory`.
- Cho phép tạo object với tham số runtime, ví dụ tạo 1 model rồi `setData()` hoặc `load()`.

**Ví dụ:**

```php
$customModel = $this->customModelFactory->create();
$customModel->setData(...)->save();
```

**Dùng khi:**
- Cần tạo object nhiều lần, với nội dung khác nhau.
- Không thể inject trực tiếp vì cần tham số động.

## 🚫 4. ObjectManager

Là Service Locator. Magento vẫn dùng nội bộ, nhưng bạn không nên dùng trực tiếp.

**Không khuyến khích:**
```php
$objectManager = \Magento\Framework\App\ObjectManager::getInstance();
$product = $objectManager->create(\Magento\Catalog\Model\Product::class);
```

**Chỉ dùng khi:**
- Trong file không DI được (ví dụ: script custom, file install, patch...).
- Rất ít trường hợp ngoại lệ chấp nhận được.

## 🎯 Tóm lại:

| Tình huống | Dùng gì? |
|---|---|
| Cần inject class nhưng trì hoãn khởi tạo | **Proxy** |
| Cần khởi tạo nhiều object của class model | **Factory** |
| Cần dùng cùng 1 class nhưng cấu hình khác | **VirtualType** |
| Không thể DI hoặc không có cách khác | **ObjectManager** (cẩn trọng) |