#!/bin/sh

# occupies file descriptor 127 (0,1,2 occupied per deault; 255 by bash; 10 by ash and friends)

# create FIFO to be used as "anonymous pipe"
# attach to file descriptor 9
# remove fifo link as cleanup step
# file descriptor will stay open as long as the shell
#------------------------------------------------------
PIPE=$(mktemp -u fifo.XXXXXX)
mkfifo ${PIPE}
exec 127<>${PIPE}
rm ${PIPE}
#------------------------------------------------------

# redirect stderr to anonymous pipe
# CREATES LOOP!
# exec 2>&127

# attach tee to pipe in background
# forward to /dev/stderr and process' stdout
tee /dev/stderr <&127 &

# exec command
{
        while true; do
                sleep 1
                echo '[stdout] foo'
                echo '[stderr] bar' >&2
        done;
} 2>&127