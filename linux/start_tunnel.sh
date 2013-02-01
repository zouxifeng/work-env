#!/bin/sh

# Change vps to the real configuration
ssh -C -f -N -D 7000 vps
