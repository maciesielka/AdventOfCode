import Foundation

public enum Runner {
    public static func part1() -> Int {
        let ints = input.components(separatedBy: .newlines)
            .map { $0.compactMap { $0.wholeNumberValue } }

        var memoize: [[Int]] = []
        for rowIndex in ints.indices {
            var array: [Int] = []
            for _ in ints[rowIndex].indices {
                array.append(0)
            }
            memoize.append(array)
        }

        func lowestRiskNavigating(toRowIndex rowIndex: Int, columnIndex: Int) -> Int? {
            guard rowIndex >= 0, rowIndex < memoize.indices.count else {
                return nil
            }

            guard columnIndex >= 0, rowIndex < memoize[rowIndex].indices.count else {
                return nil
            }

            return memoize[rowIndex][columnIndex]
        }

        for rowIndex in ints.indices {
            for columnIndex in ints[rowIndex].indices {
                if rowIndex == 0, columnIndex == 0 {
                    continue
                }

                /// Incorrect because this assumes that moving down and to the right is the best way to move through the grid.
                /// Probably need to use a path-finding algorithm instead.
                let left = lowestRiskNavigating(toRowIndex: rowIndex, columnIndex: columnIndex - 1)
                let up = lowestRiskNavigating(toRowIndex: rowIndex - 1, columnIndex: columnIndex)
                let lowestRiskRoute = minOptional(left, up) ?? 0

                memoize[rowIndex][columnIndex] = ints[rowIndex][columnIndex] + lowestRiskRoute
            }
        }

        return memoize.last!.last!
    }
}

private func minOptional<A>(_ a: A?, _ b: A?) -> A? where A: Comparable {
    if let a = a, let b = b {
        return min(a, b)
    } else {
        return a ?? b
    }
}
