import Foundation

public enum Runner {
    public static func part1() -> Int {
        run(numberOfTurns: 2)
    }

    public static func part2() -> Int {
        run(numberOfTurns: 50)
    }
}

private func run(numberOfTurns: Int) -> Int {
    let components = input.components(separatedBy: "\n\n")
    let binaryLookup = components[0]
        .replacingOccurrences(of: ".", with: "0")
        .replacingOccurrences(of: "#", with: "1")
        .map { String($0) }
    let grid = components[1].components(separatedBy: .newlines)
    var map: [Point: String] = [:]
    for (rowIndex, row) in grid.enumerated() {
        for (characterIndex, character) in row.enumerated() {
            let point = Point(row: rowIndex, column: characterIndex)
            switch character {
            case "#":
                map[point] = "1"
            case ".":
                map[point] = "0"
            default:
                break
            }
        }
    }

    var minimum = Point(row: -1, column: -1)
    var maximum = Point(row: grid.count, column: grid[0].count)

    let flips = binaryLookup[0] == "1"

    func code(for point: Point, turn: Int) -> Int {
        var string = ""
        for neighbor in point.neighbors {
            let isOdd = turn % 2 == 1
            let outerValue = isOdd && flips ? "1" : "0"
            string += map[neighbor] ?? outerValue
        }
        return Int(string, radix: 2)!
    }

    for turn in 0..<numberOfTurns {
        var new = map
        for row in minimum.row...maximum.row {
            for column in minimum.column...maximum.column {
                let point = Point(row: row, column: column)
                let code = code(for: point, turn: turn)
                new[point] = binaryLookup[code]
            }
        }

        minimum.row -= 1
        minimum.column -= 1

        maximum.row += 1
        maximum.column += 1

        map = new
    }

    return map.values.filter { $0 == "1" }.count
}

private struct Point: Hashable {
    var row: Int
    var column: Int

    var neighbors: [Point] {
        var result: [Point] = []
        for r in (row - 1)...(row + 1) {
            for c in (column - 1)...(column + 1) {
                let point = Point(row: r, column: c)
                result.append(point)
            }
        }
        return result
    }
}
