clc; clear; close all;

fid = fopen(['Lab03/PPG_Sub491.txt'],'r');

% read in the data
read_in = textscan(fid,'%f');
data = read_in{1};
% close the file after reading
fclose(fid);
% timestamp of the NI DAQ recording
NI_timestamp(1) = data(1);
NI_timestamp(2) = data(2);
NI_timestamp(3) = data(3);
NI_timestamp(4) = data(4);
NI_timestamp(5) = data(5);
NI_timestamp(6) = data(6);
% remove the timestamp from data
data(1:6) = [];
% sampling rate
sampl_rate = data(1);
% Remove sampling rate from data
data(1) = [];
% number of samples per sampling interval
nr_samples = data(1);
data(1) = [];
ppg_data = data;

%% Plot 1 minute of ppg data which has the least artifacts
%

Fs = sampl_rate;
L = length(ppg_data);
freq = linspace(0,Fs,length(ppg_data));
time = length(ppg_data)/Fs;

rawTrend = detrend(ppg_data);
Y = fft(rawTrend);
Z = conj(Y);
X = abs(Y.*Z)/L;

figure
plot(time, ppg_data);
xlabel('Time in sec.'); ylabel('Power Spectra');
xlim([0 1])

grid on;
ax = gca;
ax.XRuler.MinorTick = 'on';

sgtitle('Power Spectra vs Freq.')