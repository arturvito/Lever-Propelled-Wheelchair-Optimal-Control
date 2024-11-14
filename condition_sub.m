% Anthropometric and wheelchair parameters
hPes_s = 1.700;             % [m] altura do indivíduo (1.700 m)
mPt_s = 80;                 % [kg] massa total do sujeito
mWC_s = 12;                 % [kg] massa total da cadeira de rodas com rodas (6 kg p/ cadeira + 2x3 kg para rodas)
mr_s = (2*3);               % [kg] massa das rodas da cadeira (3 kg para cada roda)
ma_s = 2*(0.020285*mPt_s);  % [kg] massa do antebraço (1.420 kg)
mb_s = 2*(0.026000*mPt_s);  % [kg] massa do braço (1.820 kg)
mp_s = (mPt_s-ma_s-mb_s)+(mWC_s-mr_s);% [kg] massa do corpo sem braços e mãos + massa da cadeira sem rodas (tronco + pernas + cabeça + cadeira da cadeira de rodas)
ml_s = 2*0.6;               % [kg] massa da alavanca
mCJ_s =mPt_s + mWC_s;       % [kg] massa do conjunto todo (corpo + 2 braços + 2 antebraços + 2 rodas + cadeira(6.000 kg))
R1_s = 0.3;                 % [m] raio do handrin (diâmetro de 22 polegadas = 0.5588 m) 
R2_s = 0.3048;              % [m] raio da roda da cadeira (diâmetro de 24 polegadas = 0.6096 m) 
B_s = (0.188000*hPes_s);    % [m] comprimento do braço (0.3196 m)
A_s = (0.145000*hPes_s);    % [m] comprimento do antebraço (0.2465 m)
a_s = (0.062353*hPes_s);    % [m] distância do CG do antebraço # cotovelo (0.1060 m)
b_s = (0.081941*hPes_s);    % [m] distância do CG do braço # ombro (0.1393 m)
Jr_s = 2*(0.13954);         % [kg*m^2] momento de inércia da roda (para 2 rodas)  
Jb_s = 2*(0.03534);         % [kg*m^2] momento de inércia do braço
Ja_s = 2*(0.02680);         % [kg*m^2] momento de inércia do antebraço
g_s = 9.81;                 % [m/s2] aceleração da gravidade
h_s = 0.05;                 % [m] distância na horizontal do ombro até o eixo da roda
v_s = 0.73;                 % [m] distância na vertical do ombro até o eixo da roda
xP_s = 0;                   % [m] posição do CGx do sistema -> corpo sem membro superior+cadeira de rodas
yP_s = 0;                   % [m] posição do CGy do sistema -> corpo sem membro superior+cadeira de rodas

