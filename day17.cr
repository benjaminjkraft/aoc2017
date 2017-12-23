def full_spin(times, steps)
  buffer = [0]
  pos = 0
  iter = 0
  while iter < times
    iter += 1
    pos = (pos + steps) % iter + 1
    # Ugh, slicing to append doesn't seem to work
    if pos == iter
      buffer << iter
    else
      buffer[pos...pos] = iter
    end
  end
  buffer[(pos + 1) % iter]
end

def quick_spin(times, steps)
  pos = 0
  iter = 0
  after_0 = 0
  while iter < times
    iter += 1
    pos = (pos + steps) % iter + 1
    if pos == 1
      after_0 = iter
    end
  end
  after_0
end

def main()
  input = 343
  puts full_spin(2017, input)
  puts quick_spin(50000000, input)
end

main()
