#!/bin/bash


########################  Step 1, ##################################
# split train and test dataset using Trajectron-plus-plus

cd Trajectron-plus-plus
conda create -n traj python=3.6 -y
conda activate trajectron++
pip install -r requirements.txt

cd experiments/nuScenes
# For the mini nuScenes dataset, use the following
python process_data.py --data=./v1.0-mini --version="v1.0-mini" --output_path=../processed
# For the full nuScenes dataset, use the following
python process_data.py --data=./v1.0 --version="v1.0-trainval" --output_path=../processed



########################  Step 2, ##################################
# generate dill data to pred_metric/environment/nuScenes_data/cached_data
cd PlanningAwareEvaluation
conda create -n plan_torch170 python=3.7 -y
conda activate plan_torch170
pip install -r requirements.txt
pip uninstall torch -y
pip install torch==1.7.0 torchvision

python nuScenes_data.py --data_name train_mini_full --num_trajs 2 --ph 6 --prediction_module --only_preprocess_data


########################  Step 3, ##################################
# train
cd PlanningAwareEvaluation
conda create -n plan_torch181 python=3.7 -y
conda activate plan_torch181
pip install -r requirements.txt

python nuScenes_data.py --data_name train_mini_full --num_trajs 2 --ph 6 --prediction_module --train


####### analysis
python nuScenes_data.py --data_name train_mini_full --num_trajs 2 --ph 6 --prediction_module --train --sens_analyses
