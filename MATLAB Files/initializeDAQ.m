function d = initializeDAQ(sampleRate)

d = daq("ni");
daqName = "Dev1";
% daqName2 = "Dev2";
d.Rate = sampleRate; % DAQ sample rate

% Load Cell channels

% chX = addinput(d, daqName,"ai12","Voltage");
% chY = addinput(d, daqName,"ai5","Voltage");
% chZ = addinput(d, daqName,"ai11","Voltage");
% 
% chX.TerminalConfig = 'SingleEnded';
% chY.TerminalConfig = 'SingleEnded';
% chZ.TerminalConfig = 'SingleEnded';

% Channels for motor motion

% pulse_ch = addoutput(d, daqName2,"port0/line9","Digital");
% dir_ch = addoutput(d, daqName2,"port0/line10","Digital");

% Counter and its clock for encoder tracking

% clock = addinput(d, daqName2,"ai3","Voltage");
% count = addinput(d, daqName2,"ctr0", "Position");
% count.InitialCount = (2^32)/2;
% count.EncoderType = "X4";

% Hydrophone Channel

hy_ch = addinput(d,daqName,"ai6","Voltage");
hy_ch.TerminalConfig = 'SingleEnded';

disp(d.Channels)

end
