package org.x96.sys.foundation.buzz;

import java.util.concurrent.ThreadLocalRandom;

public class Buzz extends RuntimeException {

    public static final String ANSI_RESET = "\u001B[0m";
    public static final String ANSI_RED = "\u001B[31m";
    public static final String ANSI_GREEN = "\u001B[32m";

    private static final String[] BUGS = {
            "🐞", "🕷️", "🪲", "🐜", "🦟", "🐝", "🦋", "🦖", "🦕", "🌵"
    };

    public Buzz(String message, Buzz cause) {
        super(message, cause);
    }

    protected Buzz(int code, String bee, String msg, Throwable cause) {
        super(format(code, bee, msg), cause);
    }

    public Buzz(int code, String bee, String msg) {
        this(code, bee, msg, null);
    }

    private static String format(int code, String bee, String msg) {
        return String.format(
                "%s [0x%X]%n%s [%s]%n%s > %s", BUGS[8], code, BUGS[5], bee, BUGS[9], msg);
    }

}
