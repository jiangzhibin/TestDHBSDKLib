//
//  CallDirectoryHandler.m
//  DHBCallDirectory
//
//  Created by 蒋兵兵 on 16/8/17.
//  Copyright © 2016年 yulore. All rights reserved.
//

#import "CallDirectoryHandler.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler


- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    NSLog(@"CALLX-BEGIN");
    NSArray<NSString *> *phoneNumbersToBlock = [self retrievePhoneNumbersToBlock];
    if (!phoneNumbersToBlock) {
        NSLog(@"Unable to retrieve phone numbers to block");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:1 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    for (NSString *phoneNumber in phoneNumbersToBlock) {
        [context addBlockingEntryWithNextSequentialPhoneNumber:[phoneNumber longLongValue]];
    }
    
    //    NSString *filePath = [NSString pathForBridgeOfflineFilePath];
    NSString *filePath = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.yulore"].path stringByAppendingPathComponent:@"BridgeFile"];
    
    for (int i=0;i<1000;i++) {
        @autoreleasepool {
            NSString * filePathI=[[NSString alloc] initWithFormat:@"%@%d",filePath,i];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePathI])
            {
                break;
            }
            unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePathI error:nil] fileSize];
            NSLog(@"store read reoslve size %d %@ %lld",i,filePathI,fileSize);
            
            NSMutableDictionary *contentDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePathI];
            NSArray * phoneNumbers=[contentDict allKeys];
            phoneNumbers = [phoneNumbers sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
            for (NSString * phoneNumber in phoneNumbers) {
                NSString *label = [contentDict objectForKey:phoneNumber];
                [context addIdentificationEntryWithNextSequentialPhoneNumber:[phoneNumber longLongValue] label:label];
                //NSLog(@"PN: %@",phoneNumber);
            }
            //usleep(300000);
            //[[NSFileManager defaultManager] removeItemAtPath:filePathI error:nil];
            filePathI=nil;
        }
    }
    
    /*
     for (int i=2743322;i<2743323+1900000;i++){
     NSString * tel=[[NSString alloc] initWithFormat:@"+86105%d",i];
     [context addIdentificationEntryWithNextSequentialPhoneNumber:tel label:@"电话邦 测试"];
     }*/
    
    [context completeRequestWithCompletionHandler:nil];
}

- (NSArray<NSString *> *)retrievePhoneNumbersToBlock {
    // retrieve list of phone numbers to block
    NSLog(@"CALL-BLOCK");
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //[array addObject:@"+8615210310717"];
    //[array addObject:@"+8615210929788"];
    
    return array;
}

- (NSArray<NSArray *> *)retrievePhoneNumbersToIdentify {
    // retrieve list of phone numbers to identify
    /*NSLog(@"CALL-NUMBER");
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableDictionary * phoneList=[contentDict objectForKey:@"10"];
     NSLog(@"CALL-NUMBER-PL %ld",[[phoneList allKeys] count]);
     
     for (NSString * key in [phoneList allKeys])
     {
     [array addObject:[[NSArray alloc] initWithObjects:key,[phoneList objectForKey:key], nil]];
     }
     [array addObject:[[NSArray alloc] initWithObjects:@"+861056164332",@"电话邦 服务热线", nil]];
     
     return array;*/
    return nil;
}
#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
}

@end
