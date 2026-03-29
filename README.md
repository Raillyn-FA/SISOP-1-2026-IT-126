# SISOP-1-2026-IT-126
Dikerjakan oleh: Rayhan Fadhilah Allayn (5027251126)

## Tree Modul1
<img width="623" height="578" alt="image" src="https://github.com/user-attachments/assets/5126fce5-4a3c-4580-a734-b80d5450946e" />

## Soal 1
Di soal ini, kita diberikan data-data penumpang kereta dalam bentuk file *csv* bernama passenger.csv yang perlu kita unduh terlebih dahulu melalui sebuah link.
Kita bisa menggunakan *command* ini:
`wget -O passenger.csv "(link file csv)"`

Dari file tersebut kita diminta untuk:
a) Menghitung Total Jumlah Penumpang.
b) Menghitung Jumlah Gerbong Kereta.
c) Mencari Siapa Penumpang Tertua dan Berapa Umurnya.
d) Menghitung Rata-Rata Umur Penumpang.
e) Menghitung Jumlah Penumpang di Kelas *Business*.

### Full Code
```awk
BEGIN {
    FS=","
    mode = ARGV[2]
    ARGV[2] = ""
}

NR==1 { next }

{
    total++

    for (i=1; i<=NF; i++) {
        gsub(/\r/, "", $i)
        gsub(/^[ \t]+|[ \t]+$/, "", $i)
    }

    tmp = $4
    if (tmp != "") {
        carriage[tmp] = 1
    }

    sum_age += $2

    if ($2 > max_age) {
        max_age = $2
        oldest = $1
    }

    if ($3 == "Business") {
        business++
    }
}

END {
    if (mode=="a") {
        print "Jumlah seluruh penumpang KANJ adalah " total " orang"
    }
    else if (mode=="b") {
        count = 0
        for (i in carriage) count++
        print "Jumlah gerbong penumpang KANJ adalah " count
    }
    else if (mode=="c") {
        print oldest " adalah penumpang kereta tertua dengan usia " max_age " tahun"
    }
    else if (mode=="d") {
        avg = int(sum_age / total)
        print "Rata-rata usia penumpang adalah " avg " tahun"
    }
    else if (mode=="e") {
        print "Jumlah penumpang business class ada " business " orang"
    }
    else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh: awk -f KANJ.sh passenger.csv a"
    }
}
```
Pastikan file KANJ.sh dan passenger.csv berada dalam satu folder.
Gunakan command `awk -f KANJ.sh passenger.csv a/b/c/d/e`.
### a) Menghitung Total Jumlah Penumpang
Menggunakan *code* ini untuk menghitung setiap barisnya:
```awk
total++
```
Menggunakan *code* ini untuk menampilkan outputnya:
```awk
if (mode=="a") {
    print "Jumlah seluruh penumpang KANJ adalah " total " orang"
}
```
### b) Menghitung Jumlah Gerbong Kereta
Menggunakan *code* ini untuk menyimpan gerbon unik.
```awk
tmp = $4
if (tmp != "") {
    carriage[tmp] = 1
}
```
Menggunakan *code* ini untuk menampilkan outputnya:
```awk
else if (mode=="b") {
    count = 0
    for (i in carriage) count++
    print "Jumlah gerbong penumpang KANJ adalah " count
}
```
### c) Mencari Siapa Penumpang Tertua dan Berapa Umurnya
Menggunakan *code* ini untuk mencari umur terbesar/tertua:
```awk
if ($2 > max_age) {
    max_age = $2
    oldest = $1
}
```
Menggunakan *code* ini untuk menampilkan outputnya:
```awk
else if (mode=="c") {
    print oldest " adalah penumpang kereta tertua dengan usia " max_age " tahun"
}
```
### d) Menghitung Rata-Rata Umur Penumpang
Menggunakan *code* ini untuk mencari rata-rata
```awk
sum_age += $2
```
Menggunakan *code* ini untuk menampilkan outputnya:
```awk
else if (mode=="d") {
    avg = int(sum_age / total)
    print "Rata-rata usia penumpang adalah " avg " tahun"
}
```
### e) Menghitung Jumlah Penumpang di Kelas *Business*
Menggunakan *code* ini untuk menghitung jumlah kelas bisnis.
```awk
if ($3 == "Business") {
    business++
}
```
Menggunakan *code* ini untuk menampilkan outputnya:
```awk
else if (mode=="e") {
    print "Jumlah penumpang business class ada " business " orang"
}
```
## Soal 2
Pada soal ini kita diperintahkan untuk mencari sebuah koordinat suatu pusakan peninggalan mendiang paman Mas Amba.

