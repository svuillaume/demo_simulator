#!/bin/bash
awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $0; fflush(); }' | tee -a /tmp/socat.log
