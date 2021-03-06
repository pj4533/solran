# solran

Command line app to randomize monsters in a Solasta dungeon using 5e encounter rules

```
OVERVIEW: Command line app to randomize monsters in a Solasta dungeon using 5e encounter rules

USAGE: solran <filename> <level>

ARGUMENTS:
  <filename>              Solasta dungeon filename
  <level>                 Average party level

OPTIONS:
  -h, --help              Show help information.
```

### Notes

* Mac only
* Command line only

### How To Run

1. Download the latest [release](https://github.com/pj4533/solran/releases)
2. Open a terminal window and find the folder you downloaded to
3. Command to make app executable:  `chmod +x solran`
4. Command to run:  `./solran <solasta dungeon json> <level> output_dungeon_file.json`

You might also need to give MacOS permission to run the app.

### Developer Commands

`swift build` Builds app to the `.build` folder

`swift build -c release` Build a release version

`./.build/debug/solran` Runs app after building

`swift run solran` Runs app directly
