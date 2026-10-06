import utils.engine as engine
import utils.utility as utility




def init():
    print("Initializing...")
    global expList
    expList = ["help", "experimental", "graphical", "rmp"]
    eng = engine.get_engine()
    print("Welcome! Type 'help' for a list of commands, or type a module name to run the experiment.")
    moduleinput()

def nextexp():
    print("placeholder")

def exquit():
    engine.stop_engine()
    print("All done!")


def moduleinput():
    val = input().lower().strip()

    



if __name__ == "__main__":
    init()