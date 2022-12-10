import Foundation

enum Command {
    case noop
    case add(Int)

    init(string: String) {
        let components = string.components(separatedBy: " ")
        switch components[0] {
        case "noop":
            self = .noop

        case "addx":
            let addend = Int(components[1])!
            self = .add(addend)

        default:
            fatalError("Unsupported")
        }
    }
}

struct State {
    var signalStrength: Int {
        x * cycle
    }

    var strengthsOfNote: [Int: Int] = [:]
    var visiblePixels: Set<Int> {
        [x - 1, x, x + 1]
    }

    var x = 1
    var cycle = 0 {
        didSet {
            if cycle - 20 >= 0, (cycle - 20) % 40 == 0 {
                strengthsOfNote[cycle] = signalStrength
            }

            onCycle?(self)
        }
    }

    var onCycle: ((State) -> Void)?

    mutating func process(_ command: Command) {
        switch command {
        case .noop:
            cycle += 1

        case .add(let value):
            cycle += 1
            cycle += 1
            x += value
        }
    }
}

public enum Runner {
    public static func part1() -> Int {
        let commands = input
            .components(separatedBy: "\n")
            .map(Command.init)

        var state = State()
        for command in commands {
            state.process(command)

            if state.cycle >= 220 {
                break
            }
        }

        return state.strengthsOfNote.values.reduce(0, +)
    }

    public static func part2() {
        let commands = input
            .components(separatedBy: "\n")
            .map(Command.init)

        var state = State()

        var row = ""
        state.onCycle = { state in
            let position = (state.cycle - 1) % 40
            row += state.visiblePixels.contains(position) ? "#" : "."
            if (position + 1) % 40 == 0 {
                print(row)
                row = ""
            }
        }

        for command in commands {
            state.process(command)
        }
    }
}
