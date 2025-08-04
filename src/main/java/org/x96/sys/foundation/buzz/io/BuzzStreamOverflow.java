package org.x96.sys.foundation.buzz.io;

import org.x96.sys.foundation.buzz.Buzz;

public class BuzzStreamOverflow extends Buzz {
    public static final int CODE = 0xF2;

    public BuzzStreamOverflow(Integer pos, int length) {
        super(CODE, BuzzStreamOverflow.class.getSimpleName(), explain(pos, length));
    }

    private static String explain(Integer pos, int length) {
        return """
                Access beyond bounds.
                > Limit: %d
                > Attempted index: %d""".formatted(length, pos);
    }
}
