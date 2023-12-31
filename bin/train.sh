#!/bin/bash

# Variable for the hyperparameters being used
hyp_path=$(echo '/data/drone/'"$USER"'/yolov5/data/hyps/hyp.scratch-low.yaml')

# Source Chau's python environment
venv_path=$(echo '/data/drone/'"$USER"'/python_env2/bin/activate')
source "$venv_path"

# Run the train.py script
echo "Enter the path of the data.yaml (relative path (ex: ../path/to/dataset/folder/data.yaml) or full path): "
read yaml_path
echo "Enter the batch-size to train with (ex: 64): "
read batch_size
echo "Enter the name of this training run: "
read run_name
echo "Enter the number of epochs to train with (ex: 300): "
read num_epochs


#nohup python ../train.py --data $yaml_path  --batch-size=$batch_size --name $run_name --epochs=$num_epochs --hyp $hyp_path &
nohup python /data/drone/"$USER"/yolov5/train.py --data $yaml_path  --batch-size=$batch_size --name $run_name --epochs=$num_epochs --hyp $hyp_path &

# Go to the data.yaml and get the train/test path
train_path=$(cat $yaml_path | head -n1 | sed -n 's/train: //p')
train_path=$(echo '.'"$train_path")
test_path=$(cat $yaml_path | head -n2 | sed -n 's/val: //p')
test_path=$(echo '.'"$test_path")


############## v Used to save the training information

# Count up the amount of images in the data set
#train_size=$(cd $train_path &&  ( ls | wc -l))
#test_size=$(cd $test_path &&  ( ls | wc -l))
#total_size=$(expr $train_size + $test_size)

# Actually receive the data from the hyp
#hyps=()
#while IFS= read -r line; do
#  hyps+=("$line")
#done < <(tail -n29 $hyp_path)

# Run the save_hyps.py
#python ./save_hyps.py $data_path $run_name $total_size $num_epochs "${hyps[@]}" 

############## ^ commented out because we don't really need to use it at the moment
