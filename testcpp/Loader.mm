//
//  Loader.m
//  testcpp
//
//  Created by Vlad Konon on 12.10.2019.
//  Copyright © 2019 konon. All rights reserved.
//

#import "Loader.h"

@interface Loader()

@property (nonatomic, nonnull, retain) NSURLSession *urlSession;
@property (nonatomic, nonnull, retain) NSOperationQueue* delegateQueue;
@property (nonatomic, nullable, copy) ResultBlock resultBlock;
@property (nonatomic, nullable, copy) FinishBlock finishBlock;
@property (nonatomic, nullable, assign) NSURLSessionDataTask *dataTask;
@end

@implementation Loader

- (instancetype)init
{
	self = [super init];
	if (self) {
		NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
		_delegateQueue = [[[NSOperationQueue alloc] init] retain];
		_urlSession = [[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:_delegateQueue] retain];
	}
	return self;
}

- (void)dealloc
{
	[_urlSession dealloc];
	[_delegateQueue dealloc];
	[_resultBlock dealloc];
	[_finishBlock dealloc];
	[super dealloc];
}

- (void)startLoadingFromURL: (NSURL *) url resultBlock: (ResultBlock) resultBlock finishBlock:(FinishBlock) finishBlock{
	self.resultBlock = resultBlock;
	self.finishBlock = finishBlock;
	self.dataTask = [self.urlSession dataTaskWithURL:url];
	[_dataTask resume];
}

- (void)cancel{
	if ([self isLoading]) {
		[self.dataTask cancel];
		[self finishWithSuccess];
	}
}

-(BOOL)isLoading{
	return self.dataTask && self.dataTask.state == NSURLSessionTaskStateRunning;
}

- (void)finishWithSuccess{
	self.dataTask = nil;
	if (self.finishBlock){
		self.finishBlock(nil);
		self.finishBlock = nil;
		self.resultBlock = nil;
	}
}

- (void)finishWithError:(nonnull NSError *) error{
	self.dataTask = nil;
	if (self.finishBlock){
		self.finishBlock(error);
		self.finishBlock = nil;
		self.resultBlock = nil;
	}
}

#pragma mark - session delegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
	[self finishWithError:error];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
	NSUInteger code = [(NSHTTPURLResponse*)response statusCode];
	if (code>=200 && code<300) {
		completionHandler(NSURLSessionResponseAllow);
	}
	else {
		[self finishWithError:[NSError errorWithDomain:NSURLErrorDomain
												  code:code
											  userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Wrong response code: %lu", code]}]];
		completionHandler(NSURLSessionResponseCancel);
	}
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
	didReceiveData:(NSData *)data{
	self.resultBlock(data);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
	if (error) {
		[self finishWithError:error];
	}
	else {
		[self finishWithSuccess];
	}
}

@end
