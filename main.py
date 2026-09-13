import matlab.engine
import time

def prompter(text, default_value):
    val = input(f"{text} [default: {default_value}]: ").strip()
    return float(val) if val else default_value

def get_inputs():
    print("Press enter for default values")
    # materials, ks, ls, T_in, T_outs
    materials = ["Concrete", "Fiberglass", "Brick"]
    ks = [1.7, 0.04, 0.72] # W/m*k
    Ls = [0.2, 0.15, 0.35] # meters
    T_in = prompter("Inside temperature (Celsius)", 21.0)
    T_winter = prompter("Winter temperature (Celsius)", -5.0)
    T_summer = prompter("Summer temperature (Celsius)", 25.0)
    T_outs = [T_winter, T_summer]

    print("\n")
    print("Experiment configuration:")
    print(f"T_in: {T_in} degrees C")
    print(f"T_outs: Winter: {T_winter} C, Summer: {T_summer} C")

    return materials, ks, Ls, T_in, T_outs




def run_experiment():

    materials, ks, Ls, T_in, T_outs = get_inputs()

    print("MATLAB Engine Start...")
    matlabTimeStart = time.perf_counter()
    eng = matlab.engine.start_matlab()
    matlabTimeEnd = time.perf_counter()
    print(f"Initialization success. {(matlabTimeEnd - matlabTimeStart):.2f} s")
    input("Press enter to run script")

    scriptTimeStart = time.perf_counter()
    eng.matlabTest(materials, ks, Ls, T_in, T_outs, nargout=0)

    scriptTimeEnd = time.perf_counter()
    input(f"Execution finished {(scriptTimeEnd - scriptTimeStart):.2f} s. Press enter to close...")
    eng.quit()


if __name__ == "__main__":
    run_experiment()