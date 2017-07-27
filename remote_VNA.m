function [data] = remote_VNA(command,DutAddr)
%
% remote_VNA
% Matlab Instrument control for the Agilent Vector Network Analyser E5062A
% function that allow the remote control of the instrument
%
% Technical University of Denmark - DTU
% review 1.0: 20-jul-2017.
% Authors: Rafael A. Baron

newobjs = instrfind;
if isempty(newobjs) == 0
    fclose(newobjs);
    delete(newobjs);
    clear newobjs
end
myvna = visa('agilent',DutAddr);
% set(myvna,'EOSMode','read&write');
% set(myvna,'EOSCharCode','LF') ;
fopen(myvna);

switch command
    case 'IDN?'
        %Reads out information about the manufacturer, serial number and
        %firmware version.
        fprintf(myvna, '*IDN?');
        data = ['Connection OK. IDN = ' fscanf(myvna)];
        CheckDMMError(myvna); %Check if the VNA has any errors
        
    case 'BWID'
        %Configure for Bandwidth acquisition and unloaded Q factor measurement
        %It is necessary to setup the marked on the VNA to marker 1 and setup
        %The central frequency and span
        fprintf(myvna,':CALC1:MARK1:BWID:DATA?');
        data = fscanf(myvna)
        CheckDMMError(myvna); %Check if the VNA has any errors
      
    case 'MARKX'
        fprintf(myvna,':CALC1:MARK1:X?');
        data = fscanf(myvna)
        CheckDMMError(myvna); %Check if the VNA has any errors
        
    case 'MARKY'
        fprintf(myvna,':CALC1:MARK1:Y?');
        data = fscanf(myvna)
        CheckDMMError(myvna); %Check if the VNA has any errors
        
end
end
