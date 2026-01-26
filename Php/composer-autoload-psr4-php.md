
Auto load in composer(PRS-4 trong PHP)

1) Tạo một thư mục dự án có tên prs4example
2) Tạo cấu trúc thư mục và file lưu giữ code lớp Cat như sau:
prs4example/src/dongvat/Cat.php
prs4example/vendor/....

3. file co noi dung prs4example/src/dongvat/Cat.php
```
<?php
namespace App\dongvat;


class Cat
{
    public function sound() {
        echo "MEO MEO";
    }
}
```
4.Giờ dùng Compose đệ tạo bộ Autoload. Tạo file composer.json với nội dung:
```
{
 "autoload": 
 {
        "psr-4": { "App\\": "src/" }
 }
}
```

5. Rồi từ dòng lệnh cmd gõ composer dump-autoload. Lúc này nó sẽ sinh ra autoload.php trong thư mục vendor.


