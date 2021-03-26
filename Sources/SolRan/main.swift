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
            let dungeon = try decoder.decode(Dungeon.self, from: data)


            for var room in dungeon.userRooms ?? [] {
                print(room.roomBlueprintName ?? "nil blueprint")
                
                // if its a big room
                if room.roomBlueprintName?.contains("24C") ?? false {
                    let nonMonsterGadgets = room.userGadgets?.filter({!($0.gadgetBlueprintName?.contains("Monster") ?? false)})
                    
                    let datasource = EncounterDataSource()
                    datasource.getRandomEncounter()

                    room.userGadgets = nonMonsterGadgets
                }
            }
            // read avg party lvl from command line eventually
            // get random monsters for room
            // --> to start place random monsters with no algorithm
            // figure out placement -- don't place any where someting is.
            //   -- need to know width/height of rooms? local x/y
            
//            // Serializing dungeon file out
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            if let dungeonJSONData = try? encoder.encode(dungeon) {
//                let output = String(data: dungeonJSONData, encoding: .utf8)
//                print(output ?? "<error>")
//            } else {
//                print("Error processing dungeon file")
//            }
        } catch let error {
            print("Error processing dungeon file: \(error.localizedDescription)")
        }
    }
}

SolRan.main()
