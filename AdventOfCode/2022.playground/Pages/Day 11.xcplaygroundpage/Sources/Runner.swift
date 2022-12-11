import Foundation

public enum Runner {
    static let monkeys: [Monkey] = {
        let descriptions = input
            .components(separatedBy: "\n\n")

        let monkeys = (0..<descriptions.count).map { _ in Monkey() }
        for (idx, description) in descriptions.enumerated() {

            let lines = description.components(separatedBy: "\n")

            // assign items
            var components = lines[1]
                .components(separatedBy: ": ")[1]
                .components(separatedBy: ", ")
            monkeys[idx].items = components.compactMap(Int.init)

            // assign operation
            components = Array(
                lines[2]
                    .components(separatedBy: " ")
                    .suffix(3)
            )
            monkeys[idx].operation = { [components] oldValue in
                let first = components[0] == "old" ? oldValue : Int(components[0])!
                let second = components[2] == "old" ? oldValue : Int(components[2])!
                switch components[1] {
                case "+":
                    oldValue = first + second
                case "*":
                    oldValue = first * second
                default:
                    print("unsupported")
                    break
                }
            }

            // assign divisor
            components = lines[3].components(separatedBy: " ")
            monkeys[idx].divisor = components.last.flatMap(Int.init)!

            // assign other monkeys
            components = lines[4].components(separatedBy: " ")
            monkeys[idx].true = monkeys[components.last.flatMap(Int.init)!]

            components = lines[5].components(separatedBy: " ")
            monkeys[idx].false = monkeys[components.last.flatMap(Int.init)!]
        }

        return monkeys
    }()

    public static func part1() -> Int {
        for _ in 0..<20 {
            for monkey in monkeys {
                monkey.takeTurn()
            }
        }

        return monkeys
            .map(\.inspectionCount)
            .sorted()
            .suffix(2)
            .reduce(1, *)
    }

    public static func part2() -> Int {
        let leastCommonMultiple = monkeys
            .map(\.divisor)
            .reduce(1, *)

        for _ in 0..<10_000 {
            for monkey in monkeys {
                monkey.takeTurn(modulo: leastCommonMultiple)
            }
        }

        return monkeys
            .map(\.inspectionCount)
            .sorted()
            .suffix(2)
            .reduce(1, *)
    }
}

final class Monkey {
    var items: [Int] = []
    var operation: (inout Int) -> Void = { _ in }
    var divisor = 0

    var `true`: Monkey!
    var `false`: Monkey!

    private(set) var inspectionCount = 0

    init() { }

    func takeTurn(modulo: Int? = nil) {
        while !items.isEmpty {
            var item = items.removeFirst()

            // perform operation
            operation(&item)

            // get bored
            if let modulo {
                item %= modulo
            } else {
                item /= 3
            }

            if item % divisor == 0 {
                `true`.items.append(item)
            } else {
                `false`.items.append(item)
            }

            inspectionCount += 1
        }
    }
}
