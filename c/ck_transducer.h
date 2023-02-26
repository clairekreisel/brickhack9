#ifndef ck_transducer_h
#define ck_transducer_h
#include "ck_embedUtil.h"

int transmit(pin transducer, int pulseLength, int pulseFrequency, int burstDuration, int ISI, int totalTime);
#endif
