import Foundation
import Utils

struct Range {
    var start: Int
    var end: Int
    
    public func isMatch(_ input: Int) -> Bool {
        return input >= start && input <= end
    }
}

struct Constraint {
    var label: String
    var first: Range
    var second: Range
    
    public func isMatch(_ input: Int) -> Bool {
        return first.isMatch(input) || second.isMatch(input)
    }
    
    public static func parse(_ input: String) -> Constraint {
        let scanner = Scanner(string: input)
        
        let label = scanner.scanUpToString(": ")!
        let _ = scanner.scanString(": ")!
        let start1 = scanner.scanUpToString("-")!.asInt()!
        let _ = scanner.scanString("-")!
        let end1 = scanner.scanUpToString(" or ")!.asInt()!
        let _ = scanner.scanString("or ")!
        let start2 = scanner.scanUpToString("-")!.asInt()!
        let _ = scanner.scanString("-")!
        let end2 = scanner.scanInt()!
        
        return Constraint(
            label: label,
            first: Range(start: start1, end: end1),
            second: Range(start: start2, end: end2)
        )
    }
}

func parseInput(_ input: String) -> ([Constraint], [Int], [[Int]]) {
    let lines = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
    
    var i = 0
    
    var constraints = Array<Constraint>()
    while i < lines.count {
        if lines[i] == "" {
            break
        }
        constraints.append(Constraint.parse(lines[i]))
        i += 1
    }
    
    i += 1
    if lines[i] != "your ticket:" {
        fatalError()
    }
    
    i += 1
    let yourTicket = lines[i]
        .components(separatedBy: ",")
        .map({ $0.asInt()! })
    
    i += 1
    if lines[i] != "" {
        fatalError()
    }
    
    i += 1
    if lines[i] != "nearby tickets:" {
        fatalError()
    }
    
    i += 1
    
    var otherTickets = Array<[Int]>()
    while i < lines.count {
        if lines[i] == "" {
            break
        }

        let tickets = lines[i]
            .components(separatedBy: ",")
            .map({ $0.asInt()! })
        otherTickets.append(tickets)
        i += 1
    }
    
    return (constraints, yourTicket, otherTickets)
}

func findInvalidTickets(otherTickets: [[Int]], constraints: [Constraint]) -> Set<Int> {
    var invalidTickets = Set<Int>()
    for otherTicket in otherTickets {
        for ticket in otherTicket {
            let meetsConstraints = constraints.reduce(false, { $0 || $1.isMatch(ticket) })
            if !meetsConstraints {
                invalidTickets.insert(ticket)
            }
        }
    }
    return invalidTickets
}

func part1(_ input: String) -> Int {
    let (constraints, _, otherTickets) = parseInput(input)
    
    let invalid = findInvalidTickets(otherTickets: otherTickets, constraints: constraints)
    return invalid.reduce(0, +)
}

try! test(part1("""
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
""") == 71, "part1")

struct TicketField : Equatable {
    public var label: String
    public var value: Int
}

func part2(_ input: String) -> [TicketField] {
    let (constraints, yourTicket, otherTickets) = parseInput(input)
    
    let invalid = findInvalidTickets(otherTickets: otherTickets, constraints: constraints)
    
    var fieldValues = Array<[Int]>()
    for i in 0..<otherTickets[0].count {
        var values = Array<Int>()
        for otherTicket in otherTickets {
            values.append(otherTicket[i])
        }
        fieldValues.append(values)
    }
    
    var possibleTicketFields = Array<(Int, [String])>()
    for i in 0..<fieldValues.count {
        let validValues = fieldValues[i].filter({ !invalid.contains($0) })
        var possibleFields = Array<String>()
        for constraint in constraints {
            let meetsConstraint = validValues.reduce(true, { $0 && constraint.isMatch($1) })
            if meetsConstraint {
                possibleFields.append(constraint.label)
            }
        }
        possibleTicketFields.append((i, possibleFields))
    }
    
    var ticketFields = Dictionary<String, Int>()
    while !possibleTicketFields.isEmpty {
        possibleTicketFields = possibleTicketFields.filter({ (index, possibleFields) in
            let remainingPossibilities = possibleFields.filter({ ticketFields[$0] == nil })
            if remainingPossibilities.count == 0 {
                fatalError()
            } else if remainingPossibilities.count == 1 {
                ticketFields[remainingPossibilities.first!] = index
                return false
            } else {
                return true
            }
        })
    }
    
    let ticket = ticketFields.map({ TicketField(label: $0.0, value: yourTicket[$0.1]) })
    return ticket
}

let test2 = part2("""
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
""")
try! test(test2.contains(TicketField(label: "row", value: 11)), "part2")
try! test(test2.contains(TicketField(label: "class", value: 12)), "part2")
try! test(test2.contains(TicketField(label: "seat", value: 13)), "part2")

let input = try! String(contentsOfFile: "input/day16.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")

let input2 = part2(input).filter({ $0.label.starts(with: "departure") }).map({ $0.value }).reduce(1, *)
print("\(input2)")
