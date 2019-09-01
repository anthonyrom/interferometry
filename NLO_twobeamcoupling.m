clear 
instrreset
delete(instrfind);
%% connect to lockins

lockin1 = gpib('ni', 0, 1); % top lockin
lockin2 = gpib('ni', 0, 2); % bottom lockin

fopen(lockin1);
fopen(lockin2);
%% Real time plot
stop = 0;
i = 1;
timestep = 0.5;
clf
while stop ~= 1 % Will have to use Ctrl+C to break the loop until we figure out a push button
    delete(instrfind);
    lockin1 = gpib('ni', 0, 1); % top lockin
    lockin2 = gpib('ni', 0, 2); % bottom lockin

    fopen(lockin1);
    fopen(lockin2);

    fprintf(lockin1, 'OUTP?1 /n');
    X1(i) = str2double(fscanf(lockin1));
    fprintf(lockin1, 'OUTP?3 /n');
    R1(i) = str2double(fscanf(lockin1))
    
    fprintf(lockin2, 'OUTP?3 /n');
    R2(i) = str2double(fscanf(lockin2))
    pause(timestep)
    i=i+1;
    
    figure(1)
    plot(1:length(R1),R1,'blue')
    hold on
    plot(1:length(R2),R2,'red')
    title('R1 and R2 as a function of time')
    xlabel('Time (s) NOT YET')
    ylabel('R (V)')
    %ylim([0.12,0.155])
end

%% read the bottom for one min w top closed
n = 120;
i = 1;
R_bottom = zeros(n,1);
while i < n
    fprintf(lockin2, 'OUTP?3 /n');
    R_bottom(i) = str2double(fscanf(lockin2));
    i = i + 1
    pause(0.5)
end
%%
csvwrite('BottomPPol.csv', R_bottom)
R_bot_avg = mean(R_bottom)
R_bot_std = std(R_bottom)

%% read the bottom for one min w top closed
n = 120;
i = 1;
R_top = zeros(n,1);
while i < n
    fprintf(lockin1, 'OUTP?3 /n');
    R_top(i) = str2double(fscanf(lockin1));
    i = i + 1
    pause(0.5)
end
%%
csvwrite('TopPPol.csv', R_top)
R_top_avg = mean(R_top)
R_top_std = std(R_top)


%% read both after they've stabilized
n = 120;
i = 1;
R_top_bo = zeros(n,1);
R_bottom_to = zeros(n,1);
while i < n
    fprintf(lockin1, 'OUTP?3 /n');
    R_top_bo(i) = str2double(fscanf(lockin1));
    fprintf(lockin2, 'OUTP?3 /n');
    R_bottom_to(i) = str2double(fscanf(lockin2));
    i = i + 1
    pause(0.5)
end
%%
csvwrite('Top_Bottom_PPol.csv', R_top_bo, R_bottom_to)
R_top_avg_bo = mean(R_top_bo)
R_top_std_bo = std(R_top_bo)
R_bot_avg_to = mean(R_bottom_to)
R_bot_std_to = std(R_bottom_to)

%% plot
figure()
hold on
errorbar(1,R_top_avg,R_top_std,'.')
errorbar(1,R_bot_avg,R_bot_std,'.')
errorbar(2,R_top_avg_bo,R_top_std_bo,'.')
errorbar(2,R_bot_avg_to,R_bot_std_to,'.')
xlim([0,3])
ylim([0.13, 0.26])

%% read the bottom for one min w top closed SWITCHED PHOTODIODES
n = 120;
i = 1;
R_bottom_s = zeros(n-1,1);
while i < n
    fprintf(lockin1, 'OUTP?3 /n');
    R_bottom_s(i) = str2double(fscanf(lockin1));
    i = i + 1
    pause(0.5)
end

csvwrite('BottomPPol_s.csv', R_bottom_s)
R_bot_avg_s = mean(R_bottom_s)
R_bot_std_s = std(R_bottom_s)

%% read the top for one min w bottom closed SWITCHED PHOTODIODES
n = 120;
i = 1;
R_top_s = zeros(n-1,1);
while i < n
    fprintf(lockin2, 'OUTP?3 /n');
    R_top_s(i) = str2double(fscanf(lockin2));
    i = i + 1
    pause(0.5)
end

csvwrite('TopPPol_s.csv', R_top_s)
R_top_avg_s = mean(R_top_s)
R_top_std_s = std(R_top_s)


%% read both after they've stabilized SWITCHED PHOTODIODES
n = 120;
i = 1;
R_top_bo_s = zeros(n-1,1);
R_bottom_to_s = zeros(n-1,1);
while i < n
    fprintf(lockin2, 'OUTP?3 /n');
    R_top_bo_s(i) = str2double(fscanf(lockin2));
    fprintf(lockin1, 'OUTP?3 /n');
    R_bottom_to_s(i) = str2double(fscanf(lockin1));
    i = i + 1
    pause(0.5)
end

csvwrite('Top_Bottom_PPol_s.csv', [R_top_bo_s, R_bottom_to_s])
R_top_avg_bo_s = mean(R_top_bo_s)
R_top_std_bo_s = std(R_top_bo_s)
R_bot_avg_to_s = mean(R_bottom_to_s)
R_bot_std_to_s = std(R_bottom_to_s)

%% close connections
fclose(lockin1);
fclose(lockin2);
delete(instrfind);
 