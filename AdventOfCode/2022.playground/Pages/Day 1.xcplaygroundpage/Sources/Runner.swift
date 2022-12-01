import Foundation

public enum Runner {
    public static func part1() -> Int {
        input
            .components(separatedBy: "\n\n")
            .map {
                $0
                    .components(separatedBy: "\n")
                    .compactMap { Int($0) }
                    .reduce(0, +)
            }
            .max()!
    }

    public static func part2() -> Int {
        input
            .components(separatedBy: "\n\n")
            .map {
                $0
                    .components(separatedBy: "\n")
                    .compactMap { Int($0) }
                    .reduce(0, +)
            }
            .sorted()
            .suffix(3)
            .reduce(0, +)
    }
}
