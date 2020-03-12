[y, Fs]= audioread("fivewo.wav");
[P, Q]= rat(12000/ Fs);
y= resample(y, P, Q);
signal= transpose(y);
fn= 6000;
fs= 12000;
%1 band
[b, a]= butter(4, [90/fn, 5760/fn], 'bandpass');
bpass_signal= filtfilt(b, a, signal);
envelope_signal= (hilbert(bpass_signal));
noise = wgn(length(envelope_signal),1,0,'complex');
mod= zeros([1, length(envelope_signal)]);
for i=1:length(noise)
    mod(1, i)= (1/rms(noise))*real(envelope_signal(i)*noise(i));
end
mod= filtfilt(b, a, mod);
plot(1:19201,mod);
audiowrite("1band.wav", mod, 12000);
%2band
[b, a]= butter(4, [90/fn, 720/fn], 'bandpass');
bpass_signal= filtfilt(b, a, signal);
envelope_signal= (hilbert(bpass_signal));
noise = wgn(length(envelope_signal),1,-50,'complex');
mod= zeros([1, length(envelope_signal)]);
for i=1:length(noise)
    mod(1, i)= (1/rms(noise))*real(envelope_signal(i)*noise(i));
end
[b, a]= butter(4, [720/fn, 5760/fn], 'bandpass');
bpass_signal= filtfilt(b, a, signal);
envelope_signal= (hilbert(bpass_signal));
noise = wgn(length(envelope_signal),1,-30,'complex');
mod2= zeros([1, length(envelope_signal)]);
for i=1:length(noise)
    mod2(1, i)= (1/rms(noise))*real(envelope_signal(i)*noise(i));
end
plot(1:19201,mod+mod2);
[b, a]= butter(4, [90/fn, 5760/fn], 'bandpass');
modf= filtfilt(b, a, mod+mod2);
audiowrite("2band.wav", modf, 12000);