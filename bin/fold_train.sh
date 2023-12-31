#!/bin/bash

### fold_train.sh allows for conducting multiple training runs for all folds
### of a specified MAIN set.

### USAGE: ./fold_train.sh

# Variable for the hyperparameters being used
hyp_path=$(echo '/data/drone/'"$USER"'/yolov5/data/hyps/hyp.scratch-low.yaml')

# Source Chau's python environment
venv_path=$(echo '/data/drone/'"$USER"'/python_env2/bin/activate')
source "$venv_path"

# Vars needed to train the folds
echo "How many folds are there to train? (usually between 5-10): "
read num_folds
echo "Enter the path of the Main Set (ex: ../data/training_data/[MAIN_SET]/): "
read main_set_path

# Vars needed to store values used while training
echo "Enter the batch-size to train with (ex: 16): "
read batch_size
echo "Enter the number of epochs to train with (ex: 300): "
read num_epochs

# Additional var for naming Fold dirs
main_set_name=$(basename $main_set_path)

for (( i=1; i<=$num_folds; i++ ))
do
	run_name=${main_set_name}/Fold${i}
	fold_path=$main_set_path/Fold${i}/
	yaml_path=${fold_path}data.yaml

	nohup python /data/drone/"$USER"/yolov5/train.py --data $yaml_path --batch-size=$batch_size --name $run_name --epochs=$num_epochs --hyp $hyp_path --save-period 50  &

	# Go to the data.yaml and get the train/test path
	train_path=$(cat $yaml_path | head -n1 | sed -n 's/train: //p')
	train_path=$(echo '.'"$train_path")
	test_path=$(cat $yaml_path | head -n2 | sed -n 's/val: //p')
	test_path=$(echo '.'"$test_path")

	printf "\n"
	echo "##################################"
	printf "Fold${i} training started...\n"
	echo "##################################"
	printf "\n"
done
