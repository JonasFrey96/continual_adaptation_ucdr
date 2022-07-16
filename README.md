# Continual Adaptation of Semantic Segmentation **U**sing **C**omplementary 2D-3D **D**ata **R**epresentations
---
<h4 align="center">Contains code, checkpoints, documentation and installation instructions for RA-L paper.</h4>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#citation">Citation</a> •
  <a href="#setup">Setup</a> •
  <a href="#experiments">Experiments</a> •
  <a href="#evaluation">Evaluation</a> •
  <a href="#credits">Credits</a>
</p>

<p float="center">
  <img src="https://github.com/JonasFrey96/continual_adaptation_ucdr/blob/main/docs/main.png" width="95%" />
</p>

# Overview

# Citation

Jonas Frey, Hermann Blum, Francesco Milano, Roland Siegwart, Cesar Cadena, **Continual Learning of Semantic Segmentation using Complementary 2D-3D Data Representations**”, in *IEEE Robotics and Automation Letters(RA-L)*, 2022.

```latex
@inproceedings{frey2022traversability,
  author={Jonas Frey and Hermann Blum and Francesco Milano and Roland Siegwart and Cesar Cadena},
  journal={under review: IEEE Robotics and Automation Letters(RA-L},
  title={Continual Adaptation of Semantic Segmentation using Complementary 2D-3D Data Representations},
  year={2022}
}
```

# Setup
## Clone the Repository
```shell
mkdir -p ~/git/
git clone git@github.com:JonasFrey96/continual_adaptation_ucdr.git
```

We provide a conda environment file and docker container to run the code.
It is tested using `torch==1.10` , `pytorch-lightning==1.6.4` with `CUDA11.3`.


## Setting up Conda Environment
We recommend using mamba for installation and assume you have a working conda installation.

1. Install mamba
```shell
conda activate base
conda install mamba -n base -c conda-forge
```

2. Correct conda settings
```shell
conda config --set safety_checks enabled
conda config --set channel_priority false
```

3. Install and activate the ucdr environment
```shell
cd ~/git/continual_adaptation_ucdr
mamba env create -f cfg/conda/ucdr.yaml
conda activate ucdr
```
4. Install the ucdr repository
```shell
cd ~/git/continual_adaptation_ucdr
pip3 install -e ./
```
## Configuration
All configuration files are within `cfg/env`, `cfg/exp` and `cfg/eval`.

### [env] Environment 
Within the `env` configure the enviroment configuration for your_machine is stored. 
To identify the correct env configuration add the name of your_machine to your `~/.bashrc`. 
```shell
echo 'export ENV_WORKSTATION_NAME="your_machine"' >> ~/.bashrc
source  ~/.bashrc
```
Create a file in `cfg/env/your_machine.yaml` with the following content (same as `cfg/env/env.yaml`):
```yaml
base: results/learning # will create a log in this folder for each run. (global or relative to the continual_adaptation_ucdr)
labels_generic: results/labels_generated # where to find pseudo labels. (global or relative to the continual_adaptation_ucdr)
scannet: /path_to/scannet # (global path) 
```

### [exp] Experiment
In the experiment folder all experiments to reproduce the results within the paper are provided. 
Pass the relative path to the defined experiment yaml-file to the `scripts/train.py` to start training.
You may want to adapt the `neptune_project_name` to log directly to your neptune.ai account. 

### [eval] Evaluation
Pass the relative path to the defined evaluation yaml-file to the `scripts/eval.py` to start evaluation.

## Pre-trained models
All models that can be generated using the experiments can be downloaded here. 
Extract the data to your choosen `base` within the `env` configuration. 
By defaults this is `results/learning`.

# Experiments
## 1. Pretrain the model
```shell
python scripts/train.py --exp=pred_1/scannet25_pretrain.yaml
```
## 2. Generate pseudo labels 
Update the `global_checkpoint_load` in `cfg/generate/pred1.yaml` if you are not using the pretrained network.
```shell
python scripts/generate.py --generate=pred1.yaml
```
Will create a folder defined perviously in `labels_generic` in the enviornment yaml file.

- `TODO` description of using setting up kimera semantics and the raytracing.

## 3. Network adaptation
Use the provided experiment file in `pred_2_r00` where `r00` inidcates the replay ratio used and `00` corresponds to the finetuning strategy.
Update the path to the pretrained model in `checkpoint_load` if you are not using the pretrained model.

```shell
python scripts/train.py --exp=pred_2_r00/scene0000_r00.yaml
```

# Evaluation

## Pseudo Labels
Generate Score for 1-Pseudo Adap:
```shell
python scripts/eval_pseudo_labels.py --pseudo_label_idtf=labels_individual_scenes_map_2 --mode=val --scene=scene0000,scene0001,scene0002,scene0003,scene0004
```

## Network
```shell
python scripts/eval_model.py --eval=eval_pred_1.yaml
python scripts/eval_model.py --eval=eval_pred_2_00.yaml
python scripts/eval_model.py --eval=eval_pred_2_02.yaml
python scripts/eval_model.py --eval=eval_pred_2_05.yaml
```




<!---
## Using Docker
Build:
```
cd cfg/docker && ./build.sh
```
## ETH-Cluster Specific
### Singularity container:
```
mkdir exports && cd exports && SINGULARITY_NOHTTPS=1 singularity build --sandbox ucdr.sif docker-daemon://ucdr:latest
sudo tar -cvf ucdr.tar ucdr.sif
scp ucdr.tar username@euler:/cluster/work/usergroup/username/ucdr/containers
```
### Create Dataset Tar Files
Move to the directory that contains the individual scenes (scene0000_00, ...)
Tar it without compression:
```
tar -cvf scannet.tar ./
```

Repeat this for the folder containing 
- scannet25k (without scene 0-10).
- scannet (scene 0-10 only with all images subsampled correctly).
- generated labels directory (scene 0-10). 

Further script for execution on the cluster are provided under `cfg/docker`.
--->

# Credits
- The authors of [Fast-SCNN](https://arxiv.org/pdf/1902.04502.pdf)  
- TRAMAC implementing [Fast-SCNN in PyTorch](https://github.com/Tramac/Fast-SCNN-pytorch)   
- The authors of [ORBSLAM2](https://github.com/appliedAI-Initiative/orb_slam_2_ros)  
- People at <http://continualai.org> for the inspiration 
