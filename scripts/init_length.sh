#!/bin/bash
#SBATCH --cpus-per-task 12
#SBATCH --mem-per-cpu 20G
#SBATCH -J init_length
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --partition dlcegpu
#SBATCH -w dlcenode04

Rscript --verbose 04_FinalModel_CLTS.R
