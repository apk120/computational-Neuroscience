%question 1:
BFS= [500, 4000];
a= length(0:1/8:9);
psthbinwidth=0.1e-3;
%plot rate vs frequency at different intensity
for j= 1:2
    BF= BFS(j);
    in_array= zeros([10, a]);
    for intensity= -10:10:80
        freq_array=zeros([1,a]);
        k=1;
        for frequency= 62.5*2.^(0:1/8:9)
            time=0;
            spikes=0;
            [Psth, psthtime]= fiber_response(BF, frequency, intensity, 50);
            for i=1:length(psthtime)
                if (psthtime(i)<=0.2)
                    time=time+1;
                end
            end
            for i=1:time
                spikes= spikes+ Psth(i)*psthbinwidth;
            end
            freq_array(1, k)=spikes/0.2;
            k=k+1;
        end
        in_array(intensity/10+2,:)= freq_array;
    end
    figure(j)
    for i= 1:10
        semilogx(62.5*2.^(0:1/8:9), in_array(i, :));
        hold on;
    end
    legend("-10dB", "0dB","10dB","20dB","30dB","40dB","50dB","60dB","70dB","80dB");
    hold off;
end
%plot rate vs intensity
for j=1:2
    BF= BFS(j);
    in_array= zeros([10, 1]);
    for intensity= -10:10:80
        k=1;
        time=0;
        spikes=0;
        [Psth, psthtime]= fiber_response(BF, BF, intensity, 50);
        for i=1:length(psthtime)
            if (psthtime(i)<=0.2)
                time=time+1;
            end
        end
        for i=1:time
            spikes= spikes+ Psth(i)*psthbinwidth;
        end
        spikes=spikes/0.2;
        k=k+1;
        in_array(intensity/10+2,1)= spikes;
    end
    figure(3)
    plot(-10:10:80, in_array);
    hold on;
end
legend("500Hz", "4kHZ");
hold off;
%question 2
BFS= 62.5*2.^(1:1/8:7);
psthbinwidth=1e-3;
[y, Fs]= audioread("fivewo.wav");
[P, Q]= rat(100000/ Fs);
y= resample(y, P, Q);
y= y(9.5e4:13e4);
envelope= imdilate(abs(y), true(1500, 1));
hold on;
quietparts= envelope<0.05;
signal= y(5628:2.5627e4);%2.185e4
audiowrite("ah.wav", signal, 100000);
%db Value
dB_spl= 20*log10(rms(signal*10^(49/20)));
%rate response 500hz
BF= 500;
in_array= zeros([11, 1]);
for intensity= -20:10:80
    k=1;
    time=0;
    spikes=0;
    [Psth, psthtime]= fiber_response_ah(BF, signal, intensity, 50);
    for i=1:length(psthtime)
        if (psthtime(i)<=0.2)
            time=time+1;
        end
    end
    for i=1:time
        spikes= spikes+ Psth(i)*psthbinwidth;
    end
    spikes=spikes/0.2;
    k=k+1;
    in_array(intensity/10+3,1)= spikes;
end
figure(4)
plot(-20:10:80, in_array);
hold on;
% Threshold determined as 10dB-- 
%20dB just above threshold, 40 dB in dynamic range and 70dB in saturation 
% 49 fibres from 125 hz as the minimum BF allowed is 80Hz
spls= [20, 40, 70];
psth_table= [];
psth_times=[];
for spl=spls
    intensity= spl;
    for BF= BFS
        [Psth, psthtime]= fiber_response_ah(BF, signal, intensity, 50);
        psth_table= [psth_table; Psth];
        psth_times= [psth_times; psthtime];
    end
end

% Generate the spectrogram of sound signal
signal_spec= spectrogram(signal, 25.6*100, 12.8*100);
figure(5)
spectrogram(signal, 25.6*100, 12.8*100, 'yaxis');

