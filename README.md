serhex
=================

C library to for sending stand-alone serial port commands and reading responses

### Requirements

In order for the CLI to work, the serial port must be active (only tested with USB CDC compliant ports)

### Compiling
 
#### from source

`make`

#### to create a library
This step isn't needed if you only want the executable. It just creates the library with a C API for inclusion into other sources.

From the repo directory

    ```
    # make the library, `make` will also create a library by default
    make lib
    

### Using `serhex`

 Compile and Install:
 
    make
    sudo make install

 Command format:

     serhex <serial port> <bytes to send (in hex)>
     #=> <serial port response (in hex)>
 
 For example, with a RadBeacon 2.x on a serial port of `/dev/cu.usbmodem1`, the `Ping` command is
 
    serhex /dev/cu.usbmodem1 03
    #=>
    <... Logging data (if enabled) ...>
    Response from send_cmd: 08 fe 11 30 30 30 37 38 30

Some basic RadBeacon Hex commands and responses

03: Ping - check for connection

    bin/serhex 03
    #=> 08 fe 11 <data>
    08 - Message length in bytes
    fe - Status (ff is Error)
    10 - Status Code indicating hex data is being returned
    <6 byte device ID>

04: Echo - repy with the data provided

    bin/serhex /dev/cu.usbmodem1 041122334455667788
    #=> 0a fe 10 11 22 33 44 55 66 77 88
    0a - Message length in bytes
    fe - Status (ff is Error)
    10 - Status Code indicating hex data is being returned
    1122334455667788 - echoed data

05: DFU (reset the Dongle so the firmware can be reflashed)

    bin/serhex /dev/cu.usbmodem1 05
    #=> 02 ff 30   (Error)
    02 - Message length in bytes
    ff - Status (ff is Error)
    30 - Status Code: Invalid PIN

    bin/serhex /dev/cu.usbmodem1 0500000000  #00000000 is an invalid pin
    #=> 02 ff 30   (Error)
    02 - Message length in bytes
    ff - Error
    30 - Invalid PIN


    bin/serhex /dev/cu.usbmodem1 05 [4 byte pin] 
    02 - Message length in bytes
    fe - Status (ff is Error)
    01 - Status Code: Entered DFU mode

Other commands

    bin/serhex /dev/cu.usbmodem1 10[4 byte pin][16 byte UUID] # set UUID
    bin/serhex /dev/cu.usbmodem1 11[4 byte pin][2 byte Major Id] # set Major
    bin/serhex /dev/cu.usbmodem1 12[4 byte pin][2 byte Minor Id] # set Minor
    bin/serhex /dev/cu.usbmodem1 20[4 byte pin][1 byte tx power level 00-0f] # set tx power
    bin/serhex /dev/cu.usbmodem1 21[4 byte pin][2 byte advertise interval 0050-0320] # set adv interval
    bin/serhex /dev/cu.usbmodem1 30[4 byte pin][24 byte text name] # set friendly name
    bin/serhex /dev/cu.usbmodem1 31[4 byte pin]0 # get uuid, major, minor, adv pwr
    bin/serhex /dev/cu.usbmodem1 31[4 byte pin]1 # get device model, device id
    bin/serhex /dev/cu.usbmodem1 31[4 byte pin]2 # get device name
    bin/serhex /dev/cu.usbmodem1 31[4 byte pin]3 # get mac address, adv preamble, tx power, adv interval, lock state (connectable)
    bin/serhex /dev/cu.usbmodem1 40[4 byte orig pin][4 byte new pin][4 byte new pin confirm] # change pin
    bin/serhex /dev/cu.usbmodem1 41[4 byte pin] # Lock (unable to change params via Bluetooth until reboot) 


#### Create shared and/or static library

`make lib`

Libraries are in `\lib` directory

#### Set up Logging

 Set up an environmental variable with the log level desired:
     
     export RBLOG_LEVEL=RBLOG_DEBUG
 
 Then run `serhex` normally.
 
 Log level names:
 
     RBLOG_DEBUG
     RBLOG_INFO
     RBLOG_WARN
     RBLOG_ERROR  (Default)