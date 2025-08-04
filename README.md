# Flux

Java implementation of the [Flux](https://github.com/x96-sys/flux) byte stream
processing library.

## About

Flux is a Java library that provides efficient byte stream processing with
comprehensive error handling. It includes both a library component and a
command-line interface (CLI) for interactive byte manipulation.

## Features

- **ByteStream**: Core byte stream processing with bounds checking
- **Buzz Error System**: Comprehensive error handling with specific exception
  types
- **CLI Interface**: Interactive command-line tool for byte inspection
- **Full Test Coverage**: Comprehensive test suite with JaCoCo coverage
  reporting

## Quick Start

### Prerequisites

- Java 8 or higher
- Make (for build automation)

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

### coverage report

```bash
make coverage
```

### test and watch specific

```bash
make watch-test-specific TEST_METHOD=org.x96.sys.foundation.io.ByteStreamTest\#happyPerformance
```

### format

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

### release management

#### bake version

```bash
make version
```

### downloads dependencies

#### junit-platform-console-standalone

```bash
make download-junit
```

#### google-java-format

```bash
make download-gjf
```

#### JaCoCo (coverage reporting)

```bash
make download-jacoco
```

## Library Usage

### Core Components

The Flux library provides several key components:

- **ByteStream**: Main class for byte stream operations
- **Buzz**: Base exception class for error handling
- **BuzzEmptyPayload**: Exception for empty stream operations
- **BuzzStreamOverflow**: Exception for out-of-bounds access (beyond end)
- **BuzzStreamUnderflow**: Exception for out-of-bounds access (before start)

### Example

```java
import org.x96.sys.foundation.io.ByteStream;
import org.x96.sys.foundation.buzz.Buzz;

public class Example {
    public static void main(String[] args) {
        try {
            ByteStream stream = ByteStream.raw("Hello".getBytes());

            // Access bytes safely
            for (int i = 0; i < stream.length(); i++) {
                int value = stream.at(i);
                System.out.printf("Byte %d: 0x%X%n", i, value);
            }
        } catch (Buzz e) {
            System.err.println("Error: " + e.getMessage());
        }
    }
}
```

## CLI

The Flux CLI provides an interactive way to inspect byte streams from the
command line.

### Installation

Build the CLI executable:

```bash
make distro-cli
```

This creates `org.x96.sys.foundation.io.cli.jar`.

### Usage

#### Display version

```bash
java -jar org.x96.sys.foundation.io.cli.jar -v
```

```output
Flux CLI v1.0.0
```

#### Process entire string

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

### Error Handling

The CLI provides detailed error messages for various scenarios:

#### Underflow

```bash
java -jar org.x96.sys.foundation.io.cli.jar -1 'underflow'
```

```output
🦕 [0xF3]
🐝 [BuzzStreamUnderflow]
🌵 > Access before start.
> Attempted index: -1
```

#### Overflow

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

#### Empty payload

```bash
java -jar org.x96.sys.foundation.io.cli.jar 0 ''
```

```output
🦕 [0xF1]
🐝 [BuzzEmptyPayload]
🌵 > ByteStream can not be empty 🙅
```