%Generate the psth windows 
windows=[4, 8, 16, 32, 64, 128];
psth_4ms=[];
psth_8ms=[];
psth_16ms=[];
psth_32ms=[];
psth_64ms=[];
psth_128ms=[];

w= windows(1);
psth_win= [];
c= ones([1, w]);
for i= 1:49*3
    s= psth_table(i,:);
    sum_arr=[];
    for j=1:(w/2):(length(s)-mod(length(s), w/2)-(w))
        su= sum(s(j:j+w));
        sum_arr=[sum_arr, su];
    end
    psth_win=[psth_win; sum_arr];
end
psth_4ms=[psth_4ms; psth_win];

w= windows(2);
psth_win= [];
c= ones([1, w]);
for i= 1:49*3
    s= psth_table(i,:);
    sum_arr=[];
    for j=1:(w/2):(length(s)-mod(length(s), w/2)-(w))
        su= sum(s(j:j+w));
        sum_arr=[sum_arr, su];
    end
    psth_win=[psth_win; sum_arr];
end
psth_8ms=[psth_8ms; psth_win];

w= windows(3);
psth_win= [];
c= ones([1, w]);
for i= 1:49*3
    s= psth_table(i,:);
    sum_arr=[];
    for j=1:(w/2):(length(s)-mod(length(s), w/2)-(w))
        su= sum(s(j:j+w));
        sum_arr=[sum_arr, su];
    end
    psth_win=[psth_win; sum_arr];
end
psth_16ms=[psth_16ms; psth_win];

w= windows(4);
psth_win= [];
c= ones([1, w]);
for i= 1:49*3
    s= psth_table(i,:);
    sum_arr=[];
    for j=1:(w/2):(length(s)-mod(length(s), w/2)-(w))
        su= sum(s(j:j+w));
        sum_arr=[sum_arr, su];
    end
    psth_win=[psth_win; sum_arr];
end
psth_32ms=[psth_32ms; psth_win];

w= windows(5);
psth_win= [];
c= ones([1, w]);
for i= 1:49*3
    s= psth_table(i,:);
    sum_arr=[];
    for j=1:(w/2):(length(s)-mod(length(s), w/2)-(w))
        su= sum(s(j:j+w));
        sum_arr=[sum_arr, su];
    end
    psth_win=[psth_win; sum_arr];
end
psth_64ms=[psth_64ms; psth_win];

w= windows(6);
psth_win= [];
c= ones([1, w]);
for i= 1:49*3
    s= psth_table(i,:);
    sum_arr=[];
    for j=1:(w/2):(length(s)-mod(length(s), w/2)-(w))
        su= sum(s(j:j+w));
        sum_arr=[sum_arr, su];
    end
    psth_win=[psth_win; sum_arr];
end
psth_128ms=[psth_128ms; psth_win];

