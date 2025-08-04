# Diretórios
SRC_MAIN=src/main/java
SRC_CLI=src/cli/java
OUT_LIB=lib
OUT_CLI=cli
OUT_CLASSES=out
TEST_OUT=test
LIB_DIR=lib
JUNIT_JAR=$(LIB_DIR)/j.jar
FORMATTER_JAR=gjf.jar

JACOCO_AGENT_JAR=$(LIB_DIR)/jacocoagent.jar
JACOCO_CLI_JAR=$(LIB_DIR)/jacococli.jar
JACOCO_EXEC=jacoco.jar
JACOCO_REPORT_DIR=coverage-report

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
	mkdir -p $(OUT_CLASSES)
	javac -d $(OUT_CLASSES) $(shell find $(SRC_MAIN) -name "*.java")

# Compilar CLI (Main depende da lib)
.PHONY: cli
cli: lib
	mkdir -p $(OUT_CLI)
	javac -cp $(OUT_CLASSES) -d $(OUT_CLI) $(shell find $(SRC_CLI) -name "*.java")

# Executar CLI
.PHONY: run
run: cli
	java -cp $(OUT_CLI):$(OUT_LIB) org.x96.sys.foundation.io.CLI $(ARGS)

# Compilar e rodar testes
.PHONY: test
test:
	javac -cp $(JUNIT_JAR) -d $(TEST_OUT) $(shell find src -name "*.java")
	java -jar $(JUNIT_JAR) --class-path $(TEST_OUT) --scan-class-path

# Limpeza
.PHONY: clean
clean:
	rm -rf $(OUT_LIB) $(OUT_CLI) $(TEST_OUT) $(DISTRO_JAR) $(CLI_JAR)

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

.PHONY: coverage
coverage: test-with-agent report

.PHONY: test-with-agent
test-with-agent: lib
	javac -cp $(OUT_CLASSES):$(JUNIT_JAR) -d $(TEST_OUT) $(shell find src/test -name "*.java")
	java -javaagent:$(JACOCO_AGENT_JAR)=destfile=$(JACOCO_EXEC) \
	     -cp $(OUT_CLASSES):$(TEST_OUT):$(JUNIT_JAR) \
	     org.junit.platform.console.ConsoleLauncher \
	     --scan-class-path

.PHONY: report
report:
	java -jar $(JACOCO_CLI_JAR) report \
	     $(JACOCO_EXEC) \
	     --classfiles $(OUT_CLASSES) \
	     --sourcefiles $(SRC_MAIN) \
	     --html $(JACOCO_REPORT_DIR) \
	     --name "Coverage Report"
	@echo "HTML report available at $(JACOCO_REPORT_DIR)/index.html"

.PHONY: distro-cli
distro-cli: cli
	echo "Main-Class: org.x96.sys.foundation.io.CLI" > manifest.txt
	jar cfm $(CLI_JAR) manifest.txt -C $(OUT_CLI) . -C $(OUT_LIB) .
	rm manifest.txt

# Downloads
.PHONY: download-junit
download-junit:
	mkdir -p $(LIB_DIR)
	wget https://maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.12.1/junit-platform-console-standalone-1.12.1.jar -O $(JUNIT_JAR)

.PHONY: download-gjf
download-gjf:
	curl -L -o $(FORMATTER_JAR) https://github.com/google/google-java-format/releases/download/v1.28.0/google-java-format-1.28.0-all-deps.jar

.PHONY: download-jacoco
download-jacoco:
	mkdir -p $(LIB_DIR)
	curl -L -o $(JACOCO_CLI_JAR) https://maven.org/maven2/org/jacoco/org.jacoco.cli/0.8.13/org.jacoco.cli-0.8.13-nodeps.jar
	curl -L -o $(JACOCO_AGENT_JAR) https://maven.org/maven2/org/jacoco/org.jacoco.agent/0.8.13/org.jacoco.agent-0.8.13-runtime.jar
