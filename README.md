## 1. 프로젝트 개요

### AWS Guestbook Infrastructure

Terraform을 활용해 AWS 주요 관리형 서비스를 조합해보는 학습용 실습 프로젝트

> 이 프로젝트는 운영 수준의 완성된 서비스가 아니라, AWS의 주요 관리형/확장형 구성요소를 직접 연결해 보며 네트워크, 레이어 분리, 트래픽 라우팅, 데이터베이스 분리 구조를 학습하는 데 초점을 둔 Sandbox 프로젝트입니다.

### 1-1. 프로젝트 목표

1. CloudFront를 통한 `S3` 정적 웹페이지 접근, `ALB`를 통해 API 요청, 데이터를 `RDS`에 저장
2. `ALB`, `ASG`, Multi-AZ `RDS`를 활용한 멀티 AZ 구조 실습
3. Network, Database, Application 레이어 분리 실습

## 2. 아키텍처 다이어그램

[![bangmyeonglog-web-seobiseu-akitegcheo-drawio.png](https://i.postimg.cc/fbrJzv0H/bangmyeonglog-web-seobiseu-akitegcheo-drawio.png)](https://postimg.cc/zLTJpK7W)

## 3. 파일 트리 구조

```
.
├── app
│   ├── alb.tf # ALB
│   ├── cdn_s3.tf # CloudFront + S3
│   ├── data.tf
│   ├── index.html
│   ├── nat.tf # NAT 인스턴스
│   ├── network_rules.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── was.tf # WAS + ASG
├── database
│   ├── data.tf
│   ├── main.tf # RDS
│   ├── outputs.tf
│   ├── provider.tf
│   └── variables.tf
├── network
│   ├── main.tf # VPC, 서브넷, IGW 등
│   ├── outputs.tf
│   ├── provider.tf
└── README.md
```

## 4. 실습 내용

- Terraform 레이어 분리 (network / database / app)
- CloudFront + S3 기반 정적 콘텐츠 배포
- ALB 기반 API 트래픽 라우팅
- Auto Scaling Group 기반 인스턴스 자동 확장
- Multi-AZ RDS 구성
- NAT Instance를 활용한 Private Subnet 인터넷 접근

## 5. 실행 방법

> 본 프로젝트는 레이어별로 분리되어 있어 순차적인 실행이 필요함

```bash
# 실행 순서(network -> database -> app)

# 1. Network 레이어 (VPC, 서브넷, IGW, 라우팅 테이블 등...)
cd network && terraform init && terraform plan
terraform apply

# 2. Database 레이어 (RDS 보안 그룹, RDS 인스턴스)
cd ../database && terraform init && terraform plan
terraform apply

# 3. App 레이어 (CloudFront, S3, NAT Instance, ALB, ASG)
cd ../app && terraform init && terraform plan
terraform apply
```

## 6. 향후 개선 및 보완 사항

본 프로젝트는 학습용 Sandbox로서 다음과 같은 개선이 필요함

### 6-1. 보안 고도화

- **SSM Session Manager 도입**
  - 인바운드 규칙 중, 22번 포트(SSH)를 제거하고 `IAM` 기반의 보안 접속 환경 구축 필요
- **Secret Management**
  - 민감 정보 (RDS PW 등)를 코드에서 분리하여 `AWS Secret Manager` 연동 필요
- **Remote Backend**
  - 협업 및 상태 관리를 위해 `S3`와 `DynamoDB`를 활용한 원격 백엔드 구성 필요
- **HTTPS 전환 및 통신 암호화**
  - SSL/TLS를 발급받아 `ALB`에 적용 필요
- **AWS WAF 도입**
- **ALB 커스텀 헤더 기반 접근 제한**
  - (CloudFront를 거치지 않는) ALB DNS 접근 제한 필요

### 6-2. 아키텍처 최적화

- **NAT Gateway 전환**
  - 운영 안정성을 위해 NAT Instance를 AWS 관리형 `NAT Gateway`로 대체 필요
  - NAT Gateway 전환 시 비용 증가에 대한 검토 필요
- **IaC 모듈화**
  - 중복되는 리소스(VPC, Subnet 등)를 Terraform Module로 추상화하여 재사용성 향상 필요
