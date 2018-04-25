# CustomURLProtocol

查看APP的网络请求.

在AppDelegate里面注册.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  //注册protocol 监听所有网络请求
    [NSURLProtocol registerClass:[CustomURLProtocol class]];
    
    
    return YES;
}
