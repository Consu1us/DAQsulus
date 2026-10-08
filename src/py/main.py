from utils import menu
import utils.engine as engine
import utils.utility as utility
import utils.menu as menu




def init():
    print("Welcome! Type 'help' for a list of commands, or type a module name to run the experiment.")
    menu.handleCommand()

if __name__ == "__main__":
    init()