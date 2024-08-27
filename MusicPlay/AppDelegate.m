#import "AppDelegate.h"
#import "ViewController.h"
#import "MPProfileManager.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create the window
    
    [[MPProfileManager sharedManager] init];
    
    return YES;
}

 
@end
