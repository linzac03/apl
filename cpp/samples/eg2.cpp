#include <iostream>

using namespace std;


template <typename OutputIterator>
void dbl(OutputIterator first, OutputIterator last) {
	while (first != last) {
		*first = *first * 2;
		first++;
	}
}

template <typename InputIterator>
void out(InputIterator first, InputIterator last) {
	while (first != last) {
		cout << *first++ << ", ";
	}
	cout << endl;
}

int main() {
	int a[] = {1,2,3,4};


	out(a, a+4);

	dbl(a, a+4);

	out(a, a+4);

}
