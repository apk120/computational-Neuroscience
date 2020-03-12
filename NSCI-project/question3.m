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
