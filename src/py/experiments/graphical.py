import time

import utils.engine as engine
from utils.utility import prompter, nextexp

eng = engine.get_engine()

def run_experiment():

    print("\nSelect pitch or static:")
    print("  [1] Pitch")
    print("  [2] Static")
    mode = prompter("Enter mode number (1, 2)", 1)
    
    rtime = prompter("Enter runtime (s)", 90)

    if mode == 1:
        alpha = prompter("Enter pitch amplitude (deg)", 20)
        karray = prompter("Enter reduced frequencies k", 0.3)
    elif mode == 2:
        alpha = prompter("Enter static hold angle (deg)", 0)
        karray = 0
    
    scriptTimeStart = time.perf_counter()
    eng.RunGraphicalExperiments(alpha, mode, karray, rtime, nargout=0)
    scriptTimeEnd = time.perf_counter()
    print(f"\nExecution finished {(scriptTimeEnd - scriptTimeStart):.2f} s. \nPress 2 to close or 1 to run a new experiment.", 2)

    while True:
        intention = input()
        if (intention == "2"):
            engine.stop_engine()
        elif (intention == "1"):
            nextexp()
            break
        else:
            print("Invalid input. Please enter 1 or 2.")
            continue