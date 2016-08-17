//
//  ViewController.m
//  TestDHBSDKLib
//
//  Created by 蒋兵兵 on 16/8/17.
//  Copyright © 2016年 yulore. All rights reserved.
//

#import "ViewController.h"
#import "DHBSDK.h"
#import <CallKit/CallKit.h>

@interface ViewController ()

@end

@implementation ViewController


#define APIKEY_Download @"mtyFwikuZ8ARgmwhljlidzxbevhrWrjL"

#define APIKEY @"6WWpOS2NreERRbkJpYVVJd1lVZFZaMkw"
#define APISIG @"yv3%D_d&-hq3F8JmDr!?cf#dk3pvs2#D_d&-vaSc7szVs!jcCs5$NvY2ul__o)3s!__Ns$__g4*d__cne@__c#bst9sk-c$xA__5#jclsOc9^bv2__7cJ&h__ld4=U3Kij*sD5&_ds2{hX13e2@s9C#s3#zF!v%ba^2Dc"

#define APIKEY2 @"abFRSWVlxTYkhZYbCcZSdapLVlllteGX"
#define APISIG2 @"E5UaGxNMkUxTVRrd01EbGtNemN5WlRoaFpUUmpZVFV3TnprM01UVT1ZV1l6TXpjell6QXlNVFV6TUdNMU4ySmtNMlExWXpWaU1XRm1OMlptTkdRPVpUSXlNR0UzWWpKalkyUXhNbUptWTJFNVl6QTRObUprTVRjNE1UUm1"
#define kDHBHost @"https://apis-ios.dianhua.cn/"


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)downloadAction:(id)sender {
    [DHBSDKApiManager registerApp:APIKEY_Download signature:APISIG2 host:kDHBHost completionBlock:^(NSError *error) {
        // 在线标记 APIKEY2
        //        [YuloreApiManager markTeleNumberOnlineWithNumber:@"12315" flagInfomation:@"荷塘蛋花粥" completionHandler:^(BOOL successed, NSError *error) {
        //            NSLog(@"标记号码:%zd  error:%@",successed,error);
        //        }];
        
        // 在线查询
        //        [YuloreApiManager searchTeleNumber:@"12315" completionHandler:^(ResolveItemNew *resolveItem, NSError *error) {
        //            NSLog(@"%@",resolveItem);
        //            NSLog(@"error:%@",error);
        //        }];
        //
        //
        //                return ;
        
        
        
        //        [[DHBDataFetcher sharedInstance] fullDataFetcherCompletionHandler:^(NSArray *fullPackageList, NSArray *deltaPackageList, NSError *error) {
        //
        //        }];
        //        return ;
        [DHBSDKApiManager shareManager].shareGroupIdentifier = @"group.yulore";
        [DHBSDKApiManager dataInfoFetcherCompletionHandler:^(DHBSDKUpdateItem *updateItem, NSError *error) {
            /*
             fullDownloadPath:http://s3.dianhua.cn/chk/flag/1_mtyF_flag_86_61.zip,
             fullMD5:a19a05255a33b5384641e9dd740524be,
             fullSize:2698755,
             fullVersion:61,
             DHBDownloadPackageTypeDelta,
             DHBDownloadPackageTypeFull
             */
            //            updateItem.fullMD5 = @"a19a05255a33b5384641e9dd740524be";
            //            updateItem.fullDownloadPath = @"http://s3.dianhua.cn/chk/flag/1_mtyF_flag_86_61.zip";
            //            updateItem.fullSize = 2698755;
            //            updateItem.fullVersion = 61;
            
            [DHBSDKApiManager downloadDataWithUpdateItem:updateItem dataType:DHBDownloadPackageTypeFull progressBlock:^(double progress) {
                NSLog(@"进度:%f",progress);
            } completionHandler:^(NSError *error) {
                NSLog(@"下载完成 error:%@",error);
                [self reloadExtentsion];
            }];
        }];
    }];
}
- (IBAction)accessDataAction:(id)sender {
    NSString *filePath = [DHBSDKApiManager shareManager].pathForBridgeOfflineFilePath;
    NSUInteger count = 0;
    for (int i=0;i<1000;i++) {
        @autoreleasepool {
            NSString * filePathI=[[NSString alloc] initWithFormat:@"%@%d",filePath,i];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePathI])
            {
                NSLog(@"<<< %d >文件不存在:%@",i,filePathI);
                break;
            }
            //            unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePathI error:nil] fileSize];
            NSMutableDictionary *contentDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePathI];
            count += [[contentDict allKeys] count];
            //            phoneNumbers = [phoneNumbers sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
            //            NSLog(@"phoneNumbers:%@",contentDict);
            //            for (NSString * phoneNumber in phoneNumbers) {
            //                NSString *label = [contentDict objectForKey:phoneNumber];
            //
            //                NSLog(@"PN: %@",phoneNumber);
            //            }
            //            usleep(300000);
            //            [[NSFileManager defaultManager] removeItemAtPath:filePathI error:nil];
            filePathI=nil;
        }
    }
    NSLog(@"记录总数:%zd",count);
}


-(void) reloadExtentsion{
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:@"com.yulore.yellowpage.DHBCallerID" completionHandler:^(CXCallDirectoryEnabledStatus status,NSError *error)
     {
         if(status==CXCallDirectoryEnabledStatusEnabled){
             [[CXCallDirectoryManager sharedInstance] reloadExtensionWithIdentifier:@"com.yulore.yellowpage.DHBCallerID" completionHandler:^(NSError *error)
              {
                  NSLog(@"CX Call Directory Manager ERROR CODE = %ld %@ %@ %@ %@",[error code],[error localizedDescription],[error localizedFailureReason],[error localizedRecoveryOptions],[error localizedRecoverySuggestion]);
                  if ([error code] == CXErrorCodeCallDirectoryManagerErrorUnknown) {
                      NSLog(@"CXErrorCodeCallDirectoryManagerErrorUnknown");
                  } else {
                      NSLog(@"Injection Failed: %ld",[error code]);
                  }
              }];
         } else {
             NSLog(@"CX Call Directory Manager ERROR MSG = %ld %@ %@ %@ %@",status,[error localizedDescription],[error localizedFailureReason],[error localizedRecoveryOptions],[error localizedRecoverySuggestion]);
             NSLog(@"Extension Disabled");
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
