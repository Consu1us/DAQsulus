from utils import menu


def prompter(text, default_value):
    val = input(f"{text} [default: {default_value}]: ").strip()
    return float(val) if val else float(default_value)

def nextexp():
    print("Run another experiment!")
    menu.handleCommand()