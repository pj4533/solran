import Foundation
import ArgumentParser
import SolastaKit

struct SolRan: ParsableCommand {
    static let configuration = CommandConfiguration(
    	commandName: "solran",
        abstract: "Command line app to randomize monsters in a Solasta dungeon using 5e encounter rules"
    )

    @Argument(help: "Solasta dungeon filename")
    var filename: String

	func run() {
        let url = URL(fileURLWithPath: filename)
        do {
            // Reading in dungeon file
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            var dungeon = try decoder.decode(Dungeon.self, from: data)

            let datasource = EncounterDataSource()
            for index in 0..<(dungeon.userRooms?.count ?? 0) {
                for mindex in 0..<(dungeon.userRooms?[index].userGadgets?.count ?? 0) {
                    if dungeon.userRooms?[index].userGadgets?[mindex].gadgetBlueprintName == "MonsterM" {
                        for jindex in 0..<(dungeon.userRooms?[index].userGadgets?[mindex].parameterValues?.count ?? 0) {
                            if dungeon.userRooms?[index].userGadgets?[mindex].parameterValues?[jindex].gadgetParameterDescriptionName == "Creature" {
                                dungeon.userRooms?[index].userGadgets?[mindex].parameterValues?[jindex].stringValue = datasource.getRandomCreatureLabel()
                            }
                        }
                    }
                }
            }
            // read avg party lvl from command line eventually
            // get random monsters for room
            // --> to start place random monsters with no algorithm
            // figure out placement -- don't place any where someting is.
            //   -- need to know width/height of rooms? local x/y
            
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
