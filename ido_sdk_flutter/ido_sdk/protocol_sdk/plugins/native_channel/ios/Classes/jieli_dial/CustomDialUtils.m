//
//  CustomDialUtils.m
//  CustomDial
//
//  Created by qiao liwei on 2023/8/14.
//

#import "CustomDialUtils.h"
#import "PlacementSelectModel.h"

#define KEYHOUR @"KEYHOUR"
#define KEYMINUTE @"KEYMINUTE"
#define KEYTIME_DELIMITER @"KEYTIME_DELIMITER"
#define KEYDAY @"KEYDAY"
#define KEYMONTH @"KEYMONTH"
#define KEYDATE_DELIMITER @"KEYDATE_DELIMITER"
#define KEYWEEK @"KEYWEEK"
#define KEYAMPM @"KEYAMPM"

@implementation CustomDialUtils

+ (uint32_t)RGB24TORGB16ForR:(uint8_t)R G:(uint8_t)G B:(uint8_t)B
{
    return ((uint32_t)((((R)>>3)<<11) | (((G)>>2)<<5)| ((B)>>3)));
}

//0xde4371
+ (UIColor *)colorWithHex:(UInt32)hexColor
{
    return [UIColor colorWithRed:(hexColor >> 16 & 0xff)/255.0 green:(hexColor >> 8 & 0xff)/255.0 blue:(hexColor & 0xff)/255.0 alpha:1.0];
}

