import Foundation

public enum Runner {
    public static func part1() -> Int {
        let sensors = input
            .components(separatedBy: "\n")
            .map(Sensor.init)

        var set: Set<Point> = []
        for sensor in sensors {
            for point in sensor.unoccupiedPoints(withY: 2_000_000) {
                set.insert(point)
            }
        }

        return set.count
    }

    public static func part2() -> Int {
        let sensors = input
            .components(separatedBy: "\n")
            .map(Sensor.init)

        let limit = 4_000_000
        for y in 0...limit {
            var ranges = CombinedRanges()
            for sensor in sensors {
                if let range = sensor.unavailableRange(withY: y) {
                    ranges.append(range)
                }
            }

            let values = ranges.valuesNotCovered(in: 0...limit)
            if !values.isEmpty {
                return values[0] * 4_000_000 + y
            }
        }

        return -1
    }
}

struct CombinedRanges {
    var ranges: [ClosedRange<Int>] = []

    mutating func append(_ other: ClosedRange<Int>) {
        ranges.append(other)
    }

    func valuesNotCovered(in other: ClosedRange<Int>) -> [Int] {
        if other.isEmpty {
            return []
        }

        var subranges = [other]
        for range in ranges {
            var temp: [ClosedRange<Int>] = []
            while let subrange = subranges.popLast() {
                let lowerBound = max(range.lowerBound, subrange.lowerBound)
                let upperBound = min(range.upperBound, subrange.upperBound)
                guard lowerBound <= upperBound else {
                    temp.append(subrange)
                    continue
                }

                if subrange.lowerBound <= lowerBound - 1 {
                    temp.append(subrange.lowerBound...(lowerBound - 1))
                }

                if subrange.upperBound >= upperBound + 1 {
                    temp.append((upperBound + 1)...subrange.upperBound)
                }
            }

            subranges = temp
        }

        return subranges
            .flatMap { $0.map { $0 } }
            .sorted()
    }
}

struct Point: Hashable {
    var x: Int
    var y: Int
}

extension Point {
    static let zero = Point(x: 0, y: 0)
}

extension Point {
    func offset(x: Int, y: Int) -> Self {
        var copy = self
        copy.x += x
        copy.y += y
        return copy
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

struct Sensor {
    var location = Point.zero
    var beacon = Point.zero
}

extension Sensor {
    init(string: String) {
        let scanner = Scanner(string: string)
        _ = scanner.scanString("Sensor at x=")
        location.x = scanner.scanInt()!
        _ = scanner.scanString(", y=")
        location.y = scanner.scanInt()!

        _ = scanner.scanString(": closest beacon is at x=")
        beacon.x = scanner.scanInt()!
        _ = scanner.scanString(", y=")
        beacon.y = scanner.scanInt()!
    }
}

extension Sensor {
    func unoccupiedPoints(withY y: Int) -> [Point] {
        let range = abs(beacon.y - location.y) + abs(beacon.x - location.x)
        guard ((location.y - range)...(location.y + range)).contains(y) else {
            return []
        }

        var result: [Point] = []
        let offset = abs(location.y - y)
        for x in (-range + offset)...(range - offset) {
            let offset = Point(x: location.x + x, y: y)
            if offset != beacon, offset != location {
                result.append(offset)
            }
        }
        return result
    }

    func unavailableRange(withY y: Int) -> ClosedRange<Int>? {
        let range = abs(beacon.y - location.y) + abs(beacon.x - location.x)
        guard ((location.y - range)...(location.y + range)).contains(y) else {
            return nil
        }

        let offset = abs(location.y - y)
        return (-range + offset + location.x)...(range - offset + location.x)
    }
}

extension Sensor: CustomStringConvertible {
    var description: String {
        "Location: \(location), Beacon: \(beacon)"
    }
}
