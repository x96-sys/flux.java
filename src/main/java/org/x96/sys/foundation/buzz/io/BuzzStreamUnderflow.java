package org.x96.sys.foundation.buzz.io;

import org.x96.sys.foundation.buzz.Buzz;

public class BuzzStreamUnderflow extends Buzz {
    public static final int CODE = 0xF3;

    public BuzzStreamUnderflow() {
        super(CODE, BuzzStreamUnderflow.class.getSimpleName(), "Acesso aquém dos limites");
    }
}
