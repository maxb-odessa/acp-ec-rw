A simple utility to read/write ec registers via /dev/ec interface provided by acpi-ec kernel module.

```
Usage: acpi-ec-rw <register [value]>

where:
register - hex or dec register (byte, ex: 123)
value    - hex or dec value (byte, ex: 0xFF)

Examples:
acpi-ec-rw 0x3F    - read byte from register 0x3F
acpi-ec-rw 0xe5 25 - write byte 25 (dec) to register 0xE5

examine acpi-ec-rw exit code to check execution result (0 = ok)
```
