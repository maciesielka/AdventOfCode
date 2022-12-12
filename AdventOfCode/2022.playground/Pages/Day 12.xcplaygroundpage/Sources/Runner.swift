import Foundation

struct Location: Hashable {
    var x: Int
    var y: Int

    func adjacentLocations<Value>(inBoundsOf grid: [[Value]]) -> [Location] {
        var result: [Location] = []

        if x - 1 >= 0 {
            result.append(.init(x: x - 1, y: y))
        }

        if x + 1 < grid[0].count {
            result.append(.init(x: x + 1, y: y))
        }

        if y - 1 >= 0 {
            result.append(.init(x: x, y: y - 1))
        }

        if y + 1 < grid.count {
            result.append(.init(x: x, y: y + 1))
        }

        return result
    }
}

extension Location {
    static let zero = Location(x: 0, y: 0)
}

public enum Runner {
    public static func part1() -> Int {
        let grid = input
            .components(separatedBy: "\n")
            .map { $0 }

        let elevations: [[Int]] = grid
            .map { row -> [Int] in
                row
                    .compactMap { character -> UInt8? in
                        switch character {
                        case "S":
                            return Character("a").asciiValue
                        case "E":
                            return Character("z").asciiValue
                        default:
                            return character.asciiValue
                        }
                    }
                    .map { Int($0) }
            }

        var start: Location!
        var end: Location!
        initialize: for (y, row) in grid.enumerated() {
            for (x, value) in row.enumerated() {
                if value == "S" {
                    start = Location(x: x, y: y)
                }

                if value == "E" {
                    end = Location(x: x, y: y)
                }

                if start != nil && end != nil {
                    break initialize
                }
            }
        }

        // compute distances from the start to the end
        var path: [Location] = [start]
        var distances: [Location: Int] = [start: 0]

        while !path.isEmpty {
            let visited = path.removeFirst()
            let alreadyComputedDistance = distances[visited]!
            for neighbor in visited.adjacentLocations(inBoundsOf: elevations) {
                guard elevations[neighbor.y][neighbor.x] <= elevations[visited.y][visited.x] + 1 else {
                    continue
                }

                if let existingDistanceToNeighbor = distances[neighbor],
                   alreadyComputedDistance + 1 >= existingDistanceToNeighbor {
                    continue
                }

                distances[neighbor] = alreadyComputedDistance + 1
                path.append(neighbor)
            }
        }

        return distances[end] ?? -1
    }

    public static func part2() -> Int {
        let grid = input
            .components(separatedBy: "\n")
            .map { $0 }

        let elevations: [[Int]] = grid
            .map { row -> [Int] in
                row
                    .compactMap { character -> UInt8? in
                        switch character {
                        case "S":
                            return Character("a").asciiValue
                        case "E":
                            return Character("z").asciiValue
                        default:
                            return character.asciiValue
                        }
                    }
                    .map { Int($0) }
            }

        var starts: [Location] = []
        var end: Location!
        initialize: for (y, row) in grid.enumerated() {
            for (x, value) in row.enumerated() {
                if value == "S" || value == "a" {
                    let location = Location(x: x, y: y)
                    starts.append(location)
                }

                if value == "E" {
                    end = Location(x: x, y: y)
                }
            }
        }

        // start at the end and compute distances to all start nodes
        var path: [Location] = [end]
        var distances: [Location: Int] = [end: 0]

        while !path.isEmpty {
            let visited = path.removeFirst()
            let alreadyComputedDistance = distances[visited]!
            for neighbor in visited.adjacentLocations(inBoundsOf: elevations) {
                let destination =  elevations[neighbor.y][neighbor.x]
                let source = elevations[visited.y][visited.x]
                guard destination >= source - 1 else {
                    continue
                }

                if let existingDistanceToNeighbor = distances[neighbor],
                   alreadyComputedDistance + 1 >= existingDistanceToNeighbor {
                    continue
                }

                distances[neighbor] = alreadyComputedDistance + 1
                path.append(neighbor)
            }
        }

        // return the smallest distance from the end to all starts
        return starts
            .compactMap { distances[$0] }
            .min() ?? -1
    }
}
