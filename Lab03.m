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
time = linspace(0,length(ppg_data)/Fs,length(ppg_data));

rawTrend = detrend(ppg_data);
Y = fft(rawTrend);
Z = conj(Y);
X = abs(Y.*Z)/L;

chosenSec = 4900;

figure
plot(time(chosenSec:chosenSec+1000), ppg_data(chosenSec:chosenSec+1000));
xlabel('Time in sec.'); ylabel('PPG Units');
title('01 sec. of PPG data: 4.9 to 5.0')

grid on;
ax = gca;
ax.XRuler.MinorTick = 'on';

%% Apply butterworth filter to data with the following:

n = [5, 2, 1]; %Order of filter
fc = [1, 2, 5, 20]; % Cutoff frequency

for k = 1:length(n)
    for g = 1:length(fc)
        [b,a] = butter(n(k),fc(g)/(Fs/2));
        figure
        plot(filter(b,a,ppg_data(chosenSec:chosenSec+1000)));
        title(['n = ',num2str(n(k)),', fc = ',num2str(fc(g))])
        hold on
        plot(ppg_data(chosenSec:chosenSec+1000))
        legend(['n = ',num2str(n(k)),', fc = ',num2str(fc(g))],'Original PPG')
        hold off
        
    end
end

%% Using n of 2 and fc of 20
% n of 2 and fc of 5 might be good to check for breathing rate

% n = 2;
% fc = 20;
% 
% [b,a] = butter(n,fc/(Fs/2));
% figure
% plot(filter(b,a,ppg_data));
% title(['n = ',num2str(n),', fc = ',num2str(fc)])
% hold on
% plot(ppg_data)
% legend(['n = ',num2str(n),', fc = ',num2str(fc)],'Original PPG')
% hold off

