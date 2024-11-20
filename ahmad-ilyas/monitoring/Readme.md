# **Setup Monitoring Prometheus dan Grafana dengan Terraform dan Ansible**

Dokumen ini menjelaskan langkah-langkah untuk menyiapkan infrastruktur menggunakan **Terraform**, mengelola konfigurasi dengan **Ansible**, serta mengatur **Prometheus** dan **Grafana** secara manual.

## **1. Persiapan Awal**
### Prasyarat:
1. **Terraform** dan **Ansible** sudah terinstal di mesin lokal Anda.
2. Akses ke AWS dengan kredensial yang valid.
3. Lingkungan Python virtual environment, aktifkan dengan:
   ```bash
   source venv/bin/activate
   ```

## **2. Langkah Menggunakan Terraform**
### a. Inisialisasi Terraform
Inisialisasi direktori kerja Terraform (`/root/{clone-folder}/ahmad-ilyas/monitoring`):
```bash
terraform init
```

### b. Membuat dan Memeriksa Infrastruktur
1. Lihat rencana penerapan:
   ```bash
   terraform plan
   ```
2. Terapkan infrastruktur ke AWS:
   ```bash
   terraform apply
   ```
3. Catat output, terutama **IP publik instance** yang akan digunakan nanti.

### c. Menghapus Infrastruktur (Opsional)
Jika Anda ingin menghapus semua sumber daya yang dibuat:
```bash
terraform destroy
```

---

## **3. Langkah Menggunakan Ansible**
### a. Menjalankan Playbook
1. Pastikan Anda telah mengaktifkan Python virtual environment:
   ```bash
   source venv/bin/activate
   ```
2. Jalankan playbook untuk menginstal Docker dan Docker Compose, serta mengatur monitoring:
   ```bash
   ansible-playbook ./playbooks/docker/install-docker.yaml
   ansible-playbook ./playbooks/docker/set-docker-compose-monitoring.yaml
   ```

---

## **4. Setup Prometheus dan Grafana**
### a. Akses Prometheus
1. Buka browser Anda dan akses:
   ```
   http://<public-ip-instance>:9099
   ```
2. Verifikasi bahwa Prometheus berjalan dengan benar.

### b. Login ke Grafana
1. Buka browser Anda dan akses:
   ```
   http://<public-ip-instance>:3000
   ```
2. Login dengan:
   - **Username:** `admin`
   - **Password:** `admin`
3. Setelah login, buat password baru.

### c. Setup Dashboard Grafana
1. Masuk ke **"Create" > "Import"** di Grafana.
2. Masukkan ID dashboard berikut: **12486**.
3. Ikuti langkah-langkah untuk menyelesaikan proses import.

### d. Cek Alerts di Grafana
1. Buka tab **"Alerts"** di Grafana.
2. Pastikan semua alert untuk monitoring aktif dan berjalan dengan benar.


## **5. Troubleshooting**
- **Terraform gagal di apply**: Pastikan kredensial AWS Anda benar dan resource tidak berbenturan.
- **Ansible gagal dijalankan**: Periksa konfigurasi inventori dan koneksi SSH.
- **Grafana atau Prometheus tidak dapat diakses**: Periksa **Security Group** pada instance Anda dan pastikan port 3000 (Grafana) dan 9090 (Prometheus) terbuka untuk akses.