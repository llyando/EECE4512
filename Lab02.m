clc; clear; close all;

plotSpacing = 1;

% Create labels for subplots
labels = [ ...
"1000 Hz 30 sec. Bicep Flex",...
"1000 Hz 30 sec. Bicep Heavy", ...
"1000 Hz 30 sec. Bicep Resting",  ...
"1000 Hz 30 sec. Tricep Flex", ...
"1000 Hz 30 sec. Tricep Heavy",  ...
"1000 Hz 30 sec. Tricep Resting", ...
"1000 Hz 30 sec. Face Anger", ...
"1000 Hz 30 sec. Face Smile"
];

% Data source folder
dataFolder = 'LAB02/'; 
% Pull all text files from source folder
fileNameList = ls('LAB02/*.txt');
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

% Plot BICEP DATA
figure

for k = 1:3
   rawData(k).acc = dataSet(k).data(:,6);
    
   % Plot rawData vs time in separate subplots
   subplot(3,plotSpacing,k)
   
   rawTrend = detrend(rawData(k).acc);
   plot(dataSet(k).t,rawTrend)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('Raw Sensor Units');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

sgtitle('Raw Data vs Time');

% Plot TRICEP DATA
figure

for k = 4:6
   rawData(k).acc = dataSet(k).data(:,6);
    
   % Plot rawData vs time in separate subplots
   subplot(3,plotSpacing,k-3)
   
   rawTrend = detrend(rawData(k).acc);
   plot(dataSet(k).t,rawTrend)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('Raw Sensor Units');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

sgtitle('Raw Data vs Time');

% Plot TRICEP DATA
figure

for k = 7:8
   rawData(k).acc = dataSet(k).data(:,6);
    
   % Plot rawData vs time in separate subplots
   subplot(2,plotSpacing,k-6)
   
   rawTrend = detrend(rawData(k).acc);
   plot(dataSet(k).t,rawTrend)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('Raw Sensor Units');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

sgtitle('Raw Data vs Time');

% Plot Power Spectra of all plots
%

% Changing plotspacing so make 8 plots show up better
plotSpacing = 2;

figure

for k = 1:numOfFiles

    rawData(k).acc = dataSet(k).data(:,6).';
    Fs = dataSet(k).header.samplingrate;
    L = length(dataSet(k).data);
    rawTrend = detrend(rawData(k).acc);
    Y = fft(rawTrend);
    Z = conj(Y);
    X = abs(Y.*Z)/L;
    freq = linspace(0,Fs,length(X));
    
    subplot(numOfFiles,plotSpacing,k)
    
    plot(freq, X);
    
    title(labels(1,k))
    xlabel('Hz'); ylabel('Power Spectra');
    xlim([0 1.5])

   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

   sgtitle('Power Spectra vs Freq.')

   
%% Using pspectrum function to check manually calculated results.
% 
% Only referenced in report for comparison. Not really used elsewhere,
% since I couldn't understand the results as well as I would've liked.
   figure(4)

for k = 1:numOfFiles

    Fs = dataSet(k).header.samplingrate;
    L = length(dataSet(k).data);

    Y = fft(rawData(k).acc);
    Z = conj(Y);
    X = abs(Y.*Z)/L;
    freq = linspace(0,Fs,length(X));
    
    subplot(numOfFiles,plotSpacing,k)
    pspectrum(rawData(k).acc, Fs);
    xlabel('Hz'); ylabel('dB');
    xlim([0 3])

   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

   sgtitle('Power Spectra vs Freq. using pspectrum func.')