function RandomMotionProfiles(runtime)

    % vars/equations cited from other scripts

    sampleRate = 10000; % DAQ sampling rate (RunExperiments.m 3)
    GBoxR = 10; % Gearbox ratio (RunExperiments.m 6)
    C0002 = 1000; % number of pulses in one turn by motor (RunExperiments.m 7)
    dTheta = (2*pi)/(C0002 * GBoxR); % radians/pu*lse (dSpaceTesting.m 7)

    c = 0.2; % Chord length, m (dSpaceTesting.m 9)
    U = 0.328; % freestream speed, m/s (FetchData.m 6)
    max_vel = 0.5*sampleRate*dTheta; % max motor velocity (dSpaceTesting.m 19)

    dt = 1/sampleRate;
    T = runtime; % runtime (s) (dSpaceTesting.m 16) 
    t = 0:dt:T;


    % reduced frequency (0.05 quasi-steady -> 0.50 highly unsteady)
    k_min = 0.05;
    k_max = 0.50;
    N = 12;
    k_vals = linspace(k_min, k_max, N);
    f_vals = (k_vals * U) / (pi * c); % pitching frequency (hz) (dSpaceTesting.m 13)


    % random phases
    rng("shuffle"); % shuffle changes seed every run
    phases = 2 * pi * rand(1, N); % rad
    amps = ones(1, N);

    % AoA (position) and Omega generation
    position = zeros(size(t));
    omega = zeros(size(t));

    for i = 1:N
        omega_i = 2 * pi * f_vals(i); % angular freq = 2 * pi * pitching freq
        position = position + amps(i) * sin(omega_i * t + phases(i)); % sum sine waves with random phase shifts
        omega = omega + amps(i) * omega_i * cos(omega_i * t + phases(i));
    end

    A = deg2rad(15); % pitch amplitude (dSpaceTesting.m 10)
    scale_factor = A / max(abs(position)); % scale random values to amplitude 15 deg
    position = position * scale_factor;
    omega = omega * scale_factor;

    peak_omega = max(abs(omega));

    if (peak_omega > max_vel) 
        error("max velocity exceeded");
    else 
        fprintf("all good to go");
    end

    % plot code
    fig1 = figure('Color', 'k');
    theme(fig1, "dark");


    subplot(2, 1, 1);
    plot(t, rad2deg(position), 'b');
    xlabel("Time (s)");
    ylabel('AoA \alpha (deg)');
    title("Pseudorandom Angle of Attack Profile");
    grid on;

    subplot(2,1,2);
    plot(t, rad2deg(omega), 'r');
    xlabel("Time (s)");
    ylabel("Angular Velocity \omega (deg/s)");
    title("Pseudorandom Angular Velocity Profile");
    grid on;

    exportgraphics(fig1, fullfile("bin", "profiles.png"));
    savefig(fig1, fullfile("bin", "profiles.fig"));

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

    fig2 = figure('Color', 'k');
    theme(fig2, "dark");
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

    exportgraphics(fig2, fullfile("bin", "discretization.png"));
    savefig(fig2, fullfile("bin", "discretization.fig"));
