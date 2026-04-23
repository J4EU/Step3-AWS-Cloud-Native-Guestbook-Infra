# 네트워크 리소스 데이터 소스
data "terraform_remote_state" "network_link" {
  backend = "local" # 로컬 백엔드 사용

  # 네트워크 리소스 데이터 소스 경로
  config = {
    path = "../network/terraform.tfstate"
  }
}
