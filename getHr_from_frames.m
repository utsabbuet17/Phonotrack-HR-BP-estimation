function [d1,finHr,finhr] = getHr_from_frames(mult,fs,idx1,frames8,frames4,frame_len_1,frame_len_2,yResample)


flen1 = frame_len_1;
flen2 = frame_len_2;
t10 = 0:1/fs:flen1-1/fs;  %% time definition
t6_1 = 0:1/fs:4-1/fs;  %% time definition
t6_2 = 2:1/fs:6-1/fs;  %% time definition
t6_3 = 4:1/fs:8-1/fs;  %% time definition



idx2 = (idx1-1)*mult+[1,2,3];

% figure(2)
% subplot(2,2,1)
% plot(t10,frames8(:,idx1))
% title("8s frame")
% subplot(2,2,2)
% plot(t6_1,frames4(:,idx2(1)))
% title("4s 1st frame")
% subplot(2,2,3)
% plot(t6_2,frames4(:,idx2(2)))
% title("4s 2nd frame")
% subplot(2,2,4)
% plot(t6_3,frames4(:,idx2(3)))
% title("4s 3rd frame")
% 
% figure(10)
% subplot(2,1,1)
% plot(t10,yResample(1:8*fs))
% title("8s frame")
% subplot(2,1,2)
% plot(t10,frames8(:,idx1))

%% bandpass filtering
fl = 20;
fh = 200;
order = 3;
[b,a] = butter(order,[fl/(fs/2) fh/(fs/2)],'bandpass');

d1 = filter(b,a,frames8(:,idx1)); %% filtering a frame out
d2 = filter(b,a,frames4(:,idx2(1)));
d3 = filter(b,a,frames4(:,idx2(2)));
d4 = filter(b,a,frames4(:,idx2(3)));

% figure
% subplot(221)
% plot(t10,d1)
% title("8s frame after bandpass filtering")
% subplot(222)
% plot(t6_1,d2)
% title("4s 1st frame after bandpass filtering")
% subplot(223)
% plot(t6_2,d3)
% title("4s 2nd frame after bandpass filtering")
% subplot(224)
% plot(t6_3,d4)
% title("4s 3rd frame after bandpass filtering")

%% wavelet denoising
d1 = wavelet_denoising(d1);
d2 = wavelet_denoising(d2);
d3 = wavelet_denoising(d3);
d4 = wavelet_denoising(d4);

figure
subplot(221)
plot(t10,d1)
title("8s frame after denoising")
subplot(222)
plot(t6_1,d2)
title("4s 1st frame after denoising")
subplot(223)
plot(t6_2,d3)
title("4s 2nd frame after denoising")
subplot(224)
plot(t6_3,d4)
title("4s 3rd frame after denoising")

%% get heart rates

delay = 200e-3*fs;%200e-3
multiplier = 0.12;%0.15;

% 8s heart rate
[pklg,lclg] = findpeaks(d1,'MinPeakDistance',delay,'MinPeakheight',multiplier*max(abs(d1)));%mean(abs(d1))

% new method
if mod(length(lclg),2) == 0
    idx = length(lclg);
else
    idx = length(lclg)-1;
end
T = (lclg(idx)-lclg(1))/fs;
numOfIntervals = floor(idx/2)-1;


Hr1 = 60*numOfIntervals/T;
% prev method
hr1 = (60*length(pklg))/(2*frame_len_1);

% figure
% subplot(221)
% plot(t10,d1)
% hold on
% plot(lclg/fs,pklg,"r*")
% title("8s frame after denoising")

% 4s heart rate
[pklg,lclg] = findpeaks(d2,'MinPeakDistance',delay,'MinPeakheight',multiplier*max(abs(d2)));%mean(abs(d2))

% new method
if mod(length(lclg),2) == 0
    idx = length(lclg);
else
    idx = length(lclg)-1;
end
T = (lclg(idx)-lclg(1))/fs;
numOfIntervals = floor(idx/2)-1;

Hr2 = 60*numOfIntervals/T;
% prev method
hr2 = (60*length(pklg))/(2*frame_len_2);

% subplot(222)
% plot(t6_1,d2)
% hold on
% plot(lclg/fs,pklg,"r*")
% title("4s 1st frame after denoising")

% 4s heart rate
[pklg,lclg] = findpeaks(d3,'MinPeakDistance',delay,'MinPeakheight',multiplier*max(abs(d3)));%mean(abs(d3))

% new method
if mod(length(lclg),2) == 0
    idx = length(lclg);
else
    idx = length(lclg)-1;
end
T = (lclg(idx)-lclg(1))/fs;
numOfIntervals = floor(idx/2)-1;

Hr3 = 60*numOfIntervals/T;
% prev method
hr3 = (60*length(pklg))/(2*frame_len_2);

% subplot(223)
% plot(t6_2,d3)
% hold on
% plot(lclg/fs+2,pklg,"r*")
% title("4s 2nd frame after denoising")

% 4s heart rate
[pklg,lclg] = findpeaks(d4,'MinPeakDistance',delay,'MinPeakheight',multiplier*max(abs(d4)));%mean(abs(d4))

% new method
if mod(length(lclg),2) == 0
    idx = length(lclg);
else
    idx = length(lclg)-1;
end
T = (lclg(idx)-lclg(1))/fs;
numOfIntervals = floor(idx/2)-1;

Hr4 = 60*numOfIntervals/T;
% prev method
hr4 = (60*length(pklg))/(2*frame_len_2);

% subplot(224)
% plot(t6_3,d4)
% hold on
% plot(lclg/fs+4,pklg,"r*")
% title("4s 3rd frame after denoising")

% new method
finHr = (Hr1+Hr2+Hr3+Hr4)/4;
% prev method
finhr = (hr1+hr2+hr3+hr4)/4;
end