//
//  nfa.cpp
//  testcpp
//
//  Created by Vlad Konon on 16.10.2019.
//  Copyright © 2019 konon. All rights reserved.
//

#include "nfa.hpp"
#include <cstring>

using namespace dfa;

#pragma mark - dict

Dict::Dict() {
	capacity = 32;
	count = 0;
	refs = new Ref[capacity]();
}

Dict::~Dict() {
	delete [] refs;
}

const Ref* Dict::operator[](const char key){
	if (count==0){
		return nullptr;
	}
	for (size_t i=0;i<count;i++){
		if (refs[i].key == key)
		{
			return &refs[i];
		}
	}
	return nullptr;
}

void Dict::append(const Ref value){
	if (count+1>=capacity) {
		capacity+=32;
		Ref* newRefs = new Ref[capacity]();
		memcpy(newRefs, refs, count*sizeof(Ref));
		refs=newRefs;
	}
	refs[count++] = value;
}

size_t Dict::getCount(){
	return count;
}

#pragma mark - list

List::List() {
	capacity = 32;
	count = 0;
	states = new State[capacity]();
}

List::~List(){
	delete [] states;
}

const State& List::operator[](const size_t idx){
	if (idx>=count){
		throw "out of index";
	}
	return states[idx];
}

size_t List::getCount(){
	return count;
}

void List::append(const State value){
	if (count+1>=capacity) {
		capacity+=32;
		State* newStates = new State[capacity]();
		memcpy(newStates, states, count*sizeof(State));
		states=newStates;
	}
	states[count++] = value;
}

#pragma mark - state

State::State(bool value){
	isEnd = value;
}

State::~State(){
	
}

void State::addEtransition(const State& state){
	etransitions.append(state);
}

void State::addTransition(const State& state, const char symbol){
	Ref ref = {symbol, state};
	transitions.append(ref);
}
