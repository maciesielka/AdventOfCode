import Foundation
import Collections

public enum Runner {
    private static var packets: [Packet] {
        var binary = input
            .map(String.init)
            .compactMap {
                Int($0, radix: 16)
            }
            .compactMap {
                String($0, radix: 2)
            }
            .map {
                pad(string: $0, toSize: 4)
            }
            .flatMap { $0 }
            .map(String.init)

        var packets: [Packet] = []
        while !binary.isEmpty,
              let packet = parsePacket(from: &binary) {
            packets.append(packet)
        }
        return packets
    }

    public static func part1() -> Int {
        return packets.map(\.totalPacketVersion).reduce(0, +)
    }

    public static func part2() -> Int {
        return packets.map(\.evaluatedValue).reduce(0, +)
    }
}

private struct Packet {
    var version: Int
    var kind: Kind
    var type: PacketType

    enum Kind {
        case literal(Int)
        case `operator`([Packet])
    }

    var totalPacketVersion: Int {
        switch kind {
        case .literal:
            return version
        case .operator(let packets):
            return version + packets.map(\.totalPacketVersion).reduce(0, +)
        }
    }

    var evaluatedValue: Int {
        switch kind {
        case .literal(let value):
            return value

        case .operator(let packets):
            return type.evaluator(packets)
        }
    }
}

private enum PacketType {
    case sum
    case product
    case literal
    case minimum
    case maximum
    case greaterThan
    case lessThan
    case equalTo

    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .sum
        case 1:
            self = .product
        case 2:
            self = .minimum
        case 3:
            self = .maximum
        case 4:
            self = .literal
        case 5:
            self = .greaterThan
        case 6:
            self = .lessThan
        case 7:
            self = .equalTo
        default:
            fatalError("unimplemented")
        }
    }

    var isOperator: Bool {
        self != .literal
    }

    var evaluator: ([Packet]) -> Int {
        return { packets in
            switch self {
            case .sum:
                return packets.map(\.evaluatedValue).reduce(0, +)
            case .product:
                return packets.map(\.evaluatedValue).reduce(1, *)
            case .minimum:
                return packets.map(\.evaluatedValue).min()!
            case .maximum:
                return packets.map(\.evaluatedValue).max()!
            case .literal:
                return packets.map(\.evaluatedValue).first!
            case .greaterThan:
                return packets[0].evaluatedValue > packets[1].evaluatedValue ? 1 : 0
            case .lessThan:
                return packets[0].evaluatedValue < packets[1].evaluatedValue ? 1 : 0
            case .equalTo:
                return packets[0].evaluatedValue == packets[1].evaluatedValue ? 1 : 0
            }
        }
    }
}

private enum LengthTypeID: Int {
    case totalLength = 0
    case numberOfSubpackets = 1
}

private func parsePacket(from binary: inout [String]) -> Packet? {
    guard binary.count >= 3, let version = Int(binary.prefix(3).joined(separator: ""), radix: 2) else {
        return nil
    }
    binary.removeFirst(3)

    guard binary.count >= 3, let type = Int(binary.prefix(3).joined(separator: ""), radix: 2) else {
        return nil
    }
    binary.removeFirst(3)

    let packetType = PacketType(rawValue: type)
    switch packetType {
    case .literal:
        var temp = ""
        var stop = false
        while !stop {
            let first = binary.removeFirst()
            temp += binary.prefix(4).joined(separator: "")
            binary.removeFirst(4)
            stop = first == "0"
        }

        let value = Int(temp, radix: 2)!
        return Packet(version: version, kind: .literal(value), type: packetType)

    default:
        let type = Int(binary.removeFirst())!
        switch LengthTypeID(rawValue: type) {
        case .totalLength:
            let length = Int(binary.prefix(15).joined(separator: ""), radix: 2)!
            binary.removeFirst(15)

            var counted = 0
            var subPackets: [Packet] = []
            while counted < length {
                let previousLength = binary.count
                guard let nextPacket = parsePacket(from: &binary) else {
                    return nil
                }

                subPackets.append(nextPacket)
                counted += previousLength - binary.count
            }

            return Packet(version: version, kind: .operator(subPackets), type: packetType)

        case .numberOfSubpackets:
            let numberOfSubpackets = Int(binary.prefix(11).joined(separator: ""), radix: 2)!
            binary.removeFirst(11)

            var subPackets: [Packet] = []
            while subPackets.count < numberOfSubpackets {
                guard let nextPacket = parsePacket(from: &binary) else {
                    return nil
                }

                subPackets.append(nextPacket)
            }

            return Packet(version: version, kind: .operator(subPackets), type: packetType)

        default:
            break
        }
    }

    return nil
}

private func pad(string : String, toSize size: Int) -> String {
    var padded = string
    for _ in 0..<(size - string.count) {
        padded = "0" + padded
    }
    return padded
}
