%Function name: wn_signal
%Description: Generate white noise based on the sampling characteristics of
%the signal. The outputs are: Signal in Vots satisfying the input specs and Power spectral density of this signal.
%
% Author: Baron, Rafael A.
% Center for Hyperpolarization in Magnetic Resonance
% email: rabaron@elektro.dtu.dk
% Last Revision: April 2017
%
%Inputs:
%   snr - Signal-to-Noise-Ratio of the ADC used on the analysis
%   vpp - Input voltage range of the ADC, given in volts pk-pk
%   Fs -  ADC sampling frequency, in MHz
%   npts - number of points wanted for the output time domain signal that
%   satisfies the input SNR, Fs and npts.
%
%Outputs:
%   data - array of data with the given input power spectral density.
%   Pxx - Signal Power spectral density
%   time - time domain data for the output signal


function [time, data, Pxx, freq] = wn_signal(Temperature, Fs, npts, zin)

kb=1.38e-23;
Ts=1/Fs;
bw=Fs/2;
T=Temperature;

vn=sqrt(kb*T*zin*bw);
%data=2e-5*randn(1,npts);
data=vn*randn(1,npts); %Noise voltage over the entire bandwidth for a given resistor
time=0:Ts:Ts*(npts-1);

[Pxx,freq] = pwelch(data,[],[],[],Fs);

% figure;
% plot(freq/1e6,10*log10(1000*Pxx/zin))
% xlabel('Frequency (MHz)')
% ylabel('PSD (dBFS/Hz)')
% % axis([0 140 -200 -120])
% grid on

end
