#!/bin/bash

###################################################################
# This script builds all your '*.c' files from '/src' and
# places executables in '/exe'.
#
# It has it's default launch parameters set but you can use
# '-h' flag to see how you can build your executables more flexible
#
# Script doesn't check if your flag args are incorrect. 
# Unexisting arg will lead to the undefined behavior.
###################################################################


# Default launch parameters ... 
DATA_SIZES="100 150 200 250 300 350 400 450 500 550 600 650 700 850 900 950 1000"
GCC_FLAGS="-std=c99 -Wall -Werror -Wextra -Wvla"
DFLAG="SIZE"
OPTS="Os O0 O3"
TYPE=""


# Colors for colored output ...
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"


# Info ...
print_usage()
{
    echo -n -e "\n\nUsage: ${0} [-o Os | O0 | O3] [-t default | transpose] ...data_sizes\n\n"
    exit 0
}


# Define scripts behavior ...
while getopts "o:t:h" flag; do
    case "${flag}" in
        o)
            OPTS=${OPTARG}
            ;; 
        t)
            TYPE=${OPTARG}
            ;;
        h)
            print_usage
            ;;
        *)
            print_usage
    esac
done
shift $((OPTIND - 1))


# Create dir for executables if not found ...
[ ! -d "./exe" ] && mkdir exe

# Parse data sizes if any given ...
[ $# -ne 0 ] && DATA_SIZES="$*"

# Search for particular executable if specified
[ -n "$TYPE" ] && CPROGS=$(find ./src -maxdepth 1 -type f -name "mult_${TYPE}.c")
[ -z "$TYPE" ] && CPROGS=$(find ./src -maxdepth 1 -type f -name "*.c")


# Build ...
echo -n -e "\n\n${YELLOW}Building executables...${NC}\n\n"

for CPROG in $CPROGS; do
    NAME=$(echo "$CPROG" | cut -d. -f2 | cut -d/ -f3)
    for OPT in $OPTS; do
        for DATA_SIZE in $DATA_SIZES; do
            echo -n -e "Building: $NAME | $OPT | $DATA_SIZE \r"
            gcc ${GCC_FLAGS} ${CPROG} -D${DFLAG}=${DATA_SIZE} \
            -${OPT} -o ./exe/${NAME}_${OPT}_${DATA_SIZE}.exe 
        done
    done
done

echo -n -e "\n\n${GREEN}You're ready to go!${NC}\n\n"
