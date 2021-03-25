import Foundation
import ArgumentParser
import SolastaKit

struct SolRan: ParsableCommand {
    static let configuration = CommandConfiguration(
    	commandName: "solran",
        abstract: "Randomize monsters in a Solasta dungeon using 5e encounter rules"
    )

    @Argument(help: "Solasta dungeon filename")
    var filename: String

	func run() {
        let url = URL(fileURLWithPath: filename)
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let dungeon = try decoder.decode(Dungeon.self, from: data)

            print("Hello dungeon: \(dungeon.title ?? "unknown title")")
        } catch {
            print("Error processing dungeon file")
        }
    }
}

SolRan.main()
