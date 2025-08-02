package org.x96.sys.foundation.buzz;

import java.util.concurrent.ThreadLocalRandom;

public class Buzz extends RuntimeException {

    public static final String ANSI_RESET = "\u001B[0m";
    public static final String ANSI_RED = "\u001B[31m";
    public static final String ANSI_GREEN = "\u001B[32m";

    // 🐞
    private static final String[] BUGS = {
        "🐞", "🕷️", "🪲", "🐜", "🦟", "🐝", "🦋", "🦖", "🦕", "🌵"
    };

    public Buzz(String message, Buzz cause) {
        super(message, cause);
    }

    /*─────────────────────────────────────────────────────────────*/
    /* Construtores                                                */
    /*─────────────────────────────────────────────────────────────*/

    /** Construtor principal com cause opcional. */
    protected Buzz(int code, String bee, String msg, Throwable cause) {
        super(format(code, bee, msg), cause);
    }

    /** Construtor sem cause. */
    public Buzz(int code, String bee, String msg) {
        this(code, bee, msg, null);
    }

    /** Construtor apenas com mensagem (código 0). */
    public Buzz(String msg) {
        this(0, "?", msg, null);
    }

    /** Construtor completo: código, nome simples, mensagem, causa. */
    public Buzz(int code, String bee, String msg, Throwable cause, boolean unused) {
        this(code, bee, msg, cause); // mantém compatibilidade se precisar de assinatura extra
    }

    public Buzz(Exception e) {
        super(e);
    }

    public static String format(int code, String bee, String msg) {

        return String.format(
                "%s [0x%X]%n%s [%s]%n%s > %s", BUGS[8], code, BUGS[5], bee, BUGS[9], msg);
    }

    public String chainMessages() {
        StringBuilder sb = new StringBuilder();
        Throwable current = this;

        boolean primeira = true;
        while (current != null) {
            String msg = current.getMessage();
            Class<?> tipo = current.getClass();

            // Decide como prefixar
            if (!primeira) {
                if (Buzz.class.isAssignableFrom(tipo)) {
                    if (msg != null && !msg.isBlank()) {
                        sb.append("🔗 [causado por] →");
                    } else {
                        current = current.getCause();
                        continue;
                    }
                } else {
                    // padrão Java
                    sb.append("🔗 [causado por] ☕ → ").append(tipo.getName());
                    if (msg != null && !msg.isBlank()) {
                        sb.append(": ").append(msg);
                    }
                    sb.append("\n");
                }
            }

            // Mensagem principal (sem prefixo se for o primeiro)
            if (primeira || Buzz.class.isAssignableFrom(tipo)) {
                if (msg != null && !msg.isBlank()) {
                    sb.append(msg).append("\n");
                }
            }

            // Stack trace do nível atual
            for (StackTraceElement ste : current.getStackTrace()) {
                sb.append("\tat ").append(ste).append("\n");
            }

            current = current.getCause();
            primeira = false;
        }

        return sb.toString();
    }

    private static String randomBug() {
        return BUGS[ThreadLocalRandom.current().nextInt(BUGS.length)];
    }

    public static String hex(int n) {
        return String.format("0x%X", n);
    }
}
