#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <cstdlib>
#include <ext/functional>
#include <iterator>

using namespace std;
using namespace __gnu_cxx;

vector<int> values(100);
vector<string> strings(100);

int randomNumber () {
	return rand()%100;
}

int part_one() {	
	generate(values.begin(), values.end(), randomNumber);
	vector<int> ovalues(100);
	copy(values.begin(), values.end(), ovalues.begin());
	
	int i;
	cout << "values: {";
	for(i=0; i < 100; i++){
		cout << ovalues[i];
		if (i < 99) cout << ",";
	}
	cout << '}' << endl;

	return 0;
}

char randomChar () {
	return 97 + rand() % 26;
}

string randomString () {
	int len;
	len = (rand() + 5) % 15;
	char buff[len];
	generate(buff, buff+len, randomChar);
	return (string)buff;
}

int part_two() {	
	generate(strings.begin(), strings.end(), randomString);
	vector<string> ostrings(100);
	copy(strings.begin(), strings.end(), ostrings.begin());
	
	int i;
	cout << "strings: {";
	for(i=0; i < 100; i++){
		cout << ostrings[i];
		if (i < 99) cout << ',';
	}
	cout << '}' << endl;

	return 0;
}

template <typename It, typename Fn_state>
Fn_state forEach (It first, It last, Fn_state f) {
	while (first != last) {
		f(*first);
		++first;
	}

	return f;
}

struct adder : public unary_function <int, void> {
	pair<int,int> counts;
	adder() : counts(0,0) {}
	void operator() (int x) {if (x % 2 != 0) 
								counts.first += 1;
							 else 
								counts.second += 1;}
};

int part_three() {
	vector<int> oevals;
	vector<int> oevals_copy;
	adder results;	
	generate(oevals.begin(), oevals.end(), randomNumber);
	oevals_copy = oevals;

	int i;
	cout << "counts: {";
	results = forEach(oevals.begin(), oevals.end(), adder());
	for(i=0; i < oevals.size(); i++){
	}

	cout << "odds: " << results.counts.first << ", evens: " << results.counts.second << '}' << endl;

	return 0;
}

int part_four() {
	//this code builds up the vector v and copies it to cout, then removes the evens and copies the result to cout
	//well 4 and 2 were replaced by odds 5 and 7 so i don't know whats going on
	vector<int> v;
	v.push_back(1);
	v.push_back(4);
	v.push_back(2);
	v.push_back(8);
	v.push_back(5);
	v.push_back(7);
    copy(v.begin(), v.end(), ostream_iterator<int>(cout, " "));	
    cout << endl;
    vector<int>::iterator new_end = remove_if(v.begin(), v.end(), 
			compose1(
				bind2nd(equal_to<int>(), 0), 
				bind2nd(modulus<int>(), 2)
			));
	copy(v.begin(), new_end, ostream_iterator<int>(cout, " "));
	cout << endl << endl;
	return 0;
}

template <typename BidirectionalIterator>
void my_reverse(BidirectionalIterator first, BidirectionalIterator last) {
	int dist;
	dist = distance(first, last);
	int i;
	if (dist % 2 != 0)
		for (i=0; i<=(dist/2); i++) {
			last--;
			swap(*first, *last);
			first++;
		}
	else
		for (i=0; i<=(dist/2)-1; i++) {
			last--;
			swap(*first, *last);
			first++;
		}
}

struct increment {
	int curr;
	increment (int ini) : curr(ini) {}
	int operator() () {return curr++;}
};

int part_five(int size) {
	increment n(0);
	vector<int> mv(size);
	generate(mv.begin(), mv.end(), n);
	
	cout << "Size: " << size << endl;
	
	copy(mv.begin(), mv.end(), ostream_iterator<int>(cout, " "));
	cout << endl;
	my_reverse(mv.begin(), mv.end());
	copy(mv.begin(), mv.end(), ostream_iterator<int>(cout, " "));
	cout << endl;
	
	return 0;
}

int main() {
	part_one();
	cout << endl;
	part_two();
	cout << endl;
	part_three();
	cout << endl;
	part_four();
	part_five(20);
	cout << endl;
	part_five(17);
	cout << endl;
}

