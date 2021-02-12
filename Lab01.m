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
   legend(fileNameList(k,:));
    
end

% Plot in terms of g using roughly estimated calibration values from data
% Not really necessary here, but interesting all the same.

for k = 1:numOfFiles
   
   % Determined that the 6th data file had the best calibration min and max
   % values, so those are used for the purposes of plotting this section.
   
   bestCalFit = 4;
   
   CMin = 406;
   CMax = 618;
   
   % Equation comes from the ACC data sheet using best fit from rotating
   %    along the Z-axis per the data sheet
   
   %  ACCg = 2 * (rawData(k).acc - min(rawData(bestCalFit).acc) ) / ...
   %  (max(rawData(bestCalFit).acc) - min(rawData(bestCalFit).acc) ) - 1;
   
   % Using Cmin and CMax from leaving the ACC on desk.
   ACCg = ( (rawData(k).acc - CMin ) / (CMax - CMin) ) * 2 - 1;
   
   figure(2)
   title("ACC normalised w/ cal max and min vs Time")  
   subplot(numOfFiles,1,k)
   plot(dataSet(k).t,ACCg)
   legend(fileNameList(k,:));

end

% Plot power spectra
for k = 1:numOfFiles
    
    Fs = dataSet(k).header.samplingrate;   % Sampling frequency                    
    T = 1/Fs;                              % Sampling period       
    L = length(dataSet(k).data);           % Length of signal
    f = Fs*(0:(L/2))/L;                    % Define freq domain

    figure(3)
    % title("Power Spectra vs Freq. using pspectrum func.")
    subplot(numOfFiles,1,k)
    pspectrum(rawData(k).acc,Fs)
    legend(fileNameList(k,:));


end

%% Testing actual fft usage instead of using pspectrum func.

for k = 1:numOfFiles

    Fs = dataSet(k).header.samplingrate;
    L = length(dataSet(k).data);

    Y = fft(rawData(k).acc);
    P2 = abs(Y/L);
    G = L/2+1;
    P1 = P2(1:G);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;

%     figure
%     plot(f,P1)
%     title('Single-Sided Amplitude Spectrum of X(t)')
%     xlabel('f (Hz)')
%     ylabel('|P1(f)|')

    Y = fft(rawData(k).acc);
    Z = conj(Y);
    X = abs(Y.*Z);
    freq = linspace(0,Fs,length(X));
    
    figure(4)
    title("Manual calcuation of Power Spectra vs Freq., w/ normalised log10 dB scale")
    
    subplot(numOfFiles,1,k)
    plot(freq,10*log10(X));
    xlabel('Hz'); ylabel('dB');
    legend(fileNameList(k,:));

end

%% 

f_s = dataSet(k).header.samplingrate; %sample frequency
f_n = f_s/2;                          % Nyquist Frequency

                                      % Fast fourier transform the signal
L = numel(rawData(k).acc);            % Assumes data Is A Vector
XP = fft(rawData(k).acc)/L;           % Normalised Result
Fv = linspace(0, 1, fix(L/2)+1)*f_n;  % Frequency Vector (One-Sided Transform)
Iv = 1:numel(Fv);                     % Index Vector

figure
plot(Fv, 10*log10(abs(XP(Iv))*2))
grid
