function [Vmax, Vmin] = calibrate_ar(lkn_address, pps_address, min_volt, max_volt, res)

V = min_volt;
i = 1;

% Compute number of iterations needed and create empty arrays
iter = (max_volt - min_volt)/res;
Vin = zeros(iter);
Vout = zeros(iter);

% Initialize GPIB devices
lkn = gpib('ni', 0, lkn_address);
pps = gpib('ni', 0, pps_address);

% Open GPIB connections
fopen(lkn);
fopen(pps);

% Prepare Lock-in amp for measurements
fprintf(lkn, 'OUTX 1'); % Set lockin  to GPIB mode
fprintf(lkn, 'DDEF 1, 1, 0'); % Set lockin CH1 display to show R
% fprintf(lkn, 'FPOP 1, 0'); % Set CH1 output to CH1 display (R)

% Ramp Piezo Voltage
while i <= iter
    fprintf(pps, sprintf('%s %f', 'VSET', V)); % Set current voltage as PPS output
    V = V + res; % Update voltage for next loop
    inV = query(pps, 'VOUT?'); % MAY REQUIRE FORMATTING
    outV = query(lkn, 'OUTP? 3');
    Vin(i) = str2double(inV);
    Vout(i) = str2double(outV);
    i = i + 1;
    pause(2) % Maybe play with this value
end

% Plot input/output voltages
plot(Vin, Vout);

% Store maximum and minimum output voltages
Vmax = max(Vout);
Vmin = min(Vout);

% Return voltage to minimum value
V = min_volt;
fprintf(pps, sprintf('%s %f', 'VSET', V));

% Close GPIB connections
fclose(lkn);
fclose(pps);

end