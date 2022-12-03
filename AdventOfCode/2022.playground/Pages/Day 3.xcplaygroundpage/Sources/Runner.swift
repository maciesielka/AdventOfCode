import Algorithms
import Foundation

public enum Runner {
    public static func part1() -> Int {
        let lines = input.components(separatedBy: "\n")
        var sum = 0
        for line in lines {
            var c1: Set<Int> = []

            for (idx, character) in line.enumerated() {
                let value = character.value

                if idx < line.count / 2 {
                    c1.insert(value)
                } else if c1.contains(value) {
                    sum += value
                    print(value)
                    break
                }
            }
        }

        return sum
    }

    public static func part2() -> Int {
        let lines = input
            .components(separatedBy: "\n")
            .map { line in
                var set: Set<Character> = []
                for character in line {
                    set.insert(character)
                }
                return set
            }

        var sum = 0
        let groups = lines.chunks(ofCount: 3)
        for group in groups {
            let array = Array(group)
            
            for element in array[0] {
                if array[1].contains(element),
                   array[2].contains(element) {
                    sum += element.value
                }
            }
        }
        return sum
    }
}

public extension Character {
    var value: Int {
        if isUppercase {
            return Int(asciiValue! - Character("A").asciiValue!) + 26 + 1
        } else {
            return Int(asciiValue! - Character("a").asciiValue!) + 1
        }
    }
}
