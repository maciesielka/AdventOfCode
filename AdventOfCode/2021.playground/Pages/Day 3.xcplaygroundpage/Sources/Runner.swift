import Foundation

public enum Runner {
    public static func part1() -> Int {
        let lines = input.components(separatedBy: "\n")
        var frequencies = [[Int]].init(repeating: [0, 0], count: lines[0].count)
        for line in lines {
            for (idx, character) in line.enumerated() {
                let number = Int(String(character))!
                frequencies[idx][number] += 1
            }
        }

        var gamma = ""
        var epsilon = ""
        for index in 0..<lines[0].count {
            let frequenciesByCharacter = frequencies[index]
            if frequenciesByCharacter[0] > frequenciesByCharacter[1] {
                gamma += "0"
                epsilon += "1"
            } else {
                gamma += "1"
                epsilon += "0"
            }
        }

        let gammaNumber = Int(gamma, radix: 2)!
        let epsilonNumber = Int(epsilon, radix: 2)!
        return gammaNumber * epsilonNumber
    }

    public static func part2() -> Int {
        let lines = input.components(separatedBy: "\n")
        
        let oxygenRating = computeLastStanding(from: lines, by: >)
        let co2Rating = computeLastStanding(from: lines, by: <=)

        return oxygenRating * co2Rating
    }

    static func computeLastStanding(from lines: [String], by shouldKeepZeroBit: (Int, Int) -> Bool) -> Int {
        var frequencies = [[Int]].init(repeating: [0, 0], count: lines[0].count)

        var copy = lines
        var prefix = ""
        var index = 0
        while copy.count > 1, index < lines[0].count {
            for line in copy {
                let stringIndex = line.index(line.startIndex, offsetBy: index)
                let number = Int(line[stringIndex..<line.index(after: stringIndex)])!
                frequencies[index][number] += 1
            }

            let frequenciesByCharacter = frequencies[index]
            if shouldKeepZeroBit(frequenciesByCharacter[0], frequenciesByCharacter[1]) {
                prefix += "0"
            } else {
                prefix += "1"
            }

            copy = copy.filter { $0.hasPrefix(prefix) }
            index += 1
        }

        return Int(copy[0], radix: 2)!
    }
}
