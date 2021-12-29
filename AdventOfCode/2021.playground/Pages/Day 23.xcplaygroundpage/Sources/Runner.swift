import Algorithms
import Foundation
import PriorityQueueModule
import UIKit

public enum Runner {
    public static func part1() -> Int {
        let initial = input.components(separatedBy: .newlines)
            .dropFirst(2)
            .dropLast()
            .map { $0.compactMap { Aisle(rawValue: String($0)) } }
            .reversed()

        var burrow = Burrow(aisleDepth: 2)
        for line in initial {
            for (destination, aisle) in zip(Aisle.allCases, line) {
                let amphipod = Amphipod(aisle: aisle, initialAisle: destination)
                burrow.insert(amphipod, into: destination)
            }
        }

        let solver = BurrowSolver(initial: burrow)
        if let solution = solver.organize() {
            solution.print(startingAt: burrow)
            return solution.cost
        }

        return 0
    }

    public static func part2() -> Int {
        var initial = Array(
            input.components(separatedBy: .newlines)
                .dropFirst(2)
                .dropLast()
                .map { $0.compactMap { Aisle(rawValue: String($0)) } }
                .reversed()
        )

        initial.insert(contentsOf: [
            [.desert, .bronze, .amber, .copper],
            [.desert, .copper, .bronze, .amber],
        ], at: 1)

        var burrow = Burrow(aisleDepth: 4)
        for line in initial {
            for (destination, aisle) in zip(Aisle.allCases, line) {
                let amphipod = Amphipod(aisle: aisle, initialAisle: destination)
                burrow.insert(amphipod, into: destination)
            }
        }

        let solver = BurrowSolver(initial: burrow)
        if let solution = solver.organize() {
            solution.print(startingAt: burrow)
            return solution.cost
        }

        return 0
    }
}

private enum Aisle: String, CaseIterable {
    case amber = "A"
    case bronze = "B"
    case copper = "C"
    case desert = "D"

    var costPerMove: Int {
        switch self {
        case .amber:
            return 1
        case .bronze:
            return 10
        case .copper:
            return 100
        case .desert:
            return 1000
        }
    }
}

private final class BurrowSolver {
    struct Solution: Comparable {
        var burrow: Burrow
        var cost = 0
        var numberOfOrganizedAisles: Int
        var moves: [Burrow.Move] = []

        init(burrow: Burrow, cost: Int = 0, moves: [Burrow.Move] = []) {
            self.burrow = burrow
            self.cost = cost
            self.numberOfOrganizedAisles = Aisle.allCases.filter(burrow.isOrganized(in:)).count
            self.moves = moves
        }

        static func < (lhs: Solution, rhs: Solution) -> Bool {
            (lhs.cost, rhs.moves.count)
            <
            (rhs.cost, lhs.moves.count)
        }

        func print(startingAt burrow: Burrow) {
            var copy = burrow
            for move in moves {
                let (next, cost) = copy.performingMove(move)
                Swift.print("cost: \(cost)")
                copy = next
                copy.debug()
                Swift.print("---")
            }
        }
    }

    var initial: Burrow

    init(initial: Burrow) {
        self.initial = initial
    }

    func organize() -> Solution? {
        var queue = Heap<Solution>()

        let initial = Solution(burrow: initial)
        queue.insert(initial)

        var solutions = Heap<Solution>()

        var lowestCostToBurrow: [Burrow: Int] = [:]
        lowestCostToBurrow[initial.burrow] = 0

        while let visit = queue.popMin() {
            guard visit.cost == lowestCostToBurrow[visit.burrow] else {
                continue
            }

            if let existingSolution = solutions.min(),
               existingSolution.cost < visit.cost {
                break
            }

            if visit.burrow.isOrganized {
                solutions.insert(visit)
                continue
            }

            for move in visit.burrow.acceptableMoves {
                let (new, cost) = visit.burrow.performingMove(move)
                let costToNeighbor = lowestCostToBurrow[visit.burrow]! + cost
                let existing = lowestCostToBurrow[new] ?? Int.max
                if costToNeighbor < existing {
                    lowestCostToBurrow[new] = costToNeighbor

                    let solution = Solution(burrow: new, cost: costToNeighbor, moves: visit.moves + [move])
                    queue.insert(solution)
                }
            }
        }

        return solutions.min()
    }
}

private struct Burrow {
    enum State: Hashable {
        case unoccupied
        case entryWay
        case unoccupiedAisle(Aisle)
        case amphipod(Amphipod)

        func isAvailableDestination(for amphipod: Amphipod) -> Bool {
            switch self {
            case .unoccupied:
                return true
            case .unoccupiedAisle(amphipod.aisle):
                return true
            default:
                return false
            }
        }
    }

