#include "stm32f4xx.h"
#include "stm32f4_discovery.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_rcc.h"
#include "stm32f4xx_tim.h"
#include "misc.h"

void setupLed(void);
void setupInterrupt(void);

int
main()
{
   setupLed();
   setupInterrupt();

   while (1)
      ;
}

void
TIM2_IRQHandler()
{
   if (TIM_GetITStatus(TIM2, TIM_IT_Update)) {
      GPIO_ToggleBits(GPIOD, LED4_PIN);
      TIM_ClearITPendingBit(TIM2, TIM_IT_Update);
   }
}

void 
setupLed()
{
   GPIO_InitTypeDef gpioInitOptions;

   RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);
   
   gpioInitOptions.GPIO_Pin   = LED4_PIN;
   gpioInitOptions.GPIO_Mode  = GPIO_Mode_OUT;
   gpioInitOptions.GPIO_Speed = GPIO_Speed_50MHz;
   gpioInitOptions.GPIO_OType = GPIO_OType_PP;
   gpioInitOptions.GPIO_PuPd  = GPIO_PuPd_NOPULL;

   GPIO_Init(GPIOD, &gpioInitOptions);
   GPIO_ResetBits(GPIOD, LED4_PIN);
}

void
setupInterrupt()
{
   TIM_TimeBaseInitTypeDef timerInitOptions;
   NVIC_InitTypeDef nvicInitOptions;

   RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM2, ENABLE);

   timerInitOptions.TIM_Prescaler         = 4199;
   timerInitOptions.TIM_CounterMode       = TIM_CounterMode_Up;
   timerInitOptions.TIM_Period            = 999;
   timerInitOptions.TIM_ClockDivision     = TIM_CKD_DIV1;
   timerInitOptions.TIM_RepetitionCounter = 0;

   TIM_TimeBaseInit(TIM2, &timerInitOptions);
   TIM_ITConfig(TIM2, TIM_IT_Update, ENABLE);
   TIM_Cmd(TIM2, ENABLE);

   nvicInitOptions.NVIC_IRQChannel                   = TIM2_IRQn;
   nvicInitOptions.NVIC_IRQChannelPreemptionPriority = 0;
   nvicInitOptions.NVIC_IRQChannelSubPriority        = 0;
   nvicInitOptions.NVIC_IRQChannelCmd                = ENABLE;

   NVIC_Init(&nvicInitOptions);
}

