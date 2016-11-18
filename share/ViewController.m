//
//  ViewController.m
//  share
//
//  Created by 张璠 on 16/11/14.
//  Copyright © 2016年 张璠. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"
@interface ViewController ()<TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissionArray;   //权限列表
}
@end

@implementation ViewController
- (IBAction)sinaShare:(id)sender {
//    if (![WeiboSDK isWeiboAppInstalled]) {
//        [self showLoadSinaWeiboClient];
//    }else {
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://www.sina.com";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"ViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    NSLog(@"sina");
//    }
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    
     message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!http://www.baidu.com", nil);
    
    
   
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
    message.imageObject = image;
    
    
    
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.objectID = @"identifier1";
//    webpage.title = @"测试通过WeiboSDK发送文字到微博!";
//    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
//    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
//    webpage.webpageUrl = @"http://resources.icloudcity.cn/resources/html/201610/news_1010.html";
//    message.mediaObject = webpage;
    
    
    return message;
}


- (IBAction)wxShare:(id)sender {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"分享标题";
    message.description = @"分享描述";
    [message setThumbImage:[UIImage imageNamed:@"wx"]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"https://open.weixin.qq.com";
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    NSLog(@"share");
    
    [WXApi sendReq:req];
}
- (IBAction)sendFriendCircle:(id)sender {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"分享标题";
    message.description = @"分享描述";
    [message setThumbImage:[UIImage imageNamed:@"wx"]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"https://open.weixin.qq.com";
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    NSLog(@"share");
    
    [WXApi sendReq:req];
}
- (IBAction)sendQQ:(id)sender {
    // 分享跳转URL
    NSString *url = @"http://wiki.open.qq.com";
    // 分享图、预览图URL地址
    NSString *previewImageUrl = @"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=图片&hs=0&pn=0&spn=0&di=58486014950&pi=0&rn=1&tn=baiduimagedetail&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1864751896%2C666907639&os=74946260%2C658845074&simid=3448034153%2C561304310&adpicid=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fm2.quanjing.com%2F2m%2Ffod_liv002%2Ffo-11171537.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bq7wg3tg2_z%26e3Bv54AzdH3Ffiw6jAzdH3Fu5-88808cn0_z%26e3Bip4s&gsm=0";
    //分享内容
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:@"标题" description:@"描述" previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    // 将内容分享到qq
    QQApiSendResultCode send = [QQApiInterface sendReq:req];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"信息" message:@"分享成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertview show];
    
}
- (IBAction)sendQQCircle:(id)sender {
    // 分享跳转URL
    NSString *url = @"http://wiki.open.qq.com";
    // 分享图、预览图URL地址
    NSString *previewImageUrl = @"qq";
    //分享内容
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:@"标题" description:@"描述" previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    // 将内容分享到qzone
    QQApiSendResultCode send = [QQApiInterface SendReqToQZone:req];

}

- (IBAction)qqLogin:(id)sender {
   
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105593761" andDelegate:self];
     _permissionArray = [NSMutableArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            nil];
    [_tencentOAuth authorize:_permissionArray];
}
#pragma TencentSessionDelegate
/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}
-(void)tencentDidLogin{
     NSLog(@"----ok-----");
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        
        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
        //- (void)getUserInfoResponse:(APIResponse*) response
        //这个方法就是 用户信息的回调方法。
        
        [_tencentOAuth getUserInfo];
    }else{
        
        NSLog(@"accessToken 没有获取成功");
    }
}
//-(NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams{
//    NSLog(@"----%@********%@-----",permissions,extraParams);
//    return permissions;
//}
- (void)getUserInfoResponse:(APIResponse*) response{
     NSLog(@"*********");
     NSLog(@" response %@",response);
     NSLog(@"*********");
}

-(void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@" 用户点击取消按键,主动退出登录");
    }else{
        NSLog(@"其他原因， 导致登录失败");
    }
}
-(void)tencentDidNotNetWork{
     NSLog(@"没有网络了， 怎么登录成功呢");
}
- (IBAction)wxLogin:(id)sender {
        NSLog(@"%d",[WXApi isWXAppInstalled]);
//    if ([WXApi isWXAppInstalled]){
        //构造SendAuthReq结构体
        SendAuthReq* req = [[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
//    }else{
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:actionConfirm];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
    
}

//-(void)loginSuccessByCode:(NSString *)code{
//    NSLog(@"code %@",code);
//    __weak typeof(*&self) weakSelf = self;
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil nil];
//    //通过 appid  secret 认证code . 来发送获取 access_token的请求
//    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",URL_APPID,URL_SECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dic %@",dic);
//        
//        /*
//         access_token   接口调用凭证
//         expires_in access_token接口调用凭证超时时间，单位（秒）
//         refresh_token  用户刷新access_token
//         openid 授权用户唯一标识
//         scope  用户授权的作用域，使用逗号（,）分隔
//         unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
//         */
//        NSString* accessToken=[dic valueForKey:@"access_token"];
//        NSString* openID=[dic valueForKey:@"openid"];
//        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error %@",error.localizedFailureReason);
//    }];
//    
//}
//
//-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dic  ==== %@",dic);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error %ld",(long)error.code);
//    }];
//}
//

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
