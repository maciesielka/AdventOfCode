import Foundation

enum Move: Equatable {
    case rock
    case paper
    case scissors

    init(string: String) {
        switch string {
        case "A", "X":
            self = .rock

        case "B", "Y":
            self = .paper

        case "C", "Z":
            self = .scissors

        default:
            fatalError("Invalid")
        }
    }

    var score: Int {
        switch self {
        case .scissors:
            return 3

        case .paper:
            return 2

        case .rock:
            return 1
        }
    }

    func score(against other: Move) -> Int {
        if self == other {
            return score + 3
        }

        switch (self, other) {
        case (.rock, .scissors),
            (.paper, .rock),
            (.scissors, .paper):
            return score + 6
            
        default:
            return score
        }
    }
}

enum Outcome {
    case win
    case lose
    case draw

    init(string: String) {
        switch string {
        case "X":
            self = .lose

        case "Y":
            self = .draw

        case "Z":
            self = .win

        default:
            fatalError("Unsupported")
        }
    }

    var score: Int {
        switch self {
        case .win:
            return 6
        case .draw:
            return 3
        case .lose:
            return 0
        }
    }

    func score(opponentMove: Move) -> Int {
        var myMove: Move {
            switch self {
            case .draw:
                return opponentMove
            default:
                switch opponentMove {
                case .rock:
                    return self == .win ? .paper : .scissors
                case .paper:
                    return self == .win ? .scissors : .rock
                case .scissors:
                    return self == .win ? .rock : .paper
                }
            }
        }

        return score + myMove.score
    }
}

public enum Runner {

    public static func part1() -> Int {
        return input
            .components(separatedBy: "\n")
            .map {
                $0
                    .components(separatedBy: " ")
                    .map(Move.init)
            }
            .map { $0[1].score(against: $0[0]) }
            .reduce(0, +)
    }

    public static func part2() -> Int {
        return input
            .components(separatedBy: "\n")
            .map {
                $0
                    .components(separatedBy: " ")
            }
            .map { components in
                let other = Move(string: components[0])
                let outcome = Outcome(string: components[1])
                return outcome.score(opponentMove: other)
            }
            .reduce(0, +)
    }
}
