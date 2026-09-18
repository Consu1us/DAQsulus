clear; clc; close all;

% vars/equations cited from other scripts

sampleRate = 10000; % DAQ sampling rate (RunExperiments.m 3)
GBoxR = 10; % Gearbox ratio (RunExperiments.m 6)
C0002 = 1000; % number of pulses in one turn by motor (RunExperiments.m 7)
dTheta = (2*pi)/(C0002 * GBoxR); % radians/pulse (dSpaceTesting.m 7)

c = 0.2; % Chord length, m (dSpaceTesting.m 9)
U = 0.328; % freestream speed, m/s (FetchData.m 6)
max_vel = 0.5*sampleRate*dTheta; % max motor velocity (dSpaceTesting.m 19)

dt = 1/sampleRate;
T = 100; % runtime (s) (dSpaceTesting.m 16) 
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
figure('Color', 'k');


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


% discretization & call position2pulses
fprintf("\nbegin discretization");
[pulses, y] = position2pulses(position, t, dTheta, sampleRate);
step = pulses(:, 1); % 1 fire, 0 idle
dir = pulses(:, 2);  % 1 positive, 0 negative

t_pulses = (0:length(pulses)-1) * dt;

figure('Color','k');
t_start = 8.23;
t_end = 8.33;
zoom = (t_pulses >= t_start) & (t_pulses <= t_end);
subplot(2, 1, 1);
stairs(t_pulses(zoom), step(zoom), 'b');
% ylim([-0.2, 1.2])
ylabel("STEP (1/0)");
xlabel("Time (s)");
title(sprintf("Motor Pulse Signal (STEP) (%.2f s to %.2f s)", t_start, t_end));
grid on;

subplot(2,1,2);
stairs(t_pulses(zoom), dir(zoom), 'r');
% ylim([-0.2, 1.2]);
yticks([0 1]);
ylabel("DIR (1/0)");
title(sprintf("Motor Direction Signal (DIR) (%.2f s to %.2f s)", t_start, t_end));
xlabel("Time (s)");
grid on;



