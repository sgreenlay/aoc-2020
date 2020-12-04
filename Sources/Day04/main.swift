import Foundation
import Utils

func parseInput(_ input: String) -> [[String]] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n\n")
        .map({ $0.split(whereSeparator: { ($0 == "\n" || $0 == " ") } ).map({ String($0) }) })
}

func validPassportFields(_ passport: [String]) -> Bool {
    var fields = Set<String>()
    
    for field in passport {
        let splitField = field.components(separatedBy: ":")
        let fieldName = splitField[0]
        // let fieldValue = splitField[1]
        fields.insert(fieldName)
    }
    
    let validFields = [
        "byr", // (Birth Year)
        "iyr", // (Issue Year)
        "eyr", // (Expiration Year)
        "hgt", // (Height)
        "hcl", // (Hair Color)
        "ecl", // (Eye Color)
        "pid", // (Passport ID)
        // "cid", // (Country ID)
    ]
    for validField in validFields {
        if !fields.contains(validField) {
            return false
        }
    }
    return true
}

func part1(_ input: String) -> Int {
    let inputs = parseInput(input)
    let valid = inputs.filter({ validPassportFields($0) })
    return valid.count
}

assert(part1("""
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
""") == 2)

func validPassport(_ passport: [String]) -> Bool {
    var fields = Dictionary<String, String>()
    
    for field in passport {
        let splitField = field.components(separatedBy: ":")
        let fieldName = splitField[0]
        let fieldValue = splitField[1]
        fields[fieldName] = fieldValue
    }
    
    let validFields : [ (String, (String) -> Bool) ] = [
        ("byr", { input in
            // (Birth Year) - four digits; at least 1920 and at most 2002.
            if input.count != 4 {
                return false
            }
            guard let year = input.asInt() else {
                return false
            }
            return year >= 1920 && year <= 2002
        }),
        ("iyr", { input in
            // (Issue Year) - four digits; at least 2010 and at most 2020.
            if input.count != 4 {
                return false
            }
            guard let year = input.asInt() else {
                return false
            }
            return year >= 2010 && year <= 2020
        }),
        ("eyr", { input in
            // (Expiration Year) - four digits; at least 2020 and at most 2030.
            if input.count != 4 {
                return false
            }
            guard let year = input.asInt() else {
                return false
            }
            return year >= 2020 && year <= 2030
        }),
        ("hgt", { input in
            // (Height) - a number followed by either cm or in.
            let scanner = Scanner(string: input)
            guard let height = scanner.scanInt() else {
                return false
            }
            
            let remaining = String(input.suffix(from: scanner.currentIndex))
            if remaining == "cm" {
                // If cm, the number must be at least 150 and at most 193.
                return height >= 150 && height <= 193
            } else if remaining == "in" {
                // If in, the number must be at least 59 and at most 76.
                return height >= 59 && height <= 76
            } else {
                return false
            }
        }),
        ("hcl", { input in
            // (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
            if input.characterAt(offset: 0) != "#" {
                return false
            }
            
            let remaining = String(input.suffix(from: input.indexAt(offset: 1)))
            if remaining.count != 6 {
                return false
            }
            
            let validChars = Set<Character>("0123456789abcdef")
            for ch in remaining {
                if !validChars.contains(ch) {
                    return false
                }
            }
            return true
        }),
        ("ecl", { input in
            // (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
            let validColours = Set<String>(["amb","blu","brn","gry","grn","hzl","oth"])
            return validColours.contains(input)
        }),
        ("pid", { input in
            // (Passport ID) - a nine-digit number, including leading zeroes.
            if input.count != 9 {
                return false
            }
            guard let _ = input.asInt() else {
                return false
            }
            return true
        }),
        // "cid", // (Country ID)
    ]
    for validField in validFields {
        guard let field = fields[validField.0] else {
            return false
        }
        if !validField.1(field) {
            return false
        }
    }
    return true
}

func part2(_ input: String) -> Int {
    let inputs = parseInput(input)
    let valid = inputs.filter({ validPassport($0) })
    return valid.count
}

assert(part2("""
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
""") == 0)

assert(part2("""
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
""") == 4)

let input = try! String(contentsOfFile: "input/day04.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
