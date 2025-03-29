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

export R_LIBS_USER=~/Rlibs

RESULTS_FOLDER="p10_e10_linear_noise_1"

if [ -d "${RESULTS_FOLDER}" ]; then
    echo "Results folder ${RESULTS_FOLDER} already exists, exiting."
    exit 1
fi

for i in {1..10}; do
    LOG_FILE="${RESULTS_FOLDER}/dag_${i}/log.txt"
    mkdir -p ${RESULTS_FOLDER}/dag_${i}

    srun --exclusive --cpus-per-task=4 --ntasks=1 --nodes=1 bash -c "
        python3 ./main.py \\
            --train \\
            --data-path ./data/ours/data_p10_e10.0_n1000_GP \\
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
