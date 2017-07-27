close all
clear all

zin=50;     %Input impedance of the system
%zin_adc=50;     %Input impedance of the system
zin_adc=300;     %Input impedance of the system
vpp=2;      %Input pk-pk voltage
snr=71;     %SNR of the ADC in dBFS
Fs=250e6;   %Sampling frequency
npts=1e6;   %Number of point of the output data array, in time domain
gain1=20;    %Gain, in dB, RF stage 1
gain2=20;    %Gain, in dB, RF stage 2

low_freq=31e6;
hi_freq=33e6;
filt_order=14; 

kb=1.38e-23;
T=300;

%%ADC quantization Noise Power Spectral Density
[time, data_adc, Pxx, freq]=adc_nsd(snr, vpp, Fs, npts, zin_adc); %generate the time doamin signal with the input SNR and sampling specs
% figure;
% plot(freq/1e6,10*log10(Pxx/zin_adc))
% xlabel('Frequency (MHz)')
% ylabel('PSD (dBm/Hz)')
% title('ADC Quantization Noise - Power Spectral Density')
% % axis([0 140 -200 -120])
% grid on

%%Add the thermal signal excited on the coils
%Thermal noise excited on the 50 Ohm system, :
%Generating white noise signal from the noise power
[time, signal_whtn, Pxx2, freq] = wn_signal(T, Fs, npts, zin);
% figure;
% plot(freq/1e6,10*log10(1000*Pxx2/zin))
% xlabel('Frequency (MHz)')
% ylabel('PSD (dBm/Hz)')
% title('ADC Quantization Noise - Power Spectral Density')
% % axis([0 140 -200 -120])
% grid on

data_amp=signal_whtn*10^(gain1/20);   %Apply voltage gain to the data signal
[Pxx10,freq10] = pwelch(signal_whtn,[],[],[],Fs);

%Filter design for the BPF
Hd = designfilt('bandpassiir','FilterOrder',filt_order, ...
    'HalfPowerFrequency1',low_freq,'HalfPowerFrequency2',hi_freq, ...
    'SampleRate',Fs);

% Hd = designfilt('bandpassfir', 'FilterOrder', 20, ...
%              'CutoffFrequency1', low_freq, 'CutoffFrequency2', hi_freq,...
%              'SampleRate', Fs);
% fvt = fvtool(Hd,'Fs',Fs);
% legend(fvt,'designfilt')

data_bpf1 = filter(Hd,data_amp);                %Applying BPF to the amplified signal
%%Adding thermal noise to the output data'

% signal_whtn=20e-6*(randn(1,npts)); %White noise at room tempearture at room temperature
data_bpf1=data_bpf1+signal_whtn;  %Generating the white noise, time domain signal
[Pxx3,freq3] = pwelch(data_bpf1,[],[],[],Fs);

data_amp2=data_bpf1*10^(gain2/20);   %Apply voltage gain to the data signal
[freq1, data_amp2_fft]=fft_data(Fs,data_amp2);  %FFT of the filtered signal
[Pxx11,freq11] = pwelch(data_amp2,[],[],[],Fs);

data_bpf2 = filter(Hd,data_amp2);                %Applying BPF to the amplified signal
data_bpf2=data_bpf2+signal_whtn;  %Adding white noise to the filtered signal at the specified temperature, time domain signal.
[Pxx4,freq4] = pwelch(data_bpf2,[],[],[],Fs);

Pxx_avg = tsmovavg(10*log10(Pxx/zin_adc),'s',12,1);
Pxx2_avg = tsmovavg(10*log10(1000*Pxx2/zin),'s',12,1);
Pxx3_avg = tsmovavg(10*log10(1000*Pxx3/zin),'s',12,1);
Pxx4_avg = tsmovavg(10*log10(1000*Pxx4/zin),'s',12,1);
Pxx11_avg = tsmovavg(10*log10(1000*Pxx11/zin),'s',12,1);

figure;
plot(freq/1e6,[Pxx_avg Pxx2_avg Pxx11_avg Pxx4_avg ]) %The power spectral density of the adc is already given in dBm
xlabel('Frequency (MHz)')
ylabel('PSD (dBm/Hz)')
legend('PSD ADC Quantization noise','PSD Thermal noise coil','PSD RF thermal noise 2x Amp + 1x BPF','PSD RF thermal noise 2x Amp + 2x BPF')
% axis([0 140 -200 -120])
grid on
