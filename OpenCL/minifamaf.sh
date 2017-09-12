#!/bin/bash

if [ "$1" == '1' ]; then
    ssh adc201519@mini.famaf.unc.edu.ar
elif [ "$1" == '2' ]; then
    scp $2 adc201519@mini.famaf.unc.edu.ar:
elif [ "$1" == '3' ]; then
    scp adc201519@mini.famaf.unc.edu.ar:$2 /home/mef0113/Escritorio/OPENCL
fi
