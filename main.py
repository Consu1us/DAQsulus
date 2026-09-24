import matlab.engine
import time


def prompter(text, default_value):
    val = input(f"{text} [default: {default_value}]: ").strip()
    return float(val) if val else default_value


def get_inputs():
    print("Press enter for default values")
    # materials, ks, ls, T_in, T_outs
    alpha = prompter("Enter pitch amplitude (deg).", 20)

    print("\nSelect mode:")
    print("  [1] Pitch10")
    print("  [2] Static0")
    print("  [3] Static10")
    print("  [4] Static20")
    mode = prompter("Enter mode number (1-4)", 1)

    k_array = prompter("Enter reduced frequencies k", 0.3)
    runtime = prompter("Enter runtime (seconds)", 90.0)

    print("Configuration:")
    print(f"  alpha   : {alpha}")
    print(f"  mode    : {mode}")
    print(f"  k_array : {k_array}")
    print(f"  runtime : {runtime} s")

    return alpha, mode, k_array, runtime


def run_experiment():

    alpha, mode, k_array, runtime = get_inputs()

    print("MATLAB Engine Start...")
    matlabTimeStart = time.perf_counter()
    eng = matlab.engine.start_matlab()
    matlabTimeEnd = time.perf_counter()
    print(f"Initialization success. {(matlabTimeEnd - matlabTimeStart):.2f} s")
    input("Press enter to run experiment")

    scriptTimeStart = time.perf_counter()
    eng.addpath(r'MATLAB Files', nargout=0);
    eng.RunExperiments(alpha, mode, k_array, runtime, nargout=0)

    scriptTimeEnd = time.perf_counter()
    input(f"Execution finished {(scriptTimeEnd - scriptTimeStart):.2f} s. Press enter to close...")
    eng.quit()


if __name__ == "__main__":
    run_experiment()