include config.mk

# Look in $(STM_SRC) if a source file cannot be found
vpath %.c $(STM_SRC)

all: options $(PROJ_NAME)

options:
	@echo :: Build options for $(PROJ_NAME)-$(VERSION) :::::::::::::::::::::::::::::::::::
	@echo "STM_DIR     = $(STM_DIR)"
	@echo
	@echo "CC          = $(CC)"
	@echo "OBJCOPY     = $(OBJCOPY)"
	@echo "ST_FLASH    = $(ST_FLASH)"
	@echo
	@echo "CFLAGS      = $(CFLAGS)"
	@echo "LFLAGS      = $(LFLAGS)"
	@echo

$(PROJ_NAME): $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin

$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

$(PROJ_NAME).hex: $(PROJ_NAME).elf
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf   $(PROJ_NAME).hex

$(PROJ_NAME).bin: $(PROJ_NAME).elf
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin $(PROJ_NAME)-*.txz

dist: clean
	mkdir $(PROJ_NAME)-$(VERSION)
	cp -R Makefile config.mk stm32_flash.ld *.c *.h $(PROJ_NAME)-$(VERSION)
	tar czf $(PROJ_NAME)-$(VERSION).txz $(PROJ_NAME)-$(VERSION)
	rm -rf $(PROJ_NAME)-$(VERSION)

flash: $(PROJ_NAME).bin
	$(ST_FLASH) write $(PROJ_NAME).bin 0x8000000

.PHONY: all options $(PROJ_NAME) clean dist flash
