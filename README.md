# folding-on-cluster

Folding @ Home, setup as a container to run on containerised environments such as Kubernetes, singularity, etc.

There is a GitHub action setup so this image is __updated every week__.


# Install
## CPU 
```kubectl apply -f https://raw.githubusercontent.com/QAssociates/folding-on-cluster/main/deploy/fah-cpu.yml```  

## GPU (Nvidia)
```kubectl apply -f https://raw.githubusercontent.com/QAssociates/folding-on-cluster/main/deploy/fah-gpu.yml```


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

```kubectl apply -f hhttps://raw.githubusercontent.com/QAssociates/folding-on-cluster/main/deploy/folding-daemonset.yml```    

There is a `tolerations` section in this .yaml you can uncomment in order to also run FAHClient on master nodes if you wish.  

&nbsp;


# Customising

I've added the framework for a `PriorityClass`, so that K8s will preemptively evict these pods if a higher-priority one comes along.

And of course set the replica count and resource limit as appropriate depending on how much CPU you wish to donate. In my testing, memory load has been very low (<256Mi)


## config.xml

The most compatible way to edit the config.xml is by modifying it's values and creating your own Docker image.  

You *can* override/mount as a configMap in Kubernetes (you can see the scaffolding for this inside `folding.yaml`), however FAHClient seems to copy/move this file around, which doesn't work if the file is mounted. You'll get a bunch of errors from the FAHClient if you do this.

## Configuration options

