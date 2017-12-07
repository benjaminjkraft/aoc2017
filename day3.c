#include <stdio.h>
#include <stdlib.h>

int spiral_dist(int square) {
    int x=0;
    int y=0;
    int ring=0;
    for (int i=1; i<square; i++) {
        if (x == ring && y == -ring) {
            x++;
            ring++;
        } else if (y == -ring) {
            x++;
        } else if (x == -ring) {
            y--;
        } else if (y == ring) {
            x--;
        } else if (x == ring) {
            y++;
        }
    }
    return abs(x) + abs(y);
}

#define SIZE 32

int next_spiral_val(int val) {
    int grid[2*SIZE-1][2*SIZE-1] = {0};
    int x=0;
    int y=0;
    int ring=0;
    int a, b;
    int ret;
    grid[SIZE][SIZE] = 1;
    for (int i=1; ring<SIZE; i++) {
        if (x == ring && y == -ring) {
            x++;
            ring++;
        } else if (y == -ring) {
            x++;
        } else if (x == -ring) {
            y--;
        } else if (y == ring) {
            x--;
        } else if (x == ring) {
            y++;
        }
        for (a=-1; a<=1; a++) {
            for (b=-1; b<=1; b++) {
                if (a != 0 || b != 0) {
                    ret = grid[SIZE+x][SIZE+y] += grid[SIZE+x+a][SIZE+y+b];
                }
            }
        }
        if (ret > val) {
            return ret;
        }
    }
    return -1;
}

int main(int argc, char* argv[]) {
    int input = atoi(argv[1]);
    printf("Part 1: %d\n", spiral_dist(input));
    printf("Part 2: %d\n", next_spiral_val(input));
}
