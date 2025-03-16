#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <errno.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>


int usage() {
	fprintf(stderr,
			"Usage: acpi-ec-rw <register [value]>\n"
			"\n"
			"where:\n"
			"   register - hex register (byte or word, ex: 0x13)\n"
			"   value    - hex value (byte, ex: 0xFF)\n"
			"\n"
			"Examples:\n"
			"   acpi-ec-rw 0x3F    - read byte from register 0x3F\n"
			"   acpi-ec-rw E5 25   - write byte 25 (dec) to register 0xE5\n"
			"\n"
			"examine acpi-ec-rw exit code to check execution result (0 = ok)\n"
	       );

	return -1;
}

#define ACPI_EC_DEVICE "/dev/ec"

int str2byte(char *str, uint8_t *byte) {
	size_t len = strlen(str);
	long val;
	char *end = str;

	// hex number: 0xA or 0xAB
	if ((len == 3 || len == 4) && strstr(str, "0x") == str)
		val = strtol(str + 2, &end, 16);
	// dec number, non-negative: 0, 12, 123
	else if ((len >= 1 && len <= 3) && isdigit(*str) && (len >= 2 && *str != '0')) 
		val = strtol(str, &end, 10);
	else
		return 0;

	if (*end == '\0') {
		*byte = (uint8_t)val;
		return 1;
	}

	return 0;
}

int ec_read(char *reg) {
	uint8_t ec_reg, ec_val;
	int fd;
	int res = 0;

	if (! str2byte(reg, &ec_reg)) {
		fprintf(stderr, "invalid argument format: %s\n", reg);
		return -1;
	}

	fd = open(ACPI_EC_DEVICE, O_RDONLY);
	if (fd == -1) {
		fprintf(stderr, ACPI_EC_DEVICE" open failed: %s\n", strerror(errno));
		return -1;
	}

	if (res = pread(fd, &ec_val, sizeof(ec_val), ec_reg), res == -1) {
		fprintf(stderr, ACPI_EC_DEVICE" read failed: %s\n", strerror(errno));
		goto failed;
	}

	printf("0x%02x: 0x%02x (%3d)\n", ec_reg, ec_val, ec_val);

failed:
	close(fd);
	return (res <= 0);
}

int ec_write(char *reg, char *val) {
	uint8_t ec_reg, ec_val, ec_old_val;
	int fd;
	int res = 0;

	if (! str2byte(reg, &ec_reg)) {
		fprintf(stderr, "invalid argument format: %s\n", reg);
		return -1;
	}

	if (! str2byte(val, &ec_val)) {
		fprintf(stderr, "invalid argument format: %s\n", val);
		return -1;
	}

	fd = open(ACPI_EC_DEVICE, O_RDWR);
	if (fd == -1) {
		fprintf(stderr, ACPI_EC_DEVICE" open failed: %s\n", strerror(errno));
		return -1;
	}

	if (res = pread(fd, &ec_old_val, sizeof(ec_old_val), ec_reg), res == -1) {
		fprintf(stderr, ACPI_EC_DEVICE" read failed: %s\n", strerror(errno));
		goto failed;
	}

	if (res = pwrite(fd, &ec_val, sizeof(ec_val), ec_reg), res == -1) {
		fprintf(stderr, ACPI_EC_DEVICE" write failed: %s\n", strerror(errno));
		goto failed;
	}

	// verify
	if (res = pread(fd, &ec_val, sizeof(ec_val), ec_reg), res == -1) {
		fprintf(stderr, ACPI_EC_DEVICE" read failed: %s\n", strerror(errno));
		goto failed;
	}

	printf("0x%1$02x: 0x%2$02x (%2$3d) => 0x%3$02x (%3$3d)\n", ec_reg, ec_old_val, ec_val);

failed:
	close(fd);
	return (res <= 0);
}

int main(int argc, char *argv[]) {

	if (argc == 2)
		return ec_read(argv[1]);
	else if (argc == 3)
		return ec_write(argv[1], argv[2]);

	return usage();
}

