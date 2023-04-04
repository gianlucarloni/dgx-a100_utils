# DGX-A100 UTILITY REPO
This tiny repo contains some useful scripts and bash commands to leverage the full potential of the NVIDIA DGX-A100 infrastructure, such as utilizing Docker and automatically deciding the best GPU node(s) to use when running a new job.

## Rationale
The Institute of Information Science and Technologies (ISTI) of the National Research Council of Italy, in Pisa, has been equipped with a new data center infrastructure: NVIDIA DGX A100. It is a universal system for all AI workloads, offering unprecedented compute density, performance, and flexibility in the world’s first 5 petaFLOPS AI system.

Importantly, this infrastructure features 8x NVIDIA A100 40GB Tensor Core GPUs, thus exposing a total GPU memory of 320GB! I will not go in further details here so, please, refer to [official documentation](https://resources.nvidia.com/en-us-dgx-systems/nvidia-dgx-a100-system-40gb-datasheet-web-us).

## Why using Docker

As an Institute policy, it has been strongly recommended to use [Docker](https://www.docker.com/) to create the environment with the necessary software and launch processes.
When launching a process via `docker run`, the `--cpus` option is strongly recommended to avoid incorrectly occupying the entirety of CPUs. A heuristic for specifying the number of cpus to use is to choose a value between `8*nGPUs` and `24*nGPUs` where `nGPUs` indicates the number of GPUs required.

With this configuration, any changes made outside the current folder will not be retained when closing the container. If the environment needs to be changed (install/remove packages or software, etc.), changing the Dockerfile and re-running the image creation is suggested. This workflow has the advantage of making the creation of the development/launch environment more easily reproducible and robust to accidents (if the docker image I was using is mistakenly deleted, I just rebuild it with a docker build from the Dockerfile).


