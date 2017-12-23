package main

import (
    "bufio"
    "bytes"
    "fmt"
    "os"
)

const (
    right = iota
    up = iota
    left = iota
    down = iota
)

func walkGrid(grid [][]byte) ([]byte, int) {
    x := bytes.IndexByte(grid[0], '|')
    y := 0
    dir := down
    retval := []byte{}
    steps := 0;
    for true {
        steps++
        switch dir {
        case right: x++
        case up: y--
        case left: x--
        case down: y++
        }
        switch grid[y][x] {
        case '|', '-': 
        case '+': 
            switch {
            case grid[y][x+1] != ' ' && dir != left:
                dir = right
            case grid[y-1][x] != ' ' && dir != down:
                dir = up
            case grid[y][x-1] != ' ' && dir != right:
                dir = left
            case grid[y+1][x] != ' ' && dir != up:
                dir = down
            default:
                return retval, steps
            }
        case ' ':
                return retval, steps
        default:
            retval = append(retval, grid[y][x])
        }
    }
    return nil, 0
}

func main() {
    grid := [][]byte{}
    scanner := bufio.NewScanner(os.Stdin)
    for scanner.Scan() {
        grid = append(grid, []byte(scanner.Text()))
    }
    if err := scanner.Err(); err != nil {
        fmt.Fprintln(os.Stderr, "reading standard input:", err)
    }
    letters, steps := walkGrid(grid)
    fmt.Println(string(letters))
    fmt.Println(steps)
}
