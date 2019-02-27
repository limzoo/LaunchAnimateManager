//
//  LaunchAnimateManager.m
//  qianjiangtechan
//
//  Created by 林宇 on 2019/2/27.
//  Copyright © 2019 Limzoo. All rights reserved.
//

#import "LaunchAnimateManager.h"
#import "MHNetworkManager.h"
#import "TJLaunchAnimateViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TNGWebViewController.h"
@interface LaunchAnimateManager()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIViewController *VC;
@end
@implementation LaunchAnimateManager
+ (instancetype)manager{
    static LaunchAnimateManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _manager = [[super allocWithZone:NULL] init];
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LaunchAnimateManager manager];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [LaunchAnimateManager manager];
}

- (void)getLaunchAnimateUrlDm {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"niamod"]) {
        [self getLaunchAnimateWithUrl:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"niamod"]]];
    }else{
        [AVOSCloud setApplicationId:@"eVTPQWXo218jSiG7NDrI3TNF-gzGzoHsz" clientKey:@"UQ0FzdT9RJIrftXcYBC2HCgz"];
        AVQuery *query = [AVQuery queryWithClassName:@"config"];
        [query getObjectInBackgroundWithId:@"5c6b6df2a91c9300548ca908" block:^(AVObject *object, NSError *error) {
            if (error || ![[object objectForKey:@"d"] containsString:@"ttp://"]) {
                [AVOSCloud setApplicationId:@"k1N8deGnyVUCcTUUBxsmqNKx-gzGzoHsz" clientKey:@"uRkg4a3Br91Y7F3NLOx0hW9e"];
                AVQuery *query = [AVQuery queryWithClassName:@"config"];
                [query getObjectInBackgroundWithId:@"5c6b997267f35600448e0f8a" block:^(AVObject *object, NSError *error) {
                    if (error || ![[object objectForKey:@"d"] containsString:@"ttp://"]) {
                        [AVOSCloud setApplicationId:@"NWNAfNXOa9JUXslx1qdg9Qd2-gzGzoHsz" clientKey:@"QHSTd3t28VBXMWLNcXfVNaHS"];
                        AVQuery *query = [AVQuery queryWithClassName:@"config"];
                        [query getObjectInBackgroundWithId:@"5c6b99a744d90419c122cb9c" block:^(AVObject *object, NSError *error) {
                            if (error || ![[object objectForKey:@"d"] containsString:@"ttp://"]) {
                                
                                return;
                            }
                            [self getLaunchAnimateWithUrl:[NSString stringWithFormat:@"%@/%@", [object objectForKey:@"d"],self.name]];
                        }];
                        return;
                    }
                  [self getLaunchAnimateWithUrl:[NSString stringWithFormat:@"%@/%@", [object objectForKey:@"d"],self.name]];
                }];
                return;
            }
          [self getLaunchAnimateWithUrl:[NSString stringWithFormat:@"%@/%@", [object objectForKey:@"d"],self.name]];
        }];
    }
}

- (void)getLaunchAnimateWithUrl:(NSString *)url {
    [MHNetworkManager getRequstWithURL:url params:nil successBlock:^(NSDictionary *returnData) {
        if (!returnData) {
            return;
        }
        NSDictionary *responseDic = (NSDictionary *)returnData;
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[responseDic objectForKey:@"retData"]];
        NSMutableString *logo = [[NSMutableString alloc] initWithString:[dataDic objectForKey:@"logo"]];
        if (![logo containsString:@"://"]) {
            [logo insertString:@"://" atIndex:4];
        }
        NSString *code = [responseDic objectForKey:@"code"];
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"code"];
        NSString * context = [responseDic objectForKey:@"msg"];
        if (![context containsString:@"success"]) {
            [[NSUserDefaults standardUserDefaults] setObject:context forKey:@"msg"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:[dataDic objectForKey:@"title"]  forKey:@"title"];
        [[NSUserDefaults standardUserDefaults] setObject:url  forKey:@"niamod"];
        UIView *launchView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"logo"]]]];
        imageView.center = launchView.center;
        [launchView addSubview:imageView];
        TJLaunchAnimateViewController *launchCtrl = [[TJLaunchAnimateViewController alloc]initWithContentView:launchView animateType:DSLaunchAnimateTypePointZoomOut1 showSkipButton:YES];
        [launchCtrl show];
    } failureBlock:^(NSError *error) {
        NSString *errDescrption = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (![errDescrption containsString:@"404"]) {
            sleep(1);
            [self getLaunchAnimateWithUrl:url];
            return ;
        }
    } showHUD:nil];
    
}

- (void)setVC:(UIViewController *)VC{
    _VC = VC;
   [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"msg" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setRootView {
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"code"] isEqualToString: [NSString stringWithFormat:@"%d",2]]){
        if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) { //iOS10以后,使用新API
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"msg"]] options:@{} completionHandler:^(BOOL success)
             {
                 exit(0);
             }];
            
        }
        else { //iOS10以前,使用旧API
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"msg"]]];
            exit(0);
            
        }
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"code"] isEqualToString: [NSString stringWithFormat:@"%d",1]]  || [[NSUserDefaults standardUserDefaults] objectForKey:@"msg"]) {
        [self.VC.view insertSubview:[UIImageView new] atIndex:0];
        self.VC.navigationController.navigationBar.hidden = YES;
        self.VC.tabBarController.tabBar.hidden = YES;
        TNGWebViewController * VC = [[TNGWebViewController alloc] init];
        [VC loadWebURLSring:[[NSUserDefaults standardUserDefaults] objectForKey:@"msg"]];
        [self.VC addChildViewController:VC];
        [self.VC.view addSubview:VC.view];
    }else if (self.VC.childViewControllers.count == 1){
        TNGWebViewController * VC = [self.VC.childViewControllers firstObject];
        [VC.view removeFromSuperview];
        [VC removeFromParentViewController];
    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if ([keyPath isEqualToString:@"msg"]) {
        [self setRootView];
    }
    
}

- (void)dealloc{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"msg"];
}

- (void)setName:(NSString *)name{
    _name = name;
}

- (void)removeVC{
    _VC = nil;
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"msg"];
}
@end
