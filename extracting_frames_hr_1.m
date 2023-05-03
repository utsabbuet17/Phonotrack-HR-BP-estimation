function [frames10,frames6] = extracting_frames_hr_1(sig,fs,frame_len_1,frame_len_2,overlap)

% framelen = 10, overlap = 4

fp1 = frame_len_1*fs;% 10s frame
fp2 = frame_len_2*fs;% 6s frame

count_num_10 = 0;
count_num_6 = 0;
idx = 0;
% [p q] = size(sig)
q = length(sig);
frames10 = [];
frames6 = [];
lastidx = 0;

count = 0;
while(idx+fp1<=q)

    % for the 10s frame
    frames10 = cat(2,frames10,sig(idx+1:idx+fp1));
    
    % for the 6s frame
    idx2 = idx;
    while(idx2+fp2<=idx+fp1)
        frames6 = cat(2,frames6,sig(idx2+1:idx2+fp2));
        count_num_6 = count_num_6+1; % no use
        idx2 = idx2 + (frame_len_2-overlap)*fs;
    end
    lastidx = idx+fp1; % may be not using
    idx = idx + frame_len_1*fs;
    count_num_10 = count_num_10+1;%no use
end

end