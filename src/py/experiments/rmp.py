import time

import utils.engine as engine
from utils.utility import prompter, nextexp

eng = engine.get_engine()

def run_experiment():
    rtime = prompter("Enter runtime (s)", 90)
    scriptTimeStart = time.perf_counter()
    eng.RandomMotionProfiles(rtime, nargout=0)
    scriptTimeEnd = time.perf_counter()
    print(f"\nExecution finished {(scriptTimeEnd - scriptTimeStart):.2f} s. \nPress 2 to close or 1 to run a new experiment.")

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
            