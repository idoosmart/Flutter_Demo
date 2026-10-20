//
//  ActVersion.m
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/19.
//

#import "ActVersion.h"

@implementation ActVersion

+ (NSString *)getBinMsg:(NSData *)fileData {
    NSData *head = [fileData subdataWithRange:NSMakeRange(0, 8)];
    NSString *headS = [[NSString alloc] initWithData:head encoding:NSUTF8StringEncoding];
    
    NSData *binSize = [fileData subdataWithRange:NSMakeRange(20, 4)];
    long binSizeL = [OtaUtils byteToLong:binSize];
    
    NSData *binOff = [fileData subdataWithRange:NSMakeRange(48, 4)];
    long binOffL = [OtaUtils byteToLong:binOff];
    
    NSData *xmlSize = [fileData subdataWithRange:NSMakeRange(52, 4)];
    long xmlSizeL = [OtaUtils byteToLong:xmlSize];
    
    NSData *buffer = [fileData subdataWithRange:NSMakeRange(binOffL, xmlSizeL)];
    NSString * xmlData = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [self getVersionMsg:xmlData];
    
    if (dic == nil) {
        return ERROR_CODE;
    }
    
    return [self getBinJson:headS binSize:binSizeL xmlSize:xmlSizeL msg:dic];
}

+ (NSString *)getBinJson:(NSString *)head binSize:(NSInteger)binSize xmlSize:(NSInteger)xmlSize msg:(NSDictionary *)msg {
    
    NSString *versionCode = [msg objectForKey:VERSION_CODE];
    NSString *boardName = [msg objectForKey:BOARD_NAME];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:head forKey:HEAD_NAME];
    [dic setObject:[NSNumber numberWithInteger:binSize] forKey:BIN_SIZE];
    [dic setObject:[NSNumber numberWithInteger:xmlSize] forKey:XML_SIZE];
    [dic setObject:versionCode forKey:VERSION_CODE];
    [dic setObject:boardName forKey:BOARD_NAME];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    
    if (!error) {
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonStr;
    } else {
        return ERROR_CODE;
    }
}

+ (NSDictionary *)getVersionMsg:(NSString *)data {
    NSString *versionCode = [self getlabelData:data label:VERSION_CODE];
    NSString *boardName = [self getlabelData:data label:BOARD_NAME];
    
    if ([versionCode isEqualToString:ERROR_CODE] || [boardName isEqualToString:ERROR_CODE]) {
        return nil;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:versionCode forKey:VERSION_CODE];
    [dic setObject:boardName forKey:BOARD_NAME];
    return dic;
}

+ (NSString *)getlabelData:(NSString *)data label:(NSString *)label {
    NSString *begin = [NSString stringWithFormat:@"<%@>", label];
    NSString *end = [NSString stringWithFormat:@"</%@>", label];
    
    data = [self eliminate:data];
    
    NSRange startRange = [data rangeOfString:begin];
    NSRange endRange = [data rangeOfString:end];
    
    if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
        // 获取标签内容
        NSRange contentRange = NSMakeRange(NSMaxRange(startRange), endRange.location - NSMaxRange(startRange));
        NSString *tagContent = [data substringWithRange:contentRange];
        return tagContent;
    } else {
        return ERROR_CODE;
    }
}

+ (NSString *)eliminate:(NSString *)data {
    NSString *cleanT = [data stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *cleanN = [cleanT stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return cleanN;
}

@end
