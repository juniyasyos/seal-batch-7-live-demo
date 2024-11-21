#!/bin/bash

# Hentikan skrip jika terjadi kesalahan
set -e

# 1. Inisialisasi Terraform
echo "==> Inisialisasi Terraform"
terraform init

# 2. Cek apakah terraform.tfstate sudah ada
TFSTATE_FILE="terraform.tfstate"
if [ -f "$TFSTATE_FILE" ]; then
  echo "==> File $TFSTATE_FILE ditemukan, melewati terraform apply."
else
  echo "==> File $TFSTATE_FILE tidak ditemukan, menjalankan terraform apply."
  terraform apply -auto-approve
fi

# 3. Cek dan Buat Virtual Environment Python
VENV_DIR=".venv"
if [ -d "$VENV_DIR" ]; then
  echo "==> Virtual environment sudah ada di $VENV_DIR, melewati pembuatan."
else
  echo "==> Membuat Python virtual environment di $VENV_DIR"
  python3 -m venv "$VENV_DIR"
fi

# 4. Aktivasi Virtual Environment
echo "==> Mengaktifkan Python virtual environment"
source "$VENV_DIR/bin/activate"

# 5. Instal Dependensi dari requirements.txt
if [ -f "requirements.txt" ]; then
  echo "==> Menginstal dependensi dari requirements.txt"
  pip install --upgrade pip
  pip install -r requirements.txt
else
  echo "WARNING: Tidak ditemukan file requirements.txt, melewati instalasi dependensi."
fi

# 6. Menjalankan Playbook Ansible
echo "==> Menjalankan playbook Ansible"

playbooks=(
  "./playbooks/docker/install-docker.yaml"
  "./playbooks/docker/set-docker-compose-monitoring.yaml"
  "./playbooks/docker/set-testing-grafana-k6.yaml"
)

for playbook in "${playbooks[@]}"; do
  echo "==> Menjalankan playbook: $playbook"
  ansible-playbook "$playbook"
done

# 7. Menyelesaikan Proses
echo "==> Proses deployment selesai."
