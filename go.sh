#!/bin/bash

./build_apps.sh
./update_data.sh
python3 make_preproc.py
./make_postproc.sh