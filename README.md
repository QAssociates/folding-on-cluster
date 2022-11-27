# folding-on-cluster

Folding @ Home, setup as a container to run on containerised environments such as Kubernetes, singularity, etc.

There is a GitHub action setup so this image is __updated every week__.

The folding project recently added support for the Corona virus (2019-nCoV). 

https://foldingathome.org/2020/02/27/foldinghome-takes-up-the-fight-against-covid-19-2019-ncov/

This is a quick deployment that lets you run this on Kubernetes, should you have any spare cluster-power you'd like to donate. 

<u>Note</u>: COVID-19 work units are being prioritized, however the folding@home client is liable to select jobs for other diseases too.  

&nbsp;

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
mkdir run
mkdir var
docker run --privileged \
    -v $(pwd)/run:/var/run/libvirt \
    -v $(pwd)/var:/var/lib/libvirt \
    ghcr.io/qassociates/folding-on-cluster/folding-on-cluster:cpu
```

_libvirtd clients_ examples:

```sh
virsh -c qemu:///system?socket=$(pwd)/run/libvirt-sock
```

```sh
virt-manager -c qemu:///system?socket=$(pwd)/run/libvirt-sock
```
