clear all
close all
clc;

fprintf('=============Simulation============\n');
tic
%% Load parameters
config = VLC_ConFigFile();
Orient = Orientation_Def();
PoscaseSet = {'1LED_1PD', '4LED_1PD'};
Pos = Position_Def(PoscaseSet{2}, config);
%% parameters of signal
N_FFT = 128;
% bandwidth = 10*1e6; % full bandwith, unit: Hz;
bandwidth = 100*1e6; % full bandwith, unit: Hz;
K = 0:N_FFT-1;
N_CP = 16;

M_QAM = 16;
run_times = 10;
Num_LED = 1;
PA_times = 25;
range_4 = [2,17,113,128;% range of four subcarrier blocks
    18,33,97, 112;
    34,49,81, 96;
    50,64,66, 80];
range_1 = [2,64,66,128];


responsivity = 0.6;
slope_LED_PI = 10;
num_frame = 1024;
h_normalized = [1, 0, 0, zeros(1, (N_FFT+N_CP)*num_frame-3)];
h_normalized_reflect = [1, 0.5, 0.2, zeros(1, (N_FFT+N_CP)*num_frame-3)];
Pos_LED = [0 0 3];
Oren_LED = [0 0 1];
Oren_PD = [0 0 1];

X_max = 4;
max_iteration = 30;
P_D_est = zeros(1, 2*X_max/0.1);
P_D_actal = zeros(1, 2*X_max/0.1);
P_deta = zeros(1, 2*X_max/0.1);
P_D_est_reflect = zeros(1, 2*X_max/0.1);
P_D_actal_reflect = zeros(1, 2*X_max/0.1);
P_deta_reflect = zeros(1, 2*X_max/0.1);
i =1;

for x = -X_max:0.1:X_max
    %     for y =
    i
    D_est= zeros(1, max_iteration);
    D_actal = zeros(1, max_iteration);
    deta = zeros(1, max_iteration);
    D_est_reflect= zeros(1, max_iteration);
    deta_reflect = zeros(1, max_iteration);
    Pos_PD = [x x 0];
    [H_LOS_output, D_RxTx_output] = Channel_LOS(Pos_PD, Pos_LED, Oren_PD, Oren_LED, config);
    h_actual = H_LOS_output * h_normalized;
    h_actual_reflect = H_LOS_output * h_normalized_reflect;
    parfor i_iteration = 1:max_iteration
        %% bit stream
        [sig_ofdm_time, sig_ofdm_freq] = ofdmMod(num_frame, N_CP, M_QAM, Num_LED, N_FFT, range_1, h_actual);
        noise_power = noise_p(sum(h_actual), 10, 100*1e6);
        [noise_row , noise_column] = size(sig_ofdm_time{1});
        noise = 1/sqrt(2) * sqrt(noise_power) * (randn(noise_row , noise_column) + 1j * randn(noise_row , noise_column));
        %% No reflect
        Y_f_inchannel = fft(h_actual).*fft(sig_ofdm_time{1});
        y_stream = ifft(Y_f_inchannel) + noise;
        y_stream_block= reshape(y_stream, [], num_frame)';
        Y_recover = fft(y_stream_block(:, N_CP+1:end), N_FFT, 2);
        Hk = (Y_recover)./sig_ofdm_freq;
        H0 = mean(real(1/N_FFT*sum(Hk, 2)));
        H_deta = (H0-sum(h_actual))./sum(h_actual);
        D_est(i_iteration) = H0_get_D(H0, Pos_PD, Pos_LED, Oren_PD, Oren_LED, config);
        D_actal(i_iteration) = D_RxTx_output;
        deta(i_iteration) = abs(D_est(i_iteration) - D_actal(i_iteration));
        
        %% With reflect
        Y_f_inchannel_reflect = fft(h_actual_reflect).*fft(sig_ofdm_time{1});
        y_stream_reflect = ifft(Y_f_inchannel_reflect) + noise;
        y_stream_block_reflect= reshape(y_stream_reflect, [], num_frame)';
        Y_recover_reflect = fft(y_stream_block_reflect(:, N_CP+1:end), N_FFT, 2);
        Hk_reflect = (Y_recover_reflect)./sig_ofdm_freq;
        H0_reflect = mean(real(1/N_FFT*sum(Hk_reflect, 2)));
        H_deta_reflect = (H0_reflect-sum(h_actual_reflect))./sum(h_actual_reflect);
        D_est_reflect(i_iteration) = H0_get_D(H0_reflect, Pos_PD, Pos_LED, Oren_PD, Oren_LED, config);
        deta_reflect(i_iteration) = abs(D_est_reflect(i_iteration) - D_actal(i_iteration));
        
    end
    P_D_est(i) = mean(D_est);
    P_D_actal(i) = mean(D_actal);
    P_deta(i) = mean(deta);
    P_D_est_reflect(i) = mean(D_est_reflect);
    P_deta_reflect(i) = mean(deta_reflect);
    i = i+1;
end
figure()
plot([-X_max:0.1:X_max], P_deta,[-X_max:0.1:X_max], P_deta_reflect)

