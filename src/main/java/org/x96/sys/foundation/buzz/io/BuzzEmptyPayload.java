package org.x96.sys.foundation.buzz.io;

import org.x96.sys.foundation.buzz.Buzz;

public class BuzzEmptyPayload extends Buzz {
    private static final int CODE = 0xF1;

    public BuzzEmptyPayload() {
        super(CODE, BuzzEmptyPayload.class.getSimpleName(), "ByteStream can't be empty 🙅");
    }
}
