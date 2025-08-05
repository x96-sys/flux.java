VERSION=$(shell git describe --tags --always)
VERSION_FLUX_JAVA_FILE=src/main/java/org/x96/sys/foundation/io/Flux.java

# Use git version or fallback
FLUX_VERSION=$(if $(VERSION),$(VERSION),dev)

# Diretórios
SRC_MAIN=src/main/java
SRC_CLI=src/cli/java
OUT_LIB=lib
OUT_CLI=cli
OUT_CLASSES=out
TEST_OUT=test
LIB_DIR=lib
JUNIT_JAR=$(LIB_DIR)/j.jar

TOOLS_DIR=tools
FORMATTER_JAR=$(TOOLS_DIR)/gjf.jar

JACOCO_AGENT_JAR=$(LIB_DIR)/jacocoagent.jar
JACOCO_CLI_JAR=$(LIB_DIR)/jacococli.jar
JACOCO_EXEC=$(TOOLS_DIR)/jacoco.jar
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
lib: version
	@mkdir -p $(OUT_CLASSES)
	@SRC_FILES="$$(find $(SRC_MAIN) -name '*.java')"; \
	NEEDS_BUILD=0; \
	for f in $$SRC_FILES; do \
	  CLASS_PATH=$$(echo $$f | sed "s|^$(SRC_MAIN)|$(OUT_CLASSES)|" | sed 's|\.java$$|.class|'); \
	  if [ ! -e $$CLASS_PATH ] || [ $$f -nt $$CLASS_PATH ]; then \
	    NEEDS_BUILD=1; \
	    break; \
	  fi; \
	done; \
	if [ $$NEEDS_BUILD -eq 1 ]; then \
	  echo "[lib] Compiling sources..."; \
	  javac -d $(OUT_CLASSES) $$SRC_FILES; \
	else \
	  echo "[lib] Up to date."; \
	fi

# Compilar CLI (Main depende da lib)
.PHONY: cli
cli: lib
	@mkdir -p $(OUT_CLI)
	@SRC_FILES="$$(find $(SRC_CLI) -name '*.java')"; \
	NEEDS_BUILD=0; \
	for f in $$SRC_FILES; do \
	  CLASS_PATH=$$(echo $$f | sed "s|^$(SRC_CLI)|$(OUT_CLI)|" | sed 's|\.java$$|.class|'); \
	  if [ ! -e $$CLASS_PATH ] || [ $$f -nt $$CLASS_PATH ]; then \
	    NEEDS_BUILD=1; \
	    break; \
	  fi; \
	done; \
	if [ $$NEEDS_BUILD -eq 1 ]; then \
	  echo "[cli] Compiling CLI sources..."; \
	  javac -cp $(OUT_CLASSES) -d $(OUT_CLI) $$SRC_FILES; \
	else \
	  echo "[cli] Up to date."; \
	fi

# Executar CLI
.PHONY: run
run: cli
	java -cp $(OUT_CLI):$(OUT_CLASSES) org.x96.sys.foundation.io.CLI $(ARGS)

# Compilar e rodar testes
.PHONY: test
test: lib download-junit
	@mkdir -p $(TEST_OUT)
	@SRC_FILES="$$(find src/test -name '*.java')"; \
	NEEDS_BUILD=0; \
	for f in $$SRC_FILES; do \
	  CLASS_PATH=$$(echo $$f | sed "s|^src/test/java|$(TEST_OUT)|" | sed 's|\.java$$|.class|'); \
	  if [ ! -e $$CLASS_PATH ] || [ $$f -nt $$CLASS_PATH ]; then \
	    NEEDS_BUILD=1; \
	    break; \
	  fi; \
	done; \
	if [ $$NEEDS_BUILD -eq 1 ]; then \
	  echo "[test] Compiling test sources..."; \
	  javac -cp $(OUT_CLASSES):$(JUNIT_JAR) -d $(TEST_OUT) $$SRC_FILES; \
	else \
	  echo "[test] Up to date."; \
	fi
	@java -jar $(JUNIT_JAR) --class-path $(OUT_CLASSES):$(TEST_OUT) --scan-class-path

