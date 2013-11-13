//
//  Download.m
//  LazyLoading
//
//  Created by Gina Mullins on 11/12/13.
//  Copyright (c) 2013 Gina Mullins. All rights reserved.
//

#import "Download.h"
#import "DBFile.h"

@implementation Download
{
    NSURLSession *_session;
}

+ (Download*)shareManager
{
    static Download *myManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myManager = [[self alloc] init];
    });
    
    return myManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSLog(@"Download init");
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // some params - depends on requirements
        sessionConfig.allowsCellularAccess = NO;
        [sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
        sessionConfig.timeoutIntervalForRequest = 30.0;
        sessionConfig.timeoutIntervalForResource = 60.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;
        
        _session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:self
                                            delegateQueue:nil];
    }
    return self;
}

// get list of image names -
- (NSMutableArray*)refreshData
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSString *appFolder = @"";
    
    NSString *photoDir = [NSString stringWithFormat:@"https://api.dropbox.com/1/search/dropbox/%@/photos?query=.jpg",appFolder];
    NSURL *url = [NSURL URLWithString:photoDir];
    
    [[_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200)
            {
                NSError *jsonError;
                NSArray *filesJSON = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:NSJSONReadingAllowFragments
                                      error:&jsonError];
                
                if (!jsonError)
                {
                    for (NSDictionary *fileMetadata in filesJSON)
                    {
                        DBFile *file = [[DBFile alloc]
                                        initWithJSONData:fileMetadata];
                        [photos addObject:file];
                    }
                    
                    [photos sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        return [obj1 compare:obj2];
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 
                    });
                }
            } else {
                // HANDLE BAD RESPONSE //
            }
        } else {
            // ALWAYS HANDLE ERRORS :-] //
        }
    }] resume];
    
    // testing
    if ([photos count] == 0)
        [photos addObject:@"http://www.raywenderlich.com/images/store/iOS7_PDFonly_280@2x_authorTBA.png"];
    return photos;
}

- (void)retrieveImage:(NSString*)urlString withCompletionBlock:(void (^)(BOOL succeeded, UIImage *image))completed
{
    NSString *encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedUrl];
    
    NSURLSessionDownloadTask *getImageTask =
    [_session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = downloadedImage;
                completed(YES, image);
            });
        }
        else
        {
            completed(NO, nil);
        }
          }];
    
    [getImageTask resume];
}

@end
