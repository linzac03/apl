#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <cstdlib>
#include <ext/functional>
#include <iterator>
#include <list>

using namespace std;
using namespace __gnu_cxx;

list<int> ls;
list<int>::iterator it = ls.begin();
int lastWidth = 0;
int aexp;
float rexp;
list<int> prev_ls;
list<int> original_ls;
int removed = 0;

int constructList() {
	int toIns;
	while (toIns < 2) {
		cin >> toIns;
		if (toIns < 2) ls.insert(it, toIns);
	}
	return 0;
}

int stuffBit() {
	int cnt = 0;
	int i;
	original_ls = ls;
	it = ls.begin();
	int size = ls.size();
	lastWidth = (float)size;
	for(i=0; i < size; i++) {
		if (*it == 1) { 
			cnt++;
		} else {
			cnt = 0;
		}	
		it++;
		if (cnt == 5) {
			ls.insert(it, 0);
			cnt = 0;
		} 
		cout << cnt << " ::: " << *it << endl;
	}
	return 0;
}

int unstuffBit() {
	int cnt = 0;
	int i;
	prev_ls = ls;
	it = ls.begin();
	int size = ls.size();
	while (removed < aexp){ 
		if (*it == 1) { 
			cnt++;
		} else {
			cnt = 0;
		}	
		it++;
		if (cnt == 5) {
			it = ls.erase(it);
			removed++;
			cnt = 0;
		}
	}
	
	return 0;
}

int absoluteExp() {
	aexp = ls.size() - lastWidth;
	return 0;
}

int relativeExp() {
	rexp = 100.00 - (100.00 * ((float)lastWidth / (float)ls.size()));
	return 0;
}

int main() {
	constructList();
//	cout << "Original: ";
//	copy(ls.begin(), ls.end(), ostream_iterator<int>(cout, " "));
	cout << "| " << ls.size() << endl;
	stuffBit();
	cout << "Stuffed: ";
	copy(ls.begin(), ls.end(), ostream_iterator<int>(cout, " "));
	cout << endl;
	absoluteExp();
	cout << "Absolute Expansion: " << aexp << endl;
	relativeExp();
	cout << "Relative Expansion: " << rexp << "%" << endl;
	cout << "Unstuffed: ";
	unstuffBit();
	int i;
	it = ls.begin();
	while (i < ls.size()) {
		cout << *it;
		it++;
		i++;
	}
	cout << endl;
	cout << "Unstuffed == Original: " << (ls == original_ls) << endl; 
	
}
