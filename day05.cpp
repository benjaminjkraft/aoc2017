#include <iostream>
#include <vector>
using namespace std;


int jumplength1(vector<int> offsets) {
    int pos = 0;
    int jumps = 0;
    int offset;
    while (pos >= 0 && pos < offsets.size()) {
        jumps++;
        offset = offsets[pos];
        offsets[pos]++;
        pos += offset;
    }
    return jumps;
}

int jumplength2(vector<int> offsets) {
    int pos = 0;
    int jumps = 0;
    int offset;
    while (pos >= 0 && pos < offsets.size()) {
        jumps++;
        offset = offsets[pos];
        if (offset >= 3) {
            offsets[pos]--;
        } else {
            offsets[pos]++;
        }
        pos += offset;
    }
    return jumps;
}

int main() {
    int n;
    vector<int> offsets;
    while (cin >> n) {
        offsets.push_back(n);
    }

    cout << jumplength1(offsets) << "\n";
    cout << jumplength2(offsets) << "\n";
}
