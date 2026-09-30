# Hướng dẫn thêm SSH Key vào Server Ubuntu

Hướng dẫn này giúp bạn tạo SSH Key trên máy cá nhân (Client) và cấu hình xác thực bằng Key trên máy chủ Ubuntu (Server) thay cho việc sử dụng mật khẩu truyền thống, giúp đăng nhập nhanh chóng và bảo mật hơn.

---

## 1. Tạo cặp SSH Key trên máy cá nhân (Client)

> **Lưu ý:** Chạy các lệnh này trên máy tính của bạn (Windows Terminal/PowerShell, macOS Terminal hoặc Linux), **không phải** trên server.

Khuyến nghị sử dụng thuật toán **Ed25519** (nhanh và an toàn hơn RSA) hoặc **RSA 4096-bit**.

### Lựa chọn 1: Dùng Ed25519 (Khuyến nghị)
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### Lựa chọn 2: Dùng RSA 4096-bit (Phù hợp hệ thống cũ)
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Quá trình tạo:
1. `Enter file in which to save the key`: Nhấn **Enter** để lưu ở đường dẫn mặc định (`~/.ssh/id_ed25519` hoặc `~/.ssh/id_rsa`).
2. `Enter passphrase (empty for no passphrase)`: Nhập mật khẩu bảo vệ key (hoặc nhấn **Enter** 2 lần nếu muốn bỏ qua passphrase để đăng nhập không cần gõ mật khẩu).

Sau khi hoàn tất, bạn sẽ có 2 file trong thư mục `~/.ssh/`:
- `id_ed25519` (hoặc `id_rsa`): **Private Key** - Giữ tuyệt mật trên máy cá nhân, tuyệt đối không gửi cho ai.
- `id_ed25519.pub` (hoặc `id_rsa.pub`): **Public Key** - Dùng để đưa lên server Ubuntu.

---

## 2. Thêm Public Key vào Ubuntu Server

Chọn một trong 3 cách dưới đây để đưa Public Key lên server.

### Cách 1: Sử dụng lệnh `ssh-copy-id` (Nhanh nhất & Tự động)

Hầu hết Linux và macOS (hoặc Git Bash trên Windows) đều có sẵn `ssh-copy-id`:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub username@server_ip
```

*Nếu server sử dụng cổng SSH khác mặc định (ví dụ port 2222):*
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub -p 2222 username@server_ip
```
Hệ thống sẽ hỏi mật khẩu server của `username` một lần duy nhất để copy key vào file `~/.ssh/authorized_keys`.

---

### Cách 2: Dùng lệnh SSH truyền qua Pipe (Dành cho máy không có `ssh-copy-id`)

Chạy lệnh sau trên terminal máy cá nhân:

```bash
cat ~/.ssh/id_ed25519.pub | ssh username@server_ip "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

*Nếu server dùng port khác (ví dụ port 2222):*
```bash
cat ~/.ssh/id_ed25519.pub | ssh -p 2222 username@server_ip "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

---

### Cách 3: Thao tác thủ công trực tiếp trên Server

1. **Xem nội dung Public Key trên máy cá nhân:**
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
   Sao chép toàn bộ chuỗi ký tự hiển thị ra (bắt đầu bằng `ssh-ed25519 AAAAC3...` hoặc `ssh-rsa AAAAB3...`).

2. **Đăng nhập vào server Ubuntu:**
   ```bash
   ssh username@server_ip
   ```

3. **Cấu hình thư mục `.ssh` và file `authorized_keys`:**
   ```bash
   # Tạo thư mục .ssh nếu chưa có
   mkdir -p ~/.ssh

   # Phân quyền cho thư mục .ssh
   chmod 700 ~/.ssh

   # Mở file authorized_keys và dán key vào cuối file
   nano ~/.ssh/authorized_keys
   ```
   *Dán public key vào file, nhấn `Ctrl + O` -> `Enter` để lưu, `Ctrl + X` để thoát.*

4. **Phân quyền chuẩn cho file `authorized_keys`:**
   ```bash
   chmod 600 ~/.ssh/authorized_keys
   ```

---

## 3. Kiểm tra đăng nhập bằng SSH Key

Từ máy cá nhân, kiểm tra xem đã kết nối được mà không cần mật khẩu user hay chưa:

```bash
ssh username@server_ip
# Hoặc chỉ định rõ file private key:
ssh -i ~/.ssh/id_ed25519 username@server_ip
```

### Mẹo: Cấu hình `~/.ssh/config` trên máy cá nhân để đăng nhập nhanh

Mở file `~/.ssh/config` trên máy cá nhân:
```bash
nano ~/.ssh/config
```

Thêm nội dung:
```text
Host my-ubuntu
    HostName 192.168.1.100       # Thay bằng IP server hoặc domain
    User ubuntu                  # Thay bằng username trên server
    Port 22                      # Cổng SSH
    IdentityFile ~/.ssh/id_ed25519
```

Lần sau bạn chỉ cần gõ:
```bash
ssh my-ubuntu
```

---

## 4. Tăng cường bảo mật (Khuyến nghị)

Sau khi đã chắc chắn đăng nhập thành công bằng SSH Key, bạn nên tắt đăng nhập bằng mật khẩu (Password Authentication) để chống tấn công brute-force.

> ⚠️ **CẢNH BÁO QUAN TRỌNG:** Hãy giữ một session SSH đang kết nối, mở một tab terminal mới để test đăng nhập lại trước khi đóng session cũ để tránh bị khóa ngoài server.

1. **Mở file cấu hình SSH Daemon trên server:**
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```
   *(Trên Ubuntu 22.04+ có thể kiểm tra thêm thư mục `/etc/ssh/sshd_config.d/`)*

2. **Tìm và sửa/bật các cấu hình sau:**
   ```text
   PubkeyAuthentication yes
   PasswordAuthentication no
   PermitEmptyPasswords no
   KbdInteractiveAuthentication no
   ```

3. **Kiểm tra cú pháp cấu hình có lỗi không:**
   ```bash
   sudo sshd -t
   ```
   *(Nếu không trả về lỗi gì là cấu hình hợp lệ)*

4. **Khởi động lại SSH service:**
   ```bash
   sudo systemctl restart ssh
   # hoặc:
   sudo systemctl restart sshd
   ```

---

## 5. Xử lý các lỗi thường gặp (Troubleshooting)

### 1. Lỗi `Permission denied (publickey)`
- **Nguyên nhân phổ biến nhất:** Phân quyền trên server không chính xác. OpenSSH sẽ từ chối đọc file nếu quyền quá mở.
- **Khắc phục:** Chạy các lệnh sau trên server:
  ```bash
  chmod 755 ~                    # Quyền thư mục home không được là 777
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/authorized_keys
  chown -R $USER:$USER ~/.ssh
  ```

### 2. File `authorized_keys` bị dính dòng hoặc ngắt dòng sai
- Đảm bảo mỗi public key nằm trên đúng **1 dòng duy nhất**. Nếu khi copy/paste bị gãy dòng, SSH sẽ không nhận diện được key.

### 3. Server Ubuntu 22.04+ không nhận SSH RSA cũ
- OpenSSH 8.8+ mặc định vô hiệu hóa thuật toán `ssh-rsa` cũ (SHA-1).
- **Khắc phục:** Hãy tạo và dùng key `ed25519` theo Bước 1.
