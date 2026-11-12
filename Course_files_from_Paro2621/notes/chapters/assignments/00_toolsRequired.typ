#import "/setup.typ": *

= Appendix 1: Installation of the required Tools
The tools required to compile and flash programs onto the microcontroller are:
- *Mikrobootloader*: specifically the `mikroe-uhb` Linux utility.
- *MPLAB for Visual Studio Code*: (Alternatively, the standalone MPLAB X IDE can be used).

== Install the Mikrobootloader
The mikroE mikroBootloader software is required to download the firmware onto the board. #link("https://github.com/Paro2621/mikroe-uhb.git")[mikroe-uhb GitHub repository].

// ```shell-unix-generic
//   mkdir installation_folder
//   cd installation_folder
//   git clone https://github.com/Paro2621/mikroe-uhb.git
//   cd mikroe-uhb
//   make && sudo make install
// ```

// + *Clone the repository:*
//   ```bash
//   mkdir installation_folder
//   cd installation_folder
//   git clone https://github.com/thotypous/mikroe-uhb.git
//   cd mikroe-uhb
//   ```

// + *Modify the source files:*
//   Modern Python versions no longer support the `use_2to3` flag in `setuptools`, thus it is needed update the `Makefile` to use Python 3 and comment out the flag in `setup.py`.
//   Open `setup.py` and comment out the `use_2to3` line:

//   ```py
//   setup(
//       name = "mikroe-uhb",
//       version = "0.2",
//       packages = find_packages(exclude=exclusions),
//       install_requires = install_requires,
//       test_suite = "mikroeuhb.tests",
//       scripts = ["mikroe-uhb"],
//       # use_2to3 = True,  <-- COMMENT THIS LINE
//   )
//   ```

// + *Convert and install:*
//   Install the conversion tool, convert the codebase from Python 2 to Python 3, and then build and install the utility.

//   ```bash
//   sudo apt install 2to3
//   2to3 --write --nobackups .
//   make && sudo make install
//   ```

== Install MPLAB in VS Code
In the VS Code Extensions Marketplace it is required to install the #link("https://marketplace.visualstudio.com/items?itemName=Microchip.mplab-extension-pack")[MPLAB extension pack]. For detailed instructions, refer to the #link("https://developerhelp.microchip.com/xwiki/bin/view/software-tools/ides/extensions/get-started/")[MPLAB for Visual Studio Code official guide].

= Appendix 2: Working Pipeline
== Step 1: Create a Workspace and Project

- *Create a workspace folder* and open VS Code in it (run: `code .` from the terminal)

- *Create a new project:*
  Inside VS Code, open the Command Palette (`Ctrl + Shift + P`) and:
  + Select `> MPLAB: Create New Project`
  + Enter the *Project name*
  + Enter the *Project folder* (A new folder for each project in the workspace keeps the structure clean)
  + Select board: `dsPIC33EP512MU810`
  + Select compiler: `XC16`

== Step 2: Switch from Standard Desktop C environment to Embedded C environment
By default, VS Code assumes the user is writing standard desktop C code and uses the system's default GCC compiler. For this reason IntelliSense produces the "file not found" errors when it encounters embedded-specific libraries (like `#include <xc.h>`) and fails to recognize microcontroller hardware registers. 

To fix this, it is required to create/modify the configure VS Code's `c_cpp_properties.json` file to act as an embedded IDE. 

By linking the Microchip XC16 compiler paths and defining our specific dsPIC33 chip model, IntelliSense is enabled to read Microchip's libraries. This eliminates false errors and enables correct syntax highlighting and auto-completion for embedded development.

#grid(
  columns: (1fr, 1fr),
  
  [In short, it must be added to the json file the path to:
  - `xc16/vX.XX/support`
  - `xc16/vX.XX/support/dsPIC33E/h`],
  [That, in Ubuntu, are:
  - `/opt/microchip/xc16/v2.10/include`
  - `/opt/microchip/xc16/v2.10/support/dsPIC33E/h`]
)

#set text(size: 7pt)

#align(center)[
  #table(
    columns: (2fr, 3fr),
    align: left + top,
    fill: (col, row) => if row == 0 { luma(240) } else { none },

    [Standard Desktop C environment], [Embedded C environment],
    
    // Left Column
    ```json
    {
      "configurations": [
        {
          "name": "Linux",
          "includePath": [
            "${workspaceFolder}/**"
          ],
          "defines": [],
          "compilerPath": "/usr/bin/gcc",
          "cStandard": "c17",
          "cppStandard": "gnu++17",
          "intelliSenseMode": "linux-gcc-x64"
        }
      ],
      "version": 4
    }
    ```
    ,
    
    // Right Column
    ```json
{
  "configurations": [
    {
      "name": "Linux",
      "includePath": [
        "${workspaceFolder}/**",
        "/opt/microchip/xc16/v2.10/include", 
        "/opt/microchip/xc16/v2.10/support/dsPIC33E/h"
      ],
      "defines": [
        "__dsPIC33EP512MU810__"
      ],
      "compilerPath": "/opt/microchip/xc16/v2.10/bin/xc16-gcc",
      "cStandard": "c99",
      "intelliSenseMode": "gcc-x64"
    }
  ],
  "version": 4
}
    ```
  )
]

#set text(size: 9pt)
#pagebreak()

*Example of workspace:*\
```
ric@ububu:~/Desktop/Embedded System/Assignments$ tree 
.
└── baseTemplate
    ├── _build
    ├── cmake
    ├── main.c
    ├── out
    │   └── baseTemplate
    │       ├── default.elf
    │       ├── default.hex
    │       └── production
    │           ├── default-production.elf
    │           └── default-production.hex
    └── README.md

41 directories, 40 files```

== Step 3: Build the Project
Once the code is ready, before flashing it into the uC, it must be Build to generate the `.hex` file.

It can be done either, inside VS Code, via:
- the *Build* icon (the hammer) in the MPLAB sidebar,
- the Command Palette:\
  `> MPLAB: Build Project`\
  This will generate your `production.hex` file.

== Step 4: Get product and vendor id
#blueBox("Whenever the board is connected or the reset button is pushed the on-board mantain a 5-second state in wich is ready and waits for an upstream of new data to be copied in the flash memory")

```sh
ric@ububu:~$ sudo lsusb
...
Bus 001 Device 008: ID 2dbc:0001 Mikroelektronika USB HID Bootloader
...
```
We are interested into the `Mikroelektronika USB HID Bootloader`
- Vendor=`0x2dbc` 
- Product=`0x0001`

== Step 5: Flash the Program onto the uC

After building it is possible to flash the binary file on the uC. The `production.hex` file can be found at `ProjectWorkspace/out/baseTemplate/production/default-production.hex`

```sh
sudo mikroe-uhb -v --vendor=0x2dbc --product=0x0001 PATH-TO-production.hex
```
The bootloader allows the flashing of the new firmware only in that 5 seconds window after turning on the uC so, once the flash command has been run, it might be necessary to reboot the board
