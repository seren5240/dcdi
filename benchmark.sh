#!/bin/bash
#
#SBATCH --account=pi-naragam
#SBATCH --job-name=dcdi_native
#SBATCH --output=./slurm/out/%j.%N.stdout
#SBATCH --error=./slurm/out/%j.%N.stderr
#SBATCH --chdir=/home/skwok1/dcdi
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2000
#SBATCH --time=3-00:00:00

set -e

module load python/booth/3.12
module load R/4.3/4.3.2

for i in {1..10}; do
    RESULTS_FOLDER="p10_e10_linear_dcd"
    LOG_FILE="${RESULTS_FOLDER}/dag_${i}/log.txt"
    mkdir -p ${RESULTS_FOLDER}/dag_${i}

    srun --exclusive --cpus-per-task=4 --ntasks=1 --nodes=1 bash -c "
        python3 ./main.py \\
            --train \\
            --data-path ./data/perfect/data_p10_e10_n10000_linear_struct \\
            --num-vars 10 \\
            --i-dataset ${i} \\
            --exp-path ${RESULTS_FOLDER}/dag_${i} \\
            --model DCDI-G \\
            --dcd \\
            --reg-coeff 0.5 \\
        | tee ${LOG_FILE}
    " &
done

wait
