#ifndef CK_EMBEDUTIL_H
#define CK_EMBEDUTIL_H

typedef struct ck_pin pin;

void ON(pin toActivate);

void OFF(pin toDeactivate);

void SLEEP(int ms);
#endif
