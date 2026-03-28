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
