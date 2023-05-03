function denoisedFrame = wavelet_denoising(demoFrame)

multiplier = 0.25;%0.15;

% levels 8 default
filtname = 'db4';
levels = 8;
% step 1 : Wavelet decomposing to 8 scales
[C,L] = wavedec(demoFrame,levels,filtname); % decomposing intro 8 wavelets
[d1,d2,d3,d4,d5,d6,d7,d8 ] = detcoef(C,L,[1 2 3 4 5 6 7 8]);
a8 = appcoef(C,L,'db4',8);
% step 2: sure shrink thresholding
a8(abs(a8)<multiplier*max(abs(a8)))=0;%thselect(a8,'rigrsure')
d8(abs(d8)<multiplier*max(abs(d8)))=0;%thselect(d8,'rigrsure')
d7(abs(d7)<multiplier*max(abs(d7)))=0;%thselect(d7,'rigrsure')
d6(abs(d6)<multiplier*max(abs(d6)))=0;%thselect(d6,'rigrsure')
d5(abs(d5)<multiplier*max(abs(d5)))=0;%thselect(d5,'rigrsure')
d4(abs(d4)<multiplier*max(abs(d4)))=0;%thselect(d4,'rigrsure')
d3(abs(d3)<multiplier*max(abs(d3)))=0;%thselect(d3,'rigrsure')
d2(abs(d2)<multiplier*max(abs(d2)))=0;%thselect(d2,'rigrsure')
d1(abs(d1)<multiplier*max(abs(d1)))=0;%thselect(d1,'rigrsure')

% reshaping
a8 = reshape(a8,[length(a8),1]);
d8 = reshape(d8,[length(d8),1]);
d7 = reshape(d7,[length(d7),1]);
d6 = reshape(d6,[length(d6),1]);
d5 = reshape(d5,[length(d5),1]);
d4 = reshape(d4,[length(d4),1]);
d3 = reshape(d3,[length(d3),1]);
d2 = reshape(d2,[length(d2),1]);
d1 = reshape(d1,[length(d1),1]);

% step 3 : reconstruction
recon = [a8; d8; d7; d6; d5; d4; d3; d2; d1];
denoisedFrame = waverec(recon,L,filtname);

end