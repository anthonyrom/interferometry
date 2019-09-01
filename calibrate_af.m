function [Vmax,Vmin] = calibrate(piezo_addy,lockin_addy,min,max,res)
clear
instrreset
%ramps piezo from min to max voltage (start w/ 0-10V) and then finds the
%max output from the lockin
%inputs;
%piezo addy - adress of the amrel dc pwr supply controling the piezo
%lockin addy - address of the lockin
%min - ramps starting voltage
%max - ramps ending voltage
%res - resolution of ramp
%output:
%Vmax - voltage the piezo is set at that gives max voltage out
%Vmin - SAA but min
%seting up the gpibs
piezo = gpib('ni',0,piezo_addy);
lockin = gpib('ni',0,lockin_addy);
fopen(piezo);
fopen(lockin);
fprintf(lockin,'OUTX 1');
fprintf(lockin,'DDEF 1,1,0'); %lockin shows R
% fprintf(lockin,'FPOP 1,0'); %makes ch1 output R, not nesecary as far as
% we can tell
V = min; %volts, vari that gets ramped
num = (max-min)/res; %gives number of elements for Vin/Vout
Vin = zeros(num);
Vout = zeros(num);
i = 1;
while V <= max
    fprintf(piezo, sprintf('%s %f','VSET',V)); %setting pwr sup voltage
    V = V+res; %ramping voltage for next pass
    outV = query(lockin, 'OUTP? 3'); %reads R from lockin
    inV = query(piezo, 'VOUT?'); %reads voltage pwr sup is outputting
    outV = strtok(outV,'/'); %cuts off part of string, cant see why we need this but again yolo
    inV = strtok(inV,'/'); %saa
    Vin(i) = str2double(inV); %puts values into array 
    Vout(i) = str2double(outV);
    i = i+1;
    pause(2) %might have to edit value
end
%plot
plot(Vin,Vout);
% finding Vmax and Vmin
[~,maxind] = max(Vout);
[~,minind] = min(Vout);
Vmax = Vin(maxind);
Vmin = Vin(minind);
%reseting pwr sup to 0 V
fprintf(piezo,'VSET 0');
%close and exit
instrreset
end


    

