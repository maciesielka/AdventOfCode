import Foundation

public enum Runner {
    public static func part1() -> Int {
        let commands = input.components(separatedBy: .newlines)
            .compactMap { Command(string: $0, bounds: -50...50) }

        return generateEnabledCuboids(from: commands)
            .map(\.volume)
            .reduce(0, +)
    }

    public static func part2() -> Int {
        let commands = input.components(separatedBy: .newlines)
            .compactMap { Command(string: $0) }

        return generateEnabledCuboids(from: commands)
            .map(\.volume)
            .reduce(0, +)
    }
}

private func generateEnabledCuboids(from commands: [Command]) -> Set<Cuboid> {
    var enabledCuboids: Set<Cuboid> = []

    for command in commands {
        for enabledCuboid in enabledCuboids {
            // if the cuboid in the command intersects with an existing enabled cuboid
            if let intersection = enabledCuboid.intersecting(with: command.cuboid) {

                // replace the cuboid with a subset of cuboids that represent the same
                // set with the intersection removed
                enabledCuboids.remove(enabledCuboid)

                for stillEnabled in enabledCuboid.removing(intersection) {
                    enabledCuboids.insert(stillEnabled)
                }
            }
        }

        // if the command specifies enabling this set, just add it, since no overlap
        // should exist any longer
        if command.kind == .on {
            enabledCuboids.insert(command.cuboid)
        }
    }

    return enabledCuboids
}

private struct Cuboid: Hashable {
    var x: ClosedRange<Int>
    var y: ClosedRange<Int>
    var z: ClosedRange<Int>

    var volume: Int {
        x.count * y.count * z.count
    }

    func intersecting(with other: Cuboid) -> Cuboid? {
        guard x.overlaps(other.x), y.overlaps(other.y), z.overlaps(other.z) else {
            return nil
        }

        return .init(
            x: x.intersecting(with: other.x),
            y: y.intersecting(with: other.y),
            z: z.intersecting(with: other.z)
        )
    }

    private var isEmpty: Bool { x.isEmpty || y.isEmpty || z.isEmpty }

    private func contains(_ other: Cuboid) -> Bool {
        x.contains(other.x) && y.contains(other.y) && z.contains(other.z)
    }

    /// - Returns: the cuboids that remain after removing the argument
    func removing(_ removal: Cuboid) -> [Cuboid] {
        func pieces(by selector: (Cuboid) -> ClosedRange<Int>) -> [ClosedRange<Int>] {
            let this = selector(self)
            let other = selector(removal)

            var result: [ClosedRange<Int>] = []
            if this.lowerBound <= other.lowerBound - 1 {
                result.append(this.lowerBound...(other.lowerBound - 1))
            }

            result.append(other)

            if other.upperBound + 1 <= this.upperBound {
                result.append((other.upperBound + 1)...this.upperBound)
            }

            return result
        }

        let xs = pieces { $0.x }
        let ys = pieces { $0.y }
        let zs = pieces { $0.z }

        return xs
            .flatMap { x in
                ys.flatMap { y in
                    zs.map { z in
                        Cuboid(x: x, y: y, z: z)
                    }
                }
            }
            .filter { !$0.isEmpty && !removal.contains($0) }
    }
}

private extension ClosedRange {
    func intersecting(with other: ClosedRange) -> ClosedRange {
        Swift.max(lowerBound, other.lowerBound)...Swift.min(upperBound, other.upperBound)
    }

    func contains(_ other: ClosedRange) -> Bool {
        lowerBound <= other.lowerBound && other.upperBound <= upperBound
    }
}

private struct Command {
    enum Kind: String {
        case on
        case off
    }

    var kind: Kind

    var cuboid: Cuboid

    init(string: String) {
        let components = string.components(separatedBy: " ")
        kind = Kind(rawValue: components[0])!

        let ranges = components[1].components(separatedBy: ",")
            .map { string -> ClosedRange<Int> in
                let ints = string.components(separatedBy: "=")[1]
                    .components(separatedBy: "..")
                    .compactMap(Int.init)
                return (ints[0]...ints[1])
            }

        self.cuboid = .init(x: ranges[0], y: ranges[1], z: ranges[2])
    }

    init?(string: String, bounds: ClosedRange<Int>) {
        self.init(string: string)

        let ranges = [cuboid.x, cuboid.y, cuboid.z]
        let clamped = ranges.map { $0.clamped(to: bounds) }
        if clamped != ranges {
            return nil
        }

        self.cuboid.x = ranges[0]
        self.cuboid.y = ranges[1]
        self.cuboid.z = ranges[2]
    }
}