%plot the images
figure(61)
subplot(3,1,1)
imagesc(2:2:400,BFS,  psth_4ms(1:49, :))
title('10dB')
subplot(3,1,2)
imagesc(2:2:400,BFS,  psth_4ms(50:98, :))
title('40dB')
subplot(3,1,3)
imagesc(2:2:400,BFS,  psth_4ms(99:147, :))
title('70dB')
figure(62)
subplot(3,1,1)
imagesc(2:2:400,BFS,  psth_8ms(1:49, :))
subplot(3,1,2)
imagesc(2:2:400,BFS,  psth_8ms(50:98, :))
subplot(3,1,3)
imagesc(2:2:400,BFS,  psth_8ms(99:147, :))
figure(63)
subplot(3,1,1)
imagesc(2:2:400,BFS,  psth_16ms(1:49, :))
subplot(3,1,2)
imagesc(2:2:400,BFS,  psth_16ms(50:98, :))
subplot(3,1,3)
imagesc(2:2:400,BFS,  psth_16ms(99:147, :))
figure(64)
subplot(3,1,1)
imagesc(2:2:400,BFS,  psth_32ms(1:49, :))
subplot(3,1,2)
imagesc(2:2:400,BFS,  psth_32ms(50:98, :))
subplot(3,1,3)
imagesc(2:2:400,BFS,  psth_32ms(99:147, :))
figure(65)
subplot(3,1,1)
imagesc(2:2:400,BFS,  psth_64ms(1:49, :))
subplot(3,1,2)
imagesc(2:2:400,BFS,  psth_64ms(50:98, :))
subplot(3,1,3)
imagesc(2:2:400,BFS,  psth_64ms(99:147, :))
figure(66)
subplot(3,1,1)
imagesc(2:2:400,BFS,  psth_128ms(1:49, :))
subplot(3,1,2)
imagesc(2:2:400,BFS,  psth_128ms(50:98, :))
subplot(3,1,3)
imagesc(2:2:400,BFS,  psth_128ms(99:147, :))
%
%question 3
BFS= 125*2.^(0:1/2:4);
psthbinwidth=0.1e-3;
[y, Fs]= audioread("fivewo.wav");
[P, Q]= rat(100000/ Fs);
y= resample(y, P, Q);
signal= transpose(y);
psth_arr=[];
for BF= BFS
    psth_o= zeros([1, 160002]);
    for i=1:50
        [psth_h, psthtime]= fiber_response_speech(BF, signal, 10, 1);
        psth_o= psth_o+ psth_h./50;
    end
    psth_arr=[psth_arr; psth_o];
end
window= 12.8*100;
fft_psth=[];
figure
for i= 1:9
    s= zeros([1, 1280]);
    f_array=[];
    t_array=[];
    for j= 1:window/2:(length(psth_arr(1, :))- window)
        s= abs(fft(psth_arr(i, j:j+window-1)));
        [f, t]= max(s(2:end-1));
        f_array=[f_array, f];
        t_array=[t_array, t];
        
    end
    scatter(f_array, t_array, '*');
    hold on
    fft_psth=[fft_psth; s/length(psth_arr(1, :)*2/window)];
end

function [Psth, psthtime]= fiber_response(BF, stim_freq, stim_db, n_rep)
CF    = BF; % CF in Hz;   
cohc  = 1.0;   % normal ohc function
cihc  = 1.0;   % normal ihc function
fiberType = 3; % spontaneous rate (in spikes/s) of the fiber BEFORE refractory effects; "1" = Low; "2" = Medium; "3" = High
implnt = 0;    % "0" for approximate or "1" for actual implementation of the power-law functions in the Synapse
% stimulus parameters
F0 = stim_freq;     % stimulus frequency in Hz
Fs = 100e3;  % sampling rate in Hz (must be 100, 200 or 500 kHz)
T  = 200e-3;  % stimulus duration in seconds
rt = 10e-3;   % rise/fall time in seconds
stimdb = stim_db; % stimulus intensity in dB SPL
% PSTH parameters
nrep=n_rep;
psthbinwidth = 0.1e-3; % binwidth in seconds;

t = 0:1/Fs:T-1/Fs; % time vector
mxpts = length(t);
irpts = rt*Fs;

pin = sqrt(2)*20e-6*10^(stimdb/20)*sin(2*pi*F0*t); % unramped stimulus
pin(1:irpts)=pin(1:irpts).*(0:(irpts-1))/irpts; 
pin((mxpts-irpts):mxpts)=pin((mxpts-irpts):mxpts).*(irpts:-1:0)/irpts;

vihc = catmodel_IHC(pin,CF,nrep,1/Fs,T*2,cohc,cihc); 
[synout,psth] = catmodel_Synapse(vihc,CF,nrep,1/Fs,fiberType,implnt);

timeout = (1:length(psth))*1/Fs;
psthbins = round(psthbinwidth*Fs);  % number of psth bins per psth bin
psthtime = timeout(1:psthbins:end); % time vector for psth
pr = sum(reshape(psth,psthbins,length(psth)/psthbins))/nrep; % pr of spike in each bin
Psth = pr/psthbinwidth; % psth in units of spikes/s
end