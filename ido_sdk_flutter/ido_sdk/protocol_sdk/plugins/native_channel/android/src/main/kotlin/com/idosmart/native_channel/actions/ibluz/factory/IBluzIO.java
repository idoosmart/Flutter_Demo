package com.idosmart.native_channel.actions.ibluz.factory;

public interface IBluzIO {

    public void write(byte[] buffer) throws Exception;

    public void flush() throws Exception;

    public int read(byte[] buffer, int byteOffset, int byteCount) throws Exception;

    /**
     * read Interger
     *
     * @return
     * @throws Exception
     */
    public int readInt() throws Exception;

    /**
     * read short
     *
     * @return
     * @throws Exception
     */
    public short readShort() throws Exception;

    /**
     * read single byte
     *
     * @return
     * @throws Exception
     */
    public int read() throws Exception;

}
