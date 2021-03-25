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

            // Modify the dungeon monsters here
            dungeon.title = "Modified title name"
            
            let datasource = EncounterDataSource()
            datasource.getRandomEncounter()
            
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
