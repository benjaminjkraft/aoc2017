def run1(grid, rounds)
    hash = Hash.new(false)
    n = grid.length / 2
    grid.each_with_index do |line, i|
        line.each_char.each_with_index do |c, j|
            if c == '#'
                hash[[j - n, i - n]] = true
            end
        end
    end

    pos = [0, 0]
    dir = 1
    infections = 0
    for _ in 0...rounds
        if hash[pos]
            hash[pos] = false
            dir = (dir - 1) % 4
        else
            hash[pos] = true
            dir = (dir + 1) % 4
            infections += 1
        end

        pos = pos.clone()
        if dir == 0
            pos[0] += 1
        elsif dir == 1
            pos[1] -= 1
        elsif dir == 2
            pos[0] -= 1
        else # dir == 3
            pos[1] += 1
        end
    end
    return infections
end

def run2(grid, rounds)
    hash = Hash.new(0)
    n = grid.length / 2
    grid.each_with_index do |line, i|
        line.each_char.each_with_index do |c, j|
            if c == '#'
                hash[[j - n, i - n]] = 2
            end
        end
    end

    pos = [0, 0]
    dir = 1
    infections = 0
    for _ in 0...rounds
        dir = (dir + 1 - hash[pos]) % 4
        hash[pos] = (hash[pos] + 1) % 4
        if hash[pos] == 2
            infections += 1
        end

        pos = pos.clone()
        if dir == 0
            pos[0] += 1
        elsif dir == 1
            pos[1] -= 1
        elsif dir == 2
            pos[0] -= 1
        else # dir == 3
            pos[1] += 1
        end
    end
    return infections
end

def main
    input = $stdin.read.split()
    puts run1(input, 10000)
    puts run2(input, 10000000)
end

main()
