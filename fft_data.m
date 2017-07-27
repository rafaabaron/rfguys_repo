function [freq, data_fft]=fft_data(Fs,data)
%
% fft_data: Function that determines the FFT of a time domain signal,
% returning the frequency array and the FFT of the time domain signal.
% - The inputs are data array and sampling frequency. 
% - To avoid spectral leakage, it is recommended to input a windowed signal.
% - The output data is a complex number.
%
% data: Time domain input data array. It is suggested to use a windowed data.
% Fs: sampling frequency of the input data, in Hz
% 
% ESS - European Spallation Source
% review 1.0: 17-dec-2015. Rafael Baron. 
%
T = 1/Fs;             % Sampling period
L = length(data);     % Length of data array
t = (0:L-1)*T;        % Time array
Y = fft(data);
P2 = (Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
freq = Fs*(0:(L/2))/L;
data_fft=P1;

end