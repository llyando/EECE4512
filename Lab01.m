clc; clear;

% Create labels for subplots
labels = [ ...
"1000 Hz 30 sec. ACC working direction",...
"100 Hz 30 sec. ACC working direction", ...
"10 Hz 30 sec. ACC working direction",  ...
"1000 Hz 60 sec. Stepping Up and Down", ...
"100 Hz 60 sec. Stepping Up and Down",  ...
"1000 Hz 60 sec. Walking",              ...
"100 Hz 60 sec. Walking",               ...
"1000 Hz 60 sec. Walking Jeans",        ...
"100 Hz 60 sec. Walking Jeans"          ...
];

% Data source folder
dataFolder = 'LAB01/'; 
% Pull all text files from source folder
fileNameList = ls('LAB01/*.txt');
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
   subplot(numOfFiles,1,k)
   plot(dataSet(k).t,rawData(k).acc)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('Raw Sensor');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    
end

sgtitle('Raw Data vs Time');

% Plot in terms of g using roughly estimated calibration values from data
% 

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
   
    Y = fft(ACCg)/L;
    Z = conj(Y);
    X = abs(Y.*Z);
    freq = linspace(0,Fs,length(X));
     
   subplot(numOfFiles,1,k)
   plot(dataSet(k).t,ACCg)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('g, being 9.8 m/s^2');
   ylim([-3 3])
   
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';

end

sgtitle('ACC g normalised vs time')


% Testing power spectra calculation.
%

figure(3)

for k = 1:numOfFiles

    Fs = dataSet(k).header.samplingrate;
    L = length(dataSet(k).data);

    Y = fft(rawData(k).acc)/L;
    Z = conj(Y);
    X = abs(Y.*Z);
    freq = linspace(0,Fs,length(X));
    
    subplot(numOfFiles,1,k)
    plot(freq, 10*log10(X));
    
    title(labels(1,k))
    xlabel('Hz'); ylabel('Power Spectra in dB');
    xlim([0 1])

   grid on;
   ax = gca
   ax.XRuler.MinorTick = 'on';
    
end

   sgtitle('Power Spectra vs Freq.')