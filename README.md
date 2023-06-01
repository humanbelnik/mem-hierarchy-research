# Matrix multipliacation

> This repository contains a series of srcipts to implemet time measuring analisys of the algorithm which was written in C

## Task:
Measure time of matrices multiplication operation **with transposing** and **without it** corresponding to the size of the matrices. Use different compiler optimisation modes [O0, O3, Os]. Explain the results. 

## Scripts:
#### 1. build_apps.sh
* Script build executables from `src/`. 
* Run `./build_apps.sh -h` to see launch options.
#### 2. update_data.sh
* Scripts runs executables from `exe/` for several times and collects measured data in `data/raw/`.
* Run `./update_data.sh -h` to see launch options.
#### 3. make_preproc.py
* Script processes raw data and places needed characteristics in `data/proc`.
* Processed data for each experiment stays in it's own `.csv` file.
#### 4. make_postproc.sh
* Script uses `gnuplot` in order to visualise processed data

## Results:
* Despite of more operations, matrices multiplicatiopn with transposing is much faster. This result is a consequence of the computer memory architecture, especially memory hierarchy. CPU makes mush less requests to the deeper levels of memeory when we transpose the 2nd matrix.

[graph.pdf](https://github.com/humanbelnik/mem-hierarchy-research/files/11624078/graph.pdf)
