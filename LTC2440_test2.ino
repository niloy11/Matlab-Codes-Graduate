/*  START CODE HERE***********************

Schäfer Code

Version 1.1
13 Sep 2014

This code is written by Stefan Schäfer of Heidelberg University,
Institute of Environmental Physics. This is an open source code and available
for any NON-COMMERCIAL application. Any proposed commercial use of this code is
allowed only with written permission of Stefan Schäfer. Stefan's amateur radio call sign is DK7FC

The Original full code, from which this code below was developed, access to the
Linduino libraries, the use of the LTC Linduino libraries, and LTC license statements can
be found on this LTC page:

http://www.linear.com/solutions/linduino

Download the LTC Linduino libraries here:

Download the Linduino Library (Library only - please follow Quick Start Guide for instructions on install)

This will download a file called LTSketchbook.zip - This file holds all the necessary Arduino
libraries to run this code, below.

We are all extremely grateful for the cooperative work to create this library and code
between Arduino and Linear Technologies. This contribution by Linear Technologies will
enhance the Arduino community and independent developers for many years to come.

This code below was adapted by Stefan Schafer for use on this LTC2440 applications page.

>>> CRITICAL NOTE: To control SDI pin 7, connect the LTC2440 ADC SDI pin 7 to Arduino pin 11 <<<

THIS CODE IS LIMITED TO -0.3  TO +5 VOLTS APPLICATIONS - DO NOT APPLY A MORE NEGATIVE VOLTAGE TO THE ADC
THAN -0.3 VOLTS USING THIS CODE UNLESS THE LTC2440 IS IN FULL DIFFERENTIAL MODE (PINS 5 AND 6 FLOATING).
CLARIFICATION EXAMPLE - A VOLTAGE OF -0.4 VOLTS APPLIED TO PIN 5 (THE ADC INPUT) , WITH PIN 6 GROUNDED ,
CAN DESTROY THE CHIP.

*/

#include <QuikEval_EEPROM.h>            //from Linduino library
#include <LTC2440.h>                             //from Linduino library
#include <UserInterface.h>                     //from Linduino library
#include <LTC24XX_general.h>              //from Linduino library
#include <LT_SPI.h>                                //from Linduino library
#include <Linduino.h>                              //from Linduino library
#include <LT_I2C.h>                                //from Linduino library


#include <Wire.h>                                      // ADD separately from standard ARDUINO LIBRARY
#include <stdint.h>                                   // standard Arduino reference - NO ADD NECESSARY
#include <SPI.h>                                        // standard Arduino reference - NO ADD NECESSARY

static int16_t OSR_mode = LTC2440_OSR_16384; // here type values from 2^6 to 2^15, i.e.: 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768

// NOTE - This ( LTC2440_OSR_128) is the second fastest output rate (samples per socond) possible -- 2000 sample per second - IT IS FAST!!!!!
// Go to  LTC2440_OSR_1024  at (250 SPS) if you need a slower sample rate to start and a lower noise contribution from the ADC.


/*

Each person using this code must establish their priority of noise reduction to sample
output rate. I found the best solution to this decision is to try various combinations
of numbers of samples to be averaged to the final signal to noise ratio required
for the application - it is a trade-off decision. A second noise factor is from the ADC.
The faster you sample, the higher the noise.

EXAMPLE: If you are graphing your data at one point per second you can use an
extremely low ADC noise sample rate, such as LTC2440_OSR_64

ADC output rate.

*/


static float LTC2440_vref = 5.0;                         // Vref is the "reference" voltage supplied to the LTC2440 ADC Pin 2
                                                                             
const int nsamples = 1;                                       // number of data point averages - was 100  which gives lower noise levels
                                                                            //but divides the sample rate by 100!
                                                                        
                                               
/*

GAIN and OFFSET

These variables are used in the form of the linear equation   output =  aX+b   where "a" is "GAIN" and "b" is "OFFSET"

if you are not sure what your ADC output will be, make "GAIN" = 1.0 to start. This gain can be
as high as 10000 or a shift of FIVE decimal places to the left.

If you are not sure if you will need an offset for the ADC output make "OFFSET = 0.0 to start.


(ADC) "Gain" is innitally set at 1.0 and offset is at 0.0. Adjust these values as needed. A typical value
for gain with a 1 uV souce voltage  and  an op amp gain of 1000 would be GAIN = 1000.

These "word" equations might help you to get started:

ADC OUTPUT READING = (SOURCE VOLTS) * (OP AMP GAIN) * (ADC GAIN)  [  = 1.0 in example above ]

OP AMP GAIN = (ADC OUTPUT READING) / [ (ADC GAIN) * (SOURCE VOLTS) ]

SOURCE VOLTS =  ADC OUTPUT READING / [ (OP AMP GAIN) * (ADC GAIN ]

ADC input voltage = (SOURCE VOLTS) * (OP AMP GAIN)  >>> The max safe neg #
of this expression is - 0.250 Volts

*/

float GAIN=1;  
float OFFSET=0;

float Volts_Out=0;  //set initial value to "0"

/*

IMPORTANT NOTE: To control pin 7, remember to connect the LTC2440 ADC SDI pin (pin 7) to Arduino pin 11

*/

void setup()
    {
        quikeval_SPI_init(); // Configure the spi port for 4MHz SCK
        quikeval_SPI_connect(); // Connect SPI to main data port
        Serial.begin(115200); // Initialize and set baud rate for the serial port to the PC
                                               // IF YOU TEST THIS WITH YOUR ARDUINO SERIAL PORT REMEMBER TO SET THE SERIAL PORT TO 115200
    }

void loop()
    { //begin ADC read and output loop

       uint8_t adc_command; // The LTC2440 command word
       int32_t adc_code = 0; // The LTC2440 code
       float adc_voltage = 0; // The LTC2440 voltage
       float adc_summe = 0; // sum of voltages in for-loop
       float adc_average = 0; // averaged voltage after for-loop
       uint16_t miso_timeout = 1000; // Used to wait for EOC
       int i;
       adc_command = OSR_mode; // Build the OSR command code

       for (i=0; i<nsamples; i++)

           { //Begin "for"

                   if(!LTC2440_EOC_timeout(LTC2440_CS, miso_timeout))   // Check for EOC
                       {LTC2440_read(LTC2440_CS, adc_command, &adc_code);   // Throws out reading
                       adc_voltage = LTC2440_code_to_voltage(adc_code, LTC2440_vref);
                   } //End "if"

               adc_summe = adc_summe + adc_voltage;

           } //End "for"

       adc_average = adc_summe / nsamples;          // Get average value over nsamples sum

       Volts_Out = (adc_average)*(GAIN) + OFFSET;      // Allow for linear ADC voltage output calibration
                                                                                           // REMEMBER THAT GAIN IS INITIALLY SET TO 1.0 AND OFFSET IS SET TO 0.0
      
       Serial.println(Volts_Out, 6);                            // Send Arduino Board Output from to serial USB/com port
                                                         // to be read by PC/MAC/LINUX serial read program, input

    } //end ADC read and output loop

// END CODE HERE************************


