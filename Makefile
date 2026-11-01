CC=gcc
CFLAGS = -O0 -Wall -no-pie -fno-stack-protector -fcf-protection=none

all: tp1 tp2 tp3 tp4 tp5 tp6
tp1: tp1.c ; $(CC) $(CFLAGS) -o $@ $<
tp2: tp2.c ; $(CC) $(CFLAGS) -s -o $@ $<
tp3: tp3.c ; $(CC) $(CFLAGS) -o $@ $<
tp4: tp4.c ; $(CC) $(CFLAGS) -s -o $@ $<
tp5: tp5.c ; $(CC) $(CFLAGS) -o $@ $<
tp6: tp6.c
	$(CC) $(CFLAGS) -o $@ $<
	upx --best -q $@

clean: ; rm -f tp1 tp2 tp3 tp4 tp5 tp6

