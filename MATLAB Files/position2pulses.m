function [pulses, y] = position2pulses(position, time, pos_per_pulse, fs)
% fs: DAQ sample rate


t = time(1:2:end);
dt = (t(2) - t(1));
position = position(1:2:end);

velocity = gradient(position, dt); % obtain velocity profile


% Generate pulse times (continuous)
accum = 0;
pulse_times = [];


for k = 1:length(t)-1
    dist = abs(velocity(k)) * dt; % discretize position
    accum = accum + dist; 

    while accum >= pos_per_pulse % generate a pulse if cumulative distance exceeds position resolution
        frac = (accum - pos_per_pulse) / dist; % determine where pulse occurs in time step
        tp = t(k) + (1 - frac) * dt; % calculate exact time of pulse occurance
        pulse_times(end+1) = tp; % append time value to list of pulse times
        accum = accum - pos_per_pulse; % allows multiple pulses to be generated at faster speeds
    end
end

% Generate pulse train 

N = length(t); % number of rows in pulse vector
pulse_vec = zeros(N, 2);

pulse_idx = round(pulse_times * fs/2) + 1; % obtain pulse indices in time vector from list of pulse times
pulse_idx = pulse_idx(pulse_idx >= 1 & pulse_idx <= N); % check that indices are valid
pulse_idx = unique(pulse_idx); % remove duplicate pulses 
[pulse_idx, ia] = unique(pulse_idx);

% pulse_dirs = pulse_dirs(ia); % align directions to pulses

pulse_vec(pulse_idx,1) = 1; % placeholders for first column

dir_vec = zeros(N, 1);

for i = 1:N

    s = sign(velocity(i));

    if s == 1
        dir_vec(i) = 1; % assign direction based on the sign of velocity
    elseif s == -1
        dir_vec(i) = 0;
    end
end

% if ~isempty(pulse_dirs)
%     dir_vec(1:pulse_idx(1)) = pulse_dirs(1);
% end
% 
% for j = 1:length(pulse_idx)
% 
%     idx = pulse_idx(j);
% 
%     if j < length(pulse_idx)
%         next_idx = pulse_idx(j+1);
%     else
%         next_idx = N;
%     end
% 
%     dir_vec(idx:next_idx) = pulse_dirs(j);
% end

pulse_vec(:,2) = dir_vec; % fill in second column of pulse vector with directions

%pulses = pulse_vec;
pulses = zeros(size(pulse_vec, 1)*2-1,2);
pulses(1:2:end, 1) = pulse_vec(:, 1);
pulses(1:2:end, 2) = pulse_vec(:, 2);
pulses(1, 2) = 1;

for m = 2:length(pulses)-1

    if pulses(m, 2) == 0

        c = pulses(m-1, 2);
        d = pulses(m+1, 2);
        
        if c == d
            pulses(m, 2) = c;
        else
            pulses(m, 2) = 0;
        end
    end

end

y = zeros(size(pulse_vec, 1)*2-1,1);
y(1:2:end) = pulse_vec(:,1);



end