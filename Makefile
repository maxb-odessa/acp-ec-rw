
all: acpi-ec-rw.c
	$(CC) -Wall -ggdb acpi-ec-rw.c -o acpi-ec-rw

install: acpi-ec-rw
	cp -f acpi-ec-rw /usr/local/sbin && chmod 700 /usr/local/sbin/acpi-ec-rw

uninstall: /usr/local/sbin/acpi-ec-rw
	rm -f /usr/local/sbin/acpi-ec-rw

clean:
	rm -f acpi-ec-rw acpi-ec-rw.o core.*
