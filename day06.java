import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Scanner;

class Day6 {
    public static void main(String[] args) {
        Scanner stdin = new Scanner(System.in);
        ArrayList<Integer> start = new ArrayList<Integer>();
        while (stdin.hasNextInt()) {
            start.add(stdin.nextInt());
        }
        
        int[] answers = redistribute(start);
        System.out.printf("%d\n%d\n", answers[0], answers[1]);
    }

    static int[] redistribute(ArrayList<Integer> blocks) {
        int rounds = 0;
        HashMap<ArrayList<Integer>, Integer> seen;
        seen = new HashMap<ArrayList<Integer>, Integer>();
        while (true) {
            rounds++;
            int max = Collections.max(blocks);
            int index = blocks.indexOf(max);
            blocks.set(index, 0);
            for (int i = 0; i < max; i++) {
                int j = (index + i + 1) % blocks.size();
                blocks.set(j, blocks.get(j) + 1);
            }
            if (seen.containsKey(blocks)) {
                int[] retval = {rounds, rounds - seen.get(blocks)};
                return retval;
            } else {
                seen.put(new ArrayList<Integer>(blocks), rounds);
            }
        }
    }
}
