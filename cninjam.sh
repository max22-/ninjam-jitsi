#!/bin/bash
cninjam localhost -jack -user anonymous:cninjam &> /home/ninjam/log.txt
echo "Process cninjam exited with error code $?" | tee -a /home/ninjam/log.txt