#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Fri Apr 29 21:55:53 IST 2022
# SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto e8794abb577c43ac915ccf520d15d4b0 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot DesignFile_behav xil_defaultlib.DesignFile -log elaborate.log"
xelab -wto e8794abb577c43ac915ccf520d15d4b0 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot DesignFile_behav xil_defaultlib.DesignFile -log elaborate.log
