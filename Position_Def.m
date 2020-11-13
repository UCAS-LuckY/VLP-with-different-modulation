function [Posout] = Position_Def(casename, config)

PoscaseSet = ['1LED_1PD', '4LED_1PD'];

switch char(casename)
    case '1LED_1PD'
        Spacing = 0;
        Pos.LED = [0.5*config.X_room-0.5*Spacing 0.5*config.Y_room-0.5*Spacing 2.5;
            0.5*config.X_room-0.5*Spacing 0.5*config.Y_room+0.5*Spacing 2.5;
            0.5*config.X_room+0.5*Spacing 0.5*config.Y_room-0.5*Spacing 2.5;
            0.5*config.X_room+0.5*Spacing 0.5*config.Y_room+0.5*Spacing 2.5];
        Pos.PD = [2 2 1];
    case '4LED_1PD'
        Spacing = 0.2;
        Pos.LED = [0.5*config.X_room-0.5*Spacing 0.5*config.Y_room-0.5*Spacing 2.5;
            0.5*config.X_room-0.5*Spacing 0.5*config.Y_room+0.5*Spacing 2.5;
            0.5*config.X_room+0.5*Spacing 0.5*config.Y_room-0.5*Spacing 2.5;
            0.5*config.X_room+0.5*Spacing 0.5*config.Y_room+0.5*Spacing 2.5];
        Pos.PD = [2 2 1];
end
% Spacing_PD = 0.1;
% Pos.PD = [0.5*config.X_room-0.5*Spacing_PD 0.5*config.Y_room-0.5*Spacing_PD 0.75;
%     0.5*config.X_room-0.5*Spacing_PD 0.5*config.Y_room+0.5*Spacing_PD 0.75;
%     0.5*config.X_room+0.5*Spacing_PD 0.5*config.Y_room-0.5*Spacing_PD 0.75;
%     0.5*config.X_room+0.5*Spacing_PD 0.5*config.Y_room+0.5*Spacing_PD 0.75];



%% return
Posout = Pos;
end

