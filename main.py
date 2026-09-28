import matlab.engine
import time

engineRunning = False
eng = None

def prompter(text, default_value):
    val = input(f"{text} [default: {default_value}]: ").strip()
    return float(val) if val else float(default_value)


def get_inputs():
    
    
    print("Press enter for default values")

    print("\nEnter graphical or experimental mode")
    print("  [1] Graphical (Motion Profiles Only)")
    print("  [2] Experimental")
    type = prompter("Enter number (1, 2)", 2)

    print("\nSelect pitch or static:")
    print("  [1] Pitch")
    print("  [2] Static")
    mode = prompter("Enter mode number (1, 2)", 1)
    

    if mode == 1:
        alpha = prompter("Enter pitch amplitude (deg).", 20)
        k_array = prompter("Enter reduced frequencies k", 0.3)
    elif mode == 2:
        alpha = prompter("Enter static hold angle (deg)", 0)
        k_array = 0
    
    runtime = prompter("Enter runtime (seconds)", 90.0)

    print("Configuration:")
    print(f"  type    : "+("Graphical" if type == 1 else "Experimental"))
    print(f"  alpha   : {alpha} deg")
    print(f"  mode    : "+("Pitch" if mode == 1 else "Static"))
    print(f"  k_array : {k_array}")
    print(f"  runtime : {runtime} s")

    return alpha, mode, k_array, runtime, type


def run_experiment():
    global engineRunning, eng
    alpha, mode, k_array, runtime, type = get_inputs()
    
    if (engineRunning == False): 
        print("MATLAB Engine Start...")
        matlabTimeStart = time.perf_counter()
        eng = matlab.engine.start_matlab()
        matlabTimeEnd = time.perf_counter()
        print(f"Initialization success. {(matlabTimeEnd - matlabTimeStart):.2f} s")
        engineRunning = True

    input("Press enter to run experiment")


    scriptTimeStart = time.perf_counter()
    eng.addpath(r'MATLAB Files', nargout=0)

    if type == 2:
        eng.RunExperiments(alpha, mode, k_array, runtime, nargout=0)
    elif type == 1:
        eng.RunGraphicalExperiments(alpha, mode, k_array, runtime, nargout=0)

    scriptTimeEnd = time.perf_counter()
    intention = prompter(f"\nExecution finished {(scriptTimeEnd - scriptTimeStart):.2f} s. \nPress 2 to close or 1 to run a new experiment.", 2)

    if (intention == 2):
        eng.quit()
    elif (intention == 1):
        run_experiment()



if __name__ == "__main__":
    run_experiment()