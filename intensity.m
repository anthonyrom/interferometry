% top = gpib('ni', 0,1);
bot = gpib('ni', 0,2);
fopen(bot);
fprintf(bot, 'OUTX 1');
fprintf(bot, 'DDEF 1,1,0');
% fopen(top);
% fprintf(top, 'OUTX 1');
% fprintf(top, 'DDEF 1,1,0');
n = 5000;
Vbot = zeros(n);
time = zeros(n);
time(1) = 0;
tic()
for i = 1:n
    
    fprintf(bot, 'FPOP 1,0');
    outV = query(bot, 'OUTP? 3');
    outV = strtok(outV, '\');
    Vbot(i) = str2num(outV);
%     fprintf(top, 'FPOP 1,0');
%     outV = query(top, 'OUTP? 3');
%     outV = strtok(outV, '\');
%     Vtop(i) = str2num(outV);
    wait = 0.2;
    pause(wait)
    time(i+1) = time(i)+toc();
    plot(time,Vbot,'k')
    tic()
end
fclose(top)
% csvwrite('PhotodiodeTest.csv', Vout)
fclose(bot)
% 
% %%
% coeffs = polyfit(time, dat, 1);
% % Get fitted values
% fittedY = polyval(coeffs, time);
% % Plot the fitted line
% hold on;
% plot(time, fittedY, 'r-', 'LineWidth', 3);
