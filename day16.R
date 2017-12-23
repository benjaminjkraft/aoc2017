process_moves <- function (start, moves, repeats=1) {
    n <- length(start)
    target <- repeats
    current <- start
    for (i in 1:repeats) {
        for (move in moves) {
            type <- substr(move, 1, 1)
            rest <- substr(move, 2, nchar(move))
            if (type == "s") {
                offset <- as.integer(rest)
                cut <- length(current) - offset
                perm <- c((cut + 1):length(current), 1:cut)
            } else {
                if (type == "x") {
                    swaps <- as.integer(strsplit(rest, "/")[[1]]) + 1
                } else {
                    swaps <- which(current %in% strsplit(rest, "/")[[1]])
                }
                perm <- c(1:length(current))
                perm[swaps] = perm[rev(swaps)]
            }
            current <- current[perm]
        }
        if (i == target) {
            break
        }
        if (identical(current,start)) {
            # Detect cycles
            target <- (repeats %% i) + i
        }
    }
    paste(current, collapse="")
}

main <- function() {
    stdin <- file("stdin")
    input <- readLines(con=stdin)
    close(stdin)
    moves <- strsplit(input, ",")[[1]]
    start <- strsplit("abcdefghijklmnop", "")[[1]]
    print(process_moves(start, moves))
    print(process_moves(start, moves, 1000000000))
}

main()
