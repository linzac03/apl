#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

#define	size	15

int main() {
	vector<int> v(size);

	for (int i=0; i<size; i++) {
		v[i] = 10*i;
	}

	for (int i=0; i<15; i++) {
		cout << v[i] << ", ";
	}
	cout << endl;

	reverse(v.begin(), v.end());

	for (int i=0; i<15; i++) {
		cout << v[i] << ", ";
	}
	cout << endl;

}
