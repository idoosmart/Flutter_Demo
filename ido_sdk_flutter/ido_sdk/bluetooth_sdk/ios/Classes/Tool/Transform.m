//
//  Transform.m
//  flutter_bluetooth
//
//  Created by lux on 2022/9/1.
//

#import "Transform.h"


@implementation Transform

+ (float)calcDistByRssi:(int)rssi
{
    int iRssi = abs(rssi);
    float power = (iRssi-59)/(10*2.0);
    return pow(10, power);
}

+ (NSString *)getPeripheralMacAddr:(id)data
//                          deviceId:(int *)deviceId
//                        bltVersion:(int *)bltVersion
//                        deviceType:(int *)deviceType
{

    NSString * macStr = @"";
    if (!data || [data isKindOfClass:NSNull.class]) return macStr;
    if ([data length] < 8)return macStr;
    
    Byte codeBytes[[data length]];
    for (int i = 0 ; i < [data length]; i++) {
        NSData * itemData = [data subdataWithRange:NSMakeRange(i,1)];
        codeBytes[i] = ((Byte*)[itemData bytes])[0];
    }
    NSInteger count = [data length];
    int idNumber =  codeBytes[0] | (codeBytes[1] << 8);
    int version  =  count > 8 ? codeBytes[8] : 0;
    int type     =  count > 9 ? codeBytes[9] : 0;
    
    //    if (count <= 8) {
            macStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                      codeBytes[2],
                      codeBytes[3],
                      codeBytes[4],
                      codeBytes[5],
                      codeBytes[6],
                      codeBytes[7]];
            NSLog(@"1.%@",macStr);
    //    }else {
    //       NSString * serviceUuid = [NSString stringWithFormat:@"%02X%02X",codeBytes[count - 3],codeBytes[count - 2]];
    //          if ([serviceUuid isEqualToString:@"0AF0"]) {
                 macStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                           codeBytes[count - 9],
                           codeBytes[count - 8],
                           codeBytes[count - 7],
                           codeBytes[count - 6],
                           codeBytes[count - 5],
                           codeBytes[count - 4]];
        NSLog(@"2.%@",macStr);
    //          }else {
    //             if (count >= 29 || count == 10) {
                     macStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                               codeBytes[4],
                               codeBytes[5],
                               codeBytes[6],
                               codeBytes[7],
                               codeBytes[8],
                               codeBytes[9]];
        NSLog(@"3.%@",macStr);
    //             }else {
                     macStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                     count > 2 ? codeBytes[2] : 0,
                     count > 3 ? codeBytes[3] : 0,
                     count > 4 ? codeBytes[4] : 0,
                     count > 5 ? codeBytes[5] : 0,
                     count > 6 ? codeBytes[6] : 0,
                     count > 7 ? codeBytes[7] : 0];
    //             }
        NSLog(@"4.%@",macStr);
    NSLog(@"data = %@ deviceId = %d  bltVersion = %d  deviceType = %d  macAdr = %@ \n",data,idNumber,version,type > 2 ? 0 : type,macStr);
    return macStr;
}




struct ido_protocol_head
{
    uint8_t cmd;
    uint8_t key;
};

//手环数据更新,手环发给app
struct ido_protocol_control_data_update
{
    struct ido_protocol_head head;
    /*
            data_type
            | 值   | 说明                                  |      |
            | ---- | ------------------------------------- | ---- |
            | 0x0  | 无效                                  |      |
            | 1    | 手环已经解绑                          |      |
            | 2    | 心率模式改变                          |      |
            | 3    | 血氧产生数据，发生改变                |      |
            | 4    | 压力产生数据，发生改变                |      |
            | 5    | Alexa识别过程中退出                   |      |
            | 6    | 固件发起恢复出厂设置，通知app弹框提醒  |      |
            | 7    | app需要进入相机界面（TIT01定制）      |      |
            | 8    | sos事件通知（205土耳其定制）          |      |
            | 9    | alexa设置的闹钟，固件修改，需要发送对应的通知位给app，app收到后发送获取V3的闹钟命令|
     */
    uint16_t data_type;
    /*
        notify_type(按位获取)
        | 值   | 说明                                                      | 位   |
        | ---- | --------------------------------------------------------- | ---- |
        | 1    | 闹钟已经修改                                              | bit0 |
        | 2    | 固件过热异常告警                                          | bit1 |
        | 4    | 亮屏参数有修改（02 b0）                                   | bit2 |
        | 8    | 抬腕参数有修改（02 b1）                                   | bit3 |
        | 16   | 勿擾模式获取（02 30）                                     | bit4 |
        | 32   | 手机音量的下发（03  0xE3）（删除），app音量修改，直接下发 | bit5 |
     */
    uint8_t  notify_type;
    uint32_t msg_ID; //回复的ID :每个消息对应一个ID
    /*
        msg_notice(按照值获取，1到5个，最长是多少字符)
        | 值   | 说明                                |
        | ---- | ----------------------------------- |
        | 0    | 无                                  |
        | 1    | 自定义短信1（正在开会，稍后联系）。 |
        | 2    | 自定义短信2                         |
        | 3    | 自定义短信3                         |
        | 4    | 自定义短信4                         |
        | 5    | 自定义短信5                         |
      */
    uint8_t msg_notice; // 0是没有对应的短信回复，对应回复列表
    /*
     *  01 ACC  加速度
        02 PPG  心率
        03 TP   触摸
        04 FLASH
        05 过热（PPG）
        06 气压
        07 GPS
        08 地磁
     * */
    uint32_t error_index; //固件错误码返回,非0是错误,具体看固件错误码,app收到非0错误,发送获取设备0x21 11的命令采集flash数据
};

#pragma mark ===== 监听蓝牙数据状态变化 ======
+ (void)listenBlueUpdateStateWithCharacteristic:(NSData *)characteristic
{
    NSData * data = characteristic;
    if (data && data.length > 0) {
        UInt8 val[20] = {0};
        [data getBytes:&val length:20];
        if (val[0] == 0x07 && val[1] == 0x40) {
            struct ido_protocol_control_data_update *p_data = (struct ido_protocol_control_data_update *)val;
            IDOBlueUpdateStateModel * update = [[IDOBlueUpdateStateModel alloc]init];
            update.dataType = p_data->data_type;
            update.notifyType = p_data->notify_type;
            update.msgId = p_data->msg_ID;
            update.msgNotice = p_data->msg_notice;
            update.errorIndex = p_data->error_index;

        }
        
        if (val[0] != 0x02 && val[1] != 0xA0) {
            //暂停蓝牙心跳
            
        }
    }
}
@end

@implementation IDOBlueUpdateStateModel
@end
