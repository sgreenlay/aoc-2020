import Foundation
import Utils

func parseInput(_ input: String) -> [(Int, [Int])] {
    let players = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n\n")
    return players.map({
        var lines = $0
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
        
        let scanner = Scanner(string: lines.remove(at: 0))
        let _ = scanner.scanString("Player ")!
        let id = scanner.scanInt()!
        
        let cards = lines.map({ $0.asInt()! })
        
        return (id, cards)
    })
}

func part1(_ input: String) -> Int {
    var players = parseInput(input)
    
    while players.allSatisfy({ !$0.1.isEmpty }) {
        let player1 = players[0].1.remove(at: 0)
        let player2 = players[1].1.remove(at: 0)
        
        if player1 > player2 {
            players[0].1.append(player1)
            players[0].1.append(player2)
        } else if player2 > player1 {
            players[1].1.append(player2)
            players[1].1.append(player1)
        } else {
            fatalError()
        }
    }
    
    let winner = players.first(where: { !$0.1.isEmpty })!

    var score = 0
    for i in 0..<winner.1.count {
        score += (winner.1.count - i) * winner.1[i]
    }
    return score
}

try! test(part1("""
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
""") == 306, "part1")

struct GameState : Hashable {
    var player1 : [Int]
    var player2 : [Int]
}

func runGame(players: inout [(Int, [Int])]) -> Int {
    var winner: Int? = nil

    var previousStates = Set<GameState>()
    while players.allSatisfy({ !$0.1.isEmpty }) {
        let currentState = GameState(player1: players[0].1, player2: players[1].1)
        if previousStates.contains(currentState) {
            // Before either player deals a card, if there was a previous round
            // in this game that had exactly the same cards in the same order in
            // the same players' decks, the game instantly ends in a win for
            // player 1.
            winner = 0
            break
        }
        previousStates.insert(currentState)
        
        let player1 = players[0].1.remove(at: 0)
        let player2 = players[1].1.remove(at: 0)
        
        var roundWinner: Int;
        if player1 <= players[0].1.count && player2 <= players[1].1.count {
            // If both players have at least as many cards remaining in their deck
            // as the value of the card they just drew, the winner of the round
            // is determined by playing a new game of Recursive Combat.
            
            // To play a sub-game of Recursive Combat, each player creates a new deck
            // by making a copy of the next cards in their deck (the quantity of cards
            // copied is equal to the number on the card they drew to trigger the sub-game).
            var recursizePlayers = [
                (players[0].0, Array(players[0].1[0..<player1])),
                (players[1].0, Array(players[1].1[0..<player2]))
            ]
            roundWinner = runGame(players: &recursizePlayers)
        } else {
            if player1 > player2 {
                roundWinner = 0
            } else if player2 > player1 {
                roundWinner = 1
            } else {
                fatalError()
            }
        }
        
        if roundWinner == 0 {
            players[0].1.append(player1)
            players[0].1.append(player2)
        } else if roundWinner == 1 {
            players[1].1.append(player2)
            players[1].1.append(player1)
        } else {
            fatalError()
        }
    }
    
    if winner == nil {
        if players[0].1.isEmpty {
            winner = 1
        } else if players[1].1.isEmpty {
            winner = 0
        } else {
            fatalError()
        }
    }
    
    return winner!
}

func part2(_ input: String) -> Int {
    var players = parseInput(input)
    let winner = runGame(players: &players)
    
    var score = 0
    for i in 0..<players[winner].1.count {
        score += (players[winner].1.count - i) * players[winner].1[i]
    }
    return score
}

try! test(part2("""
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
""") == 291, "part2")

let input = try! String(contentsOfFile: "input/day22.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
