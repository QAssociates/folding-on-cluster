# folding-on-cluster

Folding @ Home, setup as a container to run on containerised environments such as Kubernetes, singularity, etc.

There is a GitHub action setup so this image is __updated every week__.


# Install
## ONLY CPU 
```kubectl apply -f https://raw.githubusercontent.com/qassociates/folding-on-cluster/main/folding-cpu.yaml```  

## ONLY GPU (Nvidia)
```kubectl apply -f https://raw.githubusercontent.com/qassociates/folding-on-cluster/main/folding-gpu.yaml```

## CPU & GPU (Nvidia)
```kubectl apply -f https://raw.githubusercontent.com/qassociates/folding-on-cluster/main/folding-gpu-cpu.yaml```  



### Tested GPU's:
* GeForce GTX 1080
* GeForce RTX 2080
* Tesla K40m
* Tesla K80

&nbsp;

*The default install deploys 2 replicas, limited to using 1 CPU core each.*

&nbsp;

## DaemonSet

You can also run this as a DaemonSet (runs one replica per node) with:  

```kubectl apply -f https://raw.githubusercontent.com/qassociates/folding-on-cluster/main/folding-daemonset.yaml```    

There is a `tolerations` section in this .yaml you can uncomment in order to also run FAHClient on master nodes if you wish.  

&nbsp;


# Customising

I've added the framework for a `PriorityClass`, so that K8s will preemptively evict these pods if a higher-priority one comes along.

And of course set the replica count and resource limit as appropriate depending on how much CPU you wish to donate. In my testing, memory load has been very low (<256Mi)


## config.xml

The most compatible way to edit the config.xml is by modifying it's values and creating your own Docker image.  

You *can* override/mount as a configMap in Kubernetes (you can see the scaffolding for this inside `folding.yaml`), however FAHClient seems to copy/move this file around, which doesn't work if the file is mounted. You'll get a bunch of errors from the FAHClient if you do this.


_docker run_:

```sh
docker run \
    ghcr.io/qassociates/folding-on-cluster/folding-on-cluster:main
```