+ (UIImage *)scaleImage:(UIImage *)image toWidth:(NSInteger)widthSize height:(NSInteger)heightSize {
    CGSize newSize = CGSizeMake(widthSize, heightSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0); // 1.0表示scale为1倍
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (PlacementSelectModel *)makePlacementData:(BackgroundSelectModel *)selectBg
                                 font:(FontSelectModel *)selectFont
                                color:(ColorSelectModel *)selectColor
                                  prewImagePath:(NSString *)prewImagePath
{
    PlacementSelectModel *model = [[PlacementSelectModel alloc] init];
    model.backgroundImage = selectBg.backgroundImage;
    model.isSelected = NO;
    UIImage * image = [UIImage imageWithContentsOfFile:prewImagePath];
    model.textImage = image;
    model.color = selectColor.color;
    return  model;
}


//+ (NSMutableArray <PlacementSelectModel *>*)makePlacementData:(BackgroundSelectModel *)selectBg
//                                 font:(FontSelectModel *)selectFont
//                                color:(ColorSelectModel *)selectColor
//{
//    int placementType[] = {PLACEMENT_LEFT_TOP, PLACEMENT_CENTER_TOP, PLACEMENT_CENTER_BOTTOM};
//    NSArray *textImageNameArr = @[@"top_left", @"top_centre", @"bottom_centre"];
//    
//    int i = 1;
//    int placementTypeLength = sizeof(placementType) / sizeof(placementType[0]);
//    NSMutableArray *dialPlacementArr = [NSMutableArray arrayWithCapacity:0];
//    
//    for (int j = 0; j < placementTypeLength; ++j){
//        PlacementSelectModel *model = [[PlacementSelectModel alloc] init];
//        model.backgroundImage = selectBg.backgroundImage;
//        model.placement = placementType[j];
//        model.isSelected = NO;
//        NSString * fileName = [NSString stringWithFormat:@"%@_%d", textImageNameArr[j], i];
//        NSString * imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"png"];
//        UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
//        model.textImage = image;
//        model.color = selectColor.color;
//        
//        
//        [dialPlacementArr addObject:model];
//    }
//    return dialPlacementArr;
//}

+ (Element *)getPreviewDataBean:(UIImage *)bgImage textImage:(UIImage *)textImage color:(UInt32)color
{
    Element *element = [[Element alloc] init];
    element.imageCount = 1;
    element.dataList = [NSMutableArray arrayWithCapacity:0];
    
    PlacementSelectModel *selectModel = [[PlacementSelectModel alloc] init];
    selectModel.color = color;
    selectModel.backgroundImage = bgImage;
    selectModel.textImage = textImage;
    
    UIImage *bitmap = [selectModel composeImage];
    
    if (bitmap) {
        UIImage *scaleBitmap = [self scaleImage:bitmap toWidth:PREVIEW_WIDTH height:PREVIEW_HEIGHT];//[self scaleImage:bitmap width:PREVIEW_WIDTH height:PREVIEW_HEIGHT];
        //        UIImage *roundBitmap = [ImageUtils getRoundCornerBitmap:scaleBitmap cornerRadius:12];
        NSLog(@"scaleBitmap width %f height %f", scaleBitmap.size.width, scaleBitmap.size.height);
        
        element.width = scaleBitmap.size.width;
        element.height = scaleBitmap.size.height;
        
        NSData *data = [self getBitmapAlphaPix:scaleBitmap];
        element.size = (int)data.length;
        
        [element.dataList addObject:data];
        
        // Release the images if they are no longer needed
        bitmap = nil;
        scaleBitmap = nil;
    }
    
    return element;
}

+ (Element *)getDataBean:(UIImage *)bgImage
{
    Element *element = [[Element alloc] init];
    element.imageCount = 1;
    element.dataList = [NSMutableArray arrayWithCapacity:0];
    
    element.width = DIAL_WIDTH;
    element.height = DIAL_HEIGHT;
    NSData *tData = [self getBitmapAlphaPix:bgImage];
    element.size = (int)tData.length;
    [element.dataList addObject:tData];
    
    return element;
}

+ (NSData *)getBitmapAlphaPixZH:(UIImage *)image {
    CGImageRef ImageRef = image.CGImage;
    CFDataRef mDataRef =  CGDataProviderCopyData(CGImageGetDataProvider(ImageRef));
    
    UInt8 *mPixelBuf = (UInt8 *)CFDataGetBytePtr(mDataRef);
    CFIndex length = CFDataGetLength(mDataRef);
    
    NSData *tImageData = [NSData dataWithBytes:mPixelBuf length:4992];
    
    NSMutableData *fileData = [NSMutableData data];
    for(int i=0;i<length;i+=4){
        int r = i;
        int g = i+1;
        int b = i+2;
        int a = i+3;
        
        int red   = mPixelBuf[r];
        int green = mPixelBuf[g];
        int blue  = mPixelBuf[b];
        int alapt = mPixelBuf[a];
        
        uint16_t color = [self RGB24TORGB16ForR:red G:green B:blue];
        
        [fileData appendBytes:&alapt length:1];
        [fileData appendBytes:&color length:2];
    }
    
    CFRelease(mDataRef);
    return fileData;
}

//获取带alpha的RGB565图片数据，每行对齐
+ (NSData *)getBitmapAlphaPix:(UIImage *)image {
    
    CGImageRef cgImage = [image CGImage];
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = width * bytesPerPixel;
    size_t totalBytes = bytesPerRow * height;
    
    NSMutableData *rawData = [NSMutableData dataWithLength:totalBytes];
    uint8_t *bytes = [rawData mutableBytes];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(bytes, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    
    size_t lineSize = width * 3;
    lineSize = (lineSize + 3) / 4 * 4; // Align each row to a multiple of 4 bytes
    
    NSMutableData *resultData = [NSMutableData dataWithLength:lineSize * height];
    uint8_t *resultBytes = [resultData mutableBytes];
    
    for (size_t y = 0; y < height; y++) {
        for (size_t x = 0; x < width; x++) {
            size_t byteIndex = y * bytesPerRow + x * bytesPerPixel;
            uint8_t *pixel = &bytes[byteIndex];
            
            uint8_t red = pixel[0];
            uint8_t green = pixel[1];
            uint8_t blue = pixel[2];
            uint8_t alpha = pixel[3];

            
            UInt32 color = [self RGB24TORGB16ForR:red G:green B:blue];
            
            size_t resultIndex = (y * lineSize + x * 3);
            resultBytes[resultIndex] = alpha;
            resultBytes[resultIndex + 1] = ((color >> 8) & 0xFF);
            resultBytes[resultIndex + 2] = (color & 0xFF);
//            if (alpha == 0xee){
//                resultBytes[resultIndex + 2] = 0x28;
//            }
            
//            NSLog(@"red %02x green %02x blue %02x color %04x %02x %02x %02x", red, green, blue, color, alpha, resultBytes[resultIndex + 1], resultBytes[resultIndex + 2]);
        }
    }
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultData;
}

+ (UIImage *)replaceColorPix:(UInt32)hexColor originalImage:(UIImage *)src {
    
//    if (hexColor == 0xffffff){
//        return src;
//    }
    
//    UIColor *themeColor = [UIColor colorWithRed:(hexColor >> 16 & 0xff)/255.0 green:(hexColor >> 8 & 0xff)/255.0 blue:(hexColor & 0xff)/255.0 alpha:1.0];
    CGImageRef cgImage = src.CGImage;
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    UInt8 red = (hexColor >> 16 & 0xff);
    UInt8 green = (hexColor >> 8 & 0xff);
    UInt8 blue = (hexColor & 0xff);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
    size_t bytesPerPixel = CGImageGetBitsPerPixel(cgImage) / 8;
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    size_t totalBytes = height * bytesPerRow;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UInt8 *rawData = (UInt8 *) calloc(totalBytes, sizeof(UInt8));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
        
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            size_t byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            
            UInt8 pixelAlpha = rawData[byteIndex + 3];
//            NSLog(@"R %d G %d B %d A %d", rawData[byteIndex], rawData[byteIndex + 1],rawData[byteIndex + 2],rawData[byteIndex + 3]);
            
            if (pixelAlpha > 0) {
                rawData[byteIndex] = red;
                rawData[byteIndex + 1] = green;
                rawData[byteIndex + 2] = blue;
                rawData[byteIndex + 3] = pixelAlpha;
            }
        }
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newCGImage];
    
    // Cleanup
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(rawData);
    CGImageRelease(newCGImage);
    
    return newImage;
}

