package com.idosmart.native_channel.alexa.requestbody;

import java.io.IOException;

import okhttp3.MediaType;
import okhttp3.RequestBody;
import okio.BufferedSink;
import okio.Okio;
import okio.Pipe;

/**
 * @author tianwei
 * @date 2023/9/23
 * @time 15:36
 * 用途:用于实时传输
 */
public class PipeBody extends RequestBody {
    private final Pipe pipe = new Pipe(1024*512);
    private final BufferedSink sink = Okio.buffer(pipe.sink());
    @Override
    public MediaType contentType() {
        return MediaType.parse("application/octet-stream");
    }
    public BufferedSink sink() {
        return sink;
    }

    @Override
    public void writeTo(BufferedSink sink) throws IOException {
        sink.writeAll(pipe.source());
    }
}
