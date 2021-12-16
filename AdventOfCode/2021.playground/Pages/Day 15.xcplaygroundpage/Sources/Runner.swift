import Foundation
import Collections
import PriorityQueueModule

public enum Runner {
    public static func part1() -> Int {
        let ints = input.components(separatedBy: .newlines)
            .map { $0.compactMap { $0.wholeNumberValue } }
        return shortestPath(through: ints)
    }

    public static func part2() -> Int {
        let ints = input.components(separatedBy: .newlines)
            .map { $0.compactMap { $0.wholeNumberValue } }

        let dimension = 5

        var enlargedInts: [[Int]] = []
        for row in 0..<ints.indices.count * dimension {
            let normalizedRowIndex = row % ints.indices.count
            let rowOffset = row / ints.indices.count
            let numColumns = ints[normalizedRowIndex].indices.count
            var row: [Int] = []
            for column in 0..<numColumns * dimension {
                let normalizedColumnIndex = column % numColumns
                let columnOffset = column / numColumns

                var updatedValue = ints[normalizedRowIndex][normalizedColumnIndex] + rowOffset + columnOffset
                if updatedValue >= 10 {
                    updatedValue += 1
                }
                let wrappedValue = updatedValue % 10
                row.append(wrappedValue)
            }
            enlargedInts.append(row)
        }

        return shortestPath(through: enlargedInts)
    }
}

/// See https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
func shortestPath(through ints: [[Int]]) -> Int {
    func neighbors(for node: Node) -> [Node] {
        var result: [Node] = []

        if node.row - 1 > 0 {
            let up = Node(row: node.row - 1, column: node.column)
            result.append(up)
        }

        if node.row + 1 < ints.count {
            let down = Node(row: node.row + 1, column: node.column)
            result.append(down)
        }

        if node.column - 1 > 0 {
            let left = Node(row: node.row, column: node.column - 1)
            result.append(left)
        }

        if node.column + 1 < ints[node.row].count {
            let right = Node(row: node.row, column: node.column + 1)
            result.append(right)
        }

        return result
    }

    var distanceFromSource: [Node: Int] = [:]
    for rowIndex in ints.indices {
        for columnIndex in ints[rowIndex].indices {
            let node = Node(row: rowIndex, column: columnIndex)
            distanceFromSource[node] = Int.max
        }
    }

    var queue: Heap<NodeWithDistance> = []

    let source = Node(row: 0, column: 0)
    distanceFromSource[source] = 0
    queue.insert(source.withDistance(0))

    let target = Node(row: ints.count - 1, column: ints[0].count - 1)

    var pathCache: [Node: Node] = [:]
    while let visit = queue.popMin() {
        guard visit.distanceFromSource == distanceFromSource[visit.node] else {
            continue
        }

        for neighbor in neighbors(for: visit.node) {
            let path = distanceFromSource[visit.node]! + ints[neighbor.row][neighbor.column]
            if path < distanceFromSource[neighbor]! {
                distanceFromSource[neighbor] = path
                pathCache[neighbor] = visit.node

                queue.insert(neighbor.withDistance(path))
            }
        }
    }

    var path: Deque<Node> = [target]
    var pointer = target
    while pointer != source, let next = pathCache[pointer] {
        path.prepend(next)
        pointer = next
    }

    return path
        .dropFirst()
        .map { ints[$0.row][$0.column] }
        .reduce(0, +)
}

private func minOptional<A>(_ a: A?, _ b: A?) -> A? where A: Comparable {
    if let a = a, let b = b {
        return min(a, b)
    } else {
        return a ?? b
    }
}

private struct Node: Hashable {
    var row: Int
    var column: Int
}

extension Node {
    func withDistance(_ distance: Int) -> NodeWithDistance {
        .init(node: self, distanceFromSource: distance)
    }
}

private struct NodeWithDistance: Equatable, Comparable {
    var node: Node
    var distanceFromSource: Int

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.distanceFromSource < rhs.distanceFromSource
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.node == rhs.node
    }
}
