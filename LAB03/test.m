timeRange = [1 30 60 90 120 150 180 210 240 270 300];
for k = 1:10
    heartRate(k) = PPG_reading(491, timeRange(k), timeRange(k+1), 1, 1,0);
end
close all;

hist(heartRate,10)
title('Heart Rate Avg')
avgHeartRate = sum(heartRate)/length(heartRate)
beatsPerSecond = avgHeartRate/60


    
