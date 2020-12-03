import Foundation
import Utils

func parseInput(_ input: String) -> [String] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
}

func traverse(map: [String], dx: Int, dy: Int) -> Int {
    var x = 0
    var y = 0
    
    var treeCount = 0
    while y < map.count {
        let row = map[y]
        if row.characterAt(offset: x % row.count) == "#" {
            treeCount += 1
        }
        x += dx
        y += dy
    }

    return treeCount
}

func part1(_ input: String) -> Int {
    let map = parseInput(input)
    return traverse(map: map, dx: 3, dy: 1)
}

assert(part1("""
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
""") == 7)

func part2(_ input: String) -> Int {
    let map = parseInput(input)
    let traversals = [
        traverse(map: map, dx: 1, dy: 1), // Right 1, down 1
        traverse(map: map, dx: 3, dy: 1), // Right 3, down 1
        traverse(map: map, dx: 5, dy: 1), // Right 5, down 1.
        traverse(map: map, dx: 7, dy: 1), // Right 7, down 1
        traverse(map: map, dx: 1, dy: 2), // Right 1, down 2
    ]
    return traversals.reduce(1, { $0 * $1 })
}

assert(part2("""
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
""") == 336)

let input = try! String(contentsOfFile: "input/day03.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
