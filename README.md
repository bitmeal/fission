# 💥 fission init
> multi-process docker init stack. *lightweight, simple and without reinventing the wheel*

The *"PID1-problem"*, zombie processes, signal forwarding and running multiple processes in docker containers has been discussed in length. While well tested and widely supported solutions exist, running multiple processes and setting up the required environment does not come in a simple and light-weight package. The most notable "all-in-one" solutions being `s6-overlay` and `pushion/base-image`s' `my_init.py`; which either come with a high (perceived) level of complexity or a hefty size penalty (i.e. due to the required python interpreter).

**fission init** simplifies the process of setting up your environment, running init scripts, supervising services with automatic logging and allows for simple introspection. All by means of a simple json file.

### Requirements
* A mostly POSIX compatible shell, with
  * `sed`
  * `cut`
  * `tail`
  * `xargs`
* `tini` as PID1
* `runit` for service supervision
* `jq`

> **POSIX** compatibility is **no** design goal! This project is targeting Linux containers.

Partial compatibility with existing schemes for environment initialization and `runit` supervision is provided (*see bottom of this README*).

### 📌 **why "fission"?**
> 
> 1. Fission being the scientific term for division/splitting. **fission init** allows you to "split" your single PID1 process of your container into multiple supervised processes.
> 2. *Runit*, as well as being the core component of **fission init** for service supervision, is the name of an island. *Runit* island is a nuclear waste storage site and nuclear *fission* bomb testing site.

## quickstart
```dockerfile
# Dockerfile
FROM <your-base>

# get fission-init
COPY --from=ghcr.io/bitmeal/fission:latest / /

#...

# use fission-init
ENTRYPOINT ["/opt/fission/bin/fission", "/opt/app/app", "app_param_mandatory"]
CMD ["app_param_optional"]
```
```json
// fission.json [/etc/fission/fission.json]
{
    "env": {
        "FOO": "bar"
    },
    "init": {
        "01_app_cfg": "/opt/app/init.sh"
    },
    "services": {
        "foo": "/opt/app/services/foo"
    }
}
```
* copy rootfs (`/`) from `fission:base` container image
* configure your environment, init scripts and services in `fission.json`
* add your `fission.json` configuration as `/etc/fission/fission.json` in your container
* call `fission`, and give your main command and its parameters as arguments, as `ENTRYPOINT`

> **see `examples/` for full examples of using *fission-init***
### docker images
As seen above, you can copy all required files form the provided docker image `ghcr.io/bitmeal/fission`. *Check `test/platforms/<platform>/Dockerfile` to see if your platform requires additional dependencies.*

Available tags to pull:
* `latest`: latest tagged version
* `v<version>`: specific tagged version
* `edge`: latest commit on master
### manual setup

* copy `fission` to a destination of your choice within your container
* install `tini`, `runit` and `jq`

## features
### PID1
**fission init**s' `fission` script replaces itself with `tini` as popper PID1, when ran as PID1 itself. `tini` is used for its signal forwarding capabilities with process group scope. E.g. `fpco/pid1` or `dumb-init` will break our signal forwarding or error forwarding capabilities.

### main & aux process
**fission init** adheres to the idea of *one application/service per container*, while this application may depend on the presence of other services. These services are thought to be tightly coupled to your application and not to be shared outside of the container!

Exiting your main process, or auxiliary process (if provided) will exit your services and PID1, and consequently stop the container. 

#### main process
Your main process/application and its parameters should be passed as arguments to `fission`, like any proper PID1 system. Additional arguments may thus be given while creating an instance of your container. The following example will call `/opt/app/app` with the argument `app_param`.

```Dockerfile
# Dockerfile
# ...
ENTRYPOINT ["/opt/fission/bin/fission", "/opt/app/app", "app_param"]
```
#### aux process (introspection)
**fission init** allows you to run an *auxiliary* process. Intended use for this feature is introspection into and debugging of your container. After your main process, you may pass `--` followed by an additional command and its' parameters. Using the Dockerfile example from above, you may get a shell in your container (i.e. `mycontainer`) in parallel to your main application by calling, e.g.:
```bash
docker run -it mycontainer -- /bin/sh
```
When running an auxiliary process, your main process' output will be logged to `/var/log/app/`, while additionally forwarding *stderr* to screen. To disable *stderr* forwarding, configure **fission init** to silence stderr (see *services* section).

### services
Service supervision is provided by `runit` and its `runsvdir`. Configure your services as a dictionary under the key `services` in `fission.json`. `runit` compatible configurations will automatically be generated when calling `fission`.
```json
// fission.json [/etc/fission/fission.json]
{
    "services": {
        "foo": "/opt/app/services/foo"
    }
}
```
Manually created `runit` services from `/etc/service` will be launched, but will not profit from any automated functionality of **fission init**!
#### automatic logging
A logger will be created for all services configured in your `fission.json`. *stdout* and *stderr* are merged and logged in `/var/log/<service_name>/`, using `svlogd` with automatic log rotation.

Additionally *stderr* is forwarded to `/dev/stderr` and will appear in your containers' output ("on screen")! To disable this "on screen" forwarding of *stderr*, configure **fission init** as `"stderr": false`:
```json
// fission.json [/etc/fission/fission.json]
{
    "stderr": false
}
```

### environment variables
Environment variables are configured as a dictionary under key `env`, with the variables name as key and its value as its value.
```json
// fission.json [/etc/fission/fission.json]
{
    "env": {
        "FOO": "bar"
    }
}
```

### init scripts
Provide init scripts, or directories containing init scripts, to be **`source`d** in your environment as a dictionary under the key `init`. The keys/names of your init scripts will be used to determine sourcing order and enable overlay functionality (see below). Ordering is based on unicode codepoint order, as implemented by `jq`.
```json
// fission.json [/etc/fission/fission.json]
{
    "init": {
        "01_app_cfg": "/opt/app/init.sh"
    }
}
```

### configuration overlays
To alter your configuration, you can mount additional json files in `/etc/fission/overlays/`. Overlay configuration files will be read and merged into the original config, in the order established by shell globbing with the collating sequence for `LC_COLLATE=C`. Dictionaries are "deep-merged". To remove **individual** items from the configuration, set their value to `null`; removing items is performed after merging.

### silencing **fission** output
As seen in the service section, forwarding of stderr of background services can be disabled. To disable all output of **fission init**, configure it as `"silent": true`.
```json
// fission.json [/etc/fission/fission.json]
// silence all output
{
    "silent": true,
    "stderr": false
}
```

### legacy support
Compatible with `pushion/base-image`s' `my_init.py`; except for environment configuration.
* ~~init from `/etc/rc.local` and `/etc/init.d/**`~~
* run manually created `runit` services from `/etc/service/*`

## tests
find tests and documentation in `./test`. Tests use *bats* for testing, but are "self-bootstrapping". Tests require:
* docker
* bash
* `uuidgen` or `/proc/sys/kernel/random/uuid`

---
## TODO
* service signal forwarding tests


