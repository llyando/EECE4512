clc; clear;

% Data source folder
dataFolder = 'LAB01/'; 
% Pull all text files from source folder
fileNameList = ls('LAB01/*.txt');
% Get number of files for looping and parsing
numOfFiles = size(fileNameList,1);


% Put all data in nested struct for organisation
for k = 1:numOfFiles
    
    % Prepend dataFolder for further parsing
    path(k) = string( ...
              strcat(dataFolder, fileNameList(k,:)) ...
              );

     % Read in data
    [dataSet(k).data, dataSet(k).t, dataSet(k).header] = ...
        BITalinoFileReader(path(k));
end

% Extract raw data of sensor
for k = 1:numOfFiles
   rawData(k).acc = dataSet(k).data(:,6).';
    
   % Plot rawData vs time in separate subplots
   figure(1)
   title("Raw Data vs Time")
   subplot(numOfFiles,1,k)
   plot(dataSet(k).t,rawData(k).acc)
    
end

% Plot in terms of g using roughly estimated calibration values from data
% Not really necessary here, but interesting all the same.

for k = 1:numOfFiles
   
   ACCg = 2 * (rawData(k).acc - min(rawData(k).acc) ) / ...
   (max(rawData(k).acc) - min(rawData(k).acc) ) - 1;
   
   figure(2)
   title("ACC g vs Time")  
   subplot(numOfFiles,1,k)
   plot(dataSet(k).t,ACCg)

end

% Plot power spectra
for k = 1:numOfFiles
    
    Fs = dataSet(k).header.samplingrate;   % Sampling frequency                    
    T = 1/Fs;                              % Sampling period       
    L = length(dataSet(k).data);           % Length of signal
    f = Fs*(0:(L/2))/L;                    % Define freq domain

    figure(3)
    title("Power Spectra vs Freq.")
    subplot(numOfFiles,1,k)
    pspectrum(rawData(k).acc,Fs)

end

%% Testing actual fft usage instead of using pspectrum func.
Y = fft(rawData(k).acc);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

Y = abs(fft(rawData(k).acc)).^2;
figure
plot(dataSet(k).t,rawData(k).acc)
figure
plot(dataSet(k).t,Y)
