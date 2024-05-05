# FSM
This project constructs an FSM using VHDL and implementing this to the Zybo-Z7 development board. This FSM will act like an alarm system and will have several states depending on its inputs.

## Description
For this project I constructed an FSM diagram. This FSM layout will help understand how the FSM works when implemented to the board. The diagram contains an initial state of lock, then states 1 through 3 which pass through a series of inputs which are “S W E W” from here the alarm is unlocked and is placed back to its initial state. From here I also have a wrong state which will set off the alarm and will only reset if “W E” is pressed. Finally, I have a reset stage which is activated when “E” is pressed and has several conditions when passing through the reset stage. The reset stage is activated by the “E” input through each stage I then tested through simulation as well as through implementation of the board.


## Demo Video
https://www.youtube.com/watch?v=pzCCoFQIVmk

## Dependencies
## Hardware
* https://digilent.com/reference/programmable-logic/zybo-z7/start

### Software
* https://www.xilinx.com/products/design-tools/vivado.html

### Author
* Steven Hernandez
  - www.linkedin.com/in/steven-hernandez-a55a11300
  - https://github.com/stevenhernandezz
