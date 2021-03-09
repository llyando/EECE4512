clc; clear;

plotSpacing = 2;

% Create labels for subplots
labels = [ ...
"Five Minute Reading", ...
"Thirty Second Reading"
];

% Data source folder
dataFolder = 'FinalProject/'; 
% Pull all text files from source folder
fileNameList = ls('FinalProject/*.txt');
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
   plot(dataSet(k).t, rawData(k).acc)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('Raw Sensor');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

sgtitle('Raw Data vs Time');

figure(2)

for k = 1:numOfFiles
   
   % These data points come from the LAB01/Data Calibration Recordings
   % files.
   CMin = 406;
   CMax = 618;
   
   % Equation comes from the ACC data sheet using best fit from rotating
   %    along the Z-axis per the data sheet
   
   %  ACCg = 2 * (rawData(k).acc - min(rawData(bestCalFit).acc) ) / ...
   %  (max(rawData(bestCalFit).acc) - min(rawData(bestCalFit).acc) ) - 1;
   
   % Using Cmin and CMax from leaving the ACC on desk.
   ACCg = ( (rawData(k).acc - CMin ) / (CMax - CMin) ) * 2 - 1;
   
    Fs = dataSet(k).header.samplingrate;   % Sampling frequency                    
    T = 1/Fs;                              % Sampling period       
    L = length(dataSet(k).data);           % Length of signal
    f = Fs*(0:(L/2))/L;  
   
    Y = fft(ACCg);
    Z = conj(Y);
    X = abs(Y.*Z)/L;
    freq = linspace(0,Fs,length(X));
     
   subplot(numOfFiles,plotSpacing,k)
   plot(dataSet(k).t,ACCg)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('g, (9.8 m/s^2)');
   ylim([-3 3])
   
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';

end

sgtitle('ACC g normalised vs time')

% Testing power spectra calculation.
%

figure(2)

for k = 1:numOfFiles

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
    xlim([0 1])

   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

   sgtitle('Power Spectra vs Freq.')
   