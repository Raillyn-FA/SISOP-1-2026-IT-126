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