### Langkah 1
Kita buat terlebih dahulu struktur foldernya.
```Bash
mkdir -p soal_2/ekspedisi/peta-gunung-kawi
cd soal_2/ekspedisi
```
### Langkah 2
Lalu, kita unduh file `peta-ekspedisi-amba.pdf`
```Bash
wget --no-check-certificate https://drive.google.com/uc?id=1q10pHSC3KFfvEiCN3V6PTroPR7YGHF6Q -O peta-ekspedisi-amba.pdf
```
### Langkah 3
Kita ambil link tersembunyi dari isi file.
```Bash
strings peta-ekspedisi-amba.pdf | grep http
```
Maka akan mucul link `https://github.com/pocongcyber77/peta-gunung-kawi.git`
### Langkah 4
Kita ambil JSON dari link yang tadi.
```Bash
git clone https://github.com/pocongcyber77/peta-gunung-kawi.git
```
### Langkah 5
Kita buat parserkoordinat nya
```Bash
micro parserkoordinat.sh
chmod +x parserkoordinat.sh
./parserkoordinat.sh
```
isi `parserkoordinat.sh`
```Bash
#!/bin/bash

awk '
/"id":/ {
    gsub(/[",]/,"")
    id=$2
}

/"site_name":/ {
    gsub(/[",]/,"")
    name=$2
}

/"coordinates":/ {
    gsub(/[\[\],]/,"")
    lon=$2
    lat=$3
    print id","name","lat","lon
}
' gsxtrack.json > titik-penting.txt
```
### Langkah 6
Kita cek titik pentingnya menggunakan:
`cat titik-penting.txt`
output-nya:
```
node_001,Titik,-7.920000,112.450000
node_002,Basecamp,-7.920000,112.468100
node_003,Gerbang,-7.937960,112.468100
node_004,Tembok,-7.937960,112.450000
```
### Langkah 6
Kita cari titik tengahnya.
```Bash
micro nemupusaka.sh
chmod +x nemupusaka.sh
./nemupusaka.sh
```
Isi `nemupusaka.sh`
```Bash
#!/bin/bash

read first < titik-penting.txt
read last < <(tail -n 1 titik-penting.txt)

lat1=$(echo $first | awk -F, '{print $3}')
lon1=$(echo $first | awk -F, '{print $4}')

lat2=$(echo $last | awk -F, '{print $3}')
lon2=$(echo $last | awk -F, '{print $4}')

lat_mid=$(awk "BEGIN {print ($lat1 + $lat2)/2}")
lon_mid=$(awk "BEGIN {print ($lon1 + $lon2)/2}")

echo "Koordinat pusaka: ($lat_mid, $lon_mid)" > posisipusaka.txt

cat posisipusaka.txt
```
### Langkah 7
Koordinat ditemukan
```Bash
cat posisipusaka.txt
```
Output-nya:
`Koordinat pusaka: (-7.92898, 112.45)`

## Soal 3
Di soal ini kita membantu Mas Amba mengelola kos milik pamannya, Mas Amba bertekad menciptakan program manajemen kost berbasis CLI interaktif menggunakan Bash script dan bantuan command `awk`.

Sistem utama yang diinginkan:
1. Tambah Penghuni
2. Hapus Penghuni
3. Tampilkan Penghuni
4. Update Status
5. Laporan Keuangan
6. Kelola Cron
7. Exit

### Langkah 1
Kita buat folder dan filenya:
```Bash
mkdir -p soal_3/{data,log,rekap,sampah}
cd soal_3
touch kost_slebew.sh
```

### Langkah 2
Kita buat scriptnya:
```Bash
micro kost_slebew.sh
```

Keterangan script `kost_slebew.sh`:

#### 1. Untuk cek penghuni yang menunggak & cek penghuni yang menunggak.
```Bash
check_tagihan() {
    while IFS=, read -r nama kamar harga status; do
        if [[ "$status" == "Menunggak" ]]; then
            echo "[$(date '+%F %T')] TAGIHAN: $nama (Kamar $kamar) - Menunggak Rp$harga" >> "$LOG"
        fi
    done < "$DATA"
}

if [[ "$1" == "--check-tagihan" ]]; then
    check_tagihan
    exit
fi
```
#### 2. Untuk menghapus data penghuni.
```Bash
hapus() {
    clear
    echo "===== HAPUS PENGHUNI ====="

    read -p "Nama: " nama

    if ! grep -iq "^$nama," "$DATA"; then
        echo "Data tidak ditemukan!"
        read
        return
    fi
    
    tanggal=$(date +%F)

    awk -F, -v n="$nama" -v t="$tanggal" '
    BEGIN {OFS=","}
    {
        if (tolower($1)==tolower(n)) {
            print $0,t >> "'$HISTORY'"
        } else {
            print $0
        }
    }' "$DATA" > temp.csv

    mv temp.csv "$DATA"

    echo "[✓] Penghuni dihapus & diarsipkan!"
    read -p "Enter..."
}
```
#### 3. Untuk menampilkan penghuni yang ada.
```Bash
tampil() {
    clear

    if [ ! -s "$DATA" ]; then
        echo "Belum ada data penghuni."
        read -p "Enter..."
        return
    fi
    
    echo "=============================================="
    echo "   DAFTAR PENGHUNI KOST SLEBEW"
    echo "=============================================="

    printf "%-3s %-15s %-6s %-12s %-10s\n" "No" "Nama" "Kamar" "Harga" "Status"
    echo "----------------------------------------------"

    awk -F, '{
        printf "%-3d %-15s %-6s Rp%-10s %-10s\n", NR,$1,$2,$3,$4
        total++
        if ($4=="Aktif") aktif++
        else menunggak++
    }
    END {
        print "----------------------------------------------"
        printf "Total: %d | Aktif: %d | Menunggak: %d\n", total, aktif, menunggak
    }' "$DATA"

    echo "=============================================="
    read -p "Enter..."
}
```
#### 4. Untuk memperbarui penghuni kos sudah membayar atau masih menunggak
```Bash
update() {
    clear
    echo "===== UPDATE STATUS ====="

    read -p "Nama: " nama

    while true; do
        read -p "Status baru (Aktif/Menunggak): " status
        if [[ "$status" =~ ^(Aktif|Menunggak)$ ]]; then
            break
        else
            echo "Status harus Aktif/Menunggak!"
        fi
    done

    awk -F, -v n="$nama" -v s="$status" '
    BEGIN {OFS=","}
    {
        if (tolower($1)==tolower(n)) $4=s
        print
    }' "$DATA" > temp.csv

    mv temp.csv "$DATA"

    echo "[âœ“] Status diperbarui!"
    read -p "Enter..."
}
```
