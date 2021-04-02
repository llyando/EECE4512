%% Read in data

clc; clear; close all;

plotSpacing = 2;

% Create labels for plots
labels = [ ...
"Chest Lying Down",...
"Chest Running in Place", ...
"Chest Sitting and Standing",  ...
"Chest Squatting", ...
"Hand Lying Down",  ...
"Hand Running in Place", ...
"Hand Sitting and Standing", ...
"Hand Squatting"
];

% Data source folder
dataFolder = 'LAB04/'; 
% Pull all text files from source folder
fileNameList = ls('LAB04/*.txt');
% Get number of files for looping and parsing
numOfFiles = size(fileNameList,1);


% Put all data in nested struct for organisation
%
for k = 1:numOfFiles
    
    % Prepend dataFolder for further parsing
    path(k) = string( ...
              strcat(dataFolder, fileNameList(k,:)) ...
              );

    % Read in data
    [dataSet(k).data, dataSet(k).t, dataSet(k).header] = ...
        BITalinoFileReader(path(k));
end


%% Plot Raw Data vs Time
close all;

for k = 1:numOfFiles
   rawData(k).ecg = dataSet(k).data(:,6).';
    
   % Plot rawData vs time in separate subplots
   figure(k)
   plot(dataSet(k).t,rawData(k).ecg)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('Raw Sensor');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end


%% Plot LowPass Filtered Data vs Time
close all;

cutOffFreq = 2;

for k = 1:numOfFiles
   rawData(k).ecg = dataSet(k).data(:,6).';
     
   Fs = dataSet(k).header.samplingrate;
   filterLowPass = lowpass(rawData(k).ecg,cutOffFreq,Fs,'Steepness',0.95);
   
   figure(k)
   plot(dataSet(k).t,filterLowPass)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('LowPass Filter');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

%% Plot LowPass Filtered Data vs Time
close all;

bandWindow = [1 5];

for k = 1:numOfFiles
   rawData(k).ecg = dataSet(k).data(:,6).';
     
   Fs = dataSet(k).header.samplingrate;
   filterBandPass = bandpass(rawData(k).ecg,bandWindow,Fs);
   
   figure(k)
   bandpass(rawData(k).ecg,bandWindow,Fs);
   %plot(dataSet(k).t,filterBandPass)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('BandPass Filter');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end
