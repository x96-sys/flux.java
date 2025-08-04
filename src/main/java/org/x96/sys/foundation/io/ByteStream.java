package org.x96.sys.foundation.io;

import org.x96.sys.foundation.buzz.io.BuzzEmptyPayload;
import org.x96.sys.foundation.buzz.io.BuzzStreamOverflow;
import org.x96.sys.foundation.buzz.io.BuzzStreamUnderflow;

import java.nio.ByteBuffer;

public class ByteStream {

    private final byte[] bytes;

    private ByteStream(byte[] bytes) {
        if (bytes.length == 0)
            throw new BuzzEmptyPayload();
        this.bytes = bytes;
    }

    public static ByteStream raw(byte[] bytes) {
        return new ByteStream(bytes);
    }

    public static ByteStream wrapped(byte[] bytes) {
        return new ByteStream(addSentinels(bytes));
    }

    public int length() {
        return bytes.length;
    }

    public byte at(int pos) {
        if (pos >= bytes.length) {
            throw new BuzzStreamOverflow(pos, bytes.length - 1);
        } else if (pos < 0) {
            throw new BuzzStreamUnderflow(pos);
        }
        return this.bytes[pos];
    }

    private static byte[] addSentinels(byte[] h) {
        return ByteBuffer.allocate(h.length + 2).put((byte) 0x2).put(h).put((byte) 0x3).array();
    }
}
