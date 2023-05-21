#!/bin/bash

GNU_DIR="./gnu"
PIC_DIR="./pic"

# Create directiry for graphs if didn't exist ... 
[ ! -d $PIC_DIR ] && mkdir ./pic

GNUS=$(find $GNU_DIR -type f -name "*.gpi")
for gnu in $GNUS; do
    gnuplot -p "$gnu"
done