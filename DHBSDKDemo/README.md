
#pragma mark - 将libDHBSDK集成到工程中
[1]拖动DHBSDK文件夹到工程中
[2]Build Phases -> Link Binary With Libraries中添加所需类库：
    libc++.tbd   libz.tbd  libbz2.tbd
[3]为Build Setting中的Other Linker Flags添加标记：
    -ObjC和-all_load
[4]在使用的地方 #import "DHBSDK.h"

#pragma mark - 测试时注意事项
[1]主要接口类: DHBSDKApiManager.h 详情见头文件注释
[2]在使用前 需注册
[DHBSDKApiManager registerApp:APIKEY_Download
signature:APISIG2
host:kDHBHost
cityId:nil
shareGroupIdentifier:nil
completionBlock:^(NSError *error)]
[3]现用到以下两组key
下载及更新包信息获取:
#define APIKEY @"mtyFwikuZ8ARgmwhljlidzxbevhrWrjL"
#define APISIG  @"E5UaGxNMkUxTVRrd01EbGtNemN5WlRoaFpUUmpZVFV3TnprM01UVT1ZV1l6TXpjell6QXlNVFV6TUdNMU4ySmtNMlExWXpWaU1XRm1OMlptTkdRPVpUSXlNR0UzWWpKalkyUXhNbUptWTJFNVl6QTRObUprTVRjNE1UUm1"

号码在线标记及识别：
#define APIKEY @"abFRSWVlxTYkhZYbCcZSdapLVlllteGX"
#define APISIG @"E5UaGxNMkUxTVRrd01EbGtNemN5WlRoaFpUUmpZVFV3TnprM01UVT1ZV1l6TXpjell6QXlNVFV6TUdNMU4ySmtNMlExWXpWaU1XRm1OMlptTkdRPVpUSXlNR0UzWWpKalkyUXhNbUptWTJFNVl6QTRObUprTVRjNE1UUm1"
要进行相关操作前，调用以下代码进行注册
[DHBSDKApiManager registerApp:xxxxx]


#pragma mark - 常见问题汇总
[1]无法进行HTTPS请求
新建项目未支持HTTPS，可右键点击工程Info.plist -> Open As -> Source Code 粘贴下面的代码
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>




