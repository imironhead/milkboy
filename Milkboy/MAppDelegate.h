//
//  MAppDelegate.h
//  Milkboy
//
//  Created by iRonhead on 5/15/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "cocos2d.h"


//------------------------------------------------------------------------------
@interface MAppDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate>
@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, readonly, strong) UINavigationController* navController;
@property (nonatomic, readonly, weak) CCDirectorIOS* director;
@end
