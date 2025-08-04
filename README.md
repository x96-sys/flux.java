# Flux

[Implementation of](https://github.com/x96-sys/flux)

## Scripts

### build

```bash
make
```

### distro

```bash
make distro
```

### build && test

```bash
make test
```

### clean

```bash
make clean
```

### Format

```bash
make format
```

### test and watch

```bash
make watch-test
```

### test and watch specific

```bash
make watch-test-specific
make watch-test-specific TEST_METHOD=org.x96.sys.foundation.io.ByteStreamTest\#happyPerformance
```

### Downloads

### junit-platform-console-standalone

```bash
mkdir lib
wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.12.1/junit-platform-console-standalone-1.12.1.jar -O lib/j.jar
```

### google-java-format

```bash
curl -L -o gjf.jar https://github.com/google/google-java-format/releases/download/v1.28.0/google-java-format-1.28.0-all-deps.jar
```
