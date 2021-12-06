import Foundation

public enum Runner {
    static func run(numberOfSteps: Int) -> Int {
        var state: [Int: Int] = [:]
        let allFish = input.components(separatedBy: ",").compactMap(Int.init)
        for fish in allFish {
            state[fish, default: 0] += 1
        }

        for _ in 1...numberOfSteps {
            var next: [Int: Int] = [:]
            for key in state.keys {
                if key == 0 {
                    next[6, default: 0] += state[key]!
                    next[8] = state[key]
                } else {
                    next[key - 1, default: 0] += state[key]!
                }
            }

            state = next
        }

        return state.values.reduce(0, +)
    }

    public static func part1() -> Int {
        run(numberOfSteps: 80)
    }

    public static func part2() -> Int {
        run(numberOfSteps: 256)
    }
}
