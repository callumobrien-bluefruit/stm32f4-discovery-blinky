#include "stm32f4xx.h"
#include "stm32f4_discovery.h"

#define PAUSE 4000000L

GPIO_InitTypeDef gpioInitOptions;

static void setupLed(void);
static void pause(uint32_t);

int
main()
{
   setupLed();

   while (1)
   {
      GPIO_ToggleBits(GPIOD, LED4_PIN);
      pause(PAUSE);
   }
}

static void 
setupLed()
{
   RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);
   
   gpioInitOptions.GPIO_Pin   = LED4_PIN;
   gpioInitOptions.GPIO_Mode  = GPIO_Mode_OUT;
   gpioInitOptions.GPIO_Speed = GPIO_Speed_50MHz;
   gpioInitOptions.GPIO_OType = GPIO_OType_PP;
   gpioInitOptions.GPIO_PuPd  = GPIO_PuPd_NOPULL;

   GPIO_Init(GPIOD, &gpioInitOptions);
}

static void
pause(uint32_t count)
{
   for (uint32_t i = 0; i < count; i++)
      ;
}

