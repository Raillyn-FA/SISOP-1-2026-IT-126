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
