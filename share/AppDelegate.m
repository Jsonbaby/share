//
//  AppDelegate.m
//  share
//
//  Created by 张璠 on 16/11/14.
//  Copyright © 2016年 张璠. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "AFNetworking.h"
#import "WeiboSDK.h"
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()<WXApiDelegate,QQApiInterfaceDelegate,WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:@"wxcab5e47b1e1fdd39"];//此为申请下来的key一般以wx开头
    [[TencentOAuth alloc] initWithAppId:@"1105593761" andDelegate:nil]; //注册
    [WeiboSDK registerApp:@"882182138"];
    [WeiboSDK enableDebugMode:YES];
    
    return YES;
}

// 从微信端打开第三方APP会调用此方法,此方法再调用代理的onResp方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
      [WXApi handleOpenURL:url delegate:self];
      [TencentOAuth HandleOpenURL:url];
      [WeiboSDK handleOpenURL:url delegate:self];
      return YES;
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation{
    
    [WXApi handleOpenURL:url delegate:self];
    [QQApiInterface handleOpenURL:url delegate:self];
    [TencentOAuth HandleOpenURL:url];
    return YES;
    
}


- (void)onResp:(BaseResp *)resp {

//    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"信息" message:@"分享成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//    [alertview show];
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            
            SendAuthResp *resp2 = (SendAuthResp *)resp;
            NSLog(@"微信code=%@",resp2.code);
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"appid"] = @"wxcab5e47b1e1fdd39";
            param[@"secret"] = @"decc38d7914cbf155f4cd63952509383";
            param[@"code"] = resp2.code;
            param[@"grant_type"] = @"authorization_code";

            [[AFHTTPSessionManager manager] GET:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"-----%@------",responseObject[@"access_token"]);
                
                NSMutableDictionary *param2 = [NSMutableDictionary dictionary];
                param2[@"access_token"] = responseObject[@"access_token"];
                param2[@"openid"] = @"wxcab5e47b1e1fdd39";
                
                [[AFHTTPSessionManager manager] GET:@"https://api.weixin.qq.com/sns/userinfo" parameters:param2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"-----%@------",responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"--------%@",error);
                }];
            
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"--------%@",error);
            }];
            }
        }else{ //失败
           NSLog(@"失败的啦");
        }
    
}

#pragma mark -- WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
