import Foundation
import ArgumentParser
import SolastaKit

struct SolRan: ParsableCommand {
    static let configuration = CommandConfiguration(
    	commandName: "solran",
        abstract: "Command line app to randomize monsters in a Solasta dungeon using 5e encounter rules"
    )

    enum DifficultyParam: String, CaseIterable, EnumerableFlag {
        case easy, medium, hard, deadly
    }
    
    @Flag(help: "Difficulty for encounters")
    var difficulty: DifficultyParam
    
    @Argument(help: "Solasta dungeon filename")
    var filename: String

    @Argument(help: "Average party level")
    var level: Int

	func run() {
        let url = URL(fileURLWithPath: filename)
        do {
            // Reading in dungeon file
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            var dungeon = try decoder.decode(Dungeon.self, from: data)

            let datasource = EncounterDataSource()
            for index in 0..<(dungeon.userRooms?.count ?? 0) {
                if let numberOfEnemies = dungeon.userRooms?[index].userGadgets?.filter({$0.gadgetBlueprintName == "MonsterM"}).count, numberOfEnemies > 0 {
                    let creatureLabels = datasource.getEncounter(withNumberCreatures: numberOfEnemies, forAverageLvl: self.level, withDifficulty: Difficulty(rawValue: self.difficulty.rawValue) ?? .hard)
                    
                    var i = 0
                    // I dont like this -- I usually use classes, but with structs its all values. Prob a better syntax for this, but I am going fast.
                    for mindex in 0..<(dungeon.userRooms?[index].userGadgets?.count ?? 0) {
                        if dungeon.userRooms?[index].userGadgets?[mindex].gadgetBlueprintName == "MonsterM" {
                            for jindex in 0..<(dungeon.userRooms?[index].userGadgets?[mindex].parameterValues?.count ?? 0) {
                                if dungeon.userRooms?[index].userGadgets?[mindex].parameterValues?[jindex].gadgetParameterDescriptionName == "Creature" {
                                    if i < creatureLabels.count {
                                        dungeon.userRooms?[index].userGadgets?[mindex].parameterValues?[jindex].stringValue = creatureLabels[i]
                                        i = i + 1
                                    } else {
                                        dungeon.userRooms?[index].userGadgets?[mindex].parameterValues?[jindex].stringValue = ""
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            dungeon.startLevelMin = self.level
            dungeon.startLevelMax = self.level
            
            // Serializing dungeon file out
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let dungeonJSONData = try? encoder.encode(dungeon) {
                let output = String(data: dungeonJSONData, encoding: .utf8)
                print(output ?? "<error>")
            } else {
                print("Error processing dungeon file")
            }
        } catch let error {
            print("Error processing dungeon file: \(error.localizedDescription)")
        }
    }
}

SolRan.main()
