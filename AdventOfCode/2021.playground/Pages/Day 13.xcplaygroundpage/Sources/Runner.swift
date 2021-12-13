import PlaygroundSupport
import Foundation

public enum Runner {
    public static func part1() -> Int {
        let components = input.components(separatedBy: "\n\n")
        let points = components[0].components(separatedBy: .newlines)
            .map(Point.init(string:))
        let commands = components[1].components(separatedBy: .newlines)
            .map(Command.init)

        var setOfPoints: Set<Point> = []
        for point in points {
            switch commands[0] {
            case .foldLeft(let x):
                let translated = point.foldedLeft(acrossX: x)
                setOfPoints.insert(translated)

            case .foldUp(let y):
                let translated = point.foldedUp(acrossY: y)
                setOfPoints.insert(translated)
            }
        }

        return setOfPoints.count
    }

    public static func part2() -> Int {
        let components = input.components(separatedBy: "\n\n")
        let points = components[0].components(separatedBy: .newlines)
            .map(Point.init(string:))
        let commands = components[1].components(separatedBy: .newlines)
            .map(Command.init)

        var results: Set<Point> = Set(points)
        for command in commands {
            var setOfPoints: Set<Point> = []
            for point in results {
                switch command {
                case .foldLeft(let x):
                    let translated = point.foldedLeft(acrossX: x)
                    setOfPoints.insert(translated)

                case .foldUp(let y):
                    let translated = point.foldedUp(acrossY: y)
                    setOfPoints.insert(translated)
                }
            }
            results = setOfPoints
        }

        // flip across y=x for readability
        results = Set(results.map { point in
            Point(x: point.y, y: point.x)
        })

        let maxY = results.map(\.y).max()!
        let maxX = results.map(\.x).max()!

        var string = ""
        for x in 0...maxX {
            for y in 0...maxY {
                let point = Point(x: x, y: y)
                if results.contains(point) {
                    string += "X"
                } else {
                    string += " "
                }
            }
            string += "\n"
        }

        print(string)
        return results.count
    }
}

private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

private enum Command {
    case foldLeft(x: Int)
    case foldUp(y: Int)

    init(string: String) {
        let components = string
            .components(separatedBy: " ")
            .suffix(1)
            .first!
            .components(separatedBy: "=")
        switch components[0] {
        case "x":
            self = .foldLeft(x: Int(components[1])!)
        case "y":
            self = .foldUp(y: Int(components[1])!)
        default:
            fatalError("Invalid input")
        }
    }
}

private struct Point: Hashable {
    var x: Int
    var y: Int
}

extension Point {
    func foldedLeft(acrossX barrier: Int) -> Point {
        guard x > barrier else {
            return self
        }
        return Point(x: x - 2 * (x - barrier), y: y)
    }

    func foldedUp(acrossY barrier: Int) -> Point {
        guard y > barrier else {
            return self
        }
        return Point(x: x, y: y - 2 * (y - barrier))
    }
}

extension Point {
    init(string: String) {
        let components = string.components(separatedBy: ",")
        self.init(x: Int(components[0])!, y: Int(components[1])!)
    }
}

extension Point: CustomStringConvertible {
    var description: String { "(\(x), \(y))"}
}
