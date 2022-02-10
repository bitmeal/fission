# emilia pinnbal example

run emilia pinnbal in container with `Xvfb`, `x11vnc` and `novnc` as web vnc client.

* build: `docker build -t fission:emilia .`
* run: `docker run --rm -p 8080:8080 fission:emilia`
* open: [http://localhost:8080/](http://localhost:8080/)
