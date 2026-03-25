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
