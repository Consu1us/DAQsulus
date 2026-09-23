function Data = FetchData(d, runtime, P)
% Time vector
dt = 1/P.fs;
t = 0:dt:runtime;

U = 0.328; % freestream speed [m/s]
c = 0.2; % foil chord length [m]


for i = 1:1
    for j = 1:1

        A = P.A_array(i);
        k = P.k_array(j);
        f = (k*U)/(pi*c);

        max_vel = (P.fs/2)*P.pos_per_pulse; % radians per second
        test = 2*pi*f*A;

        if test > max_vel
            error('Test value exceeds maximum velocity. Adjust parameters.');
        end
        

        position = A*sin(2*pi*f*t);
        % position = linspace(0, deg2rad(0.5), length(t));

        [pulse_vec, y] = position2pulses(1.313*position, t, P.pos_per_pulse, P.fs);

        PulseData = [pulse_vec(:, 1) pulse_vec(:, 2)];

        triggerTime = datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss.SSS');

        % Data = readwrite(d, PulseData);
        Data = read(d, length(t)); 

        % EncTtable = Data.Dev2_ctr0;

        % enc = Data.Dev2_ctr0 - 2^31; % Subtract initial count value
        % enc = (enc*2*pi)/2^17; % convert to radians 
        % 
        % figure
        % plot(t, position)
        % hold on
        % plot(seconds(Data.Time), enc)
        % title('Prescribed Motion Profile and Measured Response')
        % xlabel('Time (s)')
        % ylabel('Position (rad)')
        % legend('Prescribed Motion','Encoder Measurement')
        % 
        % err = enc' - position;
        % 
        % figure
        % plot(t, err)
        % title('Position Error')
        % xlabel('Time (s)')
        % ylabel('Position Error Between Measured and Prescribed Signals (rad)')      
        % 
        % xLoadData = Data.Dev1_ai12;
        % yLoadData = Data.Dev1_ai5;
        % zLoadData = Data.Dev1_ai11;
        % 
        AcousticData = Data.Dev1_ai6;
        % 
        % figure
        % plot(Data,"Time","Dev1_ai12")
        % hold on
        % plot(Data,"Time","Dev1_ai5")
        % plot(Data,"Time","Dev1_ai11")
        % title('Load Cell Voltage Measurements')
        % xlabel('Time (s)')
        % ylabel('Voltage (V)')
        % legend('Fx','Fy','Fz')

        figure
        plot(Data, "Time", "Dev1_ai6")
        xlabel('Time (s)')
        ylabel('Voltage (V)')
        title('Acoustic Test Data')

        
        currentTimeUTC = datetime('now', 'TimeZone', 'UTC');
        % Convert the datetime to POSIX time (seconds since the epoch)
        secondsSinceEpoch = posixtime(currentTimeUTC);
        % Display the result (seconds since epoch)
        time = num2str(floor(secondsSinceEpoch));


        fname = "C:\Users\James\OneDrive\Documents\May 2026 Experiments\Wake Characterization\Baseline Cases\" + P.depth + "_t" + time + ".mat";
        save(fname,"P","triggerTime","AcousticData")
        fprintf('data saved to: %s\n', fname);

        
    end
end


end



