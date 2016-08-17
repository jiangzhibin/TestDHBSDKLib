//
//  ViewController.m
//  DHBSDKDemo
//
//  Created by 蒋兵兵 on 16/8/17.
//  Copyright © 2016年 yulore. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#define APIKEY_Download @"mtyFwikuZ8ARgmwhljlidzxbevhrWrjL"

#define APIKEY2 @"abFRSWVlxTYkhZYbCcZSdapLVlllteGX"
#define APISIG2 @"E5UaGxNMkUxTVRrd01EbGtNemN5WlRoaFpUUmpZVFV3TnprM01UVT1ZV1l6TXpjell6QXlNVFV6TUdNMU4ySmtNMlExWXpWaU1XRm1OMlptTkdRPVpUSXlNR0UzWWpKalkyUXhNbUptWTJFNVl6QTRObUprTVRjNE1UUm1"
#define kDHBHost @"https://apis-ios.dianhua.cn/"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [DHBSDKApiManager registerApp:APIKEY_Download
                        signature:APISIG2
                             host:kDHBHost
                           cityId:nil
             shareGroupIdentifier:nil
                  completionBlock:^(NSError *error) {
                      ;
                  }];
    
    [DHBSDKApiManager dataInfoFetcherCompletionHandler:^(DHBSDKUpdateItem *updateItem, NSError *error) {
        NSLog(@"%@",updateItem);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
