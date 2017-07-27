function [fc,fL,fH,Q]=findQ(freq, data)
% function [freq, data_fft]=skin_depth(Fs,data)
% Technical University of Denmark - DTU
% review 1.0: 19-jul-2017.
% Author: Rafael A. Baron.

format long g
[data_max index0] = max(data);
fc=freq(index0);

data1=data(1:index0);
[c1 index1] = min(abs(data1-data_max+3));
fL=freq(index1);
data2=data(index0:end);

[c2 index2] = min(abs(data2-data_max+3));
fH=freq(index2+index0-1);

Q=fc/(fH-fL);

end


