from experiments import experimental, graphical, rmp

def handleCommand():
    expList = ["help", "experimental", "graphical", "rmp", "pid"]

    while True:
        val = input("> ").lower().strip()
        match val:
            case "help":
                    print("Available commands:")
                    for exp in expList:
                        print(f"- {exp}")
            case "experimental":
                experimental.run_experiment()
            case "graphical":
                graphical.run_experiment()
            case "rmp":
                rmp.run_experiment()
            case "pid":
                print("Placeholder!")
            case _:
                print(f"Unknown command: {val}, try again!")
                handleCommand()