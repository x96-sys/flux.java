package org.x96.sys.foundation.io;

public class CLI {
  public static void main(String[] args) {
    if (args.length == 0 || args.length > 2) {
      System.err.println("Usage:");
      System.err.println("  java Main <message>");
      System.err.println("  java Main <index> <message>");
      System.exit(1);
    }

    ByteStream byteStream = ByteStream.raw(args.length == 1 ? args[0].getBytes() : args[1].getBytes());

    if (args.length == 1) {
      for (int i = 0; i < byteStream.length(); i++) {
        System.out.println("Byte " + i + ": " + String.format("0x%X", byteStream.at(i)));
      }
    } else {
      try {
        int index = Integer.parseInt(args[0]);
        System.out.println("Byte " + index + ": " + String.format("0x%X", byteStream.at(index)));
      } catch (NumberFormatException e) {
        System.err.println("Error: first argument must be a valid integer index.");
        System.exit(1);
      } catch (IndexOutOfBoundsException e) {
        System.err.println("Error: index out of bounds.");
        System.exit(1);
      }
    }
  }
}
