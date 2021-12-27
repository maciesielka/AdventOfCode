import Algorithms
import Foundation
import UIKit

public enum Runner {
    public static func part1() -> Int {
        let lines = input.components(separatedBy: .newlines)

        var rightFacing: [Point: Cucumber] = [:]
        var downFacing: [Point: Cucumber] = [:]
        for (rowIndex, line) in lines.enumerated() {
            for (columnIndex, character) in line.enumerated() {
                let position = Point(row: rowIndex, column: columnIndex)
                switch character {
                case ">":
                    let cucumber = Cucumber(position: position, direction: .right)
                    rightFacing[position] = cucumber
                case "v":
                    let cucumber = Cucumber(position: position, direction: .down)
                    downFacing[position] = cucumber
                default:
                    break
                }
            }
        }

        let size = Size(width: lines[0].count, height: lines.count)

        var currentStep = 0
        var patterns: [[Point: Cucumber]] = [rightFacing, downFacing]
        var previous = patterns

        repeat {
            currentStep += 1
            previous = patterns

            for (index, pattern) in previous.enumerated() {
                var next: [Point: Cucumber] = [:]
                for (point, cucumber) in pattern {
                    let nextLocation = point.advanced(in: cucumber.direction, size: size)
                    if patterns.allSatisfy({ $0[nextLocation] == nil }) {
                        next[nextLocation] = cucumber
                    } else {
                        next[point] = cucumber
                    }
                }
                patterns[index] = next
            }
        } while previous != patterns

        return currentStep
    }
}

private func printState(_ state: [[Point: Cucumber]], in size: Size) {
    for row in 0..<size.height {
        var string = ""
        for column in 0..<size.width {
            let position = Point(row: row, column: column)

            if let occupied = state.firstNonNil({ $0[position] }) {
                string += occupied.direction == .right ? ">" : "v"
            } else {
                string += "."
            }
        }
        print(string)
    }
}

private enum Direction {
    case right
    case down
}

private struct Point: Hashable {
    var row: Int
    var column: Int

    func advanced(in direction: Direction, size: Size) -> Point {
        switch direction {
        case .right:
            return Point(
                row: row,
                column: (column + 1) % size.width
            )
        case .down:
            return Point(
                row: (row + 1) % size.height,
                column: column
            )
        }
    }
}

private struct Size {
    var width: Int
    var height: Int
}

private struct Cucumber: Equatable {
    var position: Point
    var direction: Direction
}
