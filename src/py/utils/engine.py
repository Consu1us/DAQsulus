import matlab.engine
import time
import sys
from pathlib import Path

engine_instance = None
MATLAB_DIR = Path(__file__).resolve().parents[2] / "MATLAB"  

def get_engine():
    global engine_instance
    if engine_instance is None:
        print("MATLAB Engine Start...")
        matlabTimeStart = time.perf_counter()
        engine_instance = matlab.engine.start_matlab()
        matlabTimeEnd = time.perf_counter()
        print(f"Initialization success. {(matlabTimeEnd - matlabTimeStart):.2f} s")
        engine_instance.addpath(str(MATLAB_DIR), nargout=0)
    return engine_instance

def stop_engine():
    global engine_instance
    if engine_instance is not None:
        print("Shutting down...")
        engine_instance.quit()
        engine_instance = None
        sys.exit(0)