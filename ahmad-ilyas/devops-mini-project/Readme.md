# **Artefak Miniproject DevOps**

Dokumen ini menjelaskan langkah-langkah untuk menyiapkan infrastruktur website **Gemini Clone**, yang sudah terintegrasi dengan konfigurasi monitoring menggunakan **Prometheus** dan **Grafana** serta pengujian performa menggunakan **Grafana K6**. Selain itu, dalam prosesnya, kami memanfaatkan beberapa alat DevOps untuk mengotomatiskan dan memaksimalkan pekerjaan kami, seperti **Terraform**, **Ansible**, **Docker Engine**, **GitHub Actions**, dan **GitHub**. 

Artefak yang akan disediakan mencakup:
- **Docker image** untuk Python FastAPI
- **Docker image** untuk frontend

Ikuti langkah-langkah berikut untuk melakukan instalasi dan pengaturan sistem.

---

## **1. Persiapan Awal**

### **Prasyarat**
Sebelum memulai, pastikan bahwa beberapa alat berikut sudah terinstal dan dikonfigurasi di mesin lokal Anda:
1. **Terraform**: Pastikan **Terraform** telah terinstal di sistem Anda.
2. **Kredensial AWS**: Anda memerlukan kredensial AWS yang valid yang terletak di:
   ```
   /root/.aws/credentials
   ```
3. **Repositori GitHub**: Clone repositori berikut untuk mendapatkan kode dan konfigurasi:
   ```bash
   git clone https://github.com/juniyasyos/seal-batch-7-live-demo.git
   ```
4. **Pindah ke Direktori Kerja**: Masuk ke direktori proyek:
   ```bash
   cd seal-batch-7-live-demo/ahmad-ilyas/devops-mini-project
   ```

---

## **2. Langkah Penggunaan**

### **a. Jalankan Perintah Deploy**
Untuk memulai, Anda hanya perlu menjalankan satu perintah untuk mengotomatiskan pembuatan infrastruktur server dan instalasi aplikasi. Jalankan perintah berikut di direktori kerja Anda:
```bash
chmod +x ./deploy
./deploy
```

Perintah ini akan mengonfigurasi seluruh infrastruktur dan menginstal aplikasi yang diperlukan.

---

## **3. Setup Prometheus dan Grafana**

### **a. Akses Prometheus**
1. Buka browser Anda dan akses **Prometheus** dengan URL berikut:
   ```
   http://<public-ip-tag-monitoring-testing-k6>:9099
   ```
   - Gantilah `<public-ip-tag-monitoring-testing-k6>` dengan IP publik yang diberikan saat proses deploy selesai. IP ini akan muncul di output `./deploy`, dengan tag **`tag_frontend_server`**.

2. Verifikasi status target di **Prometheus** dengan memeriksa halaman dashboard:
   ![Prometheus](docs/prometheus.png)

---

### **b. Login ke Grafana**
1. Buka browser dan akses **Grafana** dengan URL berikut:
   ```
   http://<public-ip-instance-tag-learning-monitoring>:3030
   ```
   - Gantilah `<public-ip-instance-tag-learning-monitoring>` dengan IP publik yang sesuai.

2. Login ke Grafana menggunakan kredensial berikut:
   - **Username**: `admin`
   - **Password**: `my-password-grafana`

---

### **c. Setup Dashboard Grafana**
1. Setelah login ke Grafana, buka menu **"Create" > "Import"**.
2. Import file dashboard JSON dari repositori berikut:
   ```
   https://github.com/nginxinc/nginx-prometheus-exporter/blob/main/grafana/dashboard.json
   ```
3. Pilih **Prometheus** sebagai data source (tambahkan data source manual jika belum ada), lalu klik **Import**.
   
   ![Grafana Dashboard](docs/setup-datasource-prometheus.png)

4. Setelah berhasil, verifikasi tampilan dashboard di Grafana:
   
   ![Grafana Dashboard](docs/grafana-dashboard.png)

---

## **4. Melakukan Pengujian dengan Grafana K6**

### **a. Persiapan Instance untuk Testing**
1. Untuk melakukan pengujian performa, jalankan perintah berikut menggunakan **Ansible** untuk menyiapkan pengujian beban:
   ```bash
   ansible-playbook ./playbooks/santuy-docker/main.yaml --tags load_test 
   ```

2. Setelah pengujian selesai, Anda dapat melihat hasilnya di file berikut:
   ```bash
   ./playbooks/santuy-docker/load_test_result.txt
   ```

---

### **b. Membuat Script Custom untuk Pengujian K6**
Jika Anda ingin melakukan pengujian dengan skrip kustom, buat file `load.js` di direktori `/opt/k6_repo/test/` dengan konten berikut:

```javascript
import http from "k6/http";
import { check, sleep } from "k6";

// Test configuration
export const options = {
    thresholds: {
        // Assert that 99% of requests finish within 3000ms
        http_req_duration: ["p(99) < 3000"],
    },
    stages: [
        { duration: "30s", target: 15 },
        { duration: "1m", target: 15 },
        { duration: "20s", target: 0 },
    ],
};

// Simulated user behavior
export default function () {
    let res = http.get("http://<ip-nginx-target>/stub_status");
    check(res, { "status was 200": (r) => r.status == 200 });
    sleep(1);
}
```

- Gantilah **`<ip-nginx-target>`** dengan IP instance yang menjalankan Nginx dan Prometheus.

---

### **c. Menjalankan Pengujian dengan Docker dan Grafana K6**
Untuk menjalankan pengujian dengan Docker, gunakan perintah berikut:
```bash
docker run -v /opt/k6_repo:/opt/k6_repo grafana/k6 run --out influxdb=http://<ip-vm-testing>:8086 /opt/k6_repo/test/load.js
```

- Gantilah **`<ip-vm-testing>`** dengan IP instance yang menjalankan **InfluxDB**.

Hasil pengujian akan menunjukkan proses berikut:
![Proses Testing K6](docs/proses-testing-k6.png)

Setelah pengujian selesai, Anda akan melihat hasilnya di grafik seperti berikut:
![Hasil Testing](docs/final-testing-result.png)

---

### **d. Hasil Pengujian**
Berikut adalah interpretasi dari output pengujian K6:

- **Tes berhasil**: Semua permintaan HTTP berhasil dengan status 200.
- **Kecepatan**: Rata-rata waktu respons server adalah 1.2ms.
- **Data**: 329 kB data diterima dan 115 kB data dikirim.
- **Kecepatan permintaan**: 11.7 permintaan per detik.
- **Virtual Users (VUs)**: Tes dilakukan dengan 1 hingga 15 pengguna virtual, dengan total 1290 permintaan.

Tes menunjukkan performa yang sangat baik dengan hasil yang stabil.

---

## **5. Catatan Penting**
- **Jaringan Internal atau Public**:  
  Jika menggunakan IP pribadi, pastikan kedua instance berada dalam satu VPC atau jaringan lokal. Jika menggunakan IP publik, pastikan pengaturan security group dan firewall mengizinkan koneksi.

- **Validasi Skrip**:  
  Untuk memverifikasi apakah endpoint Nginx berfungsi dengan benar, jalankan perintah berikut:
  ```bash
  curl http://<ip-nginx-target>/stub_status
  ```

---

Dengan mengikuti langkah-langkah ini, Anda dapat mengatur sistem monitoring menggunakan **Prometheus**, **Grafana**, dan melakukan pengujian beban menggunakan **K6**. 🎉