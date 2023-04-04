# DGX-A100 UTILITY REPO
This tiny repo contains some useful scripts and bash commands to leverage the full potential of the NVIDIA DGX-A100 infrastructure, such as utilizing Docker and automatically deciding the best GPU node(s) to use when running a new job.

## Rationale
The Institute of Information Science and Technologies (ISTI) of the National Research Council of Italy, in Pisa, has been equipped with a new data center infrastructure: NVIDIA DGX A100. It is a universal system for all AI workloads, offering unprecedented compute density, performance, and flexibility in the world’s first 5 petaFLOPS AI system.

Importantly, this infrastructure features 8x NVIDIA A100 40GB Tensor Core GPUs, thus exposing a total GPU memory of 320GB! I will not go in further details here so, please, refer to [official documentation](https://resources.nvidia.com/en-us-dgx-systems/nvidia-dgx-a100-system-40gb-datasheet-web-us).

## Why using Docker

As an Institute policy, it has been strongly recommended to use [Docker](https://www.docker.com/) to create the environment with the necessary software and launch processes.
When launching a process via `docker run`, the `--cpus` option is strongly recommended to avoid incorrectly occupying the entirety of CPUs. A heuristic for specifying the number of cpus to use is to choose a value between `8*nGPUs` and `24*nGPUs` where `nGPUs` indicates the number of GPUs required.

With this configuration, any changes made outside the current folder will not be retained when closing the container. If the environment needs to be changed (install/remove packages or software, etc.), changing the Dockerfile and re-running the image creation is suggested. This workflow has the advantage of making the creation of the development/launch environment more easily reproducible and robust to accidents (if the docker image I was using is mistakenly deleted, I just rebuild it with a docker build from the Dockerfile).

## docker run

When you have to launch a process (container) that uses possibly mupliple GPUs, it is helpful to automatically detect which of the available GPU nodes are preferable. This is usually associated with their 

In [docker_run_distributed.sh](https://github.com/gianlucarloni/dgx-a100_utils/blob/3de9854563b738161e782f88ab4cae4c14952044/docker_run_distributed.sh) I give an example of a script that, before launching a multi-GPU container, checks which nodes to select and assigns them to the docker run command. That bash (.sh) script starts by taking user's input from stdin (prompt via keyboard) to allocate the right number of GPUs (`NUM_GPUS=$(($1))`). For instance, if the user wants to utilize 2 GPUs will pass `2` as first (an only) argument of the bash script.
