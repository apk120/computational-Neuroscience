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
psthbinwidth = 1e-3; % binwidth in seconds;

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