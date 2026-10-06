import matlab.engine
import time

engine_instance = None

def get_engine():
    global engine_instance
    if engine_instance is None:
        print("MATLAB Engine Start...")
        matlabTimeStart = time.perf_counter()
        engine_instance = matlab.engine.start_matlab()
        matlabTimeEnd = time.perf_counter()
        print(f"Initialization success. {(matlabTimeEnd - matlabTimeStart):.2f} s")
    return engine_instance

def stop_engine():
    global engine_instance
    if engine_instance is not None:
        engine_instance.quit()
        engine_instance = None