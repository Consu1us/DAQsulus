import matlab.engine
import time

def run_experiment():
    print("MATLAB Engine Start...")
    matlabTimeStart = time.perf_counter()
    eng = matlab.engine.start_matlab()
    matlabTimeEnd = time.perf_counter()
    print(f"Initialization success. {(matlabTimeEnd - matlabTimeStart):.2f} s")
    input("Press enter to run script")

    scriptTimeStart = time.perf_counter()
    eng.matlabTest(nargout=0)

    scriptTimeEnd = time.perf_counter()
    input(f"Execution finished {(scriptTimeEnd - scriptTimeStart):.2f} s. Press enter to close...")
    eng.quit()


if __name__ == "__main__":
    run_experiment()