+ (NSData *)writeImageSize:(NSMutableArray *)list {
    NSInteger size = list.count;
    uint8_t sizeList[size * 4];
    int i = 0;
    
    for (NSNumber *num in list) {
        int value = [num intValue];
        [self intToBytes:value withLength:4 intoArray:sizeList + i];
        i += 4;
    }
    return [NSData dataWithBytes:sizeList length:size * 4];
}

+ (NSData *)writeElement:(Element *)bean{
    uint8_t elementType[20] = {0};
    [self intToBytes:bean.offset withLength:4 intoArray:elementType];
    [self intToBytes:bean.index withLength:2 intoArray:elementType + 4];
    [self intToBytes:bean.width withLength:2 intoArray:elementType + 6];
    [self intToBytes:bean.height withLength:2 intoArray:elementType + 8];
    [self intToBytes:bean.x withLength:2 intoArray:elementType + 10];
    [self intToBytes:bean.y withLength:2 intoArray:elementType + 12];
    
    elementType[14] = bean.imageCount;
    elementType[15] = bean.type | (bean.hasAlpha << 7);
    elementType[16] = bean.anchor;
    elementType[17] = bean.blackTransparent;
    elementType[18] = bean.compression << 1;
    elementType[19] = bean.leftOffset;
    
    return [NSData dataWithBytes:elementType length:20];
}

+ (void)intToBytes:(int)value withLength:(int)length intoArray:(uint8_t *)array {
    for (int i = 0; i < length; i++) {
        array[i] = (value >> (8 * i)) & 0xFF;
    }
}

