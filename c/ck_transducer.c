#include "ck_transducer.h"

int transmit(pin transducer, int pulseLength, int pulseFrequency, int burstDuration, int ISI, int totalTime){
   int pulseCycle = 1000/pulseFrequency;
   int pulseSleep = pulseCycle - pulseLength;
   for(int i = 0; i < totalTime/(burstDuration+ISI); i++){
       for(int j = 0; j < burstDuration/pulseCycle; j++){
           ON(transducer);
           SLEEP(pulseLength);
           OFF(transducer);
           SLEEP(pulseSleep);
       }
       SLEEP(ISI);
   }
   return 1;
}
