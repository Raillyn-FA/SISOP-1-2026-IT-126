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
isi `nemupusaka.sh`
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
