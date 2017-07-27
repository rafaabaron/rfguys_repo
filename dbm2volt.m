%Function name: dbm2volt
%Description: Calculate the RMS voltage for the zin system input impedance for a
%given input power
%
% Author: Baron, Rafael A.
% Center for Hyperpolarization in Magnetic Resonance
% email: rabaron@elektro.dtu.dk
% Last Revision: April 2017
%
%Inputs: 
%   zin - system impedance
%   pow - Input power for the calculation, in dBm
%Outputs:
%   vrms - Output RMS voltage for the Zin system impedance.


function [vrms,pwatts]=dbm2volt(pow, zin)

if nargin < 2
    zin=50;
end

vrms=sqrt(zin/1000*10^(pow/10));
pwatts=1/1000*10^(pow/10);

end



