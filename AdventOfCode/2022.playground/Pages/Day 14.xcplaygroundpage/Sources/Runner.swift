import Algorithms
import Foundation

enum Contents {
    case rock
    case sand
}

public enum Runner {
    static let rocks: Set<Point> = {
        let obstructedPoints: [Point] = input
            .components(separatedBy: "\n")
            .map { line -> [Point] in
                line
                    .components(separatedBy: " -> ")
                    .map(Point.init)
            }
            .flatMap { rowOfPoints -> [Point] in
                rowOfPoints.adjacentPairs()
                    .map { Line(start: $0, end: $1) }
                    .flatMap { $0.points }
            }

        return Set(obstructedPoints)
    }()

    public static func part1() -> Int {
        var count = 0
        var state = State(rocks: rocks)
        while state.addSand() != nil {
            count += 1
        }

        return count
    }

    public static func part2() -> Int {
        var count = 0
        var state = State(rocks: rocks, buffer: 1)
        while let placed = state.addSand(part: .two) {
            count += 1

            if placed == state.initial {
                break
            }
        }

        return count
    }
}

struct State {
    var initial = Point(x: 500, y: 0)
    var contents: [Point: Contents] = [:]
    var maxY: Int

    init(rocks: Set<Point>, buffer: Int = 0) {
        for rock in rocks {
            contents[rock] = .rock
        }
        self.maxY = rocks.map(\.y).max()! + buffer
    }

    enum Part {
        case one
        case two
    }

    mutating func addSand(part: Part = .one) -> Point? {
        var location = initial
        drop: while maxY >= location.y {
            let destinations: [Point] = [
                .init(x: location.x, y: location.y + 1),
                .init(x: location.x - 1, y: location.y + 1),
                .init(x: location.x + 1, y: location.y + 1)
            ]

            for destination in destinations {
                switch part {
                case .one:
                    if !contents.keys.contains(destination) {
                        location = destination
                        continue drop
                    }

                case .two:
                    let isSolid = contents.keys.contains(destination) || destination.y == maxY + 1
                    if !isSolid {
                        location = destination
                        continue drop
                    }
                }
            }

            break
        }

        if maxY >= location.y {
            contents[location] = .sand
        }

        return maxY >= location.y ? location : nil
    }
}

struct Line {
    var start: Point
    var end: Point

    var points: [Point] {
        if start.y == end.y {
            return (min(start.x, end.x)...max(start.x, end.x)).map {
                Point(x: $0, y: start.y)
            }
        } else if start.x == end.x {
            return (min(start.y, end.y)...max(start.y, end.y)).map {
                Point(x: start.x, y: $0)
            }
        } else {
            fatalError("Unsupported")
        }
    }
}

extension Line: CustomStringConvertible {
    var description: String {
        "\(start) -> \(end)"
    }
}

struct Point: Hashable {
    var x: Int
    var y: Int
}

extension Point {
    init(string: String) {
        let components = string.components(separatedBy: ",")
        x = Int(components[0])!
        y = Int(components[1])!
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}
