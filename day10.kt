fun doHash(lengths: List<Int>, n: Int, rounds: Int): Array<Int> {
    var pos = 0
    var skip = 0
    val list = Array(n, { it })
    for (round in 0 until rounds) {
        for (i in lengths.indices) {
            val listAgain = list.copyOf()
            for (j in 0 until lengths[i]) {
                list[(pos + j) % n] = listAgain[(pos + lengths[i] - 1 - j) % n]
            }
            pos += lengths[i] + skip
            skip++;
        }
    }
    return list
}

fun firstProd(list: Array<Int>): Int {
    return list[0] * list[1]
}

fun denseHash(list: Array<Int>, n: Int): String {
    var output = ""
    val blockSize = list.size / n
    for (i in 0 until n) {
        val byte = list.slice(i * blockSize until (i + 1) * blockSize).reduce(
            { j, k -> j xor k })
        output += byte.toString(16).padStart(2, '0')
    }
    return output
}

fun main(args: Array<String>) {
    val line = readLine()!!
    val extra = arrayOf(17, 31, 73, 47, 23)
    println(firstProd(doHash(line.split(",").map({ it.toInt() }), 256, 1)))
    println(denseHash(doHash(line.map({ it.toInt() }) + extra, 256, 64), 16))
}
