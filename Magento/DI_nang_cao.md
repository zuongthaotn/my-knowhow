# 🧩 Dependency Injection (DI) nâng cao trong Magento 2

Dependency Injection là **xương sống kiến trúc của Magento 2**. Ở level nâng cao, interviewers không chỉ hỏi *DI là gì* mà sẽ hỏi **cách Magento dùng DI để scale, override, optimize performance**.

---

## 1. DI trong Magento 2 là gì? (nhắc nhanh)
Magento dùng **constructor injection** + **DI Container** (Object Manager) để:
- Quản lý vòng đời object
- Giảm coupling
- Dễ mở rộng & test

❗ **Không new object thủ công**, không dùng `ObjectManager` trực tiếp.

---

## 2. Object Manager (OM) – hiểu đúng bản chất

### Object Manager làm gì?
- Resolve dependencies
- Inject class đúng implementation
- Manage shared / non-shared objects

```php
public function __construct(
    ProductRepositoryInterface $productRepository
) {}
```
👉 Magento tự map interface → implementation qua `di.xml`

## 3. di.xml – Trung tâm DI nâng cao ⭐⭐⭐

### 3.1 Preference (Override implementation)
```xml
<preference
    for="Magento\Catalog\Api\ProductRepositoryInterface"
    type="Vendor\Module\Model\ProductRepository"
/>
```
**⚠️ Cảnh báo:**
- Preference = override toàn hệ thống
- Dễ conflict
- Chỉ dùng khi bắt buộc

### 3.2 Virtual Type (Tạo class “ảo”)
👉 Tạo nhiều cấu hình khác nhau từ 1 class gốc

```xml
<virtualType name="CustomLogger" type="Magento\Framework\Logger\Monolog">
    <arguments>
        <argument name="name" xsi:type="string">custom</argument>
    </arguments>
</virtualType>
```
Inject:

```php
public function __construct(CustomLogger $logger) {}
```
- ✅ Không cần tạo class mới
- ✅ Rất clean, rất Magento-style

### 3.3 Factory (Dynamic object creation)
Magento auto-generate *Factory:

```php
public function __construct(
    \Magento\Catalog\Model\ProductFactory $productFactory
) {}

$product = $this->productFactory->create();
```
**Dùng khi:**
- Object cần runtime data
- Object không share

### 3.4 Proxy (Lazy loading – Performance ⭐⭐⭐)
```php
public function __construct(
    \Magento\Catalog\Api\ProductRepositoryInterface\Proxy $productRepo
) {}
```
👉 Object chỉ được khởi tạo khi thật sự dùng

**Dùng khi:**
- Object nặng
- Không phải request nào cũng cần

### 3.5 Shared vs Non-shared
```xml
<type name="Vendor\Module\Model\HeavyService">
    <shared>false</shared>
</type>
```

| Shared | Non-shared |
|--------|------------|
| Singleton-like | New instance mỗi lần |
| Default | Tốn memory hơn |

## 4. Interface & Service Contracts ⭐⭐⭐
Magento khuyến khích:
- Inject Interface, không inject class cụ thể
- Đảm bảo backward compatibility

```php
ProductRepositoryInterface
```
👉 **Giúp:**
- API stable
- Module dễ replace

## 5. DI + Plugin + Preference (So sánh nâng cao)

| Use case | Nên dùng |
|----------|----------|
| Thay đổi logic method | Plugin |
| Thêm logic trước/sau | Plugin |
| Thay toàn bộ implementation | Preference |
| Cấu hình khác nhau | VirtualType |

👉 **Plugin > Preference trong 90% case**

## 6. DI trong CLI / Cron / Queue
- CLI & Cron vẫn dùng DI container
- Cron chạy trong context riêng
- Không assume state shared

```php
class CustomCron {
    public function __construct(
        LoggerInterface $logger
    ) {}
}
```

## 7. DI Compilation (setup:di:compile)
```bash
bin/magento setup:di:compile
```
Magento sẽ:
- Generate factories
- Generate proxies
- Validate DI graph

❌ DI lỗi → site chết ngay

## 8. Anti-patterns (RẤT hay bị hỏi)
- ❌ `ObjectManager::getInstance()`
- ❌ Inject quá nhiều dependency
- ❌ Preference override core lung tung
- ❌ Không dùng Proxy cho heavy service