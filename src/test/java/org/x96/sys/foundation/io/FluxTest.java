package org.x96.sys.foundation.io;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Modifier;

public class FluxTest {
    @Test
    public void testVersion() {
        assertEquals("v1.0.0", Flux.VERSION);
    }

    @Test
    public void testConstructorIsPrivate() throws Exception {
        Constructor<Flux> ctor = Flux.class.getDeclaredConstructor();
        assertTrue(Modifier.isPrivate(ctor.getModifiers()));
    }

    @Test
    public void testConstructorThrows() throws Exception {
        Constructor<Flux> ctor = Flux.class.getDeclaredConstructor();
        ctor.setAccessible(true);
        InvocationTargetException ex =
                assertThrows(InvocationTargetException.class, ctor::newInstance);
        assertTrue(ex.getCause() instanceof AssertionError);
    }
}