```
Here is a list of all the config options available, with defaults in <>:

Configuration options:
The following options can be specified in a configuration file or on the command
line using the following syntax:

    --<option> <value>

  or:

    --<option>=<value>

  or when marking boolean values true:

    --<option>

Client Control:
  client-threads <integer=6>
    The number of client processing threads.

  cycle-rate <double=4>
    The maximum cycle frequency in Hz of client threads.

  cycles <integer=-1>
    Run at most this many cycles. A value less than zero means run indefinitely.

  data-directory <string=.>
    The directory, relative to the current directory, where WU data and cores
    are stored.

  disable-sleep-when-active <boolean=true>
    Attempt to keep the system from sleeping when folding, unless on battery.

  exec-directory <string=/opt/fah/fahclient-smp>
    The directory, relative to the current executable, where executables and
    dynamic libraries are located.

  exit-when-done <boolean=false>
    Exit when all slots are paused.

  fold-anon <boolean=false>
    Start folding even if not configured.

  idle-seconds <integer=300>
    Number of seconds of system idle time before enabling idle folding. Set to
    zero to ignore system idle time.

  open-web-control <boolean=false>
    Make an operating system specific call to open the Web Control in a browser
    once client is fully loaded

Configuration:
  config-rotate <boolean=true>
    Rotate the configuration file to a backup when saving would overwrite the
    previous configuration.

  config-rotate-dir <string=configs>
    Put rotated configs in this directory.

  config-rotate-max <integer=16>
    The maximum number of rotated configuration files to keep. A value of zero
    will keep all configuration file backups.

Error Handling:
  max-slot-errors <integer=10>
    The maximum number of errors before a slot is paused.

  max-unit-errors <integer=5>
    The maximum number of errors before a work unit is dumped.

Folding Core:
  checkpoint <integer=15>
    Tell cores to checkpoint at least every # minutes.

  core-dir <string=cores>
    The directory to store core files in.

  core-prep <string>
    Run this command on cores after they are downloaded. This option is useful
    for running Linux cores on BSD machines.

  core-priority <string=idle>
    Set the core priority. Valid values are: idle or low

  cpu-affinity <boolean=false>
    If true, try to lock core processes to a fixed CPU

  cpu-usage <integer=100>
    The maximum percentage of the CPU a core should use. Not implemented by all
    cores.

  gpu-usage <integer=100>
    GPU usage as a percent from 10-100

  no-assembly <boolean=false>
    Tell cores to disable optimized assembly code.

Folding Slot Configuration:
  cause <string=ANY>
    The cause you prefer to support.

  client-subtype <string=LINUX>
    The client subtype

  client-type <string=normal>
    The client type. Can be 'normal', 'advanced' or 'beta'.

  cpu-species <string=X86_AMD>
    CPU species.

  cpu-type <string=AMD64>
    CPU type.

  cpus <integer=-1>
    How many CPUs a slot should use. <= 0 will use all the CPUs detected in the
    system.

  cuda-index <string>
    The CUDA device index of the GPU, counting starts from 0.

  extra-core-args <string>
    Pass extra arguments to the core.

  gpu <boolean=true>
    Enable or disable auto-confiugration of GPU slots, requires appropriate
    hardware.

  gpu-index <string>
    The index of the GPU as detected by the client. This index corresponds
    directly to the GPUs listed in the client's '--info' output.

  max-packet-size <string=normal>
    Max size in bytes of a work unit packet. Can be small=5MB, normal=10MB,
    big=500MB or a number.

  memory <string>
    Override memory, in bytes, reported to Folding@home.

  opencl-index <string>
    The OpenCL device index of the GPU, counting starts from 0.

  os-species <string=UNKNOWN>
    Operating system species.

  os-type <string=LINUX>
    Operating system type.

  project-key <integer=0>
    Key for access to restricted testing projects.

  smp <boolean=true>
    Enable or disable auto-configuration of SMP slots, requires appropriate
    hardware.

GUI:
  gui-enabled <boolean=true>
    Set to false to disable the GUI. A GUI is not currently supported on all
    operating systems.

HTTP Server:
  allow <string=127.0.0.1>
    Client addresses which are allowed to connect to this server. This option
    overrides IPs which are denied in the deny option. The pattern 0/0 matches
    all addresses.

  connection-timeout <integer=60>
    The maximum amount of time, in seconds, a connection can be idle before
    being dropped.

  deny <string=0/0>
    Client address which are not allowed to connect to this server.

  http-addresses <string=0:7396>
    A space separated list of server address and port pairs to listen on in the
    form <ip | hostname>[:<port>]

  https-addresses <string=>
    A space separated list of secure server address and port pairs to listen on
    in the form <ip | hostname>[:<port>]

  max-connect-time <integer=900>
    The maximum amount of time, in seconds, a client can be connected to the
    server.

  max-connections <integer=800>
    Sets the maximum number of simultaneous connections.

  max-request-length <integer=52428800>
    Sets the maximum length of a client request packet.

  min-connect-time <integer=300>
    The minimum amount of time, in seconds, a client must be connected to the
    server before it can be dropped in favor or a new connection.

  threads <integer=6>
    Sets the number of server threads.

HTTP Server SSL:
  certificate-file <string>
    The servers certificate file in PEM format.

  crl-file <string>
    Supply a Certificate Revocation List. Overrides any internal CRL

  private-key-file <string>
    The servers private key file in PEM format.

Logging:
  log <string=log.txt>
    Set log file.

  log-color <boolean=true>
    Print log messages with ANSI color coding.

  log-crlf <boolean=false>
    Print carriage return and line feed at end of log lines.

  log-date <boolean=false>
    Print date information with log entries.

  log-date-periodically <integer=21600>
    Print date to log before new log entries if so many seconds have passed
    since the last date was printed.

  log-debug <boolean=true>
    Disable or enable debugging info.

  log-domain <boolean=false>
    Print domain information with log entries.

  log-domain-levels <string ...>
    Set log levels by domain. Format is:
      <domain>[:i|d|t]:<level> ...
    Entries are separated by white-space and or commas.
      i - info
      d - debug
    For example: server:i:3 module:6
    Set 'server' domain info messages to level 3 and 'module' info and debug
    messages to level 6. All other domains will follow the system wide log
    verbosity level.
    If <level> is negative it is relative to the system wide verbosity.

  log-header <boolean=true>
    Enable log message headers.

  log-level <boolean=true>
    Print level information with log entries.

  log-no-info-header <boolean=true>
    Don't print 'INFO(#):' in header.

  log-redirect <boolean=false>
    Redirect all output to log file. Implies !log-to-screen.

  log-rotate <boolean=true>
    Rotate log files on each run.

  log-rotate-dir <string=logs>
    Put rotated logs in this directory.

  log-rotate-max <integer=16>
    Maximum number of rotated logs to keep.

  log-short-level <boolean=false>
    Print shortened level information with log entries.

  log-simple-domains <boolean=true>
    Remove any leading directories and trailing file extensions from domains so
    that source code file names can be easily used as log domains.

  log-thread-id <boolean=false>
    Print id with log entries.

  log-thread-prefix <boolean=true>
    Print thread prefixes, if set, with log entries.

  log-time <boolean=true>
    Print time information with log entries.

  log-to-screen <boolean=true>
    Log to screen.

  log-truncate <boolean=false>
    Truncate log file.

  verbosity <integer=3>
    Set logging level for INFO and DEBUG messages.

Network:
  proxy <string=>
    Set proxy for outgoing HTTP connections

  proxy-enable <boolean=false>
    Enable proxy configuration

  proxy-pass <string=>
    Set password for proxy connections

  proxy-user <string=>
    Set user name for proxy connections

Process Control:
  child <boolean=false>
    Disable 'daemon', 'fork', 'pid' and 'respawn' options. Also defaults
    'log-to-screen' to false. Used internally.

  daemon <boolean=false>
    Short for --pid --service --respawn --log='' --fork

  fork <boolean=false>
    Run in background.

  pid <boolean=false>
    Create PID file.

  pid-file <string=Folding@home Client.pid>
    Name of PID file.

  priority <string>
    Set the process priority. Valid values are: idle, low, normal, high or
    realtime.

  respawn <boolean=false>
    Run the application as a child process and respawn if it is killed or exits.

  run-as <string>
    Run as specified user

  service <boolean=false>
    Ignore user logout or hangup and interrupt signals

Remote Command Server:
  command-address <string=0.0.0.0>
    The address to which the command server should be bound.

  command-allow-no-pass <string=127.0.0.1>
    IP address ranges that are allowed access to the command server with out a
    password if the 'password' option is set. These addresses will also have to
    be allowed IP based access.

  command-deny-no-pass <string=0/0>
    IP address ranges that are not allowed access to the command server with out
    a password if the 'password' option is set. Overriden by
    command-allow-no-pass

  command-enable <boolean=true>
    Set to false to disable the command server.

  command-port <integer=36330>
    The port to which the command server should be bound.

  eval <string>
    Evaluate the argument as a script.

  password <string>
    Set a command server password. Warning, setting a password disables the
    default IP address blocking.

  script <string>
    Run commands from a script file.

Slot Control:
  idle <boolean=false>
    Only run slot when idle.

  max-shutdown-wait <integer=60>
    The maxumum amount of time to wait in seconds for a unit to exit on
    shutdown.

  pause-on-battery <boolean=true>
    Pause the client or slot when the OS indicates the machine is running on
    battery power.

  pause-on-start <boolean=false>
    If true the slot will be started in a paused state.

  paused <boolean=false>
    True of client is paused.

  power <string=medium>
    Set the client's power level. Valid values are 'light', 'medium' or 'full'.
    This setting affects the defaults of several other options such as 'cpus',
    'pause-on-battery', etc.

User Information:
  machine-id <integer=0>
    The machine ID.

  passkey <string=>
    Your passkey.

  team <integer=0>
    Your team number.

  user <string=Anonymous>
    Your user name.

Web Server:
  web-allow <string=127.0.0.1>
    Client addresses which are allowed to connect to this Web server. This
    option overrides IPs which are denied in the web-deny option. This option
    differs from the 'allow'/'deny' options in that clients that are not allowed
    are served an access denied page rather than simply dropping the connection.
    The value '0/0' matches all IPs.

  web-deny <string=0/0>
    Client address which are not allowed to connect to this Web server.

  web-enable <boolean=true>
    Set to false to disable the web server.

Web Server Sessions:
  session-cookie <string=sid>
    The name of the session cookie.

  session-lifetime <integer=86400>
    The maximum session lifetime in seconds. Zero for unlimited session
    lifetime.

  session-timeout <integer=3600>
    The max maximum amount of time in seconds since the last time a session was
    used before it timesout. Zero for no session timeout.

Work Unit Control:
  dump-after-deadline <boolean=true>
    Dump units if their deadline has passed.

  max-queue <integer=16>
    Maximum units per slot in the work queue.

  max-units <integer=0>
    Process at most this number of units, then pause.

  next-unit-percentage <integer=99>
    Pre-download the next work unit when the current one is this far along.
    Values less than 90 are not allowed.

  stall-detection-enabled <boolean=false>
    Attempt to detect stalled work units and restart them.

  stall-percent <integer=5>
    Minimum estimated percent work unit completion since last frame before a WU
    can be considered stalled, if zero the percentage is ignored.

  stall-timeout <integer=1800>
    Minimum time, in seconds, since last frame before a WU can be considered
    stalled.
```
_docker run_:

```sh
docker run \
    ghcr.io/qassociates/folding-on-cluster/folding-on-cluster:main
```
