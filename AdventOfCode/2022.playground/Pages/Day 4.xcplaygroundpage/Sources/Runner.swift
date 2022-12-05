import Foundation

public enum Runner {
    public static func part1() -> Int {
        count {
            $0.isSubset(of: $1) || $1.isSubset(of: $0)
        }
    }

    public static func part2() -> Int {
        count {
            !$0.isDisjoint(with: $1)
        }
    }

    static func count(where predicate: (Set<Int>, Set<Int>) -> Bool) -> Int {
        input
            .components(separatedBy: "\n")
            .filter { line in
                let ranges = line.components(separatedBy: ",")
                    .map(Set<Int>.init)
                return predicate(ranges[0], ranges[1])
            }
            .count
    }
}

extension Set<Int> {
    init(string: String) {
        let components = string
            .components(separatedBy: "-")
            .compactMap { Int($0) }
        self = Set(components[0]...components[1])
    }
}
