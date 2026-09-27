function RunGraphicalExperiments(alpha, mode, k_array, runtime)
    % vars/equations cited from other scripts

    sampleRate = 10000; % DAQ sampling rate (RunExperiments.m 3)
    GBoxR = 10; % Gearbox ratio (RunExperiments.m 6)
    C0002 = 1000; % number of pulses in one turn by motor (RunExperiments.m 7)
    dTheta = (2*pi)/(C0002 * GBoxR); % radians/pulse (dSpaceTesting.m 7)

    c = 0.2; % Chord length, m (dSpaceTesting.m 9)
    U = 0.328; % freestream speed, m/s (FetchData.m 6)
    max_vel = 0.5*sampleRate*dTheta; % max motor velocity (dSpaceTesting.m 19)

    dt = 1/sampleRate;
    T = runtime; % runtime (s) 
    t = 0:dt:T;

    A = deg2rad(alpha);
    
    % Generate motion profile
    if (mode == 2 || alpha == 0)
        position = A * ones(size(t));
        omega = zeros(size(t));
    elseif (mode == 1)
        f = (k_array * U) / (pi * c);
        position = A * sin(2 * pi * f * t);
        omega = A * (2 * pi * f) * cos(2 * pi * f * t);
    end

    peak_omega = max(abs(omega));

    if (peak_omega > max_vel) 
        error("max velocity exceeded");
    else 
        fprintf("all good to go");
    end

    % plot code
    figure('Color', 'k');


    subplot(2, 1, 1);
    plot(t, rad2deg(position), 'b');
    xlabel("Time (s)");
    ylabel('AoA \alpha (deg)');
    title("Angle of Attack Profile");
    grid on;

    subplot(2,1,2);
    plot(t, rad2deg(omega), 'r');
    xlabel("Time (s)");
    ylabel("Angular Velocity \omega (deg/s)");
    title("Angular Velocity Profile");
    grid on;


    % discretization & call position2pulses
    fprintf("\nbegin discretization");
    [pulses, y] = position2pulses(position, t, dTheta, sampleRate);
    step = pulses(:, 1); % 1 fire, 0 idle
    dir = pulses(:, 2);  % 1 positive, 0 negative

    t_pulses = (0:length(pulses)-1) * dt;

    delta_theta = zeros(size(step));
    delta_theta(step == 1 & dir == 1) = dTheta;
    delta_theta(step == 1 & dir == 0) = -dTheta;

    pos_discrete = position(1) + cumsum(delta_theta);

    figure('Color', 'k');
    subplot(2, 1, 1);
    plot(t, rad2deg(position), 'c');
    hold on;
    plot(t_pulses, rad2deg(pos_discrete), 'm-');
    ylabel("AoA \alpha (deg)");
    xlabel("Time (s)");
    title("Continuous vs Motor Discretization Approximation")
    legend('Continuous', 'Reconstructed Motor Steps');
    grid on;

    subplot(2, 1, 2);
    t_zoom_start = 10;
    t_zoom_end = 10.5;
    zoom_idx = (t_pulses >= t_zoom_start) & (t_pulses <= t_zoom_end);

    plot(t(zoom_idx), rad2deg(position(zoom_idx)), 'c-');
    hold on;
    stairs(t_pulses(zoom_idx), rad2deg(pos_discrete(zoom_idx)), 'm-');
    xlabel("Time (s)");
    ylabel("AoA \alpha (deg)");
    title("Discretization Zoomed View");
    legend("Continuous", "Motor Steps");
    grid on;
end