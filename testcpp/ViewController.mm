//
//  ViewController.m
//  testcpp
//
//  Created by Vladimir on 27/09/2019.
//  Copyright © 2019 konon. All rights reserved.
//

#import "ViewController.h"
#import "CLogReader.h"
#import "Loader.h"

@interface ViewController ()
{
	CLogReader* reader;
}
@property (nonatomic, assign) UITextField *urlTextField;
@property (nonatomic, assign) UITextField *filterTextField;
@property (nonatomic, assign) UIButton* findButton;
@property (nonatomic, assign) UITextView* logView;
@property (nonatomic, retain) NSLayoutConstraint* logViewBottom;
@property (nonatomic, retain) Loader* loader;

@end

@implementation ViewController

-(void) loadView {
	UIView *view = [UIView new];
	self.view = view;
	view.backgroundColor = [UIColor whiteColor];
	UITextField* url = [UITextField new];
	url.placeholder = @"http://some.com";
	url.textColor = [UIColor blackColor];
	url.borderStyle = UITextBorderStyleRoundedRect;
	url.translatesAutoresizingMaskIntoConstraints = NO;
	url.delegate = self;
	url.keyboardType = UIKeyboardTypeURL;
	url.returnKeyType = UIReturnKeyNext;
	url.text = @"https://norvig.com/big.txt";
	[view addSubview:url];
	self.urlTextField = url;
	UITextField *filter = [UITextField new];
	filter.placeholder = NSLocalizedString(@"Search string", @"");
	filter.textColor = [UIColor blackColor];
	filter.borderStyle = UITextBorderStyleRoundedRect;
	filter.translatesAutoresizingMaskIntoConstraints = NO;
	filter.delegate = self;
	filter.returnKeyType = UIReturnKeySearch;
	filter.keyboardType = UIKeyboardTypeAlphabet;
	[view addSubview:filter];
	self.filterTextField = filter;
	UIButton *find = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[find setTitle:NSLocalizedString(@"Search", @"") forState:UIControlStateNormal];
	[find addTarget:self action:@selector(findAction) forControlEvents:UIControlEventTouchUpInside];
	find.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:find];
	self.findButton = find;
	UITextView* textView = [UITextView new];
	textView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
	textView.textColor = [UIColor blackColor];
	textView.font = [UIFont systemFontOfSize:10 weight:UIFontWeightLight];
	textView.translatesAutoresizingMaskIntoConstraints = NO;
	textView.text = NSLocalizedString(@"Result", @"");
	textView.editable = NO;
	[view addSubview:textView];
	self.logView = textView;
}

- (void)dealloc
{
	self.loader=nil;
	self.logViewBottom=nil;
	delete reader;
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Test", @"");
	[self configureConstraints];
	[self.urlTextField becomeFirstResponder];
	self.loader = [Loader new];
	reader = new CLogReader();
}

- (void)configureConstraints{
	self.logViewBottom = [[self.logView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-25] retain];
	NSArray <NSLayoutConstraint*> *constaints = @[
		[self.urlTextField.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:15],
		[self.urlTextField.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-15],
		[self.urlTextField.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50],
		[self.filterTextField.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:15],
		[self.filterTextField.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-15],
		[self.filterTextField.topAnchor constraintEqualToAnchor:self.urlTextField.bottomAnchor constant:20],
		[self.findButton.heightAnchor constraintEqualToConstant:44],
		[self.findButton.widthAnchor constraintEqualToConstant:100],
		[self.findButton.topAnchor constraintEqualToAnchor:self.filterTextField.bottomAnchor constant:20],
		[self.findButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
		[self.logView.topAnchor constraintEqualToAnchor:self.findButton.bottomAnchor constant:20],
		[self.logView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:16],
		[self.logView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-16],
		self.logViewBottom
	];
	[NSLayoutConstraint activateConstraints:constaints];
}


- (void)findAction {
	[self.view endEditing:YES];
	if (self.loader.isLoading){
		[self.loader cancel];
		[self.findButton setTitle:@"Search" forState:UIControlStateNormal];
		return;
	}
	if ([self.filterTextField.text length] == 0){
		[self showAlertTitle:@"Error" message:@"Search text is empty"];
		return;
	}
	NSURL* url = [NSURL URLWithString:self.urlTextField.text];
	if (!url){
		[self showAlertTitle:@"Error" message:@"Can't get url"];
	}
	if (reader->SetFilter([self.filterTextField.text cStringUsingEncoding:NSASCIIStringEncoding])){
		[self.findButton setTitle:@"Stop search" forState:UIControlStateNormal];
		[self.loader startLoadingFromURL:url
							 resultBlock:^(NSData * _Nonnull data) {
			if (reader->AddSourceBlock((const char*)data.bytes, data.length)) {
				// TODO: get results
				printf("got %lu bytes\n", data.length);
			}
			else {
				// TODO: log error
				printf("got error adding block\n");
			}
		} finishBlock:^(NSError * _Nullable error) {
			if (error){
				dispatch_async(dispatch_get_main_queue(), ^{
					[self showAlertTitle:@"Error" message:[error localizedDescription]];
				});
			}
			else {
				printf("Finished loading\n");
			}
		}];
	}
	else {
		[self showAlertTitle:@"Error" message:@"Can't set filter string"];
	}
	// TODO: call search
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField == self.urlTextField){
		[self.filterTextField becomeFirstResponder];
	}
	else {
		[self findAction];
	}
	return NO;
}

-(void)showAlertTitle:(nullable NSString *)title message:(nullable NSString *)message{
	UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	[ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
	}]];
	[self presentViewController:ac animated:YES completion:nil];
}

-(void)addToLog:(NSString*) string{
	
}
@end
