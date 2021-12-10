import Foundation
import Collections

public enum Runner {
    static let closingCharacter: [Character: Character] = [
        "{": "}",
        "[": "]",
        "<": ">",
        "(": ")"
    ]

    public static func part1() -> Int {
        let scores: [Character: Int] = [
            ")": 3,
            "]": 57,
            "}": 1197,
            ">": 25137
        ]

        let lines = input.components(separatedBy: .newlines)

        var sum = 0
        lineLoop: for line in lines {
            var stack = Stack<Character>()
            for character in line {
                if closingCharacter.keys.contains(character) {
                    stack.push(closingCharacter[character]!)
                } else if stack.peek() == character {
                    stack.pop()
                } else {
                    sum += scores[character]!
                    continue lineLoop
                }
            }
        }

        return sum
    }

    public static func part2() -> Int {
        let scores: [Character: Int] = [
            ")": 1,
            "]": 2,
            "}": 3,
            ">": 4
        ]

        let lines = input.components(separatedBy: .newlines)

        var autocompleteScores: [Int] = []
        lineLoop: for line in lines {
            var stack = Stack<Character>()
            for character in line {
                if closingCharacter.keys.contains(character) {
                    stack.push(closingCharacter[character]!)
                } else if stack.peek() == character {
                    stack.pop()
                } else {
                    continue lineLoop
                }
            }

            var score = 0
            while let next = stack.pop() {
                score = score * 5 + scores[next]!
            }
            autocompleteScores.append(score)
        }

        let sorted = autocompleteScores.sorted()
        return sorted[sorted.count / 2]
    }
}

struct Stack<Element> {
    private var storage: [Element] = []

    mutating func push(_ element: Element) {
        storage.append(element)
    }

    @discardableResult
    mutating func pop() -> Element? {
        storage.popLast()
    }

    func peek() -> Element? {
        storage.last
    }
}
