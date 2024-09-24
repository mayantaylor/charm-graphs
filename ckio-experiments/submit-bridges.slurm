#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=32
#SBATCH --output=run.out
#SBATCH --time=00:05:00

module load gcc/13 openmpi/5
module load cuda/11

input_file=??
nvert=??

for iter in 1 2 3; do
  for readers in 4 32 128 512 1024 2048 4096; do
    seed=$readers
    # evict input file from cache
    vmtouch -e $input_file
    # args are: numvert, input file, randseed, nreaders, output\
    ./charmrun ./graph_parallel $nvert $input_file $seed $readers ckio-experiments/results/4node/naive.txt +p$SLURM_NTASKS
    
    for bc in 4 32 128 512; do 
          seed=$(($bc + $readers))
          # evict input file from cache
          vmtouch -e $input_file
          # args are: numvert, input file, randseed, nreaders, nbuf, output
          ./charmrun ./graph_parallel_ckio $nvert $input_file $seed $readers $bc ckio-experiments/results/1node/ckio.txt +p$SLURM_NTASKS
    done
  done
done

