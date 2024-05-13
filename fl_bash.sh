#!/bin/bash
PORT_k=3456

export TRANSFORMERS_CACHE=/fs/nexus-scratch/cacquaye/cache
while true; do
    # Get the current number of jobs in the queue
    job_count=$(squeue -u cacquaye | wc -l)

    # Check if the job count is larger than 100
    if [ "$job_count" -gt 100 ]; then
        echo "Job count is larger than 100. Sleeping for 600 seconds."
        sleep 600
    else
        echo "Beginning new set of experiments."
        break  # Exit the loop if the condition is not met
    fi
done



# for group in "GH"; do
#     for setup in "Underspecified"; do
for file_name in "new08.yml" "your_config.yml" "new10.yml" "newlr001.yml" "newlr0001.yml" "newlr0005.yml"; do
    log_file="fl_${PORT_k}_for"
    
    python_cmd="python main.py fedavg ${file_name}"
    
    sbatch --qos=scavenger --partition=scavenger --account=scavenger --time=0-07:00:00 --gres=gpu:rtxa5000:1 --mem=64gb \
            -o ${log_file} \
            --job-name=${log_file}\
            --wrap="${python_cmd}"
    PORT_k=$((PORT_k+1))  
done
# done        
# done
# for run in 1; do
#     log_file="bert_base_${PORT_k}_underspecified"
#     python_cmd="python -m bert_validation --group GH  --setup_type Specified"
#     sbatch --qos=scavenger --partition=scavenger --account=scavenger --time=0-05:00:00 --gres=gpu:rtxa5000:1 --mem=64gb \
#             -o ${log_file} \
#             --job-name=${log_file}\
#             --wrap="${python_cmd}"
#     done
 