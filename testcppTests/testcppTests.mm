//
//  testcppTests.m
//  testcppTests
//
//  Created by Vlad Konon on 11.10.2019.
//  Copyright © 2019 konon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLogReader.h"
#include <cstring>

@interface testcppTests : XCTestCase
{
	CLogReader* sut;
}
@end

@implementation testcppTests

- (void)setUp {
	sut = new CLogReader();
}

- (void)tearDown {
	delete sut;
}

- (void)testFilterSetNULL {
	XCTAssert(sut->SetFilter(nullptr)==false, "should return false for null filter");
}

-(void)testFilerNormal{
	const char *testString = "test string";
	XCTAssert(sut->SetFilter(testString), "while setting filter result not true");
	XCTAssert(strncmp(testString, sut->GetFilter(), 1024) == 0, "wrongFilter");
}

-(void)testFilerOneStar{
	const char *testString = "*test*string*";
	XCTAssert(sut->SetFilter(testString), "while setting filter result not true");
	XCTAssert(strncmp(testString, sut->GetFilter(), 1024) == 0, "wrongFilter");
}

-(void)testFilerOneStarStaterManyInsideOneEnd{
	const char *testString = "*test******string*";
	XCTAssert(sut->SetFilter(testString), "while setting filter result not true");
	XCTAssert(strncmp("*test*string*", sut->GetFilter(), 1024) == 0, "wrongFilter");
}

-(void)testFilerManyStarStaterOneInsideOneEnd{
	const char *testString = "*****test*string*";
	XCTAssert(sut->SetFilter(testString), "while setting filter result not true");
	XCTAssert(strncmp("*test*string*", sut->GetFilter(), 1024) == 0, "wrongFilter");
}

-(void)testFilerOneStarStaterOneInsideManyEnd{
	const char *testString = "*test*string*******";
	XCTAssert(sut->SetFilter(testString), "while setting filter result not true");
	XCTAssert(strncmp("*test*string*", sut->GetFilter(), 1024) == 0, "wrongFilter");
}

-(void)testFilerManyAny{
	const char *testString = "*****test*****string*******";
	XCTAssert(sut->SetFilter(testString), "while setting filter result not true");
	XCTAssert(strncmp("*test*string*", sut->GetFilter(), 1024) == 0, "wrongFilter");
}

-(void)testFilerLongString{
	char testString[2048];
	memset(testString, '-', 2048);
	testString[2047]=0;
	XCTAssert(sut->SetFilter(testString), "while setting filter result not true");
	XCTAssert(strlen(sut->GetFilter()) == 1023, "wrong trim");
}

@end
