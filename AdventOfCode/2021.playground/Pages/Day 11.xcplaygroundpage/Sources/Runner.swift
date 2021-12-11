import Foundation

public enum Runner {
    public static func part1() -> Int {
        let ints = input.components(separatedBy: .newlines)
            .map { $0.compactMap { $0.wholeNumberValue } }

        var state = ints
        var numberOfFlashes = 0
        
        let numberOfSteps = 100

        for _ in 1...numberOfSteps {
            let (next, numberOfFlashesInStep) = nextStep(from: state)
            state = next
            numberOfFlashes += numberOfFlashesInStep
        }

        return numberOfFlashes
    }

    public static func part2() -> Int {
        let ints = input.components(separatedBy: .newlines)
            .map { $0.compactMap { $0.wholeNumberValue } }

        var state = ints
        var turn = 0
        var numberOfFlashes = 0

        let size = ints.count * ints[0].count
        while numberOfFlashes != size {
            let (next, numberOfFlashesInStep) = nextStep(from: state)

            numberOfFlashes = numberOfFlashesInStep
            turn += 1
            state = next
        }

        return turn
    }
}

private struct Size: Hashable {
    var width: Int
    var height: Int
}

private struct Point: Hashable {
    var x: Int
    var y: Int

    func adjacents(in bounds: Size) -> [Point] {
        var result: [Point] = []
        for x in (self.x - 1)...(self.x + 1) where x >= 0 && x < bounds.width {
            for y in (self.y - 1)...(self.y + 1) where y >= 0 && y < bounds.height {
                if x != self.x || y != self.y {
                    let point = Point(x: x, y: y)
                    result.append(point)
                }
            }
        }
        return result
    }
}

private func nextStep(from state: [[Int]]) -> (state: [[Int]], numberOfFlashes: Int) {
    var next = state
    var flashed: Set<Point> = []
    var numberOfFlashes = 0

    for y in state.indices {
        for x in state[y].indices {
            next[y][x] += 1

            if next[y][x] > 9 {
                let point = Point(x: x, y: y)
                flashed.insert(point)
            }
        }
    }

    var traversal = Array(flashed)

    while let pointToFlash = traversal.popLast() {
        let size = Size(
            width: state[pointToFlash.y].indices.count,
            height: state.indices.count
        )

        let adjacents = pointToFlash.adjacents(in: size)
        for adjacent in adjacents {
            next[adjacent.y][adjacent.x] += 1

            if next[adjacent.y][adjacent.x] > 9,
                !flashed.contains(adjacent) {
                flashed.insert(adjacent)
                traversal.append(adjacent)
            }
        }
    }

    for y in state.indices {
        for x in state[y].indices where next[y][x] > 9 {
            numberOfFlashes += 1

            next[y][x] = 0
        }
    }

    return (state: next, numberOfFlashes: numberOfFlashes)
}
