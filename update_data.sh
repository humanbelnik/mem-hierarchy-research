#!/bin/bash

########################################################################
# This script runs all your executables collecing output in './data/raw'
# Run script with '-h' to see launch options
########################################################################


# Colors ...
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"


print_usage()
{
    echo -n -e "\n\nUsage ${0} -c <INT> -s <INT> -t [default | transpose] -o [O0 | O3 | Os]\n\n"
    exit 0
}


# Define scripts behavior ...
while getopts "c:s:t:o:h" flag; do
    case "${flag}" in
        h)
            print_usage
            ;;
        *)
            print_usage
            ;;
        
    esac
done