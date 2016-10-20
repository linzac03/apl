#include <iostream>
#include <vector>
#include <functional>
#include <cstdlib>
#include <algorithm>

using namespace std;


template <typename It, typename Fn_state>
Fn_state forEach (It first, It last, Fn_state f) {
	while (first != last) {
		f(*first);
		++first;
	}

	return f;
}

struct adder : public unary_function <int, void> {
	int sum;
	adder() : sum(0) {}
	void operator() (int x) {sum+= x;}
};

template <typename InputIterator>
void out(InputIterator first, InputIterator last) {
   while (first != last) {
	      cout << *first++ << ", ";
   }
   cout << endl;
}         


int main() {
	vector<int> v(10);

	generate(v.begin(), v.end(), rand);

	out(v.begin(), v.end());
	adder result;

	result = forEach(v.begin(), v.end(), adder());

	cout << "The sum is " << result.sum << endl;
}

