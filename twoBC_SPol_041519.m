%% set up the space, clear everything
clear 
instrreset
delete(instrfind);

%% connect to lockins

lockin1 = gpib('ni', 0, 1); % top lockin
lockin2 = gpib('ni', 0, 2); % bottom lockin

fopen(lockin1);
fopen(lockin2);

%% read beam 1 with beam 2 closed

dt = 0.5;
sample_time = 60; % seconds
n = sample_time / dt; % number of data points to collect

i = 1;
R_1_S = zeros(n,1);

while i <= n
    fprintf(lockin1, 'OUTP?3 /n');
    R_1_S(i) = str2double(fscanf(lockin1));
    i = i + 1
    pause(0.5) % takes data every 0.5 s
end

csvwrite('1_SPol_041719.csv', R_1_S)
R_1_avg_S = mean(R_1_S)
R_1_std_S = std(R_1_S)

%% read both beams with both open, after beam 1 was open

dt = 0.5;
sample_time = 240; % seconds
n = sample_time / dt; % number of data points to collect

i = 1;
R_1_both_1_S = zeros(n,1);
R_2_both_1_S = zeros(n,1);

while i <= n
    fprintf(lockin1, 'OUTP?3 /n');
    R_1_both_1_S(i) = str2double(fscanf(lockin1));
    fprintf(lockin2, 'OUTP?3 /n');
    R_2_both_1_S(i) = str2double(fscanf(lockin2));
    i = i + 1
    pause(dt)
end

csvwrite('Both_1_SPol_041719.csv', [R_1_both_1_S, R_2_both_1_S])
R_1_both_avg_1_S = mean(R_1_both_1_S(end/2+1:end))
R_1_both_std_1_S = std(R_1_both_1_S(end/2+1:end))
R_2_both_avg_1_S = mean(R_2_both_1_S(end/2+1:end))
R_2_both_std_1_S = std(R_2_both_1_S(end/2+1:end))

%% read beam 2 with beam 1 closed

dt = 0.5;
sample_time = 60; % seconds
n = sample_time / dt; % number of data points to collect

i = 1;
R_2_S = zeros(n,1);

while i <= n
    fprintf(lockin2, 'OUTP?3 /n');
    R_2_S(i) = str2double(fscanf(lockin2));
    i = i + 1
    pause(dt) % takes data every 0.5 s
end

csvwrite('2_SPol_041719.csv', R_2_S)
R_2_avg_S = mean(R_2_S)
R_2_std_S = std(R_2_S)

%% read both beams with both open, after beam 2 was open

dt = 0.5;
sample_time = 300; % seconds
n = sample_time / dt; % number of data points to collect

i = 1;
R_1_both_2_S = zeros(n,1);
R_2_both_2_S = zeros(n,1);

while i <= n
    fprintf(lockin1, 'OUTP?3 /n');
    R_1_both_2_S(i) = str2double(fscanf(lockin1));
    fprintf(lockin2, 'OUTP?3 /n');
    R_2_both_2_S(i) = str2double(fscanf(lockin2));
    i = i + 1
    pause(dt)
end

csvwrite('Both_2_SPol_041719.csv', [R_1_both_2_S, R_2_both_2_S])
R_1_both_avg_2_S = mean(R_1_both_2_S(end/2+1:end))
R_1_both_std_2_S = std(R_1_both_2_S(end/2+1:end))
R_2_both_avg_2_S = mean(R_2_both_2_S(end/2+1:end))
R_2_both_std_2_S = std(R_2_both_2_S(end/2+1:end))

%% read both beams with both open, after both were closed

dt = 0.5;
sample_time = 180; % seconds
n = sample_time / dt; % number of data points to collect

i = 1;
R_1_both_S = zeros(n,1);
R_2_both_S = zeros(n,1);

while i <= n
    fprintf(lockin1, 'OUTP?3 /n');
    R_1_both_S(i) = str2double(fscanf(lockin1));
    fprintf(lockin2, 'OUTP?3 /n');
    R_2_both_S(i) = str2double(fscanf(lockin2));
    i = i + 1
    pause(dt)
end

csvwrite('Both_SPol_041719.csv', [R_1_both_S, R_2_both_S])
R_1_both_avg_S = mean(R_1_both_S(end/2+1:end))
R_1_both_std_S = std(R_1_both_S(end/2+1:end))
R_2_both_avg_S = mean(R_2_both_S(end/2+1:end))
R_2_both_std_S = std(R_2_both_S(end/2+1:end))

%% calculate things!

d = 10.84; % mm
sig_d = 0.1; % mm
theta = 22.5; % degrees
sig_theta = 2.5; % degrees
th_rad = theta * pi / 180; % radians
sig_th_rad = sig_theta * pi / 180; % radians
d_tilda = d / cos(th_rad);

gamma_tilda_P_1 = -(1/d_tilda) * log(R_1_both_avg_1_S * R_1_avg_S / (R_2_both_avg_1_S * R_2_avg_S))
gamma_tilda_P_2 = -(1/d_tilda) * log(R_1_both_avg_2_S * R_1_avg_S / (R_2_both_avg_2_S * R_2_avg_S))