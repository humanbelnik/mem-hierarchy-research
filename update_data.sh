#!/bin/bash

########################################################################
# This script runs all your executables collecing output in './data/raw'
# Run script with '-h' to see launch options
########################################################################


# Colors ...
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"


print_usage()
{
    echo -n -e "\n\nUsage ${0} -c <INT> -s <INT> -t [default | transpose] -o [O0 | O3 | Os]\n If you want to specify the test to add data - specify all -t -s -o keys\n\n"
    exit 0
}

[ ! -d ./exe ] && echo -n -e "\n${RED}No executables found. Run ./build_apps.sh to resolve${NC}\n" && exit 1

COUNT=10

SIZE=""
TYPE=""
OPT=""

# Define scripts behavior ...
while getopts "c:s:t:o:h" flag; do
    case "${flag}" in
        h)
            print_usage
            ;;
        s)
            SIZE=${OPTARG}
            ;;
        t)
            TYPE=${OPTARG}
            ;;
        o)
            OPT=${OPTARG}
            ;;
        c)
            COUNT=${OPTARG}
            ;;
        *)
            print_usage
            ;;
        
    esac
done
shift $((OPTIND - 1))


#[ -n "$SIZE" ] && [ -n "$TYPE" ] && [ -n "$OPT" ] || print_usage
[ -z "$SIZE" ] && EXECS=$(find ./exe -name "*.exe")


if [ -n "$SIZE" ]; then
    if [ ! -f ./exe/mult_${TYPE}_${OPT}_${SIZE}.exe ]; then
        ./build_apps.sh -o "$OPT" -t "$TYPE" "$SIZE"
    fi
    EXECS=$(find ./exe -name "mult_${TYPE}_${OPT}_${SIZE}.exe")
fi 


# Create directories for storing data if didn't exist ...
[ ! -d "./data" ] && mkdir data
[ ! -d "./data/raw" ] && mkdir ./data/raw 


# Build collect data ...
echo -n -e "\n\n${YELLOW}Collecting raw data by running executables...${NC}\n\n" 

for INDEX in $(seq "$COUNT"); do
    for EXE in $EXECS; do
        exe_name=$(echo "$EXE" | cut -d. -f2 | cut -d/ -f3)
       # echo $exe_name
        echo -n -e "Now running: $exe_name | Iteration: $INDEX \r"
        ./exe/${exe_name}.exe >> ./data/raw/${exe_name}.txt
    done
done

echo -n -e "\n\n${GREEN}Raw data collected successfly!${NC}\n\n"