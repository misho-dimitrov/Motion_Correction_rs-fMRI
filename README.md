# Scripts for comparing different fMRI data pre-processing pipelines (esp. in terms of motion correction) as well as different number of echoes.


## Docker containers

To guarantee reproducibility and reduce issues involved in solving dependencies, all the routines available here run in a Docker container. Please download the last version of the software at their website: https://www.docker.com/

To run the Docker container with the defined settings, please run:


```
docker-compose up
```

A jupyter notebook URL + token will be produced and can be copied from terminal output.


:warning: Please be aware that the first time running this routine inside a Docker container might take slightly longer, as the dependencies are built. Once these are in place, the routine should finish quickly.