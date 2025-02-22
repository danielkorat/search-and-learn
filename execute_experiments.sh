#!/bin/bash
#SBATCH -p g80
#SBATCH --gres=gpu:1
#SBATCH -c 12

# Choose model from the following options:
# Llama-3.2-1B-Instruct
# Llama-3.2-3B-Instruct
# Qwen2.5-1.5B-Instruct
# MODEL=Llama3.1-8B-PRM-Deepseek-Data/Llama-3.2-3B-Instruct
MODEL=DeepSeek-R1-Distill-Qwen-1.5B_Deepseek-PRM-Data/Llama-3.2-3B-Instruct

# Choose method from the following 3 options:
# best_of_n
# beam_search
# dvts
METHOD=best_of_n

CONDA_ROOT=$HOME/miniforge-pypy3
source $CONDA_ROOT/bin/activate sal
CONFIG=$HOME/search-and-learn/recipes/$MODEL/$METHOD.yaml
# python $USER_HOME/search-and-learn/scripts/test_time_compute.py $CONFIG

# Repeat for seeds 0-4
for s in 0 1 2 3 4; do
    python $HOME/search-and-learn/scripts/test_time_compute.py $CONFIG \
        --n=256 \
        --num_samples=500 \
        --seed=$s
done
