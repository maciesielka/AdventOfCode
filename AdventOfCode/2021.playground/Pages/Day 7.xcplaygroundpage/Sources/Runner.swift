import Foundation

public enum Runner {
    public static func part1() -> Int {
        let ints = input.components(separatedBy: ",")
            .compactMap(Int.init)
            .sorted()

        let min = ints[0]
        let max = ints[ints.count - 1]

        var minFuel: Int?
        for pivot in min...max {
            let totalFuel = ints
                .map { abs($0 - pivot) }
                .reduce(0, +)
            if let aMinFuel = minFuel {
                minFuel = Swift.min(aMinFuel, totalFuel)
            } else {
                minFuel = totalFuel
            }
        }

        return minFuel!
    }

    public static func part2() -> Int {
        let ints = input.components(separatedBy: ",")
            .compactMap(Int.init)
            .sorted()

        let min = ints[0]
        let max = ints[ints.count - 1]

        var costs: [Int: Int] = [:]
        for distance in 0...(max - min) {
            costs[distance] = costs[distance - 1, default: 0] + distance
        }

        var minFuel: Int?
        for pivot in min...max {
            let totalFuel = ints
                .map { costs[abs($0 - pivot)]! }
                .reduce(0, +)
            if let aMinFuel = minFuel {
                minFuel = Swift.min(aMinFuel, totalFuel)
            } else {
                minFuel = totalFuel
            }
        }

        return minFuel!
    }
}