+ (NSData *)getN022BCustomDialDataWithBGImage:(UIImage *)bgImage
                                    textImage:(UIImage *)textImage
                                  setColorHex:(UInt32)setColor
                                   srcBinData:(NSData *)binData
{
    NSMutableData *stream = [NSMutableData dataWithCapacity:0];
            
    NSDictionary *dataMap = [self parseBaseBin:binData
                                    setColorHex:setColor];
    
    UInt16 imageTotalCount = 2; // 2 是预览图和背景图片
    for (Element *tV in dataMap.allValues){
        imageTotalCount += tV.imageCount;
    }
    
    Byte elementCount = dataMap.count + 2; // 2 是预览图和背景图片
    
    Byte header[4] = {0};
    header[0] = (imageTotalCount & 0xff); //图片总数量
    header[1] = (imageTotalCount >> 8) & 0xff;
    header[2] = elementCount; // 元素数量 没有上/下午这个元素
    header[3] = 2; //输出格式
    
    [stream appendBytes:header length:4];
    
    int tIndex = 0;
    
    // 图片数据之前的所有数据大小，即图片数据在bin文件中的起始偏移位置
    // 头的长度4字节，9个元素，每个元素的数据占20个字节，51张图片，每张图片的size占4个字节
    NSMutableArray *sizeList = [NSMutableArray arrayWithCapacity:0];
    int imageDataBeforeSize = sizeof(header) + 20 * elementCount + imageTotalCount * 4;
    
    Element *thumbBean = [self getPreviewDataBean:bgImage textImage:textImage color:setColor];
    thumbBean.type = Element_PREVIEW;
    thumbBean.offset = imageDataBeforeSize;
    thumbBean.index = tIndex;
    thumbBean.anchor = 0;
    thumbBean.compression = 0;
    [sizeList addObject:@(thumbBean.size)];
    [stream appendData:[self writeElement:thumbBean]];
    
    tIndex += thumbBean.imageCount;
    imageDataBeforeSize += thumbBean.size * thumbBean.imageCount;
    
    Element *backgroundBean = [self getDataBean:bgImage];
    backgroundBean.type = Element_BACKGROUND;
    backgroundBean.offset = imageDataBeforeSize;
    backgroundBean.index = tIndex;
    backgroundBean.compression = 0;
    [sizeList addObject:@(backgroundBean.size)];
    [stream appendData:[self writeElement:backgroundBean]];
    tIndex += backgroundBean.imageCount;
    imageDataBeforeSize += backgroundBean.size * backgroundBean.imageCount;

    Element *hourBean = dataMap[KEYHOUR];
    if (hourBean){
        hourBean.offset = imageDataBeforeSize;
        hourBean.index = tIndex;
        hourBean.compression = 0;
        for (int i = 0; i < hourBean.imageCount; i++){
            [sizeList addObject:@(hourBean.size)];
        }
        [stream appendData:[self writeElement:hourBean]];
        tIndex += hourBean.imageCount;
        imageDataBeforeSize += hourBean.size * hourBean.imageCount;
    }
    
    Element *minuteBean = dataMap[KEYMINUTE];//[self getDataBean:nil fontType:bean.font srcType:@"time" count:10 color:bean.color];
    if (minuteBean){
        minuteBean.offset = imageDataBeforeSize;
        minuteBean.index = tIndex;
        minuteBean.compression = 0;
        for (int i = 0; i < minuteBean.imageCount; i++){
            [sizeList addObject:@(minuteBean.size)];
        }
        [stream appendData:[self writeElement:minuteBean]];
        
        tIndex += minuteBean.imageCount;
        imageDataBeforeSize += minuteBean.size * minuteBean.imageCount;
    }
    
    Element *weekBean = dataMap[KEYWEEK];//[self getDataBean:nil fontType:bean.font srcType:@"week" count:7 color:bean.color];
    if (weekBean){
        weekBean.offset = imageDataBeforeSize;
        weekBean.index = tIndex;
        weekBean.compression = 0;
        for (int i = 0; i < weekBean.imageCount; i++){
            [sizeList addObject:@(weekBean.size)];
        }
        [stream appendData:[self writeElement:weekBean]];
        
        tIndex += weekBean.imageCount;
        imageDataBeforeSize += weekBean.size * weekBean.imageCount;
    }
    
    Element *dayBean = dataMap[KEYDAY];//[self getDataBean:nil fontType:bean.font srcType:@"date" count:10 color:bean.color];
    if (dayBean){
        dayBean.offset = imageDataBeforeSize;
        dayBean.index = tIndex;
        dayBean.compression = 0;
        for (int i = 0; i < dayBean.imageCount; i++){
            [sizeList addObject:@(dayBean.size)];
        }
        [stream appendData:[self writeElement:dayBean]];
        
        tIndex += dayBean.imageCount;
        imageDataBeforeSize += dayBean.size * dayBean.imageCount;
    }
    
    Element *dateSeparatorBean = dataMap[KEYDATE_DELIMITER];//[self getDataBean:nil fontType:bean.font srcType:@"date_sep" count:1 color:bean.color];
    if (dateSeparatorBean){
        dateSeparatorBean.offset = imageDataBeforeSize;
        dateSeparatorBean.index = tIndex;
        dateSeparatorBean.compression = 0;
        for (int i = 0; i < dateSeparatorBean.imageCount; i++){
            [sizeList addObject:@(dateSeparatorBean.size)];
        }
        [stream appendData:[self writeElement:dateSeparatorBean]];
        
        tIndex += dateSeparatorBean.imageCount;
        imageDataBeforeSize += dateSeparatorBean.size * dateSeparatorBean.imageCount;
    }
    
    Element *monthBean = dataMap[KEYMONTH];//[self getDataBean:nil fontType:bean.font srcType:@"date" count:10 color:bean.color];
    if (monthBean){
        monthBean.offset = imageDataBeforeSize;
        monthBean.index = tIndex;
        monthBean.compression = 0;
        for (int i = 0; i < monthBean.imageCount; i++){
            [sizeList addObject:@(monthBean.size)];
        }
        [stream appendData:[self writeElement:monthBean]];
        
        tIndex += monthBean.imageCount;
        imageDataBeforeSize += monthBean.size * monthBean.imageCount;
    }
    
    Element *timeSeparatorBean = dataMap[KEYTIME_DELIMITER];//[self getDataBean:nil fontType:bean.font srcType:@"time_sep" count:1 color:bean.color];
    if (timeSeparatorBean){
        timeSeparatorBean.offset = imageDataBeforeSize;
        timeSeparatorBean.index = tIndex;
        timeSeparatorBean.compression = 0;
        for (int i = 0; i < timeSeparatorBean.imageCount; i++){
            [sizeList addObject:@(timeSeparatorBean.size)];
        }
        [stream appendData:[self writeElement:timeSeparatorBean]];
        
        tIndex += timeSeparatorBean.imageCount;
        imageDataBeforeSize += timeSeparatorBean.size * timeSeparatorBean.imageCount;
    }
    
    Element *halfDayBean = dataMap[KEYAMPM];//[self getDataBean:nil fontType:bean.font srcType:@"time_sep" count:1 color:bean.color];
    if (halfDayBean){
        halfDayBean.offset = imageDataBeforeSize;
        halfDayBean.index = tIndex;
        halfDayBean.compression = 0;
        for (int i = 0; i < halfDayBean.imageCount; i++){
            [sizeList addObject:@(halfDayBean.size)];
        }
        [stream appendData:[self writeElement:halfDayBean]];
        
        tIndex += halfDayBean.imageCount;
        imageDataBeforeSize += halfDayBean.size * halfDayBean.imageCount;
    }
    
    // 图片sizes（每张图片的size）
    [stream appendData:[self writeImageSize:sizeList]];
    
    // 图片数据
    [stream appendData:[thumbBean.dataList firstObject]];
    [stream appendData:[backgroundBean.dataList firstObject]];
    
    if (hourBean){
        for (int n = 0; n < hourBean.imageCount; n++){
            [stream appendData:hourBean.dataList[n]];
        }
    }
    if (minuteBean){
        for (int n = 0; n < minuteBean.imageCount; n++){
            [stream appendData:minuteBean.dataList[n]];
        }
    }
    if (weekBean){
        for (int n = 0; n < weekBean.imageCount; n++){
            [stream appendData:weekBean.dataList[n]];
        }
    }
    if (dayBean){
        for (int n = 0; n < dayBean.imageCount; n++){
            [stream appendData:dayBean.dataList[n]];
        }
    }
    if (dateSeparatorBean){
        [stream appendData:[dateSeparatorBean.dataList firstObject]];
    }
    if (monthBean){
        for (int n = 0; n < monthBean.imageCount; n++){
            [stream appendData:monthBean.dataList[n]];
        }
    }
    if (timeSeparatorBean){
        [stream appendData:[timeSeparatorBean.dataList firstObject]];
    }
    
    if (halfDayBean){
        for (int n = 0; n < halfDayBean.imageCount; n++){
            [stream appendData:halfDayBean.dataList[n]];
        }
    }

    return stream;
}

