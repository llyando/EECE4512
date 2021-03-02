clc; clear;

plotSpacing = 2;

% Create labels for subplots
labels = [ ...
"1000 Hz 30 sec. Bicep Flex",...
"1000 Hz 30 sec. Bicep Heavy", ...
"1000 Hz 30 sec. Bicep Resting",  ...
"1000 Hz 30 sec. Face Anger", ...
"1000 Hz 30 sec. Face Smile",  ...
"1000 Hz 30 sec. Tricep Flex", ...
"1000 Hz 30 sec. Tricep Heavy",  ...
"1000 Hz 30 sec. Tricep Resting"
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

% Extract raw data of sensor
%

figure(1)

for k = 1:numOfFiles
   rawData(k).acc = dataSet(k).data(:,6).';
    
   % Plot rawData vs time in separate subplots
   subplot(numOfFiles,plotSpacing,k)
   plot(dataSet(k).t,rawData(k).acc)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('Raw Sensor');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

sgtitle('Raw Data vs Time');

% Testing power spectra calculation.
%

figure(2)

for k = 1:numOfFiles

    Fs = dataSet(k).header.samplingrate;
    L = length(dataSet(k).data);
    
    Y = fft(rawData(k).acc);
    Z = conj(Y);
    X = abs(Y.*Z)/L;
    freq = linspace(0,Fs,length(X));
    
    subplot(numOfFiles,plotSpacing,k)
    plot(freq, X);
    
    title(labels(1,k))
    xlabel('Hz'); ylabel('Power Spectra');
    xlim([0 1])
    ylim([0 800])

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
    title(labels(1,k))
    xlim([0 3])

   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

   sgtitle('Power Spectra vs Freq. using pspectrum func.')