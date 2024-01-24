#!/bin/bash
yosys -p "read_verilog processor.v; prep; show -stretch -prefix graph -format dot" &
cp /home/tim/.yosys_show.dot . &
dot -Tpng .yosys_show.dot -o graph.png
