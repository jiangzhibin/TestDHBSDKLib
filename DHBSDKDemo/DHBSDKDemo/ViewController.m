//
//  ViewController.m
//  DHBSDKDemo
//
//  Created by 蒋兵兵 on 16/8/17.
//  Copyright © 2016年 yulore. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

#define APIKEY_Download @"mtyFwikuZ8ARgmwhljlidzxbevhrWrjL"

#define APIKEY2 @"abFRSWVlxTYkhZYbCcZSdapLVlllteGX"
#define APISIG2 @"E5UaGxNMkUxTVRrd01EbGtNemN5WlRoaFpUUmpZVFV3TnprM01UVT1ZV1l6TXpjell6QXlNVFV6TUdNMU4ySmtNMlExWXpWaU1XRm1OMlptTkdRPVpUSXlNR0UzWWpKalkyUXhNbUptWTJFNVl6QTRObUprTVRjNE1UUm1"
#define kDHBHost @"https://apis-ios.dianhua.cn/"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createTestUI];
    
    
}
#pragma mark - 测试界面
#define kScrollView_H       (30.0f)
#define kScreen_W       [UIScreen mainScreen].bounds.size.width
#define kScreen_H           [UIScreen mainScreen].bounds.size.height
- (void)createTestUI {
    self.scrollView = [UIScrollView new];
    self.scrollView.frame = CGRectMake(0, kScreen_H - 200, kScreen_W, kScrollView_H);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // 添加测试按钮
    [self addTestBtnWithTitle:@"下载" action:@selector(downloadAction)];
    [self addTestBtnWithTitle:@"验证数据正确性" action:@selector(validateData)];
    [self addTestBtnWithTitle:@"在线标记" action:@selector(onlineMark)];
    [self addTestBtnWithTitle:@"在线识别" action:@selector(onlineRecognize)];
//    [self addTestBtnWithTitle:@"xxx" action:@selector(downloadAction)];
}


#pragma mark - 测试方法
/**
 下载
 */
- (void)downloadAction {
//    [DHBSDKApiManager shareManager].downloadNetworkType = DHBSDKDownloadNetworkTypeAllAllow;
    [DHBSDKApiManager registerApp:APIKEY_Download
                        signature:APISIG2
                             host:kDHBHost
                           cityId:nil
             shareGroupIdentifier:nil
                  completionBlock:^(NSError *error) {
                      
                      [DHBSDKApiManager dataInfoFetcherCompletionHandler:^(DHBSDKUpdateItem *updateItem, NSError *error) {
                          /*
                           记得修改要下载的数据类型
                           DHBDownloadPackageTypeDelta,
                           DHBDownloadPackageTypeFull
                           */
                          
//                                      updateItem.fullMD5 = @"a19a05255a33b5384641e9dd740524be";
//                                      updateItem.fullDownloadPath = @"http://s3.dianhua.cn/chk/flag/1_mtyF_flag_86_61.zip";
//                                      updateItem.fullSize = 2698755;
//                                      updateItem.fullVersion = 61;
                          
                          [DHBSDKApiManager downloadDataWithUpdateItem:updateItem dataType:DHBDownloadPackageTypeDelta progressBlock:^(double progress) {
                              NSLog(@"进度:%f",progress);
                          } completionHandler:^(NSError *error) {
                              NSLog(@"下载完成 error:%@",error);
                          }];
                      }];
                  }];
}

/**
 验证数据正确性
 */
- (void)validateData {
    NSString *filePath = [DHBSDKApiManager shareManager].pathForBridgeOfflineFilePath;
    NSUInteger count = 0;
    for (int i=0;i<1000;i++) {
        @autoreleasepool {
            NSString * filePathI=[[NSString alloc] initWithFormat:@"%@%d",filePath,i];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePathI])
            {
                //                NSLog(@"<<< %d >文件不存在:%@",i,filePathI);
                break;
            }
            NSMutableDictionary *contentDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePathI];
            count += [[contentDict allKeys] count];
            filePathI=nil;
        }
    }
    NSLog(@"记录总数:%zd",count);
}


/**
 在线标记
 */
- (void)onlineMark {
    [DHBSDKApiManager registerApp:APIKEY2
                        signature:APISIG2
                             host:kDHBHost
                           cityId:nil
             shareGroupIdentifier:nil
                  completionBlock:^(NSError *error) {
                      
                      [DHBSDKApiManager markTeleNumberOnlineWithNumber:@"13146022990" flagInfomation:@"推销" completionHandler:^(BOOL successed, NSError *error) {
                          NSLog(@"标记号码:%zd  error:%@",successed,error);
                      }];
                  }];
}


/**
 在线识别
 */
- (void)onlineRecognize {
    [DHBSDKApiManager registerApp:APIKEY2
                        signature:APISIG2
                             host:kDHBHost
                           cityId:nil
             shareGroupIdentifier:nil
                  completionBlock:^(NSError *error) {
                      
                      [DHBSDKApiManager searchTeleNumber:@"12315" completionHandler:^(DHBSDKResolveItemNew *resolveItem, NSError *error) {
                          NSLog(@"%@",resolveItem);
                          NSLog(@"error:%@",error);
                      }];
                  }];

}


#define kButton_Font        [UIFont systemFontOfSize:16.0f]
#define kButton_Padding     (5.0f)
- (void)addTestBtnWithTitle:(NSString *)title
                     action:(SEL)selector {
    if (title == nil || selector == NULL) {
        return;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = kButton_Font;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(kScreen_W, kScrollView_H) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : kButton_Font} context:nil].size;
    titleSize.width = ceilf(titleSize.width) + 10;
    
    UIView *lastView = self.scrollView.subviews.lastObject;
    CGSize contentSize = self.scrollView.contentSize;
    if (lastView == nil) {
        button.frame = CGRectMake(0, 0, titleSize.width, kScrollView_H);
        contentSize.width += titleSize.width;
    }
    else {
        button.frame = CGRectMake(CGRectGetMaxX(lastView.frame) + kButton_Padding, 0, titleSize.width, kScrollView_H);
        contentSize.width += (kButton_Padding + titleSize.width);
    }
    [self.scrollView addSubview:button];
    self.scrollView.contentSize = contentSize;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
