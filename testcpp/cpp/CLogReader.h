//
//  CLogReader.h
//  testcpp
//
//  Created by Vlad Konon on 07/10/2019.
//  Copyright © 2019 konon. All rights reserved.
//

#ifndef CLogReader_h
#define CLogReader_h

#ifdef __cplusplus
extern "C" {
#endif

#include <cstddef>

class CLogReader {
public:
	CLogReader();
	~CLogReader();
	bool SetFilter(const char *filter); /// установка фильтра строк, false - ошибка, пусть максимальный размер будет 1024
	bool AddSourceBlock(const char* block,const size_t block_size); /// добавление очередного блока текстового файла
private:
	char* search_filter;
};

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* CLogReader_hpp */
