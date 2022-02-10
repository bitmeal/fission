# testing
testing uses **bats** testing framework and thus requires **bash** to run tests!


## run tests
to run tests use `test.bash`. to specify a platform to tests against, set environment variable `FISSION_PLATFORM`. default platform ist `alpine`.

## environment
### host
requirements:
* docker
* bash
* git

`test.bash` will checkout all dependencies and build containers; no further setup required

### containers
to emulate services and applications, a nodejs runtime will be used

to successfully run test, all testing containers shall include:
* nodejs + npm + chalk package

~~for debugging and introspection purposes, add:~~
* ~~pstree~~
* ~~nano~~
* ~~htop~~
* ~~tmux~~

recommendation is to install `procps` and `psmisc`


## platforms
platforms to test against shall each use a subdirectory in `./platforms`. using `FISSION_PLATFORM` variable to specify platform to test against, will build a docker container with `./platforms/${FISSION_PLATFORM}` as build context and use this container for testing.