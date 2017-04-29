#!/bin/bash


run() {
    # Rename cygwin ping to fallback to Windows ping.exe as work-around
    # for administrative privileges required for cygwin ping

    local _ping='/usr/bin/ping.exe'
    local cygping='/usr/bin/cygping.exe'

    if [ ! -f $cygping ]; then
        mv $_ping $cygping
    fi
}

run
