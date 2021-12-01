import Foundation

public enum Runner {
    public static func part1() -> Int {
        let ints = input.components(separatedBy: .newlines)
            .compactMap(Int.init)

        var numberOfIncreases = 0
        var last = ints[0]
        for int in ints.dropFirst() {
            if int > last {
                numberOfIncreases += 1
            }

            last = int
        }

        return numberOfIncreases
    }

    public static func part2() -> Int {
        let ints = input.components(separatedBy: .newlines)
            .compactMap(Int.init)
        let slidingWindowSums = ints.indices.dropLast(2)
            .map { startingIndex in
                [ints[startingIndex], ints[startingIndex + 1], ints[startingIndex + 2]]
            }
            .map { $0.reduce(0, +) }

        var numberOfIncreases = 0
        var last = slidingWindowSums[0]
        for sum in slidingWindowSums.dropFirst() {
            if sum > last {
                numberOfIncreases += 1
            }

            last = sum
        }

        return numberOfIncreases
    }
}
