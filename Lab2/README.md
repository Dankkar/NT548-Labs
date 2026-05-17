# Thực hành Lab 2 - Quản lý và Triển khai Hạ tầng AWS

---

## I. YÊU CẦU 1: TỰ ĐỘNG HÓA TERRAFORM VỚI GITHUB ACTIONS

### 1. Cách cài đặt môi trường
Đảm bảo đã cài đặt `aws-cli` trên máy tính.
- **Tạo S3 Bucket và DynamoDB Table** (Dùng để lưu trữ trạng thái Terraform):
  - Tạo một S3 bucket có bật tính năng Versioning (VD: `nt548-terraform-state-bucket`).
  - Tạo một DynamoDB table tên là `nt548-terraform-locks` với Partition Key là `LockID` (String).
  - Cập nhật tên bucket vừa tạo vào file `Lab1/terraform/versions.tf`.
- **Cấu hình xác thực OIDC cho GitHub Actions:**
  - Trên giao diện AWS IAM, tạo một **Identity Provider** (OpenID Connect) cho GitHub: `https://token.actions.githubusercontent.com`.
  - Tạo một **IAM Role** cho GitHub Actions có quyền `AdministratorAccess`.
  - Copy ARN của Role vừa tạo.
  - Trên GitHub Repository, vào **Settings > Secrets and variables > Actions**, tạo một secret tên là `AWS_ROLE_ARN` và dán ARN vào.

### 2. Cách chạy mã nguồn
Mã nguồn đã được tích hợp luồng CI/CD trong thư mục `.github/workflows/terraform.yml`. Quy trình triển khai là hoàn toàn tự động.
- Chỉ cần thực hiện commit và push code lên nhánh `main` của GitHub:
  ```bash
  git add Lab1/terraform/
  git commit -m "Deploy Terraform Infrastructure"
  git push origin main
  ```

### 3. Cách kiểm tra kết quả triển khai
- Truy cập vào Github Repository, chuyển sang tab **Actions**, sẽ thấy luồng Workflow đang chạy gồm 3 bước: `Terraform Validate` -> `Checkov Scan` (Quét bảo mật mã nguồn) -> `Terraform` (Init, Plan, Apply).
- Nếu các bước hiển thị tick xanh (Success), hãy đăng nhập vào **AWS Management Console** (Region `us-east-1`):
  - Truy cập dịch vụ **VPC**, kiểm tra xem các VPC, Subnets, Route Tables, NAT Gateway đã được tạo hay chưa.
  - Truy cập dịch vụ **EC2**, kiểm tra các máy ảo Public và Private có ở trạng thái *Running* không.

---

## II. YÊU CẦU 2: TỰ ĐỘNG HÓA CLOUDFORMATION VỚI AWS CODEPIPELINE

### 1. Cách cài đặt môi trường
- **Khởi tạo CodeCommit:**
  - Vào AWS Console, dịch vụ **CodeCommit**, tạo một repository mới tên là `nt548-lab2-cloudformation`.
- **Đẩy mã nguồn lên CodeCommit:**
  - Thêm thư mục `Lab1/cloudformation` (chứa các file `template.yaml`, `buildspec.yml`, `.taskcat.yml`, `parameters.json`) và đẩy code lên nhánh `main` của CodeCommit.
- **Tạo Key Pair EC2:**
  - Truy cập dịch vụ EC2 ở `us-east-1`, tạo một Key Pair có tên **chính xác** là `lab1-key`.
- **Tạo Pipeline tự động:**
  - Vào dịch vụ **CodePipeline**, tạo một pipeline mới nối CodeCommit -> CodeBuild -> CloudFormation.
  - Khi cấu hình CodeBuild, nhớ tích chọn **Privileged mode** (để Docker chạy được bên dưới taskcat).
  - Ở bước CloudFormation Deploy, cung cấp một IAM Role có quyền `AdministratorAccess` (Ví dụ: `LabRole` hoặc `CloudFormation-Deploy-Role`) để nó có thể tạo VPC.

### 2. Cách chạy mã nguồn
Hệ thống CI/CD này sử dụng AWS Native tools.
- Khi có thay đổi trong file `template.yaml` (Ví dụ sửa đổi rules của Security Group), chỉ cần dùng lệnh Git push đoạn code đó lên AWS CodeCommit.
- CodePipeline sẽ bắt được sự kiện thay đổi này và tự động bắt đầu quy trình: Tải mã nguồn -> CodeBuild chạy test (cfn-lint, taskcat) -> Deploy lên CloudFormation.

### 3. Cách kiểm tra kết quả triển khai
- Để xem tiến độ tự động hóa, truy cập **CodePipeline** trên AWS Console. Giao diện sẽ hiển thị 3 box (Source, Build, Deploy) chuyển sang màu xanh lá khi thành công.
- Nếu Build thất bại, có thể bấm vào `Details` ở khối Build để xem log lỗi (chẳng hạn lỗi do thiếu Key Pair, hoặc lỗi cú pháp cfn-lint).
- Để kiểm tra tài nguyên thật sự được tạo: Truy cập dịch vụ **CloudFormation**, tìm Stack có tên `Lab2-Infra-Stack` đang ở trạng thái `CREATE_COMPLETE`. Chuyển sang tab **Resources** để xem chi tiết toàn bộ các ID của hạ tầng (EC2, VPC, InternetGateway...) vừa được dựng lên.
