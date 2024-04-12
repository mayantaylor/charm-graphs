#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=8
#SBATCH --output=weighted_no_projections_smp.out
#SBATCH --partition=cpu
#SBATCH --account=mzu-delta-cpu
#SBATCH --job-name=myjobtest
#SBATCH --exclusive
#SBATCH --time=00:10:00      # hh:mm:ss for the job

export PPN=6
srun -n $SLURM_NTASKS_PER_NODE ./weighted_htram_smp $((SLURM_NTASKS_PER_NODE*PPN)) 1000 ../facebook_clean_data/smaller_graph.csv 100 1 +ppn $PPN +commap 0-63:8 +pemap 1-63:8.6
