function [ts1,ts2,systolRise,systolDecay,diastolRise,diastolDecay] = Bpcomponents(demoFrame8)

figure
subplot(211)
tm = linspace(0,8,64000);
plot(tm,demoFrame8)
grid on
title("given frame 8s at 8000 Hz")


% step 1 : resampling
win = 4; % fine tune
idxsys = 1;
demo1 = [];
while idxsys+win <= length(demoFrame8)
    frame1 = demoFrame8(idxsys:idxsys+win);
    idxsys = idxsys+win;
    demo1 = [demo1 max(frame1)];
end
demo1 = [demo1 0];

size(demo1)

fs = 2000;
tdemo = linspace(0,8,16000);

subplot(212)
plot(tdemo,demo1)
grid on
title("after peak based resampling to 2000 Hz")

% thresholding so that amplitudes lower than 0.1*peak gets 0
thresh  = 0.15*max(demoFrame8);
% th = thselect(demo1,'rigrsure')
demo1(demo1<thresh) = 0;

% find the position of maxpeak nad other peaks
[maxpeak,maxidx] = max(demo1);

delay = 200e-3*fs;%200e-3
multiplier = 0.12;%0.15;

[pklg,lclg] = findpeaks(demo1,'MinPeakDistance',delay,'MinPeakheight',multiplier*max(abs(demo1)));

figure
subplot(211)
plot(tdemo,demo1)
grid on
title("after thresholding")

subplot(212)
plot(tdemo,demo1,lclg/fs,pklg,"r*")
grid on
title("Peak detection")



% dias
h = find(lclg == maxidx);
if h == 1
    h = 3;
end
if length(lclg) == 1
    ts1 = 0;
    ts2 = 0;
    systolRise = 0;
    systolDecay = 0;
    diastolRise = 0;
    diastolDecay = 0;
else
    td = lclg(h) - lclg(h-1);

% sys
h = find(lclg == maxidx);
if length(lclg) == h
    h = length(lclg)-2;
end
ts = lclg(h+1) - lclg(h);

td = td/fs;
ts = ts/fs;

% finding out durations
idx1 = maxidx;
idxdias = find(lclg == maxidx);

if length(lclg) == idxdias
    idxdias = idxdias-2;
    idxdias = lclg(idxdias);
else
    idxdias = lclg(find(lclg == maxidx)+1);
end

i1 = idx1-1;
i2 = idx1+1;
ts1 = 0;
ts2 = 0;

systolRise = 0;
systolDecay = 0;
diastolRise = 0;
diastolDecay = 0;


while 1
    
    if sum(demo1(i1-10:i1)) + sum(demo1(i2:i2+10)) == 0
        ts1 = (i2 - i1)/fs;
        systolRise = (idx1-i1)/fs;
        systolDecay = (i2-idx1)/fs;
        break
    elseif  sum(demo1(i1-10:i1)) == 0 & sum(demo1(i2:i2+10)) ~= 0
            i2 = i2+1;
    elseif sum(demo1(i1-10:i1)) ~= 0 & sum(demo1(i2:i2+10)) == 0
            i1 = i1-1;
    else
        i1 = i1-1;
        i2 = i2+1;
    end
        
end

i1 = idxdias-1;
i2 = idxdias+1;

while 1
    
    if sum(demo1(i1-10:i1)) + sum(demo1(i2:i2+10)) == 0
        ts2 = (i2 - i1)/fs;
        diastolRise = (idxdias-i1)/fs;
        diastolDecay = (i2-idxdias)/fs;
        break
    elseif  sum(demo1(i1-10:i1)) == 0 & sum(demo1(i2:i2+10)) ~= 0
            i2 = i2+1;
    elseif sum(demo1(i1-10:i1)) ~= 0 & sum(demo1(i2:i2+10)) == 0
            i1 = i1-1;
    else
        i1 = i1-1;
        i2 = i2+1;
    end
        
end

end

end