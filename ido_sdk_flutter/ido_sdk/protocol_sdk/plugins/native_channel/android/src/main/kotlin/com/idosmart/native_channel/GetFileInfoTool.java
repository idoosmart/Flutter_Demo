package com.idosmart.native_channel;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.attribute.BasicFileAttributes;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.util.HashMap;
import java.util.Map;

public class GetFileInfoTool {

    /**
     * 获取文件的修改和创建时间
     * @param path 文件路径
     * @return
     * @throws IOException
     */
  public static Map getFileAttributes(String path) throws IOException {

      Map<String, Long> scores = new HashMap<>();

        File file = new File(path);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            BasicFileAttributes attributes = Files.readAttributes(file.toPath(), BasicFileAttributes.class);
            Instant creationTime = attributes.creationTime().toInstant();
            Instant changeTime = attributes.lastModifiedTime().toInstant();
            LocalDateTime creationDateTime = LocalDateTime.ofInstant(creationTime, ZoneId.systemDefault());
            LocalDateTime changeDateTime = LocalDateTime.ofInstant(changeTime, ZoneId.systemDefault());
            long createSeconds = creationDateTime.toInstant(ZoneOffset.ofHours(8)).toEpochMilli()/1000;
            long changeSeconds = changeDateTime.toInstant(ZoneOffset.ofHours(8)).toEpochMilli()/1000;
            scores.put("createSeconds",createSeconds);
            scores.put("changeSeconds",changeSeconds);
//            String msg = String.format("creationDateTime === %s",creationDateTime);
            return scores;
        }else {
            if (file.exists()) {
                scores.put("createSeconds",file.lastModified()/1000);
                scores.put("changeSeconds",file.lastModified()/1000);
                return scores;
            }
        }
        scores.put("createSeconds", 0L);
        scores.put("changeSeconds", 0L);
        return  scores;
    }
}
