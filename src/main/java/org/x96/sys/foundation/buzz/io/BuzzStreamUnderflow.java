package org.x96.sys.foundation.buzz.io;

import org.x96.sys.foundation.buzz.Buzz;

public class BuzzStreamUnderflow extends Buzz {
    public static final int CODE = 0xF3;

    public BuzzStreamUnderflow(Integer pos) {
        super(CODE, BuzzStreamUnderflow.class.getSimpleName(), explain(pos));
    }

    private static String explain(Integer pos) {
        return """
        Access before start.
        > Attempted index: %d\
        """
                .formatted(pos);
    }
}
