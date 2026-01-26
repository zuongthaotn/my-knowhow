# ✅ Magento 2 Best Practices (Senior-level)

Dưới đây là bộ **best practices quan trọng nhất trong Magento 2**, tập trung vào **performance, scalability, maintainability, và security** – đúng những gì interviewer & production cần.

---

## 1️⃣ Code & Architecture

### ✔ Không chỉnh sửa core
- ❌ `vendor/magento/*`
- ✅ Extend bằng **Plugin / Preference / Event**

### ✔ Ưu tiên Plugin hơn Preference
- Plugin → an toàn, ít conflict
- Preference → chỉ dùng khi **bắt buộc**

### ✔ Dùng Service Contracts
- Inject **Interface**, không inject class
- Ví dụ: `ProductRepositoryInterface`

### ✔ Module nhỏ, rõ trách nhiệm
- 1 module = 1 domain logic
- Dễ maintain & test

---

## 2️⃣ Dependency Injection (DI)

- ❌ Không dùng `ObjectManager` trực tiếp
- ✔ Dùng **constructor injection**
- ✔ Dùng **Factory** khi object cần runtime data
- ✔ Dùng **Proxy** cho service nặng
- ✔ Dùng **VirtualType** để tránh tạo class thừa

---

## 3️⃣ Database & Data Layer

### ✔ Dùng Declarative Schema
- `etc/db_schema.xml`
- Tránh `InstallSchema.php`

### ✔ Hạn chế EAV Attribute
- Chỉ tạo khi thật cần
- Tránh query phức tạp

### ✔ Dùng Repository thay vì ResourceModel trực tiếp
- Giữ logic sạch
- API-friendly

### ✔ Luôn dùng bind parameters
```php
$connection->fetchAll($sql, ['id' => $id]);
```

## 4️⃣ Performance & Caching

### ✔ Luôn bật Full Page Cache
- Redis / Varnish / CloudFront

### ✔ Dùng Redis cho cache & session
- Stateless → dễ auto scale

### ✔ Chạy Indexer ở mode Schedule
```bash
bin/magento indexer:set-mode schedule
```

### ✔ Warm-up cache sau deploy

## 5️⃣ Frontend & View Layer

### ✔ Không hardcode size image
- Dùng `view.xml`

### ✔ Không xử lý logic trong .phtml
- Dùng Block / ViewModel

### ✔ Không sửa core template
- Override qua theme

## 6️⃣ Cron, Queue & Background Jobs
- Chạy cron trên 1 node duy nhất
- Dùng Message Queue cho task nặng
- Tránh xử lý lâu trong request

## 7️⃣ Deployment & CI/CD

### ✔ Build ở CI, không build trên server
```bash
bin/magento setup:di:compile
bin/magento setup:static-content:deploy
```

### ✔ Zero downtime deploy
- Blue–Green / Rolling

### ✔ Config qua `app/etc/env.php`
- Không commit file này

## 8️⃣ Security
- ✔ Update security patch thường xuyên
- ✔ Escape output, validate input
- ✔ Hạn chế API & ACL đúng role
- ✔ Tắt error display trên production

## 9️⃣ Logging & Monitoring
- ✔ Dùng `Psr\Log\LoggerInterface`
- ✔ Rotate log định kỳ
- ✔ Monitor bằng New Relic / Prometheus

## 🔟 Những sai lầm thường gặp (Interview traps)
- ❌ Update on Save indexer cho production
- ❌ Session lưu filesystem
- ❌ Media lưu local
- ❌ Preference override core bừa bãi
- ❌ Chạy cron trên tất cả node