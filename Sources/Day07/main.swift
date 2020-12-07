import Foundation
import Utils

func parseInput(_ input: String) -> [(String, [(String, Int)])] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map({
            let scanner = Scanner(string: $0)

            // AA BB bags contain # CC DD bag, # EE FF bags.
            // AA BB bags contain no other bags.
            
            let bagType = scanner.scanUpToString(" bags")!
            let _ = scanner.scanString("bags contain ")!

            let remaining = scanner.scanUpToString(".")!
            
            if remaining == "no other bags" {
                return (bagType, [])
            }
            
            let bagContains : [(String, Int)] = remaining.components(separatedBy: ", ").map({
                let scanner = Scanner(string: $0)
                
                let count = scanner.scanInt()!
                let bagType = scanner.scanUpToString(" bag")!
                
                return (bagType, count)
            })
            
            return (bagType, bagContains)
        })
}

func part1(_ input: String) -> Int {
    let bags = parseInput(input)
    
    var graph = Graph<String>()
    for bag in bags {
        graph.add(node: GraphNode<String>(id: bag.0, links: bag.1.map({ $0.0 })))
    }
    
    var count = 0
    for bag in bags {
        if bag.0 == "shiny gold" {
            continue
        }
        
        let reachabe = graph.reachableFrom(bag.0)
        if reachabe.contains("shiny gold") {
            count += 1
        }
    }
    return count
}

assert(part1("""
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
""") == 4)

func cost(bag: String, bagLookup: Dictionary<String, [(String, Int)]>) -> Int {
    let bagCost = bagLookup[bag]!
    if bagCost.count == 0 {
        return 1
    } else {
        return bagCost.reduce(1, { $0 + $1.1 * cost(bag: $1.0, bagLookup: bagLookup) })
    }
}

func part2(_ input: String) -> Int {
    let bags = parseInput(input)
    let bagLookup = Dictionary<String, [(String, Int)]>(uniqueKeysWithValues: bags)
    let shinyGoldCost = cost(bag: "shiny gold", bagLookup: bagLookup) - 1
    return shinyGoldCost
}

assert(part2("""
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
""") == 32)

assert(part2("""
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
""") == 126)

let input = try! String(contentsOfFile: "input/day07.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
