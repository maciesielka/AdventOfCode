import Algorithms
import Foundation

public enum Runner {
    static func run(numberOfTurns: Int) -> Int {
        let components = input.components(separatedBy: "\n\n")
        let initial = components[0]
        let instructions = components[1].components(separatedBy: .newlines)
            .map(Instruction.init)
        var instructionMap: [Instruction.Key: Instruction] = [:]
        for instruction in instructions {
            instructionMap[instruction.key] = instruction
        }

        var frequencyOfPairs: [Instruction.Key: Int] = [:]
        for (first, second) in initial.adjacentPairs() {
            let key = Instruction.Key(first: first, second: second)
            frequencyOfPairs[key, default: 0] += 1
        }

        for _ in 1...numberOfTurns {
            var temp: [Instruction.Key: Int] = [:]
            for (key, value) in frequencyOfPairs {
                if let instruction = instructionMap[key] {
                    let key1 = Instruction.Key(first: key.first, second: instruction.insert)
                    temp[key1, default: 0] += value
                    let key2 = Instruction.Key(first: instruction.insert, second: key.second)
                    temp[key2, default: 0] += value
                } else {
                    temp[key, default: 0] += value
                }
            }
            frequencyOfPairs = temp
        }

        var frequencies: [Character: Int] = [:]
        for (key, value) in frequencyOfPairs {
            for character in "\(key.first)\(key.second)" {
                frequencies[character, default: 0] += value
            }
        }

        // don't double count the first or last items
        frequencies[initial.first!, default: 0] -= 1
        frequencies[initial.last!, default: 0] -= 1

        for key in frequencies.keys {
            frequencies[key] = frequencies[key]! / 2
        }

        // add back the first and last items
        frequencies[initial.first!, default: 0] += 1
        frequencies[initial.last!, default: 0] += 1

        return frequencies.values.max()! - frequencies.values.min()!
    }

    public static func part1() -> Int {
        run(numberOfTurns: 10)
    }

    public static func part2() -> Int {
        run(numberOfTurns: 40)
    }
}

private struct Instruction {
    struct Key: Hashable {
        var first: String
        var second: String
    }

    var insert: String
    var key: Key

    init(string: String) {
        let components = string.components(separatedBy: "->")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        key = .init(
            first: String(components[0].prefix(1)),
            second: String(components[0].suffix(1))
        )
        insert = components[1]
    }
}

extension Instruction.Key {
    init(first: Character, second: Character) {
        self.first = String(first)
        self.second = String(second)
    }
}
