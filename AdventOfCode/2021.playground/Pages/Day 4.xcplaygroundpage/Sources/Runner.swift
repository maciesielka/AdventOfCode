import Foundation

public enum Runner {
    public static func part1() -> Int {
        let lines = input.components(separatedBy: "\n\n")
        let numbers = lines[0]
            .components(separatedBy: ",")
            .compactMap(Int.init)

        var boards = lines.dropFirst()
            .map(Board.init)

        for number in numbers {
            for index in boards.indices {
                boards[index].markNumber(number)

                if boards[index].isComplete {
                    return number * boards[index].unmarkedNumbers.reduce(0, +)
                }
            }
        }

        return -1
    }

    public static func part2() -> Int {
        let lines = input.components(separatedBy: "\n\n")
        let numbers = lines[0]
            .components(separatedBy: ",")
            .compactMap(Int.init)

        var boards = lines.dropFirst()
            .map(Board.init)

        var incompleteIndices = Set(boards.indices)

        for number in numbers {
            for index in incompleteIndices {
                boards[index].markNumber(number)

                if boards[index].isComplete {
                    incompleteIndices.remove(index)

                    if incompleteIndices.isEmpty {
                        return number * boards[index].unmarkedNumbers.reduce(0, +)
                    }
                }
            }
        }

        return -1
    }
}

struct Board {
    var winningSets: [Set<Int>] = []
    var unmarkedNumbers: Set<Int> = []

    var isComplete = false
    var countDiagonals = false

    init(string: String) {
        let ints = string.components(separatedBy: .newlines)
            .map {
                $0.components(separatedBy: .whitespaces)
                    .compactMap(Int.init)
            }

        unmarkedNumbers = Set(ints.flatMap { $0 })

        // horizontals
        for y in ints.indices {
            var newSet: Set<Int> = []
            for x in ints[y].indices {
                newSet.insert(ints[y][x])
            }
            winningSets.append(newSet)
        }

        // verticals
        for x in ints[0].indices {
            var newSet: Set<Int> = []
            for y in ints.indices {
                newSet.insert(ints[y][x])
            }
            winningSets.append(newSet)
        }

        // diagonals
        if countDiagonals {
            var newSet: Set<Int> = []
            for coordinate in ints.indices {
                newSet.insert(ints[coordinate][coordinate])
            }
            winningSets.append(newSet)

            newSet = []
            for coordinate in ints.indices {
                let count = ints[coordinate].count - 1
                newSet.insert(ints[coordinate][count - coordinate])
            }
            winningSets.append(newSet)
        }
    }

    mutating func markNumber(_ number: Int) {
        guard let number = unmarkedNumbers.remove(number) else {
            return
        }

        for index in winningSets.indices {
            if winningSets[index].remove(number) != nil,
               winningSets[index].isEmpty {
                isComplete = true
            }
        }
    }
}
