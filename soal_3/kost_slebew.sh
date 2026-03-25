#!/bin/bash

DATA="data/penghuni.csv"
LOG="log/tagihan.log"
REKAP="rekap/laporan_bulanan.txt"
HISTORY="sampah/history_hapus.csv"

BASE_DIR=$(cd "$(dirname "$0")" && pwd)

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

tambah() {
    clear
    echo "===== TAMBAH PENGHUNI ====="

    read -p "Nama: " nama

    while true; do
        read -p "Kamar: " kamar
        if grep -q ",$kamar," "$DATA"; then
            echo "Kamar sudah terisi!"
        else
            break
        fi
    done

    while true; do
        read -p "Harga: " harga
        if [[ "$harga" =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Harga harus angka!"
        fi
    done

    while true; do
        read -p "Tanggal (YYYY-MM-DD): " tanggal
        if date -d "$tanggal" >/dev/null 2>&1; then
            if [[ "$tanggal" > "$(date +%F)" ]]; then
                echo "Tanggal tidak boleh masa depan!"
            else
                break
            fi
        else
            echo "Format tanggal salah!"
        fi
    done

    while true; do
        read -p "Status (Aktif/Menunggak): " status
        if [[ "$status" =~ ^(Aktif|Menunggak)$ ]]; then
            break
        else
            echo "Status harus Aktif/Menunggak!"
        fi
    done

    echo "$nama,$kamar,$harga,$status" >> "$DATA"

    echo "[✓] Penghuni berhasil ditambahkan!"
    read -p "Enter..."
}

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

    echo "[✓] Status diperbarui!"
    read -p "Enter..."
}

laporan() {
    clear
    echo "===== LAPORAN KEUANGAN ====="

    awk -F, '
    {
        if ($4=="Aktif") aktif+=$3
        else tunggak+=$3
    }
    END {
        print "Total pemasukan (Aktif): Rp" aktif
        print "Total tunggakan        : Rp" tunggak
        print "Jumlah kamar terisi    : " NR
        print "\nDaftar menunggak:"
    }' "$DATA" > "$REKAP"

    awk -F, '$4=="Menunggak" {print "-",$1}' "$DATA" >> "$REKAP"

    cat "$REKAP"

    echo "[✓] Laporan disimpan!"
    read -p "Enter..."
}

cron_menu() {
    while true; do
        clear
        echo "======================================"
        echo "        MENU KELOLA CRON"
        echo "======================================"
        echo "1. Lihat Cron Job Aktif"
        echo "2. Daftarkan Cron Job Pengingat"
        echo "3. Hapus Cron Job Pengingat"
        echo "4. Kembali"
        echo "======================================"

        read -p "Pilih [1-4]: " pilihan

        case $pilihan in
            1)
                echo ""
                echo "--- Daftar Cron Job Pengingat Tagihan ---"
                crontab -l 2>/dev/null | grep kost_slebew.sh || echo "Tidak ada cron aktif."
                echo ""
                read -p "Tekan ENTER untuk kembali..."
                ;;

            2)
                read -p "Masukkan Jam (0-23): " jam
                read -p "Masukkan Menit (0-59): " menit

                if [[ ! "$jam" =~ ^[0-9]+$ || ! "$menit" =~ ^[0-9]+$ ]]; then
                    echo "Input harus angka!"
                    read
                    continue
                fi

                crontab -l 2>/dev/null | grep -v kost_slebew.sh > temp_cron

                echo "$menit $jam * * * $BASE_DIR/kost_slebew.sh --check-tagihan" >> temp_cron

                crontab temp_cron
                rm temp_cron

                echo ""
                echo "[✓] Cron job berhasil ditambahkan!"
                read -p "Tekan ENTER..."
                ;;

            3)
                crontab -l 2>/dev/null | grep -v kost_slebew.sh > temp_cron
                crontab temp_cron
                rm temp_cron

                echo ""
                echo "[✓] Cron job pengingat tagihan berhasil dihapus."
                read -p "Tekan ENTER..."
                ;;

            4)
                break
                ;;

            *)
                echo "Pilihan tidak valid!"
                sleep 1
                ;;
        esac
    done
}

while true; do
    clear
    echo "====================================="
    echo "  SISTEM KELOLA KOST SLEBEW AMBATUKAM	 "
    echo "====================================="
    echo "1. Tambah Penghuni"
    echo "2. Hapus Penghuni"
    echo "3. Tampilkan Penghuni"
    echo "4. Update Status"
    echo "5. Laporan Keuangan"
    echo "6. Kelola Cron"
    echo "7. Exit"
    echo "====================================="

    read -p "Pilih [1-7]: " pilih

    case $pilih in
        1) tambah ;;
        2) hapus ;;
        3) tampil ;;
        4) update ;;
        5) laporan ;;
        6) cron_menu ;;
        7) exit ;;
        *) echo "Pilihan salah!"; sleep 1 ;;
    esac
done
