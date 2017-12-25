function maximumBy(f, l) {
    let maxVal = -Infinity;
    let maxElt = null;
    l.forEach(x => {
        let val = f(x);
        if (val > maxVal) {
            maxVal = val;
            maxElt = x;
        }
    });
    return maxElt;
}

function bestPath(graph, start, valueFn) {
    start = start || '0';
    if (!graph[start].length) {
        return {length: 0, strength: 0}
    }
    let options = graph[start].map(next => {
        let newGraph = Object.assign({}, graph);
        newGraph[start] = newGraph[start].filter(x => x != next);
        newGraph[next] = newGraph[next].filter(x => x != start);
        path = bestPath(newGraph, next, valueFn);
        return {
            length: path.length + 1,
            strength: path.strength + parseInt(start) + parseInt(next),
        };
    });
    return maximumBy(valueFn, options);
}

function strongestPath(graph, start) {
    return bestPath(graph, start, p => p.strength);
}

function longestPath(graph, start) {
    return bestPath(graph, start, p => 1000000 * p.length + p.strength);
}

function parse(input) {
    const graph = {}
    input.split("\n")
         .filter(line => line)
         .map(line => line.split("/"))
         .forEach(([x, y]) => {
             graph[x] = (graph[x] || []);
             graph[x].push(y);
             if (x !== y) {
                 graph[y] = (graph[y] || []);
                 graph[y].push(x);
             }
         });
    return graph;
}

function main() {
    let input = '';
    process.stdin.on('data', data => input += data);
    process.stdin.on('end', () => {
        const graph = parse(input);
        console.log(strongestPath(graph).strength);
        console.log(longestPath(graph).strength);
    });
}

main()
