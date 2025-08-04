# Flux

[Implementation of](https://github.com/x96-sys/flux)

## Scripts

### build

```bash
make
```

### build && test

```bash
make test
```

### test and watch

```bash
make watch-test
```

### test and watch specific

```bash
make watch-test-specific TEST_METHOD=org.x96.sys.foundation.io.ByteStreamTest\#happyPerformance
```

### Format

```bash
make format
```

### distro lib

```bash
make distro
```

### distro cli

```bash
make distro-cli
```

### clean

```bash
make clean
```

### Downloads

### junit-platform-console-standalone

```bash
make download-junit
```

### google-java-format

```bash
make download-gjf
```

## CLI

### Usage

```bash
java -jar org.x96.sys.foundation.io.cli.jar 'ceci&sofi'
```

```output
Byte 0: 0x63
Byte 1: 0x65
Byte 2: 0x63
Byte 3: 0x69
Byte 4: 0x26
Byte 5: 0x73
Byte 6: 0x6F
Byte 7: 0x66
Byte 8: 0x69
```

### Accessing specific bytes

```bash
java -jar org.x96.sys.foundation.io.cli.jar 0 'sofi&ceci'
```

```output
Byte 0: 0x73
```

### Underflow

```bash
java -jar org.x96.sys.foundation.io.cli.jar -1 'underflow'
```

```output
🦕 [0xF3]
🐝 [BuzzStreamUnderflow]
🌵 > Access before start.
> Attempted index: -1
```

### Overflow

```bash
java -jar org.x96.sys.foundation.io.cli.jar 9 'overflow'
```

```output
🦕 [0xF2]
🐝 [BuzzStreamOverflow]
🌵 > Access beyond bounds.
> Limit: 7
> Attempted index: 9
```

### Invalid input

```bash
java -jar org.x96.sys.foundation.io.cli.jar 0 ''
```

```output
🦕 [0xF1]
🐝 [BuzzEmptyPayload]
🌵 > ByteStream can not be empty 🙅
```