    private let aisleByIndex: [Int: Aisle] = {
        var result: [Int: Aisle] = [:]
        for (index, aisle) in Aisle.allCases.enumerated() {
            result[index] = aisle
        }
        return result
    }()
    private let aisleIndexByAisle: [Aisle: Int] = {
        var result: [Aisle: Int] = [:]
        for (index, aisle) in Aisle.allCases.enumerated() {
            result[aisle] = index
        }
        return result
    }()
    private func xCoordinate(for aisle: Aisle) -> Int {
        return hallwayCapLength + 2 * aisleIndexByAisle[aisle]!
    }
    private func aisle(forX x: Int) -> Aisle? {
        return aisleByIndex[(x - hallwayCapLength) / 2]
    }

    private let aisleDepth: Int
    private let hallwayCapLength = 2

    let bounds: Bounds
    var state: [Point: State] = [:]

    init(aisleDepth: Int) {
        self.aisleDepth = aisleDepth
        self.bounds = .init(
            x: 0...(hallwayCapLength * 2 + Aisle.allCases.count * 2),
            y: 0...aisleDepth
        )

        // construct the area to the left of the hallway
        for x in 0..<hallwayCapLength {
            let point = Point.hallway(x: x)
            state[point] = .unoccupied
        }

        // construct the hallway
        for x in 0..<Aisle.allCases.count - 1 {
            let point = Point.hallway(x: 2 * x + hallwayCapLength + 1)
            state[point] = .unoccupied
        }

        // construct area to the right of the hallway
        let hallwayInteriorLength = Aisle.allCases.count * 2 - 1
        for x in 0..<hallwayCapLength {
            let point = Point.hallway(x: x + hallwayInteriorLength + hallwayCapLength)
            state[point] = .unoccupied
        }

        // construct aisles
        for aisle in Aisle.allCases {
            let x = xCoordinate(for: aisle)
            let point = Point(x: x, y: 0)
            state[point] = .entryWay

            for y in 0..<aisleDepth {
                let point = Point(x: x, y: y + 1)
                state[point] = .unoccupiedAisle(aisle)
            }
        }
    }

    func isPointInHallway(_ point: Point) -> Bool {
        point.y == 0
    }

    @discardableResult
    mutating func insert(_ amphipod: Amphipod, into aisle: Aisle) -> Bool {
        let x = xCoordinate(for: aisle)
        var y = aisleDepth
        while y > 0 {
            let point = Point(x: x, y: y)
            if case .unoccupiedAisle(aisle) = state[point] {
                state[point] = .amphipod(amphipod)
                return true
            }

             y -= 1
        }

        return false
    }

    struct Move: Equatable, CustomStringConvertible {
        var from: Point
        var to: Point

        var distance: Int {
            // moves from aisle to aisle can't use basic manhattan distance
            if from.y > 0 && to.y > 0 && from.x != to.x {
                let midPoint = Point(x: from.x, y: 0)
                return Move(from: from, to: midPoint).distance + Move(from: midPoint, to: to).distance
            } else {
                return abs(from.x - to.x) + abs(from.y - to.y)
            }
        }

        var description: String {
            "from: \(from), to: \(to)"
        }
    }

    var acceptableMoves: [Move] {
        acceptableMoves(debug: false)
    }

    func acceptableMoves(debug: Bool = false) -> [Move] {
        if isOrganized {
            return []
        }

        var moves: [Move] = []
        for (point, state) in state {
            if case .amphipod(let amphipod) = state {
                let eligibleDestinations = amphipod.eligibleDestinations(in: self, from: point)
                moves.append(contentsOf: eligibleDestinations.map { destination in
                    .init(from: point, to: destination)
                })
            }
        }

        if debug {
            for move in moves {
                print("from \(move.from)", "to \(move.to)")
            }
        }

        return moves
    }

    func performingMove(_ move: Move) -> (burrow: Burrow, cost: Int) {
        var copy = self

        copy.state[move.to] = copy.state[move.from]

        var cost = 0
        if case .amphipod(var amphipod) = copy.state[move.to] {
            amphipod.mustMoveToAisle = true
            amphipod.moveCount += 1
            copy.state[move.to] = .amphipod(amphipod)

            cost = move.distance * amphipod.aisle.costPerMove
        }

        if isPointInHallway(move.from) {
            copy.state[move.from] = .unoccupied
        } else {
            let aisle = aisle(forX: move.from.x)!
            copy.state[move.from] = .unoccupiedAisle(aisle)
        }

        return (burrow: copy, cost: cost)
    }

    var isOrganized: Bool {
        return Aisle.allCases.allSatisfy(isOrganized(in:))
    }

    func isOrganized(in aisle: Aisle) -> Bool {
        states(in: aisle).allSatisfy { _, state in
            guard case .amphipod(let amphipod) = state,
                    amphipod.aisle == aisle else {
                return false
            }

            return true
        }
    }

    func states(in aisle: Aisle) -> [(Point, State)] {
        var states: [(Point, State)] = []
        let x = xCoordinate(for: aisle)
        for y in 0..<aisleDepth {
            let point = Point(x: x, y: y + 1)
            states.append((point, state[point]!))
        }
        return states
    }

