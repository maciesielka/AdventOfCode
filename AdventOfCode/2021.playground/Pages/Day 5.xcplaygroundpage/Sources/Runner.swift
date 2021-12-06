import Foundation

struct Point: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    var description: String {
        "(\(x), \(y))"
    }
}

extension Point {
    init(string: String) {
        let components = string.components(separatedBy: ",")
            .compactMap(Int.init)
        x = components[0]
        y = components[1]
    }
}

struct Vector {
    var start: Point
    var end: Point

    var considersDiagonals = false

    private var slope: Double {
        Double(end.y - start.y) / Double(end.x - start.x)
    }

    var line: [Point] {
        if start.x == end.x {
            let startY = min(start.y, end.y)
            let endY = max(start.y, end.y)

            return (startY...endY).map { Point(x: start.x, y: $0) }
        } else if start.y == end.y {
            let startX = min(start.x, end.x)
            let endX = max(start.x, end.x)

            return (startX...endX).map { Point(x: $0, y: start.y) }
        } else if considersDiagonals, abs(slope) == 1 {
            let startPoint = min(start.x, end.x) == start.x
                ? start
                : end
            let endPoint = startPoint == start
                ? end
                : start

            let slope = endPoint.y > startPoint.y ? 1 : -1
            return (startPoint.x...endPoint.x).enumerated()
                .map { Point(x: $0.element, y: startPoint.y + $0.offset * slope) }
        } else {
            return []
        }
    }
}

public enum Runner {

    public static func part1() -> Int {
        let vectors = input.components(separatedBy: .newlines)
            .map { string -> Vector in
                let points = string.components(separatedBy: "->")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .map(Point.init)
                return Vector(start: points[0], end: points[1])
            }

        var frequency: [Point: Int] = [:]
        for vector in vectors {
            for point in vector.line {
                frequency[point, default: 0] += 1
            }
        }

        return frequency
            .filter { $0.value >= 2 }
            .count
    }

    public static func part2() -> Int {
        let vectors = input.components(separatedBy: .newlines)
            .map { string -> Vector in
                let points = string.components(separatedBy: "->")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .map(Point.init)
                return Vector(
                    start: points[0],
                    end: points[1],
                    considersDiagonals: true
                )
            }

        var frequency: [Point: Int] = [:]
        for vector in vectors {
            for point in vector.line {
                frequency[point, default: 0] += 1
            }
        }

        return frequency
            .filter { $0.value >= 2 }
            .count
    }
}
