function [output] = VLC_ConFigFile( )
%% Noise
config.detector_area = 1e-4; % unit: m^2
config.responsivity = 0.6; % responsivity of receiver
config.electronic_charge = 1.6021892*1e-19; % unit: C
config.current_2 = 0.562;
config.Boltzman_constant = 1.3806505*1e-23; % unit: J/K
config.capacitance_per_area = 112*1e-12/1e-4; %unit:F/m^2
config.open_loop_voltage_gain = 10;
config.Temperature = 298; % unit: K
config.noise_factor = 1.5;
config.FET_transconductance = 30*1e-3; % unit: S
config.current_3 = 0.0868;

%% Room
config.X_room = 4;
config.Y_room = 4;
config.Z_room = 3;

%% Transmitter
config.Semi_Illu = 60;%half power of LED
config.P_singleLED = 10;
config.N_perarray_LED = 1;
config.N_LEDarray = 2;%Num of LED array¡¡N*N
config.Num_LED = config.N_LEDarray^2;
%% Receciver
config.FOV_PD = 90;%FOV of PD
config.Adet = 1.0 * 10^-4;%Rececive area of PD cm2
config.G_Opf = 1;%Optical filter gian
config.Re_index = 1.5; % PD internal refractive index
config.O2E = 0.53;%optical to electricitiy rate

%% derived parameters
config.ml = -log(2)/log(cosd(config.Semi_Illu));%order of Lambertian radiation pattern
config.P_totalLED = config.P_singleLED * config.N_perarray_LED;%Total power of LED array
config.G_Con = (config.Re_index^2)/((sind(config.FOV_PD)).^2);%Concentrator gain
% config.Pos_LED = [config.X_room/2, config.Y_room/2, config.X_room];
%% return
output = config;
end

