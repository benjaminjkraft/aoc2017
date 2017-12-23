s/!.//g
let orig = getline(1)
s/<[^>]*>/!!/g
let nogarbage = getline(1)
s/!//g
s/,//g

let groups = getline(1)
let level = 0
let total = 0
for c in split(groups, '\zs')
  if c == '{'
    let level += 1
    let total += level
  elseif c == '}'
    let level -= 1
  endif
endfor
call setline(1, printf("%d", total))
call setline(2, printf("%d", len(orig) - len(nogarbage)))
