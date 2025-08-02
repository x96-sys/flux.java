package org.x96.sys.foundation.buzz.io;

import org.x96.sys.foundation.buzz.Buzz;

public class BuzzStreamOverflow extends Buzz {
    public static final int CODE = 0xF2;

    public BuzzStreamOverflow() {
        super(CODE, BuzzStreamOverflow.class.getSimpleName(), "Acesso além dos limites");
    }
}
