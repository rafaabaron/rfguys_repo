%Function name: genwn
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
%   Output signal provided in Volts
%   time - time domain data for the output signal 


function [time, data, Pxx, freq] = adc_nsd(snr, vpp, Fs, npts, zin)

%if nargin < 2
%zin=50
%end  

Ts=1/Fs;
bw=Fs/2;
vrms=vpp/(2*sqrt(2));
pwatts=vrms^2/zin;

pin_max=10*log10(1000*pwatts)
psd_adc_dbfs=-snr-10*log10(bw)
psd_adc_dbm=psd_adc_dbfs+pin_max

vrms_sd=dbm2volt(psd_adc_dbfs,zin);%Voltage NSD, in V/sqrt(Hz)
amp=vrms_sd*sqrt(bw); %Voltage in the bandiwdth, given by the amount of samples of the reconstructed signal 

data=amp*4*(randn(1,npts));  %Generating the white noise, time domain signal
time=0:Ts:Ts*(npts-1);

% w1=window(@hann,length(data));
[Pxx,freq] = pwelch(data,[],[],[],Fs);

end
