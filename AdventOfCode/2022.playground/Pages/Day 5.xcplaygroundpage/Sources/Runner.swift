import Foundation

public enum Runner {
    struct Data {
        var stacks: [Stack<String>]
        var instructions: [Instruction]
    }

    static func parse() -> Data {
        let components = input
            .components(separatedBy: "\n\n")

        var stackInput = components[0]
            .components(separatedBy: "\n")
        var stacks: [Stack<String>] = []

        // the last line isn't interesting
        stackInput.removeLast()
        let pileCount = stackInput.last!.filter { $0 == "]" }.count

        for pile in 0..<pileCount {
            let offset = 4 * pile + 1

            var stack = Stack<String>()
            for row in stackInput.reversed() {
                guard offset < row.count else {
                    break
                }
                let startIndex = row.index(row.startIndex, offsetBy: offset)
                let endIndex = row.index(after: startIndex)

                let input = String(row[startIndex..<endIndex])
                if input == " " {
                    break
                }

                stack.push(input)
            }
            stacks.append(stack)
        }

        let instructions = components[1]
            .components(separatedBy: "\n")
            .map(Instruction.init)

        return .init(stacks: stacks, instructions: instructions)
    }

    public static func part1() -> String {
        var data = parse()

        for instruction in data.instructions {
            for _ in 0..<instruction.count {
                let element = data.stacks[instruction.from - 1].pop()!
                data.stacks[instruction.to - 1].push(element)
            }
        }

        return data.stacks
            .compactMap { $0.peek() }
            .joined()
    }

    public static func part2() -> String {
        var data = parse()

        for instruction in data.instructions {
            var temp = Stack<String>()
            for _ in 0..<instruction.count {
                let element = data.stacks[instruction.from - 1].pop()!
                temp.push(element)
            }

            while let next = temp.pop() {
                data.stacks[instruction.to - 1].push(next)
            }
        }

        return data.stacks
            .compactMap { $0.peek() }
            .joined()
    }
}

struct Instruction {
    var count: Int
    var from: Int
    var to: Int

    init(string: String) {
        let components = string
            .components(separatedBy: " ")
            .compactMap { Int($0) }
        count = components[0]
        from = components[1]
        to = components[2]
    }
}

struct Stack<Element> {
    private var storage: [Element] = []

    mutating func push(_ element: Element) {
        storage.append(element)
    }

    mutating func pop() -> Element? {
        storage.popLast()
    }

    func peek() -> Element? {
        storage.last
    }
}
