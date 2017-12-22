<?php

function getreg1($regs, $ref) {
    if (is_numeric($ref)) {
        return intval($ref);
    } else if (array_key_exists($ref, $regs)) {
        return $regs[$ref];
    } else {
        return 0;
    }
}

function getreg2($regs, $running, $ref) {
    if (is_numeric($ref)) {
        return intval($ref);
    } else if (array_key_exists($ref, $regs[$running])) {
        return $regs[$running][$ref];
    } else if ($ref == "p") {
        return $running;
    } else {
        return 0;
    }
}

function run1($inss) {
    $regs = array();
    $pos = 0;
    $playing = NULL;
    while ($pos >= 0 && $pos < count($inss)) {
        $ins = $inss[$pos];
        if ($ins[0] == "snd") {
            $playing = getreg1($regs, $ins[1]);
        } else if ($ins[0] == "set") {
            $regs[$ins[1]] = getreg1($regs, $ins[2]);
        } else if ($ins[0] == "add") {
            $regs[$ins[1]] = getreg1($regs, $ins[1]) + getreg1($regs, $ins[2]);
        } else if ($ins[0] == "mul") {
            $regs[$ins[1]] = getreg1($regs, $ins[1]) * getreg1($regs, $ins[2]);
        } else if ($ins[0] == "mod") {
            $regs[$ins[1]] = getreg1($regs, $ins[1]) % getreg1($regs, $ins[2]);
        } else if ($ins[0] == "rcv") {
            if (getreg1($regs, $ins[1]) != 0) {
                return $playing;
            }
        } else if ($ins[0] == "jgz") {
            if (getreg1($regs, $ins[1]) > 0) {
                $pos += getreg1($regs, $ins[2]);
                continue;
            }
        } else {
            return "ERROR";
        }
        $pos++;
    }
    return "HIT END";
}

function run2($inss) {
    $regs = array(array(), array());
    $pos = array(0, 0);
    $running = 0; // which thread is running
    $queues = array(array(), array());
    $locked = false; // if the other thread is waiting on us
    $done = array(false, false);
    $sends1 = 0;
    while (true) {
        if ($pos[$running] < 0 || $pos[$running] >= count($inss)) {
            $done[$running] = true;
        }
        if ($done[$running]) {
            $locked = true;
            $running = 1 - $running;
            continue;
        }

        $ins = $inss[$pos[$running]];
        if ($ins[0] == "snd") {
            array_push(
                $queues[1 - $running],
                getreg2($regs, $running, $ins[1]));
            $locked = false;
            if ($running == 1) {
                $sends1++;
            }
        } else if ($ins[0] == "set") {
            $regs[$running][$ins[1]] = getreg2($regs, $running, $ins[2]);
        } else if ($ins[0] == "add") {
            $regs[$running][$ins[1]] = (
                getreg2($regs, $running, $ins[1]) +
                getreg2($regs, $running, $ins[2]));
        } else if ($ins[0] == "mul") {
            $regs[$running][$ins[1]] = (
                getreg2($regs, $running, $ins[1]) *
                getreg2($regs, $running, $ins[2]));
        } else if ($ins[0] == "mod") {
            $regs[$running][$ins[1]] = (
                getreg2($regs, $running, $ins[1]) %
                getreg2($regs, $running, $ins[2]));
        } else if ($ins[0] == "rcv") {
            if (count($queues[$running])) {
                $regs[$running][$ins[1]] = array_shift($queues[$running]);
            } else if ($locked) {
                return $sends1;
            } else {
                $running = 1 - $running;
                $locked = true;
                continue;
            }
        } else if ($ins[0] == "jgz") {
            if (getreg2($regs, $running, $ins[1]) > 0) {
                $pos[$running] += getreg2($regs, $running, $ins[2]);
                continue;
            }
        } else {
            return "ERROR";
        }
        $pos[$running]++;
    }
}

function main() {
    $inss = array();
    while ($line = trim(fgets(STDIN))) {
        array_push($inss, explode(" ", $line));
    }
    echo run1($inss), "\n";
    echo run2($inss), "\n";
}

main()

?>
