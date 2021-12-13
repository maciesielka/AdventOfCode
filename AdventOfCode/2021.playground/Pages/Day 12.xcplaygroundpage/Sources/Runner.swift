import Foundation
import Collections

public enum Runner {
    public static func part1() -> Int {
        let caves = input.components(separatedBy: .newlines)
            .map { string -> (from: Cave, to: Cave) in
                let caves = string
                    .components(separatedBy: "-")
                    .map(Cave.init)
                return (from: caves[0], to: caves[1])
            }

        var graph: [Cave: [Cave]] = [:]
        for (from, to) in caves {
            graph[from, default: []].append(to)
            graph[to, default: []].append(from)
        }

        var completed: [Path] = []

        var queue: Deque<Path> = []
        queue.append(.init(startingAt: .start, graph: graph))


        while let visit = queue.popFirst() {
            if visit.current == .end {
                completed.append(visit)
                continue
            }

            for neighbor in visit.neighbors {
                var copy = visit
                copy.visit(neighbor)
                queue.append(copy)
            }
        }

        return completed.count
    }

    public static func part2() -> Int {
        let caves = input.components(separatedBy: .newlines)
            .map { string -> (from: Cave, to: Cave) in
                let caves = string
                    .components(separatedBy: "-")
                    .map(Cave.init)
                return (from: caves[0], to: caves[1])
            }

        var graph: [Cave: [Cave]] = [:]
        for (from, to) in caves {
            graph[from, default: []].append(to)
            graph[to, default: []].append(from)
        }

        var completed: [Path] = []

        var queue: Deque<Path> = []
        queue.append(.init(startingAt: .start, graph: graph, smallCaveVisitThreshold: 2))

        while let visit = queue.popFirst() {
            if visit.current == .end {
                completed.append(visit)
                continue
            }

            for neighbor in visit.neighbors {
                var copy = visit
                copy.visit(neighbor)
                queue.append(copy)
            }
        }

        return completed.count
    }
}

private struct Path {
    private var hasVisitedOneSmallCaveTwice = false
    private var smallCaveVisitThreshold = 1
    private var visitFrequency: [Cave: Int] = [:]

    var caves: [Cave]
    var remaining: [Cave: [Cave]]

    var current: Cave {
        caves.last!
    }

    var neighbors: [Cave] {
        let neighbors = caves.last
            .flatMap { remaining[$0] } ?? []
        return neighbors.filter { cave in
            if cave.isSmallCave {
                return visitFrequency[cave, default: 0] < smallCaveVisitThreshold
            } else {
                return true
            }
        }
    }

    init(startingAt cave: Cave, graph: [Cave: [Cave]], smallCaveVisitThreshold: Int = 1) {
        caves = [cave]
        remaining = graph
        self.smallCaveVisitThreshold = smallCaveVisitThreshold

        for (key, var value) in remaining {
            value.removeAll { $0 == cave }
            remaining[key] = value
        }
    }

    mutating func visit(_ cave: Cave) {
        caves.append(cave)
        visitFrequency[cave, default: 0] += 1

        if cave.isSmallCave,
            smallCaveVisitThreshold > 1,
            visitFrequency[cave] == 2 {
            smallCaveVisitThreshold = 1
        }
    }
}

private struct Cave: Hashable {
    var name: String

    var isBigCave: Bool {
        CharacterSet.uppercaseLetters.contains(name.unicodeScalars.first!)
    }

    var isSmallCave: Bool {
        self != .start &&
            self != .end &&
            CharacterSet.lowercaseLetters.contains(name.unicodeScalars.first!)
    }
}

extension Cave: CustomStringConvertible {
    var description: String { name }
}

extension Cave {
    static let start = Cave(name: "start")
    static let end = Cave(name: "end")
}
