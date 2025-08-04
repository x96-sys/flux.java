# Diretórios
SRC_MAIN=src/main/java
SRC_CLI=src/cli/java
OUT_LIB=lib
OUT_CLI=cli
TEST_OUT=test
LIB_DIR=lib
JUNIT_JAR=$(LIB_DIR)/j.jar
FORMATTER_JAR=gjf.jar

# Artefato distribuível
DISTRO_JAR=org.x96.sys.foundation.io.jar

# Empacotar a CLI em um JAR executável
CLI_JAR=org.x96.sys.foundation.io.cli.jar

# Default
.PHONY: all
all: lib cli

# Compilar a lib (sem Main)
.PHONY: lib
lib:
	mkdir -p $(OUT_LIB)
	javac -d $(OUT_LIB) $(shell find $(SRC_MAIN) -name "*.java")

# Compilar CLI (Main depende da lib)
.PHONY: cli
cli: lib
	mkdir -p $(OUT_CLI)
	javac -cp $(OUT_LIB) -d $(OUT_CLI) $(shell find $(SRC_CLI) -name "*.java")

# Executar CLI
.PHONY: run
run: cli
	java -cp $(OUT_CLI):$(OUT_LIB) org.x96.sys.foundation.io.CLI

# Compilar e rodar testes
.PHONY: test
test:
	javac -cp $(JUNIT_JAR) -d $(TEST_OUT) $(shell find src -name "*.java")
	java -jar $(JUNIT_JAR) --class-path $(TEST_OUT) --scan-class-path

# Limpeza
.PHONY: clean
clean:
	rm -rf $(OUT_LIB) $(OUT_CLI) $(TEST_OUT) $(DISTRO_JAR) "*.jar"

# Formatador
.PHONY: format
format:
	find src -name "*.java" -print0 | xargs -0 java -jar $(FORMATTER_JAR) --aosp --replace

# Empacotar a lib
.PHONY: distro
distro: lib
	jar cf $(DISTRO_JAR) -C $(OUT_LIB) .

# Teste com watch
.PHONY: watch-test
watch-test:
	find . -name "*.java" | entr -c bash -c 'clear && make test'

# Watch de teste específico
.PHONY: watch-test-specific
watch-test-specific:
	find . -name "*.java" | entr -c bash -c '\
		javac -cp $(JUNIT_JAR) -d $(TEST_OUT) $(shell find src -name "*.java") && \
		java -jar $(JUNIT_JAR) \
			--class-path $(TEST_OUT) \
			--select "method:$(TEST_METHOD)"'

.PHONY: distro-cli
distro-cli: cli
	echo "Main-Class: org.x96.sys.foundation.io.CLI" > manifest.txt
	jar cfm $(CLI_JAR) manifest.txt -C $(OUT_CLI) . -C $(OUT_LIB) .
	rm manifest.txt

# Downloads
.PHONY: download-junit
download-junit:
	mkdir -p $(LIB_DIR)
	wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.12.1/junit-platform-console-standalone-1.12.1.jar -O $(JUNIT_JAR)

.PHONY: download-gjf
download-gjf:
	curl -L -o $(FORMATTER_JAR) https://github.com/google/google-java-format/releases/download/v1.28.0/google-java-format-1.28.0-all-deps.jar
