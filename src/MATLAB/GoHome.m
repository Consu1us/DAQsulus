function HomeData = GoHome(d, EncTtable, P)

HomeOffset = 0;
HomeRunTime = 10;

currCount = EncTtable(end) - EncTtable(1);
currCount = currCount/P.GBoxR;

deltaPulses = HomeOffset - currCount;

dt = 1/P.fs;
thome = 0:dt:HomeRunTime;

home_position = linspace(0, deltaPulses*P.pos_per_pulse, length(thome));
[pulse_home, ~] = position2pulses(home_position, thome, P.pos_per_pulse, P.fs);

PulseHomeData = [pulse_home(:,1) pulse_home(:,2)];

HomeData = readwrite(d, PulseHomeData);

end