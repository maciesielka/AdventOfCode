import Foundation

public enum Runner {
    public static func part1() -> Int {
        return getSuccessfulLaunches()
            .map { _, arc -> Int in
                arc.map { $0.y }.max()!
            }
            .max()!
    }

    public static func part2() -> Int {
        return getSuccessfulLaunches().count
    }
}

private func getSuccessfulLaunches() -> [(initialVelocity: Vector, arc: [Point])] {
    var components = input.components(separatedBy: ":")
        .map { $0.trimmingCharacters(in: .whitespaces) }
    components = components[1].components(separatedBy: ",")
        .map { $0.trimmingCharacters(in: .whitespaces) }
    let bounds = components.map { string -> ClosedRange<Int> in
        let ints = string.dropFirst(2).components(separatedBy: "..")
            .map { Int($0)! }
        return ints[0]...ints[1]
    }
    let (xBounds, yBounds) = (bounds[0], bounds[1])

    var successfulLaunches: [(Vector, [Point])] = []
    for dx in 1...xBounds.upperBound {
        // this isn't the smartest way to do this, but the input is small enough
        // that we can brute force this
        for dy in yBounds.lowerBound...max(yBounds.upperBound, xBounds.upperBound*50) {
            let initialVelocity = Vector(dx: dx, dy: dy)
            var projectile = Projectile(velocity: initialVelocity)

            while true {
                projectile.move()

                // if the projectile is in the target area,
                // we can stop
                if xBounds.contains(projectile.position.x),
                   yBounds.contains(projectile.position.y) {
                    successfulLaunches.append((initialVelocity, projectile.arc))
                    break
                }

                // the projectile doesn't move backwards,
                // so once we're past the right end of the
                // target area, this initial velocity is invalid
                if projectile.position.x > xBounds.upperBound {
                    break
                }

                // if the projectile is moving downwards and is past
                // the bottom of the target area, this initial velocity is invalid
                if projectile.position.y < yBounds.lowerBound,
                   projectile.velocity.slope < 1 {
                    break
                }
            }
        }
    }
    return successfulLaunches
}

private struct Point {
    var x: Int
    var y: Int
}

extension Point {
    static let origin = Point(x: 0, y: 0)
}

private struct Vector {
    var dx: Int
    var dy: Int

    var slope: Double {
        Double(dy) / Double(dx)
    }
}

private struct Projectile {
    private(set) var arc: [Point] = [Point.origin]
    private(set) var position = Point.origin
    private(set) var velocity: Vector

    mutating func move() {
        position.x += velocity.dx
        position.y += velocity.dy
        arc.append(position)

        velocity.dx = max(velocity.dx - 1, 0)
        velocity.dy -= 1
    }
}
