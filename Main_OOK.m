clear all
close all
clc;

fprintf('=============Simulation============\n');
tic
%% Load parameters
load h
h_syn = syn_h(Feature_CIR);
config = VLC_ConFigFile();
Orient = Orientation_Def();
PoscaseSet = {'1LED_1PD', '4LED_1PD'};
Pos = Position_Def(PoscaseSet{2}, config);

responsivity = 0.6;
slope_LED_PI = 10;


Pos_LED = [0 0 3];
Oren_LED = [0 0 1];
Oren_PD = [0 0 1];

X_max = 2.5;
max_iteration = 30;
P_D_est = zeros(1, 2*X_max/0.1);
P_D_actal = zeros(1, 2*X_max/0.1);
P_deta = zeros(1, 2*X_max/0.1);
P_D_est_reflect = zeros(1, 2*X_max/0.1);
P_D_actal_reflect = zeros(1, 2*X_max/0.1);
P_deta_reflect = zeros(1, 2*X_max/0.1);
i =1;
num_frame = 1024;
h_normalized = [1, 0, 0. zeros(1, num_frame -3)];
% h_normalized_reflect = [1, 0.5, 0.2, zeros(1, num_frame-3)];
for x = -X_max:0.1:X_max
    i
%     h_normalized_reflect = [Feature_CIR(i,:), zeros(1, num_frame-length(Feature_CIR(i,:)))];
    D_est= zeros(1, max_iteration);
    D_actal = zeros(1, max_iteration);
    deta = zeros(1, max_iteration);
    D_est_reflect= zeros(1, max_iteration);
    deta_reflect = zeros(1, max_iteration);
    Pos_PD = [x x 1];
    [H_LOS_output, D_RxTx_output] = Channel_LOS(Pos_PD, Pos_LED, Oren_PD, Oren_LED, config);
    h_actual = H_LOS_output * h_normalized;
    h_actual_reflect = [h_syn(i,:), zeros(1, num_frame-length(h_syn(i,:)))];
    for i_iteration = 1:max_iteration
        %% bit stream
        OOK_bit_stream = ones(1, num_frame);
        noise_power = noise_p(sum(h_actual), 10, 100*1e6);
        [noise_row , noise_column] = size(OOK_bit_stream);
        noise = 1/sqrt(2) * sqrt(noise_power) * (randn(noise_row , noise_column) + 1j * randn(noise_row , noise_column));
        %% NO reflect
        Y_f = fft(h_actual).*fft(OOK_bit_stream);
        y_stream = ifft(Y_f) + noise;
        H0 = mean(real((y_stream)./(OOK_bit_stream)));
        D_est(i_iteration) = H0_get_D(H0, Pos_PD, Pos_LED, Oren_PD, Oren_LED, config);
        D_actal(i_iteration) = D_RxTx_output;
        deta(i_iteration) = abs(D_est(i_iteration) - D_actal(i_iteration));
        
        %% With reflect
        Y_f_inchannel_reflect = fft(h_actual_reflect).*fft(OOK_bit_stream);
        y_stream_reflect = ifft(Y_f_inchannel_reflect) + noise;
        
        
        H0_reflect = mean(real((y_stream_reflect)./(OOK_bit_stream)));
        
%         H_deta_reflect = (H0_reflect-sum(h_actual_reflect))./sum(h_actual_reflect);
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

