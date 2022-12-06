import Algorithms
import Foundation

public enum Runner {
    public static func part1() -> Int {
        firstIndex(markerSize: 4)
    }

    public static func part2() -> Int {
        firstIndex(markerSize: 14)
    }

    static func firstIndex(markerSize: Int) -> Int {
        for (idx, window) in input.windows(ofCount: markerSize).enumerated() {
            if Set(window).count == markerSize {
                return idx + markerSize
            }
        }

        return 0
    }
}
