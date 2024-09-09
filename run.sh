#!/bin/bash
#SBATCH --job-name=targets_main
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5gb          
#SBATCH --time=24:00:00
#SBATCH --partition=standard
#SBATCH --account=<youraccount>
#SBATCH -o logs/%x_%j.out

# Load necessary modules
module load R/4.3

# Start targets pipeline
R -e 'targets::tar_make()'