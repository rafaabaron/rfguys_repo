%Function name: volt2dbm
%Description: Calculate the power, in dBm for the zin system input impedance
%
% Author: Baron, Rafael A.
% Center for Hyperpolarization in Magnetic Resonance
% email: rabaron@elektro.dtu.dk
% Last Revision: April 2017
%
%Inputs: 
%   zin - system impedance
%   vrms - RMS input voltage
%
%Outputs:
%   pow - Output power, in dBm, for the Zin system impedance.


function [pow]=volt2dbm(vrms, zin)

% Check number of inputs.
if nargin < 2
    zin=50;
end

pow=10*log10(1000.*vrms.^2./zin);

end



