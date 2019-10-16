//
//  CLogReader.cpp
//  testcpp
//
//  Created by Vlad Konon on 07/10/2019.
//  Copyright © 2019 konon. All rights reserved.
//

#include "CLogReader.hpp"
#include <cstring>

CLogReader::CLogReader(){
}

CLogReader::~CLogReader(){
}

bool CLogReader::SetFilter(const char *filter){
	if (filter == nullptr) {
		return false;
	}
	const size_t len = strnlen(filter, SEARCH_FILTER_MAX_LEN);
	int i=0;
	int j=0;
	while (filter[i] != 0 && i<len) {
		search_filter[j] = filter[i];
		if (i>0 && filter[i-1] == '*' && filter[i]=='*') {
			do i++; while (filter[i] == '*' && i<len);
			search_filter[j] = filter[i];
		}
		j++;
		i++;
	};
	if (j>=SEARCH_FILTER_MAX_LEN) {
		search_filter[SEARCH_FILTER_MAX_LEN-1] = 0;
	}
	return true;
}

const char* CLogReader::GetFilter(){
	return search_filter;
}

bool CLogReader::AddSourceBlock(const char* block,const size_t block_size){
	return true;
}

