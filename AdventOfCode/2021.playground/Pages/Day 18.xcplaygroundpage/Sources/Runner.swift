import Algorithms
import Collections
import Foundation

public enum Runner {
    public static func part1() -> Int {
        let fish = input.components(separatedBy: .newlines)
            .map { Snailfish(string: $0) }
        var current = fish[0]
        for addition in fish.dropFirst() {
            current = current + addition
        }

        return current.magnitude
    }

    public static func part2() -> Int {
        let fish = input.components(separatedBy: .newlines)
            .map { Snailfish(string: $0) }

        return fish.permutations(ofCount: 2)
            .map { $0[0].copy + $0[1].copy }
            .map(\.magnitude)
            .max()!
    }
}

private extension Snailfish {
    static func + (_ left: Snailfish, _ right: Snailfish) -> Snailfish {
        let new = Snailfish(left: .pointer(left), right: .pointer(right))
        left.parent = new
        right.parent = new
        new.reduce()
        return new
    }
}

private final class Snailfish {
    indirect enum Kind {
        case literal(Int)
        case pointer(Snailfish)

        var child: Snailfish? {
            guard case .pointer(let snailfish) = self else {
                return nil
            }

            return snailfish
        }

        var isLiteral: Bool {
            guard case .literal = self else {
                return false
            }

            return true
        }
    }

    private var id = UUID()

    weak var parent: Snailfish?

    var left: Kind
    var right: Kind

    init(left: Kind, right: Kind) {
        self.left = left
        self.right = right
    }

    func reduce() {
        evaluate: while true {
            for element in literalsOnlyTraversal {
                if element.explode() {
                    continue evaluate
                }
            }

            for element in hasAtLeastOneLiteralTraversal {
                if element.split() {
                    continue evaluate
                }
            }

            break
        }
    }

    private var depth: Int {
        guard let parent = parent else {
            return 0
        }

        return parent.depth + 1
    }

    private var root: Snailfish {
        guard let parent = parent else {
            return self
        }

        return parent.root
    }

    private func explode() -> Bool {
        guard depth >= 4 else {
            return false
        }

        guard let parent = parent,
              case .literal(let left) = left,
              case .literal(let right) = right else {
            return false
        }

        // explode to the left
        for (first, second) in root.hasAtLeastOneLiteralTraversal.adjacentPairs() {
            if second.id == id {
                if case .literal(let value) = first.right {
                    first.right = .literal(value + left)
                } else if case .literal(let value) = first.left {
                    first.left = .literal(value + left)
                }

                break
            }
        }

        // explode to the right
        for (first, second) in root.hasAtLeastOneLiteralTraversal.adjacentPairs() {
            if first.id == id {
                if case .literal(let value) = second.left {
                    second.left = .literal(value + right)
                } else if case .literal(let value) = second.right {
                    second.right = .literal(value + right)
                }

                break
            }
        }

        // collapse the original node into a 0
        let isLeftChild = parent.left.child?.id == id
        if isLeftChild {
            parent.left = .literal(0)
        } else {
            parent.right = .literal(0)
        }

        return true
    }

    private func split() -> Bool {
        if case .literal(let value) = left, value >= 10 {
            let child = Snailfish(left: .literal(value / 2), right: .literal((value + 1) / 2))
            child.parent = self
            left = .pointer(child)
            return true
        }

        if case .literal(let value) = right, value >= 10 {
            let child = Snailfish(left: .literal(value / 2), right: .literal((value + 1) / 2))
            child.parent = self
            right = .pointer(child)
            return true
        }

        return false
    }
}

extension Snailfish {
    var inOrderTraversal: [Snailfish] {
        func tree(for kind: Kind) -> [Snailfish] {
            guard case .pointer(let snailfish) = kind else {
                return []
            }

            return snailfish.inOrderTraversal
        }

        return tree(for: left) + [self] + tree(for: right)
    }

    var literalsOnlyTraversal: [Snailfish] {
        inOrderTraversal.lazy.filter { $0.left.isLiteral && $0.right.isLiteral }
    }

    var hasAtLeastOneLiteralTraversal: [Snailfish] {
        inOrderTraversal.lazy.filter { $0.left.isLiteral || $0.right.isLiteral }
    }
}

extension Snailfish: CustomStringConvertible {
    var description: String {
        "[\(left),\(right)]"
    }
}

extension Snailfish.Kind: CustomStringConvertible {
    var description: String {
        switch self {
        case .literal(let value):
            return value.description
        case .pointer(let snailfish):
            return snailfish.description
        }
    }
}

private extension Snailfish {
    var magnitude: Int {
        3 * left.magnitude + 2 * right.magnitude
    }
}

private extension Snailfish.Kind {
    var magnitude: Int {
        switch self {
        case .pointer(let fish):
            return fish.magnitude
        case .literal(let value):
            return value
        }
    }
}

private extension Snailfish {
    var copy: Snailfish {
        let copy = Snailfish(left: left.copy, right: right.copy)

        if case .pointer(let child) = copy.left {
            child.parent = copy
        }

        if case .pointer(let child) = copy.right {
            child.parent = copy
        }

        return copy
    }
}

private extension Snailfish.Kind {
    var copy: Self {
        switch self {
        case .literal:
            return self
        case .pointer(let child):
            return .pointer(child.copy)
        }
    }
}

private extension Snailfish {
    convenience init(string: String) {
        var copy = string
        self.init(string: &copy)
    }

    convenience init(string: inout String) {
        // remove opening bracket
        guard string.first == "[" else {
            fatalError("invalid format: \(string)")
        }
        string.removeFirst()

        let left = Kind(string: &string)

        // remove delimiter
        guard string.first == "," else {
            fatalError("invalid format: \(string)")
        }
        string.removeFirst()

        let right = Kind(string: &string)

        // remove closing bracket
        guard string.first == "]" else {
            fatalError("invalid format: \(string)")
        }
        string.removeFirst()

        self.init(left: left, right: right)

        if case .pointer(let child) = self.left {
            child.parent = self
        }

        if case .pointer(let child) = self.right {
            child.parent = self
        }
    }
}

private extension Snailfish.Kind {
    init(string: inout String) {
        if string.first == "[" {
            let next = Snailfish(string: &string)
            self = .pointer(next)
        } else {
            let intString = string.prefix(while: isNotDelimiter(in: [",", "]"]))
            string.removeFirst(intString.count)
            self = .literal(Int(intString)!)
        }
    }
}

private func isNotDelimiter(in set: Set<Character>) -> (Character) -> Bool {
    { !set.contains($0) }
}
