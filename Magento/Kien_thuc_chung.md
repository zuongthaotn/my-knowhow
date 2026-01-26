# � Tổng hợp Kiến thức Magento 2

## �🔧 1. Kiến thức cốt lõi về Magento 2
- Cấu trúc thư mục của Magento.
- Luồng xử lý request → controller → layout → block → template.
- Khái niệm **Module**, **Theme**, **Plugin** (Interceptor), **Preference**, **Observer**, **Event**.
- **Dependency Injection** trong Magento.
- **EAV** vs **Flat Table** (vì Magento dùng EAV cho product, customer...).
- XML cấu hình: `routes.xml`, `di.xml`, `module.xml`, `events.xml`, `menu.xml`, `acl.xml`...

## 🛒 2. Quản lý sản phẩm và catalog
- Các loại sản phẩm: **simple**, **configurable**, **virtual**, **downloadable**...
- **Attribute Set** và cách tạo custom attribute.
- Cách tạo custom entity hoặc mở rộng entity sẵn có như **Product**, **Customer**.

## 💡 3. Customization
- Tạo một custom module từ đầu.
- Override / Extend một chức năng có sẵn (class, template, layout).
- Tạo/override REST API.
- Tạo cron job trong Magento.
- Tạo console command custom.

## 🧪 4. Database & Performance
- Cách Magento kết nối DB, sử dụng **ResourceModel**, **Collection**, **Repository**.
- **Indexer** là gì, cách hoạt động và cách reindex.
- Cache system (types of cache: config, layout, full_page...).
- **Varnish**, **Redis** integration nếu có kinh nghiệm.

## 🧩 5. GraphQL và REST API
- So sánh **REST** và **GraphQL** trong Magento.
- Cách tạo custom endpoint.
- Authentication token, customer token, admin token.

## 🖼 6. Frontend (nếu có liên quan)
- **KnockoutJS**, **RequireJS** trong UI Component.
- Layout XML và các loại handle.
- LESS, static content deploy.
- Theme fallback và cách tạo theme mới.

## 🧪 7. Testing
- Unit test với **PHPUnit**.
- Integration Test.
- Functional Test bằng **MFTF**.

## 🛠 8. Công cụ và quy trình phát triển
- **Magento CLI**: các lệnh phổ biến (`bin/magento setup:upgrade`, `deploy:mode:set`, `indexer:reindex`...).
- **Composer**: cài đặt module, autoloading.
- GIT workflow nếu làm team.
- **Docker** setup cho Magento (nếu bạn có dùng).

## 🧠 9. Câu hỏi tình huống/phỏng vấn kỹ năng
- Đã từng giải quyết lỗi production nghiêm trọng chưa? Là gì và bạn xử lý thế nào?
- Làm thế nào để tối ưu tốc độ Magento cho website có hàng chục nghìn sản phẩm?
- Bạn sẽ thiết kế module quản lý phiếu giảm giá như thế nào?