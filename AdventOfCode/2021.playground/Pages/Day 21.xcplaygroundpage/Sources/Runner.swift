import Algorithms
import Foundation

public enum Runner {
    public static func part1() -> Int {
        let startingPositions = input.components(separatedBy: .newlines)
            .compactMap {
                $0.components(separatedBy: ":")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .last
                    .flatMap(Int.init)
            }

        var players = startingPositions.map {
            Player(position: $0)
        }

        let first = (1...).lazy
            .striding(by: 3)
            .rotated(aroundRange: 1...100)
        let second = (2...).lazy
            .striding(by: 3)
            .rotated(aroundRange: 1...100)
        let third = (3...).lazy
            .striding(by: 3)
            .rotated(aroundRange: 1...100)
        let roll = zip(zip(first, second), third)
            .lazy
            .map { ($0.0, $0.1, $1) }
        let sum = roll.map { $0 + $1 + $2 }

        for (turn, roll) in sum.enumerated() {
            let playerIndex = turn % players.count
            players[playerIndex].move(by: roll)

            if players[playerIndex].score >= 1000 {
                let numberOfRollsPerTurn = 3
                return (turn + 1) * numberOfRollsPerTurn * players.map(\.score).min()!
            }
        }

        return 0
    }

    public static func part2() -> Int {
        let startingPositions = input.components(separatedBy: .newlines)
            .compactMap {
                $0.components(separatedBy: ":")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .last
                    .flatMap(Int.init)
            }
        let players = startingPositions.map(Player.init)
        let output = quantumWinnerFrequency(scoreThreshold: 21, players: players)
        return output.values.max()!
    }
}

private let numberOfRolls = 3
private let quantumOutcomes = (1...numberOfRolls).flatMap { _ in [1, 2, 3] }
    .uniquePermutations(ofCount: 3)
    .map { $0.reduce(0, +) }
    .reduce(into: [:]) { (acc: inout [Int: Int], next: Int) in
        acc[next, default: 0] += 1
    }

private func quantumWinnerFrequency(
    turnCount: Int = 0,
    scoreThreshold: Int,
    players: [Player]
) -> [Player.ID: Int] {
    var cache: [GameKey: [Player.ID: Int]] = [:]
    return quantumWinnerFrequency(
        turnCount: turnCount,
        scoreThreshold: scoreThreshold,
        players: players,
        cache: &cache
    )
}

private func quantumWinnerFrequency(
    turnCount: Int = 0,
    scoreThreshold: Int,
    players: [Player],
    cache: inout [GameKey: [Player.ID: Int]]
) -> [Player.ID: Int] {
    let playerIndex = turnCount % players.count

    let key = GameKey(turnCount: turnCount, players: players)
    if let cached = cache[key] {
        return cached
    }

    var results: [Player.ID: Int] = [:]
    defer { cache[key] = results }

    for (sum, outcomeFrequency) in quantumOutcomes {
        var player = players[playerIndex]
        player.move(by: sum)

        if player.score >= scoreThreshold {
            results[player.id, default: 0] += outcomeFrequency
            continue
        }

        var copy = players
        copy[playerIndex] = player

        let output = quantumWinnerFrequency(
            turnCount: turnCount + 1,
            scoreThreshold: scoreThreshold,
            players: copy,
            cache: &cache
        )

        for (playerId, winningFrequency) in output {
            results[playerId, default: 0] += outcomeFrequency * winningFrequency
        }
    }
    
    return results
}

private struct GameKey: Hashable {
    let turnIndex: Int
    let players: [Player]

    init(turnCount: Int, players: [Player]) {
        self.turnIndex = turnCount % players.count
        self.players = players
    }
}

private struct Player: Identifiable, Hashable {
    var id = UUID()

    @Rotated(aroundRange: 1...10)
    var position: Int
    var score = 0

    init(position: Int) {
        self.position = position
    }

    mutating func move(by value: Int) {
        position += value
        score += position
    }
}

@propertyWrapper
private struct Rotated: Hashable {
    private let range: ClosedRange<Int>
    private var value: Int

    var wrappedValue: Int {
        get { value }
        set { value = (newValue - range.lowerBound) % (range.upperBound - range.lowerBound + 1) + range.lowerBound }
    }

    init(aroundRange range: ClosedRange<Int>) {
        self.range = range
        self.value = range.lowerBound
    }

    init(aroundRange range: ClosedRange<Int>, wrappedValue: Int) {
        self.init(aroundRange: range)
        self.wrappedValue = wrappedValue
    }
}

private extension LazySequenceProtocol where Elements.Element == Int {
    func rotated(aroundRange range: ClosedRange<Int>) -> LazyMapSequence<Elements, Int> {
        map { Rotated(aroundRange: range, wrappedValue: $0).wrappedValue }
    }
}
