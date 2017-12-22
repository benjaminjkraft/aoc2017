let rounds = 64
let block = 16
let size = block * block
let bits = block * 8

let compose f g = fun x -> f (g x)

let char_nums str =
    List.init (String.length str) (fun i -> int_of_char str.[i])

let rec knot_hash_core nums pos skip lengths =
    match lengths with
    | [] -> nums
    | length :: other_lengths ->
        let n = Array.length nums in
        let newnums = Array.init n (fun i ->
            if (n + i - pos) mod n < length
            then nums.((n + n + 2 * pos + length - 1 - i) mod n)
            else nums.(i)) in
        knot_hash_core
            newnums ((pos + length + skip) mod n) (skip + 1) other_lengths

let dense_hash nums =
    List.init block (fun i ->
        Array.fold_left (lxor) 0 (Array.sub nums (i * block) block))

let rec pow n k = if n == 0 then 1 else n * (pow n (k - 1))

let bits_of n = List.rev (List.init 8 (fun i -> (n / (1 lsl i)) mod 2))

let knot_hash str =
    let lengths = List.append (char_nums str) [17; 31; 73; 47; 23] in
    let full_lengths = List.concat (List.init rounds (fun i -> lengths)) in
    let nums = Array.init size (fun i -> i) in
    let hash_nums = knot_hash_core nums 0 0 full_lengths in
    Array.of_list (List.concat (List.map bits_of (dense_hash hash_nums)))

let make_grid key =
    Array.init bits (fun i -> (knot_hash (key ^ "-" ^ string_of_int i)))

let sum_array l = Array.fold_left (+) 0 l

let sum_grid grid = sum_array (Array.map sum_array grid)

let rec mark_region grid i j =
    if i >= 0 && i < bits && j >= 0 && j < bits && grid.(i).(j) == 1 then begin
        grid.(i).(j) <- 0;
        mark_region grid (i+1) j;
        mark_region grid (i-1) j;
        mark_region grid i (j+1);
        mark_region grid i (j-1);
    end


let count_regions grid =
    let k = ref 0 in
    for i = 0 to (bits - 1) do
        for j = 0 to (bits - 1) do
            if grid.(i).(j) == 1 then begin
                mark_region grid i j;
                k := !k + 1;
            end
        done
    done;
    !k

let main () =
    let input = read_line() in
    let grid = make_grid input in
    print_endline (string_of_int (sum_grid grid));
    print_endline (string_of_int (count_regions grid));

;;
main ()
