import Foundation

public enum Runner {
    struct Command {
        enum Kind: String {
            case forward
            case down
            case up
        }

        var kind: Kind
        var value: Int
    }

    struct Position {
        var horizontal = 0
        var depth = 0
    }

    public static func part1() -> Int {
        let commands = input.components(separatedBy: .newlines)
            .map { string -> Command in
                let components = string.components(separatedBy: " ")
                return .init(
                    kind: .init(rawValue: components[0])!,
                    value: Int(components[1])!
                )
            }

        var position = Position()
        for command in commands {
            switch command.kind {
            case .forward:
                position.horizontal += command.value
            case .up:
                position.depth -= command.value
            case .down:
                position.depth += command.value
            }
        }

        return position.horizontal * position.depth
    }

    struct PositionWithAim {
        var horizontal = 0
        var depth = 0
        var aim = 0
    }

    public static func part2() -> Int {
        let commands = input.components(separatedBy: .newlines)
            .map { string -> Command in
                let components = string.components(separatedBy: " ")
                return .init(
                    kind: .init(rawValue: components[0])!,
                    value: Int(components[1])!
                )
            }

        var position = PositionWithAim()
        for command in commands {
            switch command.kind {
            case .forward:
                position.horizontal += command.value
                position.depth += position.aim * command.value
            case .up:
                position.aim -= command.value
            case .down:
                position.aim += command.value
            }
        }

        return position.horizontal * position.depth
    }
}
