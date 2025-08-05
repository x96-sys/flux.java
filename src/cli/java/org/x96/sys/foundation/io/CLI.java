package org.x96.sys.foundation.io;

import org.x96.sys.foundation.buzz.Buzz;

public class CLI {

    public static void main(String[] args) {
        if (args.length == 0 || args.length > 2) {
            printUsage();
        }

        // Handle version flag
        if (args.length == 1 && ("-v".equals(args[0]) || "--version".equals(args[0]))) {
            printVersion();
            return;
        }

        try {
            ByteStream byteStream = happens(args);

            if (args.length == 1) {
                for (int i = 0; i < byteStream.length(); i++) {
                    safe(byteStream, i);
                }
            } else {
                look(byteStream, Integer.parseInt(args[0]));
            }
        } catch (Buzz e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }
    }

    private static void printUsage() {
        printVersion();
        System.err.println("Usage:");
        System.err.println("  java -jar org.x96.sys.foundation.io.cli.jar <message>");
        System.err.println("  java -jar org.x96.sys.foundation.io.cli.jar <index> <message>");
        System.err.println("  java -jar org.x96.sys.foundation.io.cli.jar -v|--version");
        System.exit(1);
    }

    private static void printVersion() {
        System.out.println("Flux CLI " + Flux.VERSION);
    }

    private static ByteStream happens(String[] args) {
        return ByteStream.raw(args.length == 1 ? args[0].getBytes() : args[1].getBytes());
    }

    private static void safe(ByteStream byteStream, int i) {
        System.out.println("Byte " + i + ": " + fHex(byteStream.at(i)));
    }

    private static void look(ByteStream byteStream, int index) {
        try {
            safe(byteStream, index);
        } catch (Buzz e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }
    }

    private static String fHex(int value) {
        return String.format("0x%X", value);
    }
}
