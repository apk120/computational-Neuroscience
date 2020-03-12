%question 2
BFS= 62.5*2.^(1:1/8:7);
psthbinwidth=1e-3;
[y, Fs]= audioread("fivewo.wav");
[P, Q]= rat(100000/ Fs);
y= resample(y, P, Q);
y= y(9.5e4:13e4);
envelope= imdilate(abs(y), true(1500, 1));
plot(envelope);
hold on;
quietparts= envelope<0.05;
plot(quietparts);
signal= y(5628:2.5627e4);%2.185e4
plot(signal);
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