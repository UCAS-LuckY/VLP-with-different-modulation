function [H_LOS_output, D_RxTx_output] = Channel_LOS(Posi_PD, Pos_LED, Oren_PD, Oren_LED, config)

%% Vector of RxTx
RxTx = Pos_LED - Posi_PD;
D_RxTx = norm(RxTx); %Distance between RxTx
%% Emitted Angle
cosphi_emitted = (RxTx* Oren_LED')/(D_RxTx*norm(Oren_LED));
Angle_emitted = acosd(cosphi_emitted);
%% Received Angle 
cosphi_received = (RxTx* Oren_PD')/(D_RxTx*norm(Oren_PD));
Angle_received = acosd(cosphi_received);

%% H_LOS
Flag_FOV = abs(Angle_received)<=config.FOV_PD;
H_LOS = Flag_FOV .*(config.ml+1)./(2 * pi * D_RxTx.^2) * config.Adet.* cosphi_emitted.^(config.ml) * cosphi_received;
% P_rec_A1 = P_total.* H_A1.* Ts.* G_Con; %A1的接收功率
% P_rec_A1 =P_rec_A1 .*(abs(receiver_angle)<=FOV) .*cosphi_A2 .*(abs(emitted_angle)<=FOV_LED);
% P_rec_total = P_rec_total+P_rec_A1;
 %% return
 H_LOS_output = H_LOS;
 D_RxTx_output = D_RxTx;
end

