//
//  AppDelegate.h
//  LazyLoading
//
//  Created by Gina Mullins on 11/12/13.
//  Copyright (c) 2013 Gina Mullins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) UINavigationController *navigationController;


@end
