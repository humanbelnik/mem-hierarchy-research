import os
import sys
import shutil
import csv
import statistics
import math


# Paths ...
PATH_TO_DATA = "./data/"
PATH_TO_PROC = PATH_TO_DATA + "proc/"
PATH_TO_RAW = PATH_TO_DATA + "raw/"


# Aliases ...
md_O0_substring = "mult_default_O0"
md_O3_substring = "mult_default_O3"
md_Os_substring = "mult_default_Os"

mt_O0_substring = "mult_transpose_O0"
mt_O3_substring = "mult_transpose_O3"
mt_Os_substring = "mult_transpose_Os"


# Write data to csv ...
def write_csv(csv_file, data) -> None:
    with open(PATH_TO_PROC + csv_file, "w") as f:
        writer = csv.writer(f, delimiter= "|")
        for row in data:
            writer.writerow(row)


if __name__ == "__main__":

    # Prepare directory for processed data ...
    if not os.path.exists(PATH_TO_DATA):
        sys.exit(f"ERR: No data. Run ./update_data.sh to resolve.")
    if not os.path.exists(PATH_TO_RAW):
        sys.exit("ERR: No raw data to analyze. Run ./update_data.sh to resolve.")
    if not os.path.exists(PATH_TO_PROC):
        os.mkdir(PATH_TO_PROC)
    else:
        shutil.rmtree(PATH_TO_PROC)
        os.mkdir(PATH_TO_PROC)
    
    
    # Get raw data files
    raws = os.listdir(PATH_TO_RAW)

    # Each list will keep raw files for the particular experiment ...
    md_O0_raws = list()
    md_O3_raws = list()
    md_Os_raws = list()

    mt_O0_raws = list()
    mt_O3_raws = list()
    mt_Os_raws = list()

    for raw in raws:
        if md_O0_substring in raw: md_O0_raws.append(raw)
        if md_O3_substring in raw: md_O3_raws.append(raw)
        if md_Os_substring in raw: md_Os_raws.append(raw)

        if mt_O0_substring in raw: mt_O0_raws.append(raw)
        if mt_O3_substring in raw: mt_O3_raws.append(raw)
        if mt_Os_substring in raw: mt_Os_raws.append(raw)

    raws = []
    raws.append(md_O0_raws)
    raws.append(md_O3_raws)
    raws.append(md_Os_raws)

    raws.append(mt_O0_raws)
    raws.append(mt_O3_raws)
    raws.append(mt_Os_raws)

    
    # Parse data ...
    time = list()
    
    for experiment in raws:
        # Define filename for each experiment ...
        csv_file = experiment[0].rsplit("_", 1)[0] + ".csv"
        sizes = []
        avgs = []
        avgs_squared = []
        variances = []
        std_errors = []
        relative_errors = []
        #lns = []
        #lns_double = []

        for datasize in experiment:
            size = int(datasize.rsplit("_", 1)[1].split(".")[0])
            time = []

            with open(PATH_TO_RAW + datasize, "r") as src:
                for line in src:
                    time.append(int(line))
            avg = round(sum(time) / len(time), 6)
            avg_squared = round(avg ** 2, 6)
            variance = round(statistics.variance(time), 6)
            std_error = round(math.sqrt(variance) / len(time), 6)

            if avg != 0: 
                relative_error = round((std_error / avg) * 100, 6)
            else:
                relative_error = -1


            sizes.append(size)
            avgs.append(avg)
            avgs_squared.append(avg_squared)
            variances.append(variance) 
            std_errors.append(std_error)
            relative_errors.append(relative_error)
        
        data = []
        data = list(zip(sizes, avgs, avgs_squared, variances, std_errors, relative_errors))
        data_sorted = sorted(data, key=lambda x: x[0])
        write_csv(csv_file, data_sorted)
        
        """
        if "O0" in csv_file:
            print(f"ln() thing for {csv_file}:")
            sizes = sorted(sizes)
            avgs = sorted(avgs) 
            for i in range(len(sizes) - 1):
                calculation = (math.log(avgs[i + 1]) - math.log(avgs[i])) / (math.log(sizes[i + 1]) - math.log(sizes[i]))
                #print(f"logs:", math.log(time[i + 1]), math.log(time[i]))
                print(f"{sizes[i]} : {calculation}")
        """
        