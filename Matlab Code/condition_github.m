% Anthropometric and wheelchair parameters
hPes = 1.700;             % [m] altura do indivíduo (1.700 m)
mPt = 80;                 % [kg] massa total do sujeito
mWC = 12;                 % [kg] massa total da cadeira de rodas com rodas (6 kg p/ cadeira + 2x3 kg para rodas)
mr = (2*3);               % [kg] massa das rodas da cadeira (3 kg para cada roda)
ma = 2*(0.020285*mPt);    % [kg] massa do antebraço (1.420 kg)
mb = 2*(0.026000*mPt);    % [kg] massa do braço (1.820 kg)
mp = (mPt-ma-mb)+(mWC-mr);% [kg] massa do corpo sem braços e mãos + massa da cadeira sem rodas (tronco + pernas + cabeça + cadeira da cadeira de rodas)
mp = 1*mp;                % [kg] aumento de massa aparente
ml = 2*0.6;               % [kg] massa da alavanca
mCJ = mPt + mWC;          % [kg] massa do conjunto todo (corpo + 2 braços + 2 antebraços + 2 rodas + cadeira(6.000 kg))
R1 = 0.3;                 % [m] raio do handrin (diâmetro de 22 polegadas = 0.5588 m) 
R2 = 0.30;                % [m] raio da roda da cadeira (diâmetro de 24 polegadas = 0.6096 m) 
A = (0.145000*hPes);      % [m] comprimento do antebraço (0.2465 m)
B = (0.188000*hPes);      % [m] comprimento do braço (0.3196 m)
a = (0.062353*hPes);      % [m] distância do CG do antebraço # cotovelo (0.1060 m)
b = (0.081941*hPes);      % [m] distância do CG do braço # ombro (0.1393 m)
Jr = 2*(0.13954);         % [kg*m^2] momento de inércia da roda (para 2 rodas)  
Jb = 2*(0.03534);         % [kg*m^2] momento de inércia do braço
Ja = 2*(0.02680);         % [kg*m^2] momento de inércia do antebraço
g = 9.81;                 % [m/s2] aceleração da gravidade
L1=0.8;
l3 = L1*0.5;
h = 0.05;                 % [m] distância na horizontal do ombro até o eixo da roda
v = 0.73;                 % [m] distância na vertical do ombro até o eixo da roda
xP = 0;                   % [m] posição do CGx do sistema -> corpo sem membro superior+cadeira de rodas
yP = 0;                   % [m] posição do CGy do sistema -> corpo sem membro superior+cadeira de rodas

lax = h;                  % [h  0.15 0.3 ];
lay = v;
L3 = R1;                  % [R1 0.4 0.5  0.6 ];
p = 1;                    % ps = [0.5 2/3 1 3/2 2];
speed = 1
ni_dg = 0     
ni  = ni_dg*pi/180; %rad
ml  = 2*0.5; %kg
Jl  = ml*L3^2/12;
Froll = 2*10; %N

t_act = 10*10^-3; %constante de aticavao
t_deact = 20*10^-3; % constante de desativacao
max_lever_w = 300; % graus/s setado no musc equivalente

betae_max = 138*pi/180;
betae_min = 12*pi/180;
alfa_min = -28*pi/180;
alfa_max = 80*pi/180;

