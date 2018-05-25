PROJ_NAME=blinky
VERSION=0.1.0

STM_DIR = ../STM32F4-Discovery_FW_V1.1.0
STM_SRC = $(STM_DIR)/Libraries/STM32F4xx_StdPeriph_Driver/src

 # Look in $(STM_SRC) if a source file cannot be found
vpath %.c $(STM_SRC)

SRCS = system_stm32f4xx.c stm32f4xx_rcc.c stm32f4xx_tim.c stm32f4xx_gpio.c main.c misc.c \
	   $(STM_DIR)/Libraries/CMSIS/ST/STM32F4xx/Source/Templates/TrueSTUDIO/startup_stm32f4xx.s

COMPILER_TOOLCHAIN_DIR = /usr/bin
ST_LINK_DIR            = ../stlink/bin

CC       = $(COMPILER_TOOLCHAIN_DIR)/arm-none-eabi-gcc
OBJCOPY  = $(COMPILER_TOOLCHAIN_DIR)/arm-none-eabi-objcopy
GDB      = $(COMPILER_TOOLCHAIN_DIR)/arm-none-eabi-gdb
ST_FLASH = $(ST_LINK_DIR)/st-flash.exe

INCLUDES     = -I. -I$(STM_DIR)/Libraries/CMSIS/Include \
               -I$(STM_DIR)/Libraries/CMSIS/ST/STM32F4xx/Include \
               -I$(STM_DIR)/Utilities/STM32F4-Discovery \
               -I$(STM_DIR)/Libraries/STM32F4xx_StdPeriph_Driver/inc
DEFS         = -DUSE_STDPERIPH_DRIVER -DSTM32F4XX -DVERSION=$(VERSION)
WARNINGS     = -Wall -Wextra -Warray-bounds
MACHINE_OPTS = -mlittle-endian -mthumb -mcpu=cortex-m4 \
               -mthumb-interwork -mfloat-abi=hard -mfpu=fpv4-sp-d16

CFLAGS  = -ggdb -std=c99 -O0 $(INCLUDES) $(DEFS) $(WARNINGS) $(MACHINE_OPTS)
LFLAGS  = -Tstm32_flash.ld

