# Diretórios
SRC_DIR=src/main
OUT_DIR=run
TEST_OUT=test
LIB_DIR=lib
JUNIT_JAR=$(LIB_DIR)/j.jar
FORMATTER_JAR=gjf.jar

# Artefato distribuível
DISTRO_JAR=org.x96.sys.foundation.io.jar

# Classe de teste específica (pode mudar com argumento ou var externa)
TEST_METHOD=org.x96.sys.foundation.io.ByteStreamTest\#happySlowPerformance

# Compilar o projeto principal
build:
	javac -d $(OUT_DIR) $(shell find $(SRC_DIR) -name "*.java")

# Criar .jar da distribuição
distro: build
	jar cf $(DISTRO_JAR) -C $(OUT_DIR) .

# Compilar e executar testes
.PHONY: test
test:
	javac -cp $(JUNIT_JAR) -d $(TEST_OUT) $(shell find src -name "*.java")
	java -jar $(JUNIT_JAR) --class-path $(TEST_OUT) --scan-class-path

# Limpar todos os binários e jars
clean:
	rm -rf $(OUT_DIR) $(TEST_OUT) $(DISTRO_JAR) "$(LIB_DIR)" "*.jar"

# Formatador de código
.PHONY: format
format:
	find src -name "*.java" -print0 | xargs -0 java -jar $(FORMATTER_JAR) --aosp --replace

# Watch: reexecuta testes ao salvar qualquer .java
watch-test:
	find . -name "*.java" | entr -c bash -c 'clear && make test'

# Watch: reexecuta método de teste específico
watch-test-specific:
	find . -name "*.java" | entr -c bash -c '\
		javac -cp $(JUNIT_JAR) -d $(TEST_OUT) $(shell find src -name "*.java") && \
		java -jar $(JUNIT_JAR) \
			--class-path $(TEST_OUT) \
			--select "method:$(TEST_METHOD)"'

# Download do JUnit Console Standalone
download-junit:
	mkdir -p $(LIB_DIR)
	wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.12.1/junit-platform-console-standalone-1.12.1.jar -O $(JUNIT_JAR)

# Download do Google Java Format
download-gjf:
	curl -L -o $(FORMATTER_JAR) https://github.com/google/google-java-format/releases/download/v1.28.0/google-java-format-1.28.0-all-deps.jar
