# Flux

[Implementation of](https://github.com/x96-sys/flux)

## Scripts

### build

```bash
javac -d run $(find src/main -name "*.java")
```

### distro

```bash
jar cf org.x96.sys.foundation.io.jar -C run .
```

### build && test

```bash
javac -cp lib/j.jar -d test $(find src -name "*.java") && java -jar lib/j.jar --class-path test --scan-class-path
```

### clean

```bash
rm -rf lib run test "*.jar"
```

### Format

```bash
java -jar gjf.jar --aosp --replace src/**/*.java
```

### test and watch

```bash
find . -name "*.java" | entr -c bash -c 'clear && javac -cp lib/j.jar -d test $(find src -name "*.java") && java -jar lib/j.jar --class-path test --scan-class-path'
```

### test and watch specific

```bash
find . -name "*.java" | entr -c bash -c ' javac -cp lib/j.jar -d test $(find src -name "*.java") &&
java -jar lib/j.jar \
  --class-path test \
  --select "method:org.x96.sys.foundation.io.ByteStreamTest#happySlowPerformance"
'
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