# Limpeza
.PHONY: clean
clean:
	rm -rf $(OUT_LIB) $(OUT_CLI) $(TEST_OUT) $(DISTRO_JAR) $(CLI_JAR)
	rm -rf $(VERSION_FLUX_JAVA_FILE) $(JACOCO_REPORT_DIR) $(OUT_CLASSES) $(TOOLS_DIR)

# Formatador
.PHONY: format
format: download-gjf
	find src -name "*.java" -print0 | xargs -0 java -jar $(FORMATTER_JAR) --aosp --replace

# Empacotar a lib
.PHONY: distro
distro: lib
	jar cf $(DISTRO_JAR) -C $(OUT_CLASSES) .

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
coverage: download-jacoco test-with-agent report

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
	jar cfm $(CLI_JAR) manifest.txt -C $(OUT_CLI) . -C $(OUT_CLASSES) .
	rm manifest.txt


.PHONY: version
version:
	@mkdir -p $(dir $(VERSION_FLUX_JAVA_FILE))
	@TMP_FILE=$$(mktemp); \
	{ \
		echo "package org.x96.sys.foundation.io;"; \
		echo "public class Flux {"; \
		echo "  public static final String VERSION = \"$(FLUX_VERSION)\";"; \
		echo "  private Flux() {"; \
		echo "    throw new AssertionError(\"Not instantiable\");"; \
		echo "  }"; \
		echo "}"; \
	} > $$TMP_FILE; \
	if ! cmp -s $$TMP_FILE $(VERSION_FLUX_JAVA_FILE); then \
		echo "[flux] Updating version file: $(VERSION_FLUX_JAVA_FILE)"; \
		mv $$TMP_FILE $(VERSION_FLUX_JAVA_FILE); \
	else \
		rm $$TMP_FILE; \
	fi

# Downloads
.PHONY: download-junit
download-junit:
	@mkdir -p $(LIB_DIR)
	@if [ ! -f "$(JUNIT_JAR)" ]; then \
		echo "[junit] Downloading $(JUNIT_JAR)"; \
		wget -q https://maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.12.1/junit-platform-console-standalone-1.12.1.jar -O $(JUNIT_JAR); \
	else \
		echo "[junit] $(JUNIT_JAR) is up to date."; \
	fi

.PHONY: download-gjf
download-gjf:
	@mkdir -p $(TOOLS_DIR)
	@if [ ! -f "$(FORMATTER_JAR)" ]; then \
		echo "[gjf] Downloading $(FORMATTER_JAR)"; \
		curl -sSL -o $(FORMATTER_JAR) https://github.com/google/google-java-format/releases/download/v1.28.0/google-java-format-1.28.0-all-deps.jar; \
	else \
		echo "[gjf] $(FORMATTER_JAR) is up to date."; \
	fi

.PHONY: download-jacoco
download-jacoco:
	@mkdir -p $(TOOLS_DIR) $(LIB_DIR)
	@if [ ! -f "$(JACOCO_CLI_JAR)" ]; then \
		echo "[jacoco] Downloading CLI JAR..."; \
		curl -sSL -o $(JACOCO_CLI_JAR) https://repo1.maven.org/maven2/org/jacoco/org.jacoco.cli/0.8.13/org.jacoco.cli-0.8.13-nodeps.jar; \
	else \
		echo "[jacoco] CLI JAR is up to date."; \
	fi
	@if [ ! -f "$(JACOCO_AGENT_JAR)" ]; then \
		echo "[jacoco] Downloading Agent JAR..."; \
		curl -sSL -o $(JACOCO_AGENT_JAR) https://repo1.maven.org/maven2/org/jacoco/org.jacoco.agent/0.8.13/org.jacoco.agent-0.8.13-runtime.jar; \
	else \
		echo "[jacoco] Agent JAR is up to date."; \
	fi
