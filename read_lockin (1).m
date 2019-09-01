clear
instrreset

% Runtime parameters:
savefile = true;
label = 's_4kV';
runtime = 420; % seconds
dt = 1.0; % seconds

npts = runtime/dt;

lockin1 = gpib('ni', 0, 1);
lockin2 = gpib('ni', 0, 2);
fopen(lockin1);
fopen(lockin2);

V1vals = zeros(1, npts);  
V2vals = zeros(1, npts);
timevals = zeros(1, npts);

starttime = now;
disp('Beginning intensity read...')

for i = drange(1:npts)
    fprintf(lockin1,'outp? 3')
    ans1 = fscanf(lockin1);
    V1vals(i) = str2num(ans1);	
    fprintf(lockin2,'outp? 3')
    ans2 = fscanf(lockin2);
    V2vals(i) = str2num(ans2);
    timevals(i) = (now - starttime)*86400;

    subplot(1,1,1);
    plot(timevals(1:i), V1vals(1:i), timevals(1:i), V2vals(1:i));
    legend('Lockin 1', 'Lockin 2')
    xlabel('Time');
    ylabel('Voltage');

    pause(dt - 0.1);

end

if savefile
    path = 'C:\Users\314 Lab\Documents\Ted Blaise Shreyas\data\';
    filename = [path num2str(starttime-737456, '%2.4f') '_' label '.csv' ];
    csvwrite(filename, transpose([timevals; V1vals; V2vals]));
    disp(['Data saved to: ' filename])
end
fclose(lockin1);
delete(lockin1);
fclose(lockin2);
delete(lockin2);

disp(['Average 1:' num2str(mean(V1vals))])
disp(['Average 2:' num2str(mean(V2vals))])

