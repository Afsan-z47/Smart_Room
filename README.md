Digital Smart Room
==================

A System Verilog implementation

Specifications
==============

- Control the number of people entering/exiting using two switches (Switch A and B). Switch A will increase, and Switch B will decrease the count.
- Display current person-count on 7-segment display.
- The number of lights (Green LEDs) and fans (Red LEDs) turned
on in the room should be half of the total number of people inside.
- Trigger “room full” LED if more than 10 people.
- Show the energy usage in another 7-segment display.
- Energy usage will be controlled by a counter or a clock. Its speed will be proportional to the current person-count.

Required
================================================
Yosys, iverilog, vvp, gtkwave (for .vcd files)

Running
=============

To run the test bench:
```bash
yosys synth.ys
iverilog -o sim.vvp tb.sv smart_room_netlist.sv
vvp sim.vvp
```
To see clock waves?
```bash
gtkwave smart_room.vcd
```
