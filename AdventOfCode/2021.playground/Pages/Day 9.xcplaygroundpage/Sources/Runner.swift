import Foundation

public enum Runner {
    public static func part1() -> Int {
        let grid = input.components(separatedBy: .newlines)
            .map {
                $0.compactMap { $0.wholeNumberValue }
            }

        var lowpoints: [Int] = []
        for y in grid.indices {
            for x in grid[y].indices {
                let value = grid[y][x]

                if y > 0, grid[y - 1][x] <= value {
                    continue
                }

                if y < grid.indices.count - 1, grid[y + 1][x] <= value {
                    continue
                }

                if x > 0, grid[y][x - 1] <= value {
                    continue
                }

                if x < grid[y].indices.count - 1, grid[y][x + 1] <= value {
                    continue
                }

                lowpoints.append(grid[y][x])
            }
        }

        return lowpoints
            .map { $0 + 1 }
            .reduce(0, +)
    }

    public static func part2() -> Int {
        let grid = input.components(separatedBy: .newlines)
            .map {
                $0.compactMap { $0.wholeNumberValue }
            }

        var lowpoints: [Point] = []
        for y in grid.indices {
            for x in grid[y].indices {
                let value = grid[y][x]

                if y > 0, grid[y - 1][x] <= value {
                    continue
                }

                if y < grid.indices.count - 1, grid[y + 1][x] <= value {
                    continue
                }

                if x > 0, grid[y][x - 1] <= value {
                    continue
                }

                if x < grid[y].indices.count - 1, grid[y][x + 1] <= value {
                    continue
                }

                lowpoints.append(Point(x: x, y: y))
            }
        }

        var depths: [Int] = []
        for lowpoint in lowpoints {
            let basinSize = basinSize(
                using: grid,
                from: lowpoint
            )

            depths.append(basinSize)
        }

        return depths
            .sorted()
            .suffix(3)
            .reduce(1, *)
    }

    enum Direction {
        case up
        case down
        case left
        case right

        static let all: Set<Direction> = [.up, .down, .left, .right]
    }

    struct Point: Hashable {
        var x: Int
        var y: Int
    }

    private static func basinSize(
        using grid: [[Int]],
        from point: Point
    ) -> Int {
        var counted: Set<Point> = []
        return basinSize(using: grid, from: point, counted: &counted)
    }

    private static func basinSize(
        using grid: [[Int]],
        from point: Point,
        counted: inout Set<Point>
    ) -> Int {
        guard !counted.contains(point) else {
            return 0
        }
        counted.insert(point)

        var size = 1
        let (y, x) = (point.y, point.x)
        let value = grid[y][x]
        if value == 9 {
            return 0
        }

        for direction in Direction.all {
            switch direction {
            case .up where y - 1 >= 0:
                if grid[y - 1][x] > value {
                    size += basinSize(
                        using: grid,
                        from: Point(x: x, y: y - 1),
                        counted: &counted
                    )
                }
            case .down where y + 1 < grid.count:
                if grid[y + 1][x] > value {
                    size += basinSize(
                        using: grid,
                        from: Point(x: x, y: y + 1),
                        counted: &counted
                    )
                }
            case .left where x - 1 >= 0:
                if grid[y][x - 1] > value {
                    size += basinSize(
                        using: grid,
                        from: Point(x: x - 1, y: y),
                        counted: &counted
                    )
                }
            case .right where x + 1 < grid[0].count:
                if grid[y][x + 1] > value {
                    size += basinSize(
                        using: grid,
                        from: Point(x: x + 1, y: y),
                        counted: &counted
                    )
                }
            default:
                break
            }
        }

        return size
    }
}
