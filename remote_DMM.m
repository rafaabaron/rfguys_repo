function [data] = remote_DMM(command,DutAddr)
%
% remote_DMM
% Matlab Instrument control for the Keysigh Digital Multimeter 34461A
% function that allow the remote control
%
% Technical University of Denmark - DTU
% review 1.0: 19-jul-2017.
% Authors: Rafael A. Baron / Juan D. Sanchez


newobjs = instrfind;
if isempty(newobjs) == 0
    fclose(newobjs);
    delete(newobjs);
    clear newobjs
end
myDmm = visa('agilent',DutAddr);
set(myDmm,'EOSMode','read&write');
set(myDmm,'EOSCharCode','LF') ;
fopen(myDmm);

switch command
    case 'IDN?'
        fprintf(myDmm, '*IDN?');
        data = ['Connection OK. IDN = ' fscanf(myDmm)];
        CheckDMMError(myDmm); %Check if the DMM has any errors
        
        
    case 'PT100'
        %Configure for Temperature reading with a PT100
        fprintf(myDmm,'CONF:TEMP FRTD,85');
        fprintf(myDmm,'READ?');
        data = fscanf(myDmm)
        CheckDMMError(myDmm); %Check if the DMM has any errors
        
        
    case '4wire'
        %Configure for OHM 4 wire Autoranged
        fprintf(myDmm,'CONF:FRES');
        fprintf(myDmm,'READ?');
        data = fscanf(myDmm)
        CheckDMMError(myDmm); %Check if the DMM has any errors
end

end
