#!/bin/bash

# str -> ___s_t_r___ (underline and surround with ___)
echo -e "___\e[4m$1\e[0m___" #surround with POSIX chars
