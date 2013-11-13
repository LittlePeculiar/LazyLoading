//
//  Download.h
//  LazyLoading
//
//  Created by Gina Mullins on 11/12/13.
//  Copyright (c) 2013 Gina Mullins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Download : NSObject <NSURLSessionTaskDelegate>

+ (Download*)shareManager;
- (NSMutableArray*)refreshData;
- (void)retrieveImage:(NSString*)urlString withCompletionBlock:(void (^)(BOOL succeeded, UIImage *image))completed;


@end
