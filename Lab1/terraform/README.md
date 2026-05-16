# Lab 1: Deploying AWS Infrastructure with Terraform

Đây là mã nguồn Terraform cho bài thực hành **Lab 1**. Dự án này sẽ tự động triển khai một hệ thống mạng hoàn chỉnh trên nền tảng AWS.

## Kiến trúc Hệ Thống
Mã nguồn này sẽ tạo ra các tài nguyên sau trên AWS:
- **VPC** (Virtual Private Cloud) tùy chỉnh.
- **2 Public Subnets** & **2 Private Subnets** phân bổ trên 2 Availability Zones.
- **Internet Gateway (IGW)** cho phép các Public EC2 kết nối ra Internet.
- **NAT Gateway & Elastic IP** giúp các Private EC2 có thể tải gói từ Internet về nhưng không bị truy cập từ bên ngoài cục bộ vào.
- **Bảng Định Tuyến (Route Tables)** và các **Associations**.
- **Security Groups** bảo mật cấu hình tường lửa (Chỉ mở Port 22 - SSH).
- **EC2 Instances** (Amazon Linux 2023): Gồm 1 máy ở Public Subnet và 1 máy ở Private Subnet.
- **Key Pair**: Tự động sinh khóa Private Key bảo mật để truy cập SSH.

---

## Yêu cầu chuẩn bị (Prerequisites)
1. **Terraform CLI**: Đảm bảo máy tính đã cài đặt Terraform v1.0.0 trở lên. (Có thể kiểm tra bằng lệnh `terraform version`).
2. **AWS CLI v2**: Đã được cài đặt và cấu hình tài khoản AWS (chạy lệnh `aws configure` để thiết lập `Access Key` và `Secret Key`). Mặc định region là `ap-southeast-2` (hoặc cấu hình trong file `variables.tf`).

---

## Hướng dẫn chạy mã nguồn (Deployment Steps)

Mở cửa sổ dòng lệnh (Terminal/Command Prompt) và di chuyển vào thư mục gốc của dự án (`Lab1/terraform`), sau đó thực thi lần lượt các lệnh sau:

### Bước 1: Khởi tạo Project
Tải các thư viện nhà cung cấp (AWS Provider, Local, TLS) cần thiết:
```bash
terraform init
```

### Bước 2: Xem trước những thay đổi sẽ áp dụng
Kiểm tra lại cấu hình và lên kế hoạch những tài nguyên sẽ được tạo trên AWS:
```bash
MY_IP=$(curl -s https://checkip.amazonaws.com)/32
echo $MY_IP

terraform plan \
  -var="project_name=lab1" \
  -var="ssh_allowed_ip=$MY_IP"
```

### Bước 3: Áp dụng triển khai hạ tầng
Tạo toàn bộ tài nguyên:
```bash
terraform apply \
  -var="project_name=lab1" \
  -var="ssh_allowed_ip=$MY_IP"
```
*(Hệ thống sẽ hỏi bạn xác nhận tạo tài nguyên, nhập `yes` và nhấn Enter)*.

Sau khi hoàn tất, Terraform sẽ xuất ra terminal **địa chỉ Public IP**, **Private IP** của các máy ảo và các thông tin mạng khác. Đồng thời tự động tải private-key mang tên `lab1-key.pem` xuống ngay tại thư mục hiện tại.

---

## Hướng dẫn Kiểm tra hệ thống (Testing)

Vì tường lửa (Security Group) được thiết lập CHỈ CHO PHÉP SSH (Port 22), bạn không thể dùng lệnh `ping` trực tiếp máy ảo từ bên ngoài. Dưới đây là các test case kiểm tra:

### Lưu ý cho máy tính mội trường WINDOWS
Trước khi kết nối SSH, trên Windows bạn cần khóa chứng chỉ bảo mật `.pem` chỉ cấp cho mình Quyền Đọc, nếu không sẽ bị báo lỗi "UNPROTECTED PRIVATE KEY FILE":
```bash
# Gõ trên Command Prompt hoặc Powershell
icacls.exe lab1-key.pem /inheritance:r
icacls.exe lab1-key.pem /grant:r "%USERNAME%:(R)"
```

### Kiểm tra 1: Kết nối vào máy EC2 Public
```bash
ssh -i lab1-key.pem ec2-user@<public_ec2_public_ip>
```
*Vào trong thành công, bạn có thể gõ `ping 8.8.8.8 -c 4` để khẳng định Public Subnet có Internet.*

### Kiểm tra 2: Sử dụng Public EC2 làm máy chủ bàn đạp (Bastion) sang Private EC2
Mở một Command Prompt khác trên máy thật, tải key `.pem` lên tay Public EC2:
```bash
scp -i lab1-key.pem lab1-key.pem ec2-user@<public_ec2_public_ip>:/home/ec2-user/
```

### Kiểm tra 3: SSH vào Private EC2 và Test NAT Gateway
Từ Terminal đang đứng trên Public EC2 (sau khi đã SCP), phân quyền và SSH tiếp sang Private:
```bash
chmod 400 lab1-key.pem
ssh -i lab1-key.pem ec2-user@<private_ec2_private_ip>
```
Kế đến ping / kéo file từ google trên Private EC2 để verify NAT Gateway hoạt động chuẩn:
```bash
curl -I https://amazon.com
```

---

## Dọn dẹp hệ thống (Clean up)
**Tuyệt đối quan trọng:** Sau khi thực hành và kiểm tra mọi thứ thành công, hãy thực hiện lệnh xóa sạch tài nguyên để tránh phát sinh chi phí AWS ngoài ý muốn (Elastic IP và NAT Gateway tính phí theo giờ rất đắt).
```bash
terraform destroy \
  -var="project_name=lab1" \
  -var="ssh_allowed_ip=$MY_IP"
```
*(Gõ `yes` và Enter khi nhận được cảnh báo).*

## Test cases

Chạy test validate Terraform:

```bash
cd Lab1/tests
./terraform_validate.sh

cd ../terraform
VPC_ID=$(terraform output -raw vpc_id)
```

Chạy test kiểm tra tài nguyên AWS:
```bash
cd ../tests
./aws_check_resources.sh $VPC_ID
```

