#!/usr/bin/env python3
import sys
import collections

import tqdm


def _last_word(line):
    return line.split()[-1].strip(':.')


class TM:
    def __init__(self, transitions, start_state):
        self.tape = collections.defaultdict(lambda: '0')
        self.pos = 0
        self.transitions = transitions
        self.state = start_state

    @classmethod
    def parse(cls, inp):
        inp = inp.split('\n\n')
        begin_line, perform_line = inp[0].split('\n')
        start_state = _last_word(begin_line)
        run_for = int(perform_line.split()[-2])

        # Dict of (state, value) -> (written value, move (+/-1), new state)
        transitions = {}
        for state_desc in inp[1:]:
            state_desc = state_desc.strip().split('\n')
            state_name = _last_word(state_desc[0])
            for i in range(1, len(state_desc), 4):
                cur_line, write_line, move_line, cont_line = state_desc[i:i+4]
                transitions[(state_name, _last_word(cur_line))] = (
                    _last_word(write_line),
                    -1 if _last_word(move_line) == 'left' else 1,
                    _last_word(cont_line))
        tm = cls(transitions, start_state)
        return tm, run_for

    def run(self, steps):
        for _ in tqdm.tqdm(range(steps)):
            self.tape[self.pos], pos_incr, self.state = self.transitions[
                (self.state, self.tape[self.pos])]
            self.pos += pos_incr

    def diagnostic(self):
        return list(self.tape.values()).count('1')


def main():
    inp = sys.stdin.read()
    tm, steps = TM.parse(inp)
    tm.run(steps)
    print(tm.diagnostic())

if __name__ == '__main__':
    main()
