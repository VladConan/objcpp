//
//  Loader.h
//  testcpp
//
//  Created by Vlad Konon on 12.10.2019.
//  Copyright © 2019 konon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ResultBlock)(NSData* _Nonnull);
typedef void (^FinishBlock)(NSError* _Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface Loader : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate>

- (void)startLoadingFromURL: (NSURL *) url resultBlock: (ResultBlock) resultBlock finishBlock:(FinishBlock) finishBlock;
- (void)cancel;

-(BOOL)isLoading;
@end

NS_ASSUME_NONNULL_END
