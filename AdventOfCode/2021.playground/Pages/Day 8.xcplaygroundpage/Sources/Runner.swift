import Foundation

public enum Runner {
    public static func part1() -> Int {
        let lines = input.components(separatedBy: .newlines)

        let outputs = lines.flatMap {
            $0.components(separatedBy: "|")
                .map { $0.trimmingCharacters(in: .whitespaces ) }[1]
                .components(separatedBy: " ")
                .map { Set(Array($0)) }
        }

        return outputs
            .filter {
                $0.count == 2 ||
                $0.count == 4 ||
                $0.count == 3 ||
                $0.count == 7
            }
            .count
    }

    public static func part2() -> Int {
        let lines = input.components(separatedBy: .newlines)

        func getOutputNumber(atLineIndex index: Int) -> Int {
            let components = lines[index].components(separatedBy: "|")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            let inputs = components[0]
                .components(separatedBy: " ")
                .map { Set(Array($0))}
            let outputs = components[1]
                .components(separatedBy: " ")
                .map { Set(Array($0))}

            let possibleValuesByNumberOfSegments: [Int: [Int]] = [
                2: [1],
                3: [7],
                4: [4],
                5: [2, 3, 5],
                6: [0, 6, 9],
                7: [8]
            ]

            var valueBySegments: [Set<String.Element>: Int] = [:]
            var representationByValue: [Int: Set<String.Element>] = [:]
            for item in inputs {
                if let possibleValues = possibleValuesByNumberOfSegments[item.count],
                   possibleValues.count == 1 {
                    valueBySegments[item] = possibleValues[0]
                    representationByValue[possibleValues[0]] = item
                }
            }

            let a = representationByValue[7]!.subtracting(representationByValue[1]!)

            let uniquePartOfNine = representationByValue[4]!.union(a)
            let nine = inputs.first { $0.count == 6 && $0.isSuperset(of: uniquePartOfNine) }!
            valueBySegments[nine] = 9
            representationByValue[9] = nine
            assert(inputs.contains(nine), "invalid representation for 9")

            let g = nine.subtracting(uniquePartOfNine)
            let e = representationByValue[8]!.subtracting(nine)

            let bAndD = representationByValue[4]!.subtracting(representationByValue[1]!)

            let six = inputs.first { $0.count == 6 && $0 != nine && $0.isSuperset(of: bAndD) }!
            valueBySegments[six] = 6
            representationByValue[6] = six
            assert(inputs.contains(six), "invalid representation for 6")

            let zero = inputs.first { $0.count == 6 && $0 != six && $0 != nine }!
            valueBySegments[zero] = 0
            representationByValue[0] = zero
            assert(inputs.contains(zero), "invalid representation for 0")

            let d = representationByValue[8]!.subtracting(representationByValue[0]!)
            let b = bAndD.subtracting(d)

            let three = representationByValue[8]!
                .subtracting(b)
                .subtracting(e)
            assert(inputs.contains(three), "invalid representation for 3 -- \(three.sorted())")
            valueBySegments[three] = 3
            representationByValue[3] = three

            let two = inputs.first { $0.count == 5 && $0 != three && $0.isSuperset(of: e) }!
            valueBySegments[two] = 2
            representationByValue[2] = two
            assert(inputs.contains(two), "invalid representation for 2")

            let five = inputs.first { $0.count == 5 && $0 != three && $0.isSuperset(of: b) }!
            valueBySegments[five] = 5
            representationByValue[5] = five
            assert(inputs.contains(five), "invalid representation for 5")

            let stringy = outputs
                .map { String(valueBySegments[$0]!) }
                .reduce("", +)
            return Int(stringy)!
        }

        var sum = 0
        for index in lines.indices {
            sum += getOutputNumber(atLineIndex: index)
        }
        return sum
    }
}