+ ( NSString * _Nullable )getN022BCustomDialDataWithBGImagePath:(NSString *)bgImagePath
                                    textImagePath:(NSString *)textImagePath
                                      setColorHex:(UInt32)setColor
                                       srcBinPath:(NSString *)binFilePath
                                       savePath:(NSString *)savePath {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:bgImagePath] ||
        ![[NSFileManager defaultManager] fileExistsAtPath:textImagePath] ||
        ![[NSFileManager defaultManager] fileExistsAtPath:binFilePath]) {
        return nil;
    }
    
    NSData * data = [self getN022BCustomDialDataWithBGImage:[UIImage imageWithContentsOfFile:bgImagePath] 
    textImage:[UIImage imageWithContentsOfFile:textImagePath] 
    setColorHex:setColor 
    srcBinData:[NSData dataWithContentsOfFile:binFilePath]];

    BOOL result = NO;
    if (data) {
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
        result = [data writeToFile:savePath atomically:YES];
    }
    
    return result ? savePath : nil;
}

+ (NSDictionary *)parseBaseBin:(NSData *)binData
                   setColorHex:(UInt32)hexColor
{
    UInt16 twoBytes = 0;
    UInt32 fourBytes = 0;
    int tOffset = 100; //100个字节预留,第一个字节为0xFF
        
    Element *hourModel = [[Element alloc] init];
    Element *minuteModel = [[Element alloc] init];
    hourModel.type = Element_HOUR;
    minuteModel.type = Element_MINUTE;
    
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    hourModel.width = twoBytes;
    minuteModel.width = twoBytes;
    
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    hourModel.height = twoBytes;
    minuteModel.height = twoBytes;
    
    hourModel.dataList = [NSMutableArray arrayWithCapacity:0];
    minuteModel.dataList = [NSMutableArray arrayWithCapacity:0];
    hourModel.imageCount = 10;
    minuteModel.imageCount = 10;
    
    for (int n = 0; n < 10; n++){
        [binData getBytes:&fourBytes range:NSMakeRange(tOffset, 4)];
        tOffset += 4;
        NSData *tRawData = [binData subdataWithRange:NSMakeRange(tOffset, fourBytes)];
        tOffset += fourBytes;
        
//        CFDataRef dataRef = (__bridge CFDataRef)tRawData;
//        CGImageSourceRef source = CGImageSourceCreateWithData(dataRef, nil);
//        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil);
//        int width = (int)CGImageGetWidth(cgImage);
//        int height = (int)CGImageGetHeight(cgImage);
//        size_t pixelCount = width * height;
//        CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
//        CFDataRef tTestData = CGDataProviderCopyData(provider);
//        
//        UInt8 *mPixelBuf = (UInt8 *)CFDataGetBytePtr(tTestData);
//
//
//        CFRelease(tTestData);
//        CGImageRelease(cgImage);
//        CFRelease(source);

        UIImage *bitmap = [UIImage imageWithData:tRawData];
        UIImage *dest = [self replaceColorPix:hexColor originalImage:bitmap];
        NSData *data = [self getBitmapAlphaPix:dest];
        hourModel.size = (int)data.length;
        minuteModel.size = (int)data.length;
        [hourModel.dataList addObject:data];
        [minuteModel.dataList addObject:data];
    }
    
    // 时间分隔符图片
    Element *timeSeparatorModel = [[Element alloc] init];
    timeSeparatorModel.type = Element_ICON;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    timeSeparatorModel.width = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    timeSeparatorModel.height = twoBytes;
    timeSeparatorModel.dataList = [NSMutableArray arrayWithCapacity:0];
    [binData getBytes:&fourBytes range:NSMakeRange(tOffset, 4)];
    tOffset += 4;
    NSData *tRawData = [binData subdataWithRange:NSMakeRange(tOffset, fourBytes)];
    tOffset += fourBytes;
    timeSeparatorModel.imageCount = 1;
    UIImage *bitmap = [UIImage imageWithData:tRawData];
    UIImage *dest = [self replaceColorPix:hexColor originalImage:bitmap];
    NSData *data = [self getBitmapAlphaPix:dest];
    timeSeparatorModel.size = (int)data.length;
    [timeSeparatorModel.dataList addObject:data];
    
    // 日期数字图片
    Element *dayModel = [[Element alloc] init];
    Element *monthModel = [[Element alloc] init];
    dayModel.type = Element_DAY;
    monthModel.type = Element_MONTH;
    
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    dayModel.width = twoBytes;
    monthModel.width = twoBytes;
    
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    dayModel.height = twoBytes;
    monthModel.height = twoBytes;
    
    dayModel.dataList = [NSMutableArray arrayWithCapacity:0];
    monthModel.dataList = [NSMutableArray arrayWithCapacity:0];
    dayModel.imageCount = 10;
    monthModel.imageCount = 10;
    
    for (int n = 0; n < 10; n++){
        [binData getBytes:&fourBytes range:NSMakeRange(tOffset, 4)];
        tOffset += 4;
        NSData *dayRawData = [binData subdataWithRange:NSMakeRange(tOffset, fourBytes)];
        tOffset += fourBytes;

        UIImage *dayBitmap = [UIImage imageWithData:dayRawData];
        UIImage *dest = [self replaceColorPix:hexColor originalImage:dayBitmap];
        NSData *dayData = [self getBitmapAlphaPix:dest];
        dayModel.size = (int)dayData.length;
        monthModel.size = (int)dayData.length;
        [dayModel.dataList addObject:dayData];
        [monthModel.dataList addObject:dayData];
    }
    
    // 日期分隔符图片
    Element *dateSeparatorModel = [[Element alloc] init];
    dateSeparatorModel.type = Element_ICON;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    dateSeparatorModel.width = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    dateSeparatorModel.height = twoBytes;
    dateSeparatorModel.dataList = [NSMutableArray arrayWithCapacity:0];
    [binData getBytes:&fourBytes range:NSMakeRange(tOffset, 4)];
    tOffset += 4;
    NSData *dateSeparatorData = [binData subdataWithRange:NSMakeRange(tOffset, fourBytes)];
    tOffset += fourBytes;
    dateSeparatorModel.imageCount = 1;
    UIImage *dateBitmap = [UIImage imageWithData:dateSeparatorData];
    UIImage *dateDest = [self replaceColorPix:hexColor originalImage:dateBitmap];
    NSData *dateData = [self getBitmapAlphaPix:dateDest];
    dateSeparatorModel.size = (int)dateData.length;
    [dateSeparatorModel.dataList addObject:dateData];
    
    
    // 星期图片
    Element *weekModel = [[Element alloc] init];
    weekModel.type = Element_WEEK;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    weekModel.width = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    weekModel.height = twoBytes;
    weekModel.dataList = [NSMutableArray arrayWithCapacity:0];
    weekModel.imageCount = 7;
    
    for (int n = 0; n < 7; n++){
        [binData getBytes:&fourBytes range:NSMakeRange(tOffset, 4)];
        tOffset += 4;
        NSData *weekRawData = [binData subdataWithRange:NSMakeRange(tOffset, fourBytes)];
        tOffset += fourBytes;

        UIImage *weekBitmap = [UIImage imageWithData:weekRawData];
        UIImage *weekDest = [self replaceColorPix:hexColor originalImage:weekBitmap];
        NSData *weekData = [self getBitmapAlphaPix:weekDest];
        weekModel.size = (int)weekData.length;
        [weekModel.dataList addObject:weekData];
    }
    
    // 上/下午图片
    Element *halfDayModel = [[Element alloc] init];
    halfDayModel.type = Element_AM_PM;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    halfDayModel.width = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    halfDayModel.height = twoBytes;
    halfDayModel.dataList = [NSMutableArray arrayWithCapacity:0];
    halfDayModel.imageCount = 2;

    for (int n = 0; n < 2; n++){
        [binData getBytes:&fourBytes range:NSMakeRange(tOffset, 4)];
        tOffset += 4;
        NSData *halfDayRawData = [binData subdataWithRange:NSMakeRange(tOffset, fourBytes)];
        tOffset += fourBytes;

        UIImage *halfDayBitmap = [UIImage imageWithData:halfDayRawData];
        UIImage *halfDayDest = [self replaceColorPix:hexColor originalImage:halfDayBitmap];
        NSData *halfDayData = [self getBitmapAlphaPix:halfDayDest];
        halfDayModel.size = (int)halfDayData.length;
        [halfDayModel.dataList addObject:halfDayData];
    }
    
    //位置信息
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    hourModel.x = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    hourModel.y = twoBytes;

    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    timeSeparatorModel.x = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    timeSeparatorModel.y = twoBytes;

    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    minuteModel.x = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    minuteModel.y = twoBytes;
    
    // 月
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    monthModel.x = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    monthModel.y = twoBytes;

    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    dateSeparatorModel.x = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    dateSeparatorModel.y = twoBytes;

    // 日
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    dayModel.x = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    dayModel.y = twoBytes;

    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    weekModel.x = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    weekModel.y = twoBytes;

    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    halfDayModel.x = twoBytes;
    [binData getBytes:&twoBytes range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    halfDayModel.y = twoBytes;
                
                

    NSMutableDictionary *tDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (hourModel.x != -1 && hourModel.y != -1){
        [tDataDic setObject:hourModel forKey:KEYHOUR];
    }
    if (minuteModel.x != -1 && minuteModel.y != -1){
        [tDataDic setObject:minuteModel forKey:KEYMINUTE];
    }
    if (timeSeparatorModel.x != -1 && timeSeparatorModel.y != -1){
        [tDataDic setObject:timeSeparatorModel forKey:KEYTIME_DELIMITER];
    }
    if (dayModel.x != -1 && dayModel.y != -1){
        [tDataDic setObject:dayModel forKey:KEYDAY];
    }
    if (monthModel.x != -1 && monthModel.y != -1){
        [tDataDic setObject:monthModel forKey:KEYMONTH];
    }
    if (dateSeparatorModel.x != -1 && dateSeparatorModel.y != -1){
        [tDataDic setObject:dateSeparatorModel forKey:KEYDATE_DELIMITER];
    }
    if (weekModel.x != -1 && weekModel.y != -1){
        [tDataDic setObject:weekModel forKey:KEYWEEK];
    }
    if (halfDayModel.x != -1 && halfDayModel.y != -1){
        [tDataDic setObject:halfDayModel forKey:KEYAMPM];
    }
    
    return tDataDic;
}


@end
