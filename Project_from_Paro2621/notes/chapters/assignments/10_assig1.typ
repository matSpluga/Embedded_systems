#import "/setup.typ": *

#pagebreak()
= Assignment 1: PinMode

Objective: 

Steps:
+ [step 1] create `assignment1_pushButton` folder in the workSpace
+ [step 2] modify `c_cpp_properties.json` to specify XC16 compiler and the path to its libraries 
+ _write the code_
+ [step 4] build the project (Hammer icon, production option)
+ [step 5] upload the code

To upload the code from the VS Code terminal (from the folder `out/assignment1_pushButton/production`):
```shell-unix-generic
sudo mikroe-uhb -v --vendor=0x2dbc --product=0x0001 default-production.hex
```

== pushButton
#set text(size: 8pt)
```c
#include <xc.h>

int main(void) {
    // disable all Analog pins
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

    // --- setup ---
    TRISAbits.TRISA0 = 0;   // set the pin as output
    TRISEbits.TRISE8 = 1;   // set the pin as input
    
    // --- infinite loop ---
    while(1) {
        if(PORTEbits.RE8 == 0){ // 0 -> true
            LATAbits.LATA0 = 1; // Turn LED ON
        } else {
            LATAbits.LATA0 = 0; // Turn LED OFFs
        }
    }
    return 0; 
}
```
#set text(size: 9pt)

== switchButton w/ debouncing in buisywaiting
#set text(size: 8pt)
```c
#include <xc.h>
#define LED_ON  1
#define LED_OFF 0

#define isPushed 0

int main(void) {
  // disable all Analog pins
  ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

  // --- setup ---
  TRISAbits.TRISA0 = 0;   // set the pin as output
  TRISEbits.TRISE8 = 1;   // set the pin as input

  int LedState = LED_ON;
  
  // --- infinite loop ---
  while(1) {
    if(PORTEbits.RE8 == isPushed){ // 0 -> true
    if(LedState == LED_ON){
      LATAbits.LATA0 = LED_OFF; // Turn LED OFFs
      LedState = LED_OFF;
    } else {
      LATAbits.LATA0 = LED_ON; // Turn LED OFFs
      LedState = LED_ON;
    }

    for(int i=0; i<10000; i++){
        for(int j=0; j<1000; j++){}
      }
    }
  }
  return 0; 
}
```
#set text(size: 9pt)




// gitignore:
// - gitignore di mplab per pushare file importanti
//   ```exclude
//   *.d
//   *.pre
//   *.p1
//   *.lst
//   *.sym
//   *.obj
//   *.o
//   *.sdb
//   *.obj.dmp
//   *.mk
//   *.map
//   *.properties
//   *.production
//   *.debug
//   html/
//   nbproject/private/
//   nbproject/Package-*.bash
//   build/
//   nbbuild/
//   dist/
//   nbdist/
//   nbactions.xml
//   nb-configuration.xml
//   funclist
//   nbproject/Makefile-*
//   disassembly/
//   .generated_files/
//   ```