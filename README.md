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
b) Menghitung Jumlah Gerbong Kereta
c) Mencari Siapa Penumpang Tertua dan Berapa Umurnya.
d) Menghitung Rata-Rata Umur Penumpang.
e) Menghitung Jumlah Penumpang di Kelas *Business*

### a) Menghitung Total Jumlah Penumpang
Menggunakan *code* ini untuk menghitung setiap barisnya:
```awk
total++
```

Gunakan *code* ini untuk menampilkan outputnya:
```awk
if (mode=="a") {
    print "Jumlah seluruh penumpang KANJ adalah " total " orang"
}
```
