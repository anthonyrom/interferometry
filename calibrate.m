function calibration = calibrate(pps_address, dsp_address, min, max, res, nramp)
pps = gpib('ni',0,pps_address);
dsp = gpib('ni',0,dsp_address);
fopen(pps);
fopen(dsp);
voltage = min;
rampnum = 1;
vin(1) = voltage; 
vout(1) = 0;
i = 1;
fprintf(dsp, 'OUTX 1');
fprintf(dsp, 'DDEF 1,1,0');
while rampnum < nramp
    while voltage <= max
        fprintf(pps, sprintf('%s %f','VSET',voltage));
        fprintf(dsp, 'FPOP 1,0');
        voltage = voltage + res;
        outV = query(dsp, 'OUTP? 3');
        inV = query(pps, 'VOUT?')
        inV = strtok(inV, '\');
        outV = strtok(outV, '\');
        Vin(i) = str2num(inV);
        Vout(i) = str2num(outV);
        i = i + 1;
        plot(Vin, Vout);
        pause(2)
    end
    voltage = min;
    rampnum = rampnum + 1
end
%OUT = [Vin; Vout];
csvwrite('interference1.csv', OUT.')
fprintf(pps, sprintf('%s %f', 'VSET', voltage))
fclose(pps);
fclose(dsp);
end