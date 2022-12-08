import Foundation

public enum Runner {

    struct Location: Hashable {
        var row: Int
        var column: Int

        func next(in direction: Direction) -> Location {
            switch direction {
            case .top:
                return .init(row: row - 1, column: column)
            case .left:
                return .init(row: row, column: column - 1)
            case .right:
                return .init(row: row, column: column + 1)
            case .bottom:
                return .init(row: row + 1, column: column)
            }
        }
    }

    enum Direction {
        case top
        case left
        case right
        case bottom
    }

    static let values = input
        .components(separatedBy: "\n")
        .map { $0.compactMap { $0.wholeNumberValue } }
    static let numRows = values.count
    static let numColumns = values[0].count

    static func isLocationOutOfBounds(_ location: Location) -> Bool {
        location.row < 0 || location.row >= numRows || location.column < 0 || location.column >= numColumns
    }

    static let visibleTrees: Set<Location> = {
        let debug = false

        func printSet(_ set: Set<Location>) {
            guard debug else {
                return
            }

            for row in 0..<numRows {
                var string = ""
                for column in 0..<numColumns {
                    let location = Location(row: row, column: column)
                    string += set.contains(location) ? "1" : "0"
                }
                print(string)
            }
        }

        func isLocation(_ location: Location, autoVisibleInDirection direction: Direction) -> Bool {
            switch direction {
            case .top:
                return location.row == 0

            case .left:
                return location.column == 0

            case .bottom:
                return location.row == numRows - 1

            case .right:
                return location.column == numColumns - 1
            }
        }

        func visibleTrees(from direction: Direction) -> Set<Location> {
            var visibleTrees: Set<Location> = []

            let row = [Int](repeating: 0, count: numColumns)
            var maximum = Array(repeating: row, count: numRows)

            func markLocation(
                row: Int,
                column: Int
            ) {
                let location = Location(row: row, column: column)
                let other = location.next(in: direction)

                let value = values[location.row][location.column]

                if isLocation(location, autoVisibleInDirection: direction) {
                    maximum[row][column] = value
                    visibleTrees.insert(location)
                    return
                }

                if value > maximum[other.row][other.column] {
                    visibleTrees.insert(location)
                }

                maximum[row][column] = max(maximum[other.row][other.column], value)
            }

            switch direction {
            case .top:
                for row in 0..<numRows {
                    for column in 0..<numColumns {
                        markLocation(row: row, column: column)
                    }
                }

            case .left:
                for column in 0..<numColumns {
                    for row in 0..<numRows {
                        markLocation(row: row, column: column)
                    }
                }

            case .right:
                for column in (0..<numColumns).reversed() {
                    for row in 0..<numRows {
                        markLocation(row: row, column: column)
                    }
                }

            case .bottom:
                for row in (0..<numRows).reversed() {
                    for column in 0..<numColumns {
                        markLocation(row: row, column: column)
                    }
                }
            }

            return visibleTrees
        }

        let visibleFromTop = visibleTrees(from: .top)
        let visibleFromLeft = visibleTrees(from: .left)
        let visibleFromRight = visibleTrees(from: .right)
        let visibleFromBottom = visibleTrees(from: .bottom)

        let visible = visibleFromTop
            .union(visibleFromLeft)
            .union(visibleFromRight)
            .union(visibleFromBottom)

        return visible
    }()

    public static func part1() -> Int {
        visibleTrees.count
    }

    public static func part2() -> Int {
        func numberVisibleTrees(from location: Location, in direction: Direction) -> Int {
            let currentHeight = values[location.row][location.column]
            var current = location.next(in: direction)
            var numTrees = 0
            while !isLocationOutOfBounds(current) {
                numTrees += 1

                if values[current.row][current.column] >= currentHeight {
                    break
                }

                current = current.next(in: direction)
            }
            return numTrees
        }

        func scenicScore(for location: Location) -> Int {
            numberVisibleTrees(from: location, in: .top) *
                numberVisibleTrees(from: location, in: .left) *
                numberVisibleTrees(from: location, in: .right) *
                numberVisibleTrees(from: location, in: .bottom)
        }

        return visibleTrees
            .map(scenicScore)
            .max()!
    }
}
