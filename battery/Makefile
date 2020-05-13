all: wd009-battery

wd009-battery: wd009-battery.o ./linux/i2c-dev.h
	$(CC) -o wd009-battery wd009-battery.c linux/i2c-dev.h

install: