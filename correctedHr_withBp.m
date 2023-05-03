clc;
clear all;
close all;

%% load pcg signal
filename = "Asif_sit_w1.m4a";

%"F:\Biomed_project\newBPalgo\codes\heart_rate_final\Biomed_Project\Collected_data_270123_SBH\pcg_data\Shovon_sit_B_1.m4a";

Duration = 10;

[y, Fs] = audioread(filename);
length(y)/Fs; %% this is the initial duration
y = y(1:Duration*Fs,1); % cropping 1st 120s of the data
t=0:1/Fs:(length(y)-1)/Fs ;
figure(1)
subplot(311)
plot(t,y)
xlim([0 8])
title("original signal")
xlabel('time/sec')
ylabel('amplitude')
ym=max(y);
ylim([-1.2*ym 1.2*ym])
grid on

%% Resampling to 8000 hz sampling frequency
fs = 8000;
yResample=resample(y,fs,Fs);
t1=0:1/fs:(length(yResample)-1)/fs ;

subplot(312)
plot(t1,yResample)
title("After Resampling to 8000 Hz")
xlim([0 8])
xlabel('time/sec')
ylabel('amplitude')
ylim([-1.2*max(yResample) 1.2*max(yResample)])
grid on

%% Normalization and scaling
yResample = normalize(yResample);
yResample = yResample/max(yResample);

subplot(313)
plot(t1,yResample)
title("After Normalization and Scaling")
xlim([0 8])
xlabel('time/sec')
ylabel('amplitude')
ylim([-1.2*max(yResample) 1.2*max(yResample)])
grid on

%% extracting frames
frame_len_1 = 8;
frame_len_2 = 4;
overlap    = 2;

[frames8,frames4] = extracting_frames_hr_1(yResample,fs,frame_len_1,frame_len_2,overlap);


flen1 = frame_len_1;
flen2 = frame_len_2;
t10 = 0:1/fs:flen1-1/fs;  %% time definition
t6_1 = 0:1/fs:4-1/fs;  %% time definition
t6_2 = 2:1/fs:6-1/fs;  %% time definition
t6_3 = 4:1/fs:8-1/fs;  %% time definition

[p1 q1] = size(frames8);
[p2 q2] = size(frames4);
mult = q2/q1;

% % this is the frame number
% idx1 = 10; % chose a frame of 10 s
% [d1,finHr,finhr] = getHr_from_frames(mult,fs,idx1,frames8,frames4,frame_len_1,frame_len_2);
% finHr
% finhr


%% saving parameters for BP

[p,q] = size(frames8);

% these are the parameters to save
finHrs = [];
finHrs2 = [];
ts1s = [];
ts2s = [];
systolRises = [];
systolDecays = [];
diastolRises = [];
diastolDecays = [];

Psys = [];
Pdias = [];

for idx1 = 1:q
    [d1,finHr,finhr] = getHr_from_frames(mult,fs,idx1,frames8,frames4,frame_len_1,frame_len_2,yResample);
    finHrs = [finHrs; finHr];
    finHrs2 = [finHrs2;finhr];
    [ts1,ts2,systolRise,systolDecay,diastolRise,diastolDecay] = Bpcomponents(d1);
    ts1s = [ts1s; ts1];
    ts2s = [ts2s; ts2];
    systolRises = [systolRises; systolRise];
    systolDecays = [systolDecays; systolDecay];
    diastolRises = [diastolRises; diastolRise];
    diastolDecays = [diastolDecays; diastolDecay];

    % relation derived
    ps = 100.5-80.070330*systolRise+103.470207*systolDecay+23.399877*ts1+0.167803*finhr;
    pd = 70.5-23.444477*diastolRise+37.530675*diastolDecay+14.086198*ts2+0.090402*finhr;

    Psys = [Psys; ps];
    Pdias = [Pdias; pd];
end


label_HR = zeros(size(finHrs));
label_Psys =zeros(size(finHrs));
label_Pdias =zeros(size(finHrs));

%save('F:\Biomed_project\newBPalgo\codes\heart_rate_final\Biomed_Project\Collected Data 2-2-23\csv_before_labels\270123_data\Shovon_sit_B_1.mat','finHrs','finHrs2','ts1s','ts2s','systolRises','systolDecays','diastolRises','diastolDecays','label_HR','label_Psys','label_Pdias');


% csvwrite('F:\Biomed_project\newBPalgo\codes\heart_rate_final\Final_dataset\ecg_pcg_21_subs\final_ds\ecgFrames_alvi_dumbbel_w3.csv',frames8);

% finHrs
% finHrs2

%% predictions

Heart_rate = finHrs2
systolPressure = Psys
diastolPressure = Pdias



%% printing in lcd
% % a = arduino('com7','uno','libraries','ExampleLCD/LCDAddon','ForceBuildOn',true);
% % lcd = addon(a,'ExampleLCD/LCDAddon','RegisterSelectPin','D12','EnablePin','D11','DataPins',{'D5','D4','D3','D2'});
% % initializeLCD(lcd);
% %% for loop
% for(i=1:15)
%     printLCD(lcd,'Heart rate =');
%     printLCD(lcd,int2str(Heart_rate(i)));
%     pause(1)
%     printLCD(lcd,'Psys =');
%     printLCD(lcd,int2str(systolPressure(i)));
%     pause(1)
%     printLCD(lcd,'Dsys =');
%     printLCD(lcd,int2str(diastolPressure(i)));
%     pause(1)
% end
% clearLCD(lcd);



