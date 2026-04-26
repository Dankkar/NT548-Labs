# Lab 1 CloudFormation - Nested Stacks

Thư mục này chứa cấu trúc CloudFormation dạng **Nested Stacks**, được chia nhỏ thành các module tương tự như cách tiếp cận của Terraform.

## Cấu trúc thư mục

- `main.yaml`: Root stack điều phối việc triển khai các module.
- `modules/`: Chứa các sub-templates:
    - `vpc.yaml`: VPC và Subnets.
    - `keypair.yaml`: Quản lý EC2 KeyPair.
    - `nat_gateway.yaml`: NAT Gateway và Elastic IP.
    - `route_tables.yaml`: Bảng định tuyến và các liên kết.
    - `security_groups.yaml`: Các nhóm bảo mật cho Public và Private instances.
    - `ec2_instances.yaml`: Triển khai các máy chủ EC2.

## Hướng dẫn triển khai

Do sử dụng Nested Stacks, bạn cần tải các template lên S3 trước khi triển khai. Bạn có thể sử dụng lệnh `aws cloudformation package`.

### Bước 1: Tạo S3 Bucket (nếu chưa có)

Nếu bạn chưa có bucket nào, hãy tạo một cái:

```powershell
# Thay 'my-cf-templates-unique-id' bằng tên bucket duy nhất của bạn
aws s3 mb s3://my-cf-templates-unique-id
```

### Bước 2: Đóng gói template (Package)

Lệnh này sẽ tải các file trong `modules/` lên S3 và tạo một file `packaged.yaml` mới với các đường dẫn S3 đã được cập nhật:

```powershell
aws cloudformation package `
  --template-file main.yaml `
  --s3-bucket my-cf-templates-unique-id `
  --output-template-file packaged.yaml
```

### Bước 3: Triển khai stack

```powershell
aws cloudformation deploy `
  --template-file packaged.yaml `
  --stack-name lab1-nested-stack `
  --parameter-overrides file://parameters.json `
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND
```

## Lưu ý về IAM Capabilities

Khi triển khai các stack lồng nhau hoặc có tài nguyên IAM, bạn cần thêm:
- `--capabilities CAPABILITY_IAM`: Do template có tạo IAM roles/policies (nếu có).
- `--capabilities CAPABILITY_AUTO_EXPAND`: Cần thiết khi sử dụng nested stacks để CloudFormation có thể mở rộng các stack con.

---

## Hướng dẫn Kiểm tra hệ thống (Testing)

Vì Security Group được thiết lập chỉ cho phép SSH (Port 22), bạn có thể thực hiện các bước sau để kiểm tra hạ tầng tương tự như với Terraform:

### Bước 1: Lấy thông tin Public/Private IP
Sau khi stack ở trạng thái `CREATE_COMPLETE`, hãy lấy địa chỉ IP để test:
```powershell
aws cloudformation describe-stacks `
  --stack-name lab1-nested-stack `
  --query "Stacks[0].Outputs" `
  --output table
```

### Bước 2: Kết nối vào máy EC2 Public
Sử dụng file key pair (mặc định là `lab1-key.pem`) để truy cập:

**Lưu ý cho Windows (Khắc phục lỗi quyền hạn file .pem):**
```powershell
icacls.exe lab1-key.pem /inheritance:r
icacls.exe lab1-key.pem /grant:r "%USERNAME%:(R)"
```

**Thực hiện SSH:**
```bash
ssh -i lab1-key.pem ec2-user@<PublicInstanceIP>
```
*Thử lệnh `ping 8.8.8.8 -c 4` để xác nhận máy Public có Internet.*

### Bước 3: Kiểm tra NAT Gateway từ Private EC2
1. **Copy key sang máy Public (Bastion Host):**
   ```bash
   scp -i lab1-key.pem lab1-key.pem ec2-user@<PublicInstanceIP>:/home/ec2-user/
   ```

2. **SSH sang máy Private:**
   Từ terminal đang đứng ở máy Public:
   ```bash
   chmod 400 lab1-key.pem
   ssh -i lab1-key.pem ec2-user@<PrivateInstanceIP>
   ```

3. **Kiểm tra Internet tại máy Private:**
   ```bash
   curl -I https://amazon.com
   ```
   *Nếu nhận được HTTP 200, nghĩa là NAT Gateway đang hoạt động tốt.*

---

## Dọn dẹp hệ thống (Clean up)

**Tuyệt đối quan trọng:** Để tránh phát sinh chi phí không đáng có (đặc biệt là NAT Gateway, Elastic IP và lưu trữ S3), hãy thực hiện xóa sạch tài nguyên theo thứ tự sau:

### 1. Xóa CloudFormation Stack
Lệnh này sẽ gỡ bỏ VPC, EC2, NAT Gateway và các tài nguyên mạng khác:
```powershell
aws cloudformation delete-stack --stack-name lab1-nested-stack
```
*(Bạn có thể kiểm tra trạng thái xóa trên Console hoặc qua lệnh `aws cloudformation describe-stacks`).*

### 2. Xóa S3 Bucket
Sau khi Stack đã xóa xong, bạn hãy xóa luôn Bucket chứa template (Lưu ý: Lệnh này sẽ xóa toàn bộ nội dung trong bucket):
```powershell
# Thay 'my-cf-templates-unique-id' bằng tên bucket bạn đã tạo ở Bước 1
aws s3 rb s3://my-cf-templates-unique-id --force
```
