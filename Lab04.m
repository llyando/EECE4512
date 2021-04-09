%% Read in data

clc; clear; close all;

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

%% Experiment 01: Plot Raw Data vs Time
close all;

k = 1;

rawData(k).ecg = detrend(dataSet(k).data(:,6));

% Plot rawData vs time in separate subplots
figure(k)
plot(dataSet(k).t,rawData(k).ecg)

title(labels(1,k))
xlabel('Time in sec'); ylabel('Raw Sensor');
grid on;
ax = gca;
ax.XRuler.MinorTick = 'on';

% Finding the local maxima with a rough MinProminence estimate.
% Just eyeballed it until it looked decent
ismax = islocalmax(rawData(k).ecg,'MinProminence',35);
maxIndices = find(ismax);
msPerBeat = mean(diff(maxIndices));
heartRate = 60*(100/msPerBeat);

formatSpec = '\n%s Heart Rate: %2.0f ';
fprintf(formatSpec,labels(1,k),heartRate);
snapnow

k = 5;

rawData(k).ecg = detrend(dataSet(k).data(:,6));

% Plot rawData vs time in separate subplots
figure(k)
plot(dataSet(k).t,rawData(k).ecg)

title(labels(1,k))
xlabel('Time in sec'); ylabel('Raw Sensor');
grid on;
ax = gca;
ax.XRuler.MinorTick = 'on';

% Finding the local maxima with a rough MinProminence estimate.
% Just eyeballed it until it looked decent
ismax = islocalmax(rawData(k).ecg,'MinProminence',65);
maxIndices = find(ismax);
msPerBeat = mean(diff(maxIndices));
heartRate = 60*(100/msPerBeat);

formatSpec = '\n%s Heart Rate: %2.0f \n';
fprintf(formatSpec,labels(1,k),heartRate);

snapnow
%% 01 Questions and Answers
% Was there variability between the beats? Would you expect the interval 
% between beats to be identical? Why or why not?

% There was variability between the beats. This makes sense as the distance from
% the heart was different. I would expect the variability between beats to be
% extremely close however. Assuming a healthy blood vessel system, then I
% couldn't imagine any issues with the

%% Experiment 02: Plot Raw Data vs Time
close all;

for k = 1:numOfFiles
   rawData(k).ecg = detrend(dataSet(k).data(:,6));
    
   % Plot rawData vs time in separate subplots
   figure(k)
   plot(dataSet(k).t,rawData(k).ecg)
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('Raw Sensor');
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    snapnow

ismax = islocalmax(rawData(k).ecg,'MinProminence',65);
maxIndices = find(ismax);
msPerBeat = mean(diff(maxIndices));
heartRate = 60*(100/msPerBeat);

formatSpec = '\n65: %s Heart Rate: %2.0f';
fprintf(formatSpec,labels(1,k),heartRate);

end

%% Experiment 02: Plot LowPass Filtered Data vs Time
close all;

cutOffFreq = 3;

for k = 1:numOfFiles
   rawData(k).ecg = detrend(dataSet(k).data(:,6));
     
   Fs = dataSet(k).header.samplingrate;
   filterLowPass = lowpass(rawData(k).ecg,cutOffFreq,Fs,'Steepness',0.95);
   
   figure(k)
   hold on
   plot(dataSet(k).t,rawData(k).ecg)
   plot(dataSet(k).t,filterLowPass, 'r' )
   hold off
   
   title(labels(1,k))
   xlabel('Time in sec'); ylabel('LowPass Filter');
   legend('Raw Data', 'LowPass Filtered Data')
   grid on;
   ax = gca;
   ax.XRuler.MinorTick = 'on';
    snapnow


ismax = islocalmax(rawData(k).ecg,'MinProminence',65);
maxIndices = find(ismax);
msPerBeat = mean(diff(maxIndices));
heartRate = 60*(100/msPerBeat);

formatSpec = '\n65: %s Heart Rate: %2.0f';
fprintf(formatSpec,labels(1,k),heartRate);

end

%% 02 Questions and Answers
% What physiological advantage is there in a slower resting heart rate?

% A slower resting heart rate means your heart is more efficient at pumping
% oxengentated blood around your body. Since it is stronger, it pumps less
% often, causing less wear on the heart over the lifetime of the person. Also it
% likely means that the heart can recover from high periods of activity faster,
% returning to a lower rate and easing the workload much faster than a not as
% healthy heart.


%% Plot BandPass Filtered Data vs Time (Just for reference)
% close all;
% 
% bandWindow = [1 5];
% 
% for k = 1:numOfFiles
%    rawData(k).ecg = detrend(dataSet(k).data(:,6));
%      
%    Fs = dataSet(k).header.samplingrate;
%    filterBandPass = bandpass(rawData(k).ecg,bandWindow,Fs);
%    
%    figure(k)
%    bandpass(rawData(k).ecg(1:10000),bandWindow,Fs);
%    %plot(dataSet(k).t,filterBandPass)
%    
%    title(labels(1,k))
%    xlabel('Time in sec'); ylabel('BandPass Filter');
%    grid on;
%    ax = gca;
%    ax.XRuler.MinorTick = 'on';
%     
% end
