# debugger

a debug container based on `ubuntu:bionic` (`18.04 lts`) with bcc tools, perf, dns utils, strace, and other tools pre-installed, ready to use

## build
```
docker build -t local/debugger .
```

## run
```
docker run --privileged --rm -ti -v $(pwd):/output -v /usr/src:/usr/src:ro -v /lib/modules:/lib/modules:ro -v /sys:/sys -v /proc:/proc  local/debugger
```

## create off cpu flamegraph
```
offcputime -f 5 > /tmp/offcputime ; flamegraph.pl /tmp/offcputime > /output/offcputime.svg
```

### attach to pod and run

to attach to a pod, you will need to know the NS to enter into when running, I published a similar thing on my [blog](https://medium.com/ovni/access-and-debug-your-kubernetes-service-docker-container-988fe33748a) some time ago .. so we'll re-use that example .. 

```
docker ps | grep <POD> | grep -v "pause:"
docker run -ti --privileged \
  --pid=container:<CONTAINER_ID> \
  --net=container:<CONTAINER_ID> \
  -v $(pwd):/output \
  -v /usr/src:/usr/src:ro \
  -v /lib/modules:/lib/modules:ro \
  -v /sys:/sys \
  -v /proc:/proc
```

then create the flamegraph, or use any other `bcc` tools (readily available in your PATH, or go to `/usr/share/bcc/tools/`)
```
offcputime -f 5 > /tmp/offcputime ; flamegraph.pl /tmp/offcputime > /output/offcputime.svg
```
