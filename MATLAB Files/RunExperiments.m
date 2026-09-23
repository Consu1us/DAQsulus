function RunExperiments(alpha, mode, k_array, runtime)
    sampleRate = 10000; % DAQ sampling rate
    d = initializeDAQ(sampleRate); % open DAQ channels

    P.GBoxR = 10; % Motor to Gearbox ratio
    P.C0002 = 1000; % number of pulses in one turn by motor
    P.pos_per_pulse = (2*pi)/(P.C0002*P.GBoxR); % radians per pulse
    P.alpha = alpha;
    P.mode = mode;
    P.k_array = k_array;
    P.fs = d.Rate;

    P.mode = mode;

    P.A_array = deg2rad(0); % pitch amplitudes
    % P.k_array = 0.3; % reduced frequencies
    P.depth = "No Foil Moving"; 

    % runtime = 90; % seconds

    % filePath = "C:\Users\James\Documents\MATLAB\LoadCellCalibration\data\LoadCellData\";

    fprintf('Reset the load cell relay to tare the load cell. Start current probe. Press any key to continue after this is done. \n')
    pause

    fprintf('Start the flume if it is not already running. Wait 30 seconds after startup is complete to let the flow fully develop. \n')
    pause

    fprintf('Ensure that parameters are set properly. Press any key to collect data. \n')
    pause

    Data = FetchData(d, runtime, P);
    %%
    fprintf('Data has been collected and saved. Press any key to send the foil back to its home location. \n')
    pause

    GoHome(d, Data.Dev2_ctr0, P)

    fprintf('Foil has returned home. If you have cycled through all frequencies at a specific amplitude, turn off the flume and wait 15 minutes. \n')

end

