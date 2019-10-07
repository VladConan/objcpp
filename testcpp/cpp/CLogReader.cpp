//
//  CLogReader.cpp
//  testcpp
//
//  Created by Vlad Konon on 07/10/2019.
//  Copyright © 2019 konon. All rights reserved.
//

#include "CLogReader.h"
#include <cstring>

CLogReader::CLogReader(){
	
}

CLogReader::~CLogReader(){
	
}

bool CLogReader::SetFilter(const char *filter){
	size_t len = strnlen(filter, 1024);
	search_filter = new char[len]();
	strncpy(search_filter, filter, 1024);
	if (len == 1024) { // limit
		search_filter[1023] = 0;
	}
	// TODO: process input string
	return true;
}

bool CLogReader::AddSourceBlock(const char* block,const size_t block_size){
	return true;
}

