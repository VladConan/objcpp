//
//  nfa.hpp
//  testcpp
//
//  Created by Vlad Konon on 16.10.2019.
//  Copyright © 2019 konon. All rights reserved.
//

#ifndef nfa_hpp
#define nfa_hpp

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

namespace dfa {


class Ref;
class State;

/// append only dictionary
class Dict{
public:
	Dict();
	~Dict();
	const Ref* operator [] (const char key);
	void append(const Ref);
	size_t getCount();
private:
	size_t count;
	Ref* refs;
	size_t capacity;
};

class List{
public:
	List();
	~List();
	const State& operator [] (const size_t idx);
	void append(const State);
	size_t getCount();
private:
	size_t count;
	State* states;
	size_t capacity;
};

class State {
public:
	State(bool value = false);
	~State();
	void addEtransition(const State& state);
	void addTransition(const State& State, const char symbol);
protected:
	bool isEnd;
	Dict transitions;
	List etransitions;
};

struct Ref {
	char key;
	State state;
};

}
#ifdef __cplusplus
} // extern "C"
#endif

#endif /* nfa_hpp */
