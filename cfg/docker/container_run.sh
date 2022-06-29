#!/bin/bash

echo "Execute cluster_run_container.sh"
h=`echo $@`
echo $h
export ENV_WORKSTATION_NAME=euler

cd /home/git/continual_adaptation_ucdr
python -m pip install --root ./  ./
pip install --cache-dir /home/code/ torchmetrics==0.9.1 
echo "WORKING"
export PYTHONPATH=$PYTHONPATH:/home/git/continual_adaptation_ucdr

exec bash -c "python3 -u scripts/train.py $h"