function [heart_rate] = PPG_reading(sub_num,startTime,endTime,...
    apply_filter,apply_peak,apply_pspectrum)
close all
folder_name = ['Lab03/'];
file_name = ['PPG_Sub' num2str(sub_num) '.txt'];
fid = fopen([folder_name file_name],'r');

% read out the data
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
data(1) = [];

% number of samples per sampling interval
nr_samples = data(1);
data(1) = [];
ppg_data = data;


% shorten the signal to have the same signal length in all trials
shorten_sig = 1;
%Shortening of the PPG data
ppg_time = [0:1/sampl_rate:numel(ppg_data)/sampl_rate]';
len = min (numel(ppg_data),numel(ppg_time));
ppg_time = ppg_time(1:len);
ppg_data = ppg_data(1:len);
if(shorten_sig == 1) %consider only the the interval given by Start and End Time
    ppg_data = ppg_data(startTime*sampl_rate+1:endTime*sampl_rate);
    ppg_time = ppg_time(startTime*sampl_rate+1:endTime*sampl_rate)-ppg_time(startTime*sampl_rate);
end

%Display ppg_ir versus time

figure(1)
subplot(4,1,1)
plot(ppg_time, ppg_data),
title('PPG--IR--Raw')
ylabel('Normalized unit')
xlabel('Time (s)')
grid on


if apply_filter == 1
    %%%%%%%%%%%% Lowpass filtering of PPG signal %%%%%%%%%%%%%
    n_order = 2;
    % corner frequency of the lowpass filter in Hz
    f_c = 1;
    ppg_data_filtered = lowpass_filter(ppg_data, sampl_rate, n_order,f_c);
    
    figure(1)
    subplot(4,1,2)
    plot(ppg_time, ppg_data_filtered), hold on
    title('PPG--IR--Filtered')
    ylabel('Normalized unit')
    xlabel('Time (s)')
    grid on
end

if apply_peak == 1
    %%%%%%%%%%%%%% Find peaks %%%%%%%%%%%%%
    max_pulse = 120;
    [ppg_pks,ppg_pks_loc] = find_peaks(ppg_data_filtered, ppg_time, sampl_rate,max_pulse);
    heart_rate = 60*numel(ppg_pks)/(endTime-startTime);
    figure(1)
    subplot(4,1,3)
    plot(ppg_time, ppg_data_filtered), hold on
    plot(ppg_pks_loc, ppg_pks, 'r*')
    title('PPG--IR--Filtered')
    ylabel('Normalized unit')
    xlabel('Time (s)')
    grid on
    legend(['Heart Rate = ' num2str(heart_rate) ' beats/min'])
end

    
if apply_pspectrum == 1
       
    Fs = sampl_rate;
    L = length(ppg_data);

    Y = fft(detrend(ppg_data));
    Z = conj(Y);
    X = abs(Y.*Z)/L;
    freq = linspace(0,Fs,length(X));
    
    figure
    plot(freq, X)
    xlabel('Hz'); ylabel('dB');
    title('Frequency plot: 30Hz Fundamental')
    xlim([0 250])
    ylim([0 10*10^-5])

   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
   
   figure
   pspectrum(ppg_data, Fs);
    xlabel('Hz'); ylabel('dB');
    xlim([0 250])

   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end
    
% End of Function
end

function data_filtered = lowpass_filter(data, sampl_rate, n_order,f_c);
[b_low,a_low] = butter(n_order,f_c/sampl_rate,'low');
data_filtered = filtfilt(b_low,a_low,data);
end

function [data_pks,data_pks_loc] = find_peaks(data, time, sampl_rate,max_pulse);
[pks,pks_loc] = findpeaks(data,'MINPEAKDISTANCE',sampl_rate/(max_pulse/60));
data_pks = pks;
data_pks_loc = time(pks_loc);
end
