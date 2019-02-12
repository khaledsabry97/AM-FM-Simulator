%givens
Fc = 100000;
B = 5;
%load music clip
modulatingSignal=load('handel');
y = modulatingSignal.y;
O_Fs = modulatingSignal.Fs;
%resample and get Frequency Deviation
y = y(:,1);
Fs = 3*Fc;
y = resample(y, Fs, O_Fs);
freq_Deviation = B*(Fs);  
%Get Kf
M = max(y);
Kf = 2*pi*O_Fs*B* (1/M);
%calc time
delta = 1/Fs;
t = 0 : delta : (length(y)*delta)-delta;
%make Fm Signal
cumsummatiom = cumsum(y)/Fs;
FM = 3 *cos(2*pi*Fc*t' + Kf*cumsummatiom); %3 is just a amplitude carrier
MSE = [];
for i=0:20
    noise = awgn(FM, i); %add Noise
    output = fmdemod(noise, Fc, Fs, freq_Deviation);  %Demodulate
    MSE = [MSE, immse(output, y)]; %calc Mean Squard Error
end

output = resample(output, O_Fs, Fs);
sound(output);
plot(MSE);