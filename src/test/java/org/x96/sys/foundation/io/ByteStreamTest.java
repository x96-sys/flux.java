package org.x96.sys.foundation.io;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.x96.sys.foundation.buzz.io.BuzzEmptyPayload;
import org.x96.sys.foundation.buzz.io.BuzzStreamOverflow;
import org.x96.sys.foundation.buzz.io.BuzzStreamUnderflow;

import java.text.NumberFormat;
import java.util.Locale;

public class ByteStreamTest {

    @Test
    void happyRaw() {
        ByteStream inputStream = ByteStream.raw("ab".getBytes());
        assertTrue(inputStream.length() == 2);
        assertTrue(inputStream.at(0) == 0x61);
        assertTrue(inputStream.at(1) == 0x62);
    }

    @Test
    void happyWrapped() {
        ByteStream inputStream = ByteStream.wrapped(new byte[] {});
        assertTrue(inputStream.length() == 2);
        assertTrue(inputStream.at(0) == 0x2);
        assertTrue(inputStream.at(1) == 0x3);
    }

    @Test
    void happyBuzzEmptyPayload() {
        var e = assertThrows(BuzzEmptyPayload.class, () -> ByteStream.raw(new byte[] {}));
        assertEquals(
                """
                        \uD83E\uDD95 [0xF1]
                        \uD83D\uDC1D [BuzzEmptyPayload]
                        \uD83C\uDF35 > ByteStream can not be empty 🙅""",
                e.getLocalizedMessage());
    }

    @Test
    void happyBuzzStreamOverflow() {
        ByteStream inputStream = ByteStream.raw(new byte[] { 0x78 });
        assertTrue(inputStream.length() == 1);
        assertTrue(inputStream.at(0) == 0x78);
        var e = assertThrows(BuzzStreamOverflow.class, () -> inputStream.at(1));
        assertEquals(
                """
                        \uD83E\uDD95 [0xF2]
                        \uD83D\uDC1D [BuzzStreamOverflow]
                        \uD83C\uDF35 > Access beyond bounds.
                        > Limit: 0
                        > Attempted index: 1""",
                e.getLocalizedMessage());
    }

    @Test
    void happyBuzzStreamOverflow2() {
        ByteStream inputStream = ByteStream.raw(new byte[] { 0x0 });
        assertTrue(inputStream.length() == 1);
        var e = assertThrows(BuzzStreamUnderflow.class, () -> inputStream.at(-1));
        assertEquals(
                """
                        \uD83E\uDD95 [0xF3]
                        \uD83D\uDC1D [BuzzStreamUnderflow]
                        \uD83C\uDF35 > Access before start.
                        > Attempted index: -1""",
                e.getLocalizedMessage());
    }

    @Test
    void happyPerformance() {
        int sizeInMegaBytes = 200;
        int sizeInKiloBytes = sizeInMegaBytes * 1024;
        int sizeInBytes = sizeInKiloBytes * 1024;

        byte[] payload = generateBytes(sizeInBytes);
        ByteStream inputStream = ByteStream.raw(payload);

        long start = System.nanoTime();

        long checksum = 0;

        for (int i = 0; i < inputStream.length(); i++) {
            checksum += inputStream.at(i);
        }

        long durationNanos = System.nanoTime() - start;
        double durationSeconds = durationNanos / 1_000_000_000.0;

        double bytesPerSecond = inputStream.length() / durationSeconds;
        double megaBytesPerSecond = bytesPerSecond / (1024.0 * 1024.0);
        double gigaBytesPerSecond = megaBytesPerSecond / 1024.0;

        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ROOT);
        nf.setMaximumFractionDigits(2);
        nf.setMinimumFractionDigits(2);

        System.out.printf(
                "📊 ⚡️ read %,d bytes in %.3f s — avg: %,.0f bytes/s (%s MB/s) (%s GB/s) —"
                        + " checksum: %,d%n",
                inputStream.length(),
                durationSeconds,
                bytesPerSecond,
                nf.format(megaBytesPerSecond),
                nf.format(gigaBytesPerSecond),
                checksum);

        assertEquals(sizeInBytes, inputStream.length());
        assertTrue(checksum > 0);
        assertTrue(gigaBytesPerSecond < 3);
        assertTrue(gigaBytesPerSecond > 2);
    }

    @Test
    void happySlowPerformance() {
        int sizeInMegaBytes = 100;
        int sizeInKiloBytes = sizeInMegaBytes * 1024;
        int sizeInBytes = sizeInKiloBytes * 1024;

        byte[] payload = generateBytes(sizeInBytes);
        ByteStream inputStream = ByteStream.raw(payload);

        long start = System.nanoTime();

        long c = 0;
        long checksum = 0;
        for (int i = 0; i < inputStream.length(); i++) {
            if (i % 7 == 0) {
                c++;
            }
            checksum += inputStream.at(i);
        }

        long durationNanos = System.nanoTime() - start;
        double durationSeconds = durationNanos / 1_000_000_000.0;

        double bytesPerSecond = inputStream.length() / durationSeconds;
        double megaBytesPerSecond = bytesPerSecond / (1024.0 * 1024.0);
        double gigaBytesPerSecond = megaBytesPerSecond / 1024.0;

        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ROOT);
        nf.setMaximumFractionDigits(2);
        nf.setMinimumFractionDigits(2);

        System.out.printf(
                "📊 🐌 read %,d bytes in %.3f s — avg: %,.0f bytes/s (%s MB/s) (%s GB/s) —"
                        + " checksum: %,d%n",
                inputStream.length(),
                durationSeconds,
                bytesPerSecond,
                nf.format(megaBytesPerSecond),
                nf.format(gigaBytesPerSecond),
                checksum + c);

        assertEquals(sizeInBytes, inputStream.length());
        assertTrue(checksum > 0);
        assertTrue(gigaBytesPerSecond < 1);
        assertTrue(gigaBytesPerSecond > 0.6);
    }

    // helpers
    private static byte[] generateBytes(int sizeInBytes) {
        byte[] data = new byte[sizeInBytes];
        for (int i = 0; i < sizeInBytes; i++) {
            data[i] = (byte) (i % 0x80);
        }
        return data;
    }
}
