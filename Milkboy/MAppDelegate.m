//
//  MAppDelegate.m
//  Milkboy
//
//  Created by iRonhead on 5/15/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MAppDelegate.h"


//------------------------------------------------------------------------------
@interface MAppDelegate()
@property (nonatomic, readwrite, strong) UINavigationController* navController;
@property (nonatomic, readwrite, weak) CCDirectorIOS* director;
@property (nonatomic, assign) BOOL useRetinaDisplay;
@end

//------------------------------------------------------------------------------
@implementation MAppDelegate
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        self.useRetinaDisplay = NO;
    }

    return self;
}

//------------------------------------------------------------------------------
-(BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    //--Main Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	//--Director
    self.director = (CCDirectorIOS*)[CCDirector sharedDirector];

    //--Turn on display FPS
    [self.director setDisplayStats:YES];
    [self.director setAnimationInterval:1.0 / 30.0];

    //--GL View
    CCGLView* glView = [CCGLView viewWithFrame:[self.window bounds]
                                   pixelFormat:kEAGLColorFormatRGB565
                                   depthFormat:0
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];

    [self.director setView:glView];
    [self.director setDelegate:self];
    [self.director setWantsFullScreenLayout:YES];

    //--Retina Display ?
    [self.director enableRetinaDisplay:self.useRetinaDisplay];

    //--Navigation Controller
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.director];
    self.navController.navigationBarHidden = YES;

    //--AddSubView doesn't work on iOS6
    //[self.window addSubview:self.navController.view];
    [self.window setRootViewController:self.navController];
    [self.window makeKeyAndVisible];

    //--Default texture format for PNG/BMP/TIFF/JPEG/GIF images
    //--It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
    //--You can change anytime.
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB5A1];

    //--
    [CCTexture2D PVRImagesHavePremultipliedAlpha:TRUE];

    // If the 1st suffix is not found, then the fallback suffixes are going to used. If none is found, it will try with the name without suffix.
    // On iPad HD  : "-ipadhd", "-ipad",  "-hd"
    // On iPad     : "-ipad", "-hd"
    // On iPhone HD: "-hd"
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];

    [sharedFileUtils setEnableFallbackSuffixes:YES];            //--Default: NO. No fallback suffixes are going to be used
    [sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];      //--Default on iPhone RetinaDisplay is "-hd"
    [sharedFileUtils setiPadSuffix:@"-hd"];                     //--Default on iPad is "ipad"
    [sharedFileUtils setiPadRetinaDisplaySuffix:@"-xd"];        //--Default on iPad RetinaDisplay is "-ipadhd"

    //--load textures for tower, I need them everywhere
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];

    NSArray* namesSpriteFrameFile =
    @[
        @"Texture/menu.plist",
        @"Texture/back.plist",
        @"Texture/char.plist",
        @"Texture/step.plist",
        @"Texture/wall.plist",
        @"Texture/particle.plist"
    ];

    for (NSString* name in namesSpriteFrameFile)
    {
        [frameCache addSpriteFramesWithFile:name];
    }

    NSArray* namesTexture =
    @[
        @"Texture/menu.pvr.ccz",
        @"Texture/back.pvr.ccz",
        @"Texture/char.pvr.ccz",
        @"Texture/step.pvr.ccz",
        @"Texture/wall.pvr.ccz",
        @"Texture/particle.pvr.ccz"
    ];

    CCTextureCache* textureCache = [CCTextureCache sharedTextureCache];

    for (NSString* name in namesTexture)
    {
        [[textureCache addImage:name] setAliasTexParameters];
    }

    //--scene
    CCScene *scene = [NSClassFromString(@"MScene") new];

    //--go
    [self.director pushScene:scene];

    return YES;
}

//------------------------------------------------------------------------------
-(void) applicationWillResignActive:(UIApplication *)application
{
    if ([self.navController visibleViewController] == self.director)
    {
        [self.director pause];
    }
}

//------------------------------------------------------------------------------
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    if ([self.navController visibleViewController] == self.director)
    {
        [self.director resume];
    }
}

//------------------------------------------------------------------------------
-(void) applicationDidEnterBackground:(UIApplication*)application
{
    if ([self.navController visibleViewController] == self.director)
    {
        [self.director stopAnimation];
    }
}

//------------------------------------------------------------------------------
-(void) applicationWillEnterForeground:(UIApplication*)application
{
    if ([self.navController visibleViewController] == self.director)
    {
        [self.director startAnimation];
    }
}

//------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application
{
    CC_DIRECTOR_END();
}

//------------------------------------------------------------------------------
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [self.director purgeCachedData];
}

//------------------------------------------------------------------------------
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
    [self.director setNextDeltaTimeZero:YES];
}

//------------------------------------------------------------------------------
@end