    func isPoint(_ point: Point, in aisle: Aisle) -> Bool {
        xCoordinate(for: aisle) == point.x
    }

    func debug(includeMoves: Bool = false) {
        let maxX = state.keys.map(\.x).max()!
        let maxY = state.keys.map(\.y).max()!

        for y in 0...maxY {
            var string = ""
            for x in 0...maxX {
                let point = Point(x: x, y: y)
                if let occupant = state[point] {
                    switch occupant {
                    case .amphipod(let amphipod):
                        string += "\(amphipod.aisle.rawValue)-\(amphipod.moveCount)"
                    default:
                        string += " . "
                    }
                } else {
                    string += "   "
                }
            }
            print(string)
        }

        if includeMoves {
            for move in acceptableMoves {
                print("from", move.from, "to", move.to)
            }
        }
    }
}

extension Burrow: Equatable {
    static func == (lhs: Burrow, rhs: Burrow) -> Bool {
        lhs.state == rhs.state
    }
}

extension Burrow: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(state)
    }
}

private enum Direction: Hashable {
    case north
    case east
    case west
    case south

    static let all: Set<Direction> = [.north, .east, .south, .west]

    var opposite: Direction {
        switch self {
        case .north:
            return .south
        case .east:
            return .west
        case .west:
            return .east
        case .south:
            return .north
        }
    }
}

private struct Amphipod: Hashable {
    var aisle: Aisle
    let initialAisle: Aisle
    var mustMoveToAisle = false
    var moveCount = 0
    var uuid = UUID()

    func eligibleDestinations(
        in burrow: Burrow,
        from source: Point,
        in directions: Set<Direction> = Direction.all
    ) -> [Point] {
        guard moveCount < 2 else {
            return []
        }

        if isPositioned(in: burrow, at: source) {
            return []
        }

        let neighbors = source.neighbors(in: burrow.bounds, in: directions)

        var results: [Point] = []
        for (neighbor, direction) in neighbors {
            switch burrow.state[neighbor] {
            case .unoccupied where !mustMoveToAisle:
                let new = [neighbor] + eligibleDestinations(
                    in: burrow,
                    from: neighbor,
                    in: Direction.all.subtracting([direction.opposite])
                )
                results.append(contentsOf: new)

            case .unoccupiedAisle(initialAisle) where moveCount == 0:
                return eligibleDestinations(
                    in: burrow,
                    from: neighbor,
                    in: Direction.all.subtracting([direction.opposite])
                )

            case .unoccupiedAisle(aisle):
                let states = burrow.states(in: aisle)
                let canMoveIntoAisle = states.map(\.1).allSatisfy {
                    switch $0 {
                    case .amphipod(let amphipod) where amphipod.aisle == aisle:
                        return true
                    case .unoccupiedAisle(aisle):
                        return true
                    default:
                        return false
                    }
                }

                if canMoveIntoAisle {
                    return states.reversed()
                        .firstNonNil { point, state -> Point? in
                            if case .unoccupiedAisle(aisle) = state {
                                return point
                            }

                            return nil
                        }
                        .map { [$0] } ?? []
                } else {
                    return []
                }

            case .unoccupiedAisle, .amphipod, nil:
                continue

            case .entryWay, .unoccupied:
                let new = eligibleDestinations(
                    in: burrow,
                    from: neighbor,
                    in: Direction.all.subtracting([direction.opposite])
                )
                results.append(contentsOf: new)
            }
        }
        return results
    }

    func isPositioned(in burrow: Burrow, at point: Point) -> Bool {
        guard burrow.isPoint(point, in: aisle) else {
            return false
        }

        return burrow.states(in: aisle).dropFirst(point.y).allSatisfy { _, state in
            switch state {
            case .amphipod(let amphipod) where amphipod.aisle == aisle:
                return true
            default:
                return false
            }
        }
    }
}

private struct Bounds {
    var x: ClosedRange<Int>
    var y: ClosedRange<Int>
}

private struct Point: Hashable {
    var x: Int
    var y: Int

    func neighbors(in bounds: Bounds, in directions: Set<Direction>) -> [(Point, Direction)] {
        directions
            .map(advanced)
            .filter { bounds.x.contains($0.0.x) && bounds.y.contains($0.0.y) }
    }

    private func advanced(in direction: Direction) -> (Point, Direction) {
        let point: Point
        switch direction {
        case .north:
            point = Point(x: x, y: y - 1)
        case .east:
            point = Point(x: x - 1, y: y)
        case .west:
            point = Point(x: x + 1, y: y)
        case .south:
            point = Point(x: x, y: y + 1)
        }
        return (point, direction)
    }
}

extension Point {
    static func hallway(x: Int) -> Point {
        return .init(x: x, y: 0)
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

private extension Collection where Element: Equatable {
    func hasPrefix<C>(_ other: C) -> Bool where C: Collection, C.Element == Element {
        guard count >= other.count else {
            return false
        }
        return zip(other, self).allSatisfy { $0 == $1 }
    }
}
