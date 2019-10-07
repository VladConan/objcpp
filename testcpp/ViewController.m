//
//  ViewController.m
//  testcpp
//
//  Created by Vladimir on 27/09/2019.
//  Copyright © 2019 konon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) UITextField *urlTextField;
@property (nonatomic, assign) UITextField *filterTextField;
@property (nonatomic, assign) UIButton* findButton;
@property (nonatomic, assign) UITextView* logView;
@property (nonatomic, retain) NSLayoutConstraint* logViewBottom;

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
	url.text = @"http://";
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

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Test", @"");
	[self configureConstraints];
	[self.urlTextField becomeFirstResponder];
}

- (void)configureConstraints{
	self.logViewBottom = [self.logView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-25];
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
	if ([self.filterTextField.text length] == 0){
		// TODO: show error
		return;
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
@end
