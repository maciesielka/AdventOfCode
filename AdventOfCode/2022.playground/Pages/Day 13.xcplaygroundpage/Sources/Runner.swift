import Foundation

public enum Runner {
    public static func part1() -> Int {
        let pairs = input
            .components(separatedBy: "\n\n")
            .map { pair in
                pair
                    .components(separatedBy: "\n")
                    .map(Packet.init(string:))
            }

        let results = pairs.enumerated()
            .filter { $0.element[0] < $0.element[1] }
            .map { $0.offset + 1 }

        return results.reduce(0, +)
    }

    public static func part2() -> Int {
        var allPackets = input
            .components(separatedBy: "\n\n")
            .flatMap { pair in
                pair
                    .components(separatedBy: "\n")
                    .map(Packet.init(string:))
            }

        allPackets.append("[[2]]")
        allPackets.append("[[6]]")

        allPackets.sort()

        return (allPackets.firstIndex(of: "[[2]]")! + 1) * (allPackets.firstIndex(of: "[[6]]")! + 1)
    }
}

enum Packet {
    case int(Int)
    indirect case array([Packet])

    init(string: String) {
        var copy = string
        self.init(string: &copy)
    }

    private init(string: inout String) {
        let next = string.removeFirst()
        switch next {
        case "[":
            var array: [Packet] = []
            while let first = string.first, first != "]" {
                let next = Packet(string: &string)
                array.append(next)

                if string.first == "," {
                    string.removeFirst()
                }
            }

            // remove trailing "]"
            string.removeFirst()
            self = .array(array)

        default:
            var temp = String(next)
            done: while let next = string.first {
                switch next {
                case ",", "]":
                    break done

                default:
                    string.removeFirst()
                    temp += String(next)
                }
            }

            let int = Int(temp)!
            self = .int(int)
        }
    }
}

extension Packet: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(string: value)
    }
}

extension Packet: CustomStringConvertible {
    var description: String {
        switch self {
        case .int(let int):
            return "\(int)"

        case .array(let array):
            return "[\(array.map(\.description).joined(separator: ", "))]"
        }
    }
}

extension Packet: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.array, .int(let int)):
            return lhs < .array([.int(int)])

        case (.int(let int), .array):
            return .array([.int(int)]) < rhs

        case (.int(let lhs), .int(let rhs)):
            return lhs < rhs

        case (.array(let lhs), .array(let rhs)):
            for (lhs, rhs) in zip(lhs, rhs) {
                if lhs < rhs {
                    return true
                } else if lhs > rhs {
                    return false
                }
            }

            return lhs.count < rhs.count
        }
    }
}
