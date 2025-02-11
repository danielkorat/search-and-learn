#!/bin/bash
#SBATCH -c 12

# Choose model from the following options:
# Llama-3.2-1B-Instruct
# Llama-3.2-3B-Instruct
# Qwen2.5-1.5B-Instruct
MODEL=Llama-3.2-3B-Instruct

# Choose method from the following 3 options:
# best_of_n
# beam_search
# dvts
METHOD=best_of_n

USER_HOME=/home/rlaperdo
CONDA_ROOT=$USER_HOME/miniforge3
source $CONDA_ROOT/bin/activate qwen-math
DATASET_ID=$MODEL-$METHOD-completions
VOTING_N="1 2 4 16 32 64 128 256"

# Repeat for seeds 0-4
for s in 0 1 2 3 4; do
    DATASET_PATH="$USER_HOME/search-and-learn/data/meta-llama/$MODEL/${METHOD}_seed-${s}_n-256_completions.jsonl"

    echo "Dataset Path: $DATASET_PATH"

    python $USER_HOME/Qwen2.5-Math/evaluation/evaluate_hf.py \
        --dataset_id $DATASET_ID \
        --dataset_config MATH-500--T-0.8--top_p-1.0--n-256--max_tokens-2048--bsz-8--seed-$s--agg_strategy-last \
        --voting_n $VOTING_N \
        --dataset_file_path $DATASET_PATH
done
