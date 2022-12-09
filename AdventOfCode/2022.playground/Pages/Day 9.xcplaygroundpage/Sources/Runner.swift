import Foundation

public enum Runner {
    public static func part1() -> Int {
        var state = State1()
        let instructions = input
            .components(separatedBy: "\n")
            .map(Instruction.init)

        for instruction in instructions {
            state.process(instruction)
        }

        return state.visitedTailLocations.count
    }

    public static func part2() -> Int {
        var state = State2()
        let instructions = input
            .components(separatedBy: "\n")
            .map(Instruction.init)

        for instruction in instructions {
            state.process(instruction)
        }

        return state.visitedTailLocations.count
    }
}

enum Direction {
    case up
    case left
    case down
    case right

    init(string: String) {
        switch string {
        case "U":
            self = .up
        case "L":
            self = .left
        case "D":
            self = .down
        case "R":
            self = .right
        default:
            fatalError("Unsupported")
        }
    }
}

struct Instruction {
    var direction: Direction
    var count: Int

    init(string: String) {
        let components = string.components(separatedBy: " ")
        direction = .init(string: components[0])
        count = Int(components[1])!
    }
}

struct Point: Hashable {
    var x: Int
    var y: Int

    mutating func move(in direction: Direction) {
        switch direction {
        case .up:
            y += 1
        case .left:
            x -= 1
        case .down:
            y -= 1
        case .right:
            x += 1
        }
    }
}

extension Point {
    static let zero = Point(x: 0, y: 0)
}

struct Rope {
    var head = Point.zero
    var tail = Point.zero

    mutating func move(in direction: Direction) {
        head.move(in: direction)
        tighten()
    }

    mutating func tighten() {
        if abs(head.x - tail.x) > 1 || abs(head.y - tail.y) > 1 {
            tail.x += max(-1, min(head.x - tail.x, 1))
            tail.y += max(-1, min(head.y - tail.y, 1))
        }
    }
}

struct State1 {
    var rope = Rope()
    var visitedTailLocations: Set<Point> = [.zero]

    mutating func process(_ instruction: Instruction) {
        for _ in 0..<instruction.count {
            rope.move(in: instruction.direction)
            visitedTailLocations.insert(rope.tail)
        }
    }
}

struct State2 {
    var ropes = Array(repeating: Rope(), count: 9)
    var visitedTailLocations: Set<Point> = [.zero]

    mutating func process(_ instruction: Instruction) {
        for _ in 0..<instruction.count {
            ropes[0].move(in: instruction.direction)

            for ropeIndex in ropes.indices.dropFirst() {
                ropes[ropeIndex].head = ropes[ropeIndex - 1].tail
                ropes[ropeIndex].tighten()
            }

            visitedTailLocations.insert(ropes.last!.tail)
        }

        var printing = ""
        for y in -10...10 {
            var string = ""
            for x in -10...10 {
                if x == 0, y == 0 {
                    string += "s"
                } else if visitedTailLocations.contains(.init(x: x, y: y)) {
                    string += "X"
                } else {
                    string += "."
                }
            }
            printing = "\(string)\n\(printing)"
        }
    }
}
