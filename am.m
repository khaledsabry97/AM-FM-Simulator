%givens
Fc = 100000;
u = 0.9;
%load music clip
modulatingSignal = load('handel');
y = modulatingSignal.y;
O_Fs = modulatingSignal.Fs;
%resample
y = y(:,1);
Fs = 3*Fc;
y = resample(y, Fs, O_Fs);
delta = 1/Fs;
t = 0 : delta : (length(y)*delta)-delta;
%carrier, absolute minimum amplitude and Carrier Amplitude
carrier = cos(2*pi*Fc*t');
max_amplitude = abs(min(y));
Ac = max_amplitude / u;
%Amplitude Modulation
AM = (Ac + y).*carrier;
%Receive and Calc. MSE
MSE = [];
for i=0:20
    %add Noise
    noise = awgn(AM,i);
    %Demodulate
    yupper = envelope(noise);
    output = yupper - mean(yupper);
    %calc Mean Squard Error
    MSE = [MSE, immse(output, y)];
end

output = resample(output, O_Fs, Fs);
sound(output);
plot(MSE);