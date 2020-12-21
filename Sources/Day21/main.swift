import Foundation
import Utils

func parseInput(_ input: String) -> [([String], [String])] {
    let lines = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")

    return lines.map({
        let scanner = Scanner(string: $0)
        
        let ingredients = scanner.scanUpToString(" (contains")!
            .components(separatedBy: " ")
        
        let _ = scanner.scanString("(contains")
        let allergens = scanner.scanUpToString(")")!
            .components(separatedBy: ", ")
        
        return (ingredients, allergens)
    })
}

func part1(_ input: String) -> Int {
    let foods = parseInput(input)
    
    var allIngredients = Set<String>()
    var allAllergens = Dictionary<String, Set<String>>()
    for (ingredients, allergens) in foods {
        allIngredients = allIngredients.union(ingredients)
        for allergen in allergens {
            if allAllergens[allergen] == nil {
                allAllergens[allergen] = Set<String>(ingredients)
            } else {
                allAllergens[allergen] = allAllergens[allergen]!.intersection(ingredients)
            }
        }
    }
    
    let allergens = allAllergens.reduce(Set<String>(), { $0.union($1.value) })
    let notAllergens = allIngredients.filter({ !allergens.contains($0) })
    
    return foods.reduce(0, {
        $0 + $1.0.filter({ notAllergens.contains($0) }).count
    })
}

try! test(part1("""
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
""") == 5, "part1")

func part2(_ input: String) -> String {
    let foods = parseInput(input)

    var allAllergens = Dictionary<String, Set<String>>()
    for (ingredients, allergens) in foods {
        for allergen in allergens {
            if allAllergens[allergen] == nil {
                allAllergens[allergen] = Set<String>(ingredients)
            } else {
                allAllergens[allergen] = allAllergens[allergen]!.intersection(ingredients)
            }
        }
    }
    
    var knowAllergens = Dictionary<String, String>();
    
    while !allAllergens.isEmpty {
        let knownMappings = Dictionary<String, String>(uniqueKeysWithValues: allAllergens
            .filter({ $0.value.count == 1 })
            .map({ ($0.key, $0.value.first!) }))

        allAllergens = allAllergens.filter({ knownMappings[$0.key] == nil})
        for (key, value) in allAllergens {
            allAllergens[key] = value.filter({ !knownMappings.values.contains($0) })
        }
        
        for (allergen, ingredient) in knownMappings {
            knowAllergens[allergen] = ingredient
        }
    }

    return knowAllergens.sorted(by: { $0.key < $1.key }).map({ $0.value }).joined(separator: ",")
}

try! test(part2("""
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
""") == "mxmxvkd,sqjhc,fvjkl", "part1")

let input = try! String(contentsOfFile: "input/day21.txt", encoding: String.Encoding.utf8)

print("\(part1(input))")
print("\(part2(input))")
