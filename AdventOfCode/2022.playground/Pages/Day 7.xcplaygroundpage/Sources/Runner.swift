import Foundation

public enum Runner {
    public static func part1() -> Int {
        let system = compute()
        return system.directorySizes
            .filter { $0 < 100_000 }
            .reduce(0, +)
    }

    public static func part2() -> Int {
        let totalSize = 70_000_000
        let requiredSpace = 30_000_000
        let system = compute()
        let availableSpace = totalSize - system.size
        let minDeletionSize = requiredSpace - availableSpace
        return system.directorySizes
            .filter { $0 > minDeletionSize }
            .min() ?? -1
    }
}

private extension Runner {
    struct FileSystem {
        var size: Int
        var directorySizes: [Int]
    }

    static func compute() -> FileSystem {
        var lines = input
            .components(separatedBy: "\n")
            .map(Line.init)
        var sizes: [Int] = []

        func determineSizeOfCurrentDirectory() -> Int {
            var size = 0

            // the current directory size includes
            // all subsequent items until we move out
            checkDirectory: while let next = lines.first {
                lines.removeFirst()

                switch next {
                case .command(.changeDirectory("..")):
                    break checkDirectory

                case .command(.changeDirectory):
                    size += determineSizeOfCurrentDirectory()

                case .command(.list):
                    break

                case .item(.directory):
                    break

                case .item(.file(let fileSize)):
                    size += fileSize
                }
            }

            sizes.append(size)
            return size
        }

        lines.removeFirst()
        let size = determineSizeOfCurrentDirectory()
        return .init(size: size, directorySizes: sizes)
    }
}

enum Item {
    case file(Int)
    case directory(String)

    init?(string: String) {
        let components = string.components(separatedBy: " ")
        if components[0] == "$" {
            return nil
        }

        switch components[0] {
        case "dir":
            self = .directory(components[1])
        case let size:
            self = .file(Int(size)!)
        }
    }
}

enum Command {
    case changeDirectory(String)
    case list

    init?(string: String) {
        let components = string.components(separatedBy: " ")
        guard components[0] == "$" else {
            return nil
        }

        switch components[1] {
        case "cd":
            self = .changeDirectory(components[2])

        case "ls":
            self = .list

        default:
            return nil
        }
    }
}

enum Line {
    case command(Command)
    case item(Item)

    init(string: String) {
        if let command = Command(string: string) {
            self = .command(command)
        } else {
            let item = Item(string: string)!
            self = .item(item)
        }
    }
}
