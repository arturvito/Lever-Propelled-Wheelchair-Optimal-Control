%% --------------------------------------------------------------------- %%
%                          ** Main Program **                             %
% Author: Artur Fernando de Vito Junior                                   %
%-------------------------------------------------------------------------%

clear; clc; close all;

% Initialize problem conditions

condition;

% Specify the number of nodes in each of the phases
% numNodesPhase1 and numNodesPhase2 represent the number of discretization points
numNodesPhase1 = 51; % Number of nodes in phase 1
numNodesPhase2 = 51; % Number of nodes in phase 2

% Define the phases of the problem using TOMLAB library
% Phase 1 goes from initial time (0) to final time tf1
toms t1 tf1     
phase1 = tomPhase('phase1', t1, 0, tf1, numNodesPhase1);

% Phase 2 starts from tf1 and goes to tf2
toms t2 tf2
phase2 = tomPhase('phase2', t2, tf1, tf2 - tf1, numNodesPhase2); 

% (problem parameters)
configurationIndices = [1, 2, 3, 4, 8, 9, 10];      
xDistances = [0.05, 0.05, 0.05, 0.05, 0.3, 0.3, 0.3]; 
leverLengths = [R1, 0.4, 0.5, 0.6, 0.4, 0.5, 0.6];   
gearRatios = [0.5, 0.75, 1, 1.25, 1.5, 2.0, 2.25, 2.5]; 
speedValues = [0.25, 0.5];                         
niDegrees = [1, 2, 3, 4];                           


for configIdx =1:1%length(configurationIndices)      
    for  gearIdx = 1:1%length(gearRatios) 
        for niIdx = 1:1%length(niDegrees)    
        cg = configurationIndices(configIdx)
        lax = xDistances(configIdx); 
        lay = v; 
        L3  = leverLengths(configIdx); 
        p   = gearRatios(gearIdx) 
        ni_dg = niDegrees(niIdx)     
        ni  = ni_dg*pi/180; %rad   
        
        if cg == 1
            ml_s = 0;
        else
            ml_s = ml;
        end
        % Moment of inertia of the lever
        Jl = ml_s * L_1^2 / 12; 
        Froll = 2 * 10; 

        % Activation and deactivation times for muscle equivalent model
        t_act = 10 * 10^-3; % Activation time constant (s)
        t_deact = 30 * 10^-3; % Deactivation time constant (s)
        max_lever_w = 300; % Maximum lever angular velocity (degrees/s)

        % Load configuration data
        config_filename = ['configs/config_' num2str(cg) '.mat'];
        load(config_filename);

        % Phase 1: propulsion
        setPhase(phase1);
        tomStates gama1 gamad1 a_pos1 a_neg1;
        tomControls u_pos1 u_neg1;
        q1 = [gama1];
        qd1 = [gamad1];

        F_pos1 = interp2(r_OS, v_OS, f_pos, gama1, gamad1, 'linear');
        F_neg1 = interp2(r_OS, v_OS, f_neg, gama1, gamad1, 'linear');

        tau_pos1 = F_pos1 * a_pos1 * L3 * 2;
        tau_neg1 = F_neg1 * a_neg1 * L3 * 2;

        % Phase 2: recovery
        setPhase(phase2);
        tomStates gama2 gamad2 x02 x02d a_pos2 a_neg2;
        tomControls u_pos2 u_neg2;
        q2 = [gama2; x02];
        qd2 = [gamad2; x02d];

        F_pos2 = interp2(r_OS, v_OS, f_pos, gama2, gamad2, 'linear');
        F_neg2 = interp2(r_OS, v_OS, f_neg, gama2, gamad2, 'linear');

        tau_pos2 = F_pos2 * a_pos2 * L3 * 2;
        tau_neg2 = F_neg2 * a_neg2 * L3 * 2;

        % Define propulsion phase dynamics
        setPhase(phase1);
        [M1, rhs1] = propulsion([q1; qd1], [tau_pos1; tau_neg1], lax, lay, L3, p, ni, Jl, ml_s, Froll);
        ceq1 = collocate({
            dot(q1) == qd1;
            M1 * dot(qd1) == rhs1;
            dot(a_pos1) == (u_pos1 - a_pos1) * (u_pos1 / t_act + (1 - u_pos1) / t_deact);
            dot(a_neg1) == (u_neg1 - a_neg1) * (u_neg1 / t_act + (1 - u_neg1) / t_deact)
        });

        % Define recovery phase dynamics
        setPhase(phase2);
        [M2, rhs2] = recovery([q2; qd2], [tau_pos2; tau_neg2], lax, lay, L3, ni, Jl, ml_s, Froll);
        ceq2 = collocate({
            dot(q2) == qd2;
            M2 * dot(qd2) == rhs2;
            dot(a_pos2) == (u_pos2 - a_pos2) * (u_pos2 / t_act + (1 - u_pos2) / t_deact);
            dot(a_neg2) == (u_neg2 - a_neg2) * (u_neg2 / t_act + (1 - u_neg2) / t_deact)
        });



        % Iterate over different speeds
        for ss = 1:1%length(speedValues)

            speed = speedValues(ss); % [m/s]
            % Maximum duration for phase 1
            DT1max = 1.5; % [s]

            % Maximum duration for phase 2
            DT2max = 1.5; % [s]

            % Phase 1: propulsion phase constraints
            setPhase(phase1);
            cbox1 = {
                0.02 <= tf1 <= DT1max;
                (min(r_OS) + 3 * pi / 180) <= icollocate(gama1) <= (max(r_OS) - 3 * pi / 180);
                -max_lever_w * pi / 180 <= icollocate(gamad1) <= max_lever_w * pi / 180;
                0 <= icollocate(a_pos1) <= 1;
                0 <= icollocate(a_neg1) <= 1
            };

            % Phase 2: recovery phase constraints
            setPhase(phase2);
            cbox2 = {
                tf1 <= tf2 <= DT1max + DT2max;
                0 <= icollocate(x02) <= speed * (DT1max + DT2max);
                (min(r_OS) + 3 * pi / 180) <= icollocate(gama2) <= (max(r_OS) - 3 * pi / 180);
                0 <= icollocate(x02d) <= 10 * speed;
                -max_lever_w * pi / 180 <= icollocate(gamad2) <= max_lever_w * pi / 180;
                0 <= icollocate(a_pos2) <= 1;
                0 <= icollocate(a_neg2) <= 1
            };
            if ni > 0
                ini = ['musc_config_' num2str(cg) '_p_' num2str(p) '_v_' num2str(speed) '_ni_' num2str(ni_dg-1) '.mat'];
            else
                if ss == 1                
                        ini = ['musc_config_' num2str(cg) '_p_' num2str(p) '_v_' num2str(speed) '_ni_' num2str(ni_dg) '.mat'];
                    else
                        ini = ['musc_config_' num2str(cg) '_p_' num2str(p) '_v_' num2str(speeds(ss-1)) '_ni_' num2str(ni_dg) '.mat'];
                end
            end
            
            pwd_ini = ['inicial/' ini];
            
            load(pwd_ini)
            setPhase(phase1)
            x10 = {tf1 == opt.tf1
                icollocate({
                gama1 == interp1p(opt.t1,opt.gama1,t1)
                gamad1 == interp1p(opt.t1,opt.gamad1,t1)
                a_pos1 == interp1p(opt.t1,opt.a_pos1,t1)
                a_neg1 == interp1p(opt.t1,opt.a_neg1,t1)
                })}; 
            setPhase(phase2)
            x20 = {tf2 == opt.tf2
                icollocate({
                gama2 == interp1p(opt.t2,opt.gama2,t2)
                gamad2 == interp1p(opt.t2,opt.gamad2,t2)
                x02 == interp1p(opt.t2,opt.x02,t2)
                x02d == interp1p(opt.t2,opt.x02d,t2)
                a_pos2 == interp1p(opt.t2,opt.a_pos2,t2)
                a_neg2 == interp1p(opt.t2,opt.a_neg2,t2)    
                })};  
            % Initial guess for controls
         
            setPhase(phase1)
            x10 = {x10
                collocate(u_pos1 == interp1p(opt.t1,opt.u_pos1,t1)  )
                collocate(u_neg1 == interp1p(opt.t1,opt.u_neg1,t1)  )};
            setPhase(phase2)
            x20 = {x20
                collocate(u_pos2 == interp1p(opt.t2,opt.u_pos2,t2)  )
                collocate(u_neg2 == interp1p(opt.t2,opt.u_neg2,t2)  )};
            
                    
            clear opt
            % Constraints
            % Lower and upper bounds on controls

            setPhase(phase1);
            cbox1 = {cbox1;
                0 <= collocate(u_pos1);
                     collocate(u_pos1) <= 1;
                0 <= collocate(u_neg1);
                     collocate(u_neg1) <= 1};

            setPhase(phase2);
            cbox2 = {cbox2;
                0 <= collocate(u_pos2);
                     collocate(u_pos2) <= 1;
                0 <= collocate(u_neg2);
                     collocate(u_neg2) <= 1};

            % Inequality constraints

            [alfa1, betae1, beta1] = ang(gama1, lax, lay, L3);
            [alfa2, betae2, beta2] = ang(gama2, lax, lay, L3);

            setPhase(phase1);
            cineq1 = {
                (betae_min) <= icollocate(betae1) <= betae_max;
                icollocate(gamad1) <= 0
            };

            setPhase(phase2);
            cineq2 = {
                (betae_min) <= icollocate(betae2) <= betae_max;
                icollocate(-gamad2 * p * R2 - x02d) <= 0
            };

            % Boundary constraints on initial and final states
            setPhase(phase1);
            cbnd1 = {};

            setPhase(phase2);
            cbnd2 = {
                initial({x02 == abs((initial(phase1, gama1) - final(phase1, gama1)) * p * R2)});
                initial({x02d == abs(final(phase1, gamad1) * p * R2)});
                final({x02 == speed * tf2}) % Roda apenas com a objective / tf2*speed
            };

            % Link constraints between phases
            link = {
                final(phase1, gama1) == initial(phase2, gama2);
                final(phase1, gamad1) == initial(phase2, gamad2);
                final(phase2, x02) == speed * tf2; % Velocidade média
                final(phase2, gama2) == initial(phase1, gama1);
                final(phase2, x02d) == abs(initial(phase1, gamad1 * p * R2));
                final(phase2, gamad2) == initial(phase1, gamad1); % Sem colisão no retorno
                final(phase2, a_pos2) == initial(phase1, a_pos1);
                final(phase2, a_neg2) == initial(phase1, a_neg1);
                final(phase1, a_pos1) == initial(phase2, a_pos2);
                final(phase1, a_neg1) == initial(phase2, a_neg2)
            };

            % Objective function
            objective = ((integrate(phase1, u_pos1^2) + integrate(phase1, u_neg1^2) + integrate(phase2, u_pos2^2) + integrate(phase2, u_neg2^2)) / (tf2 * speed));

            % Direct Solution Setup

            options = struct;
            options.name = 'leverwheelchair';
            options.PriLevOpt = 1; % Priority level for output options
            options.Prob.SOL.optPar(30) = 500000;
            options.Prob.SOL.optPar(35) = 500000;
            options.Prob.SOL.optPar(36) = 500000;

            % Set up constraints for the problem
            constr = {cbox1, ceq1, cineq1, cbox2, ceq2, cineq2, cbnd1, cbnd2, link};

            % Solve the optimization problem
            [solution, prop] = ezsolve(objective, constr, {x10, x20}, options);


            % Process results for phase 1
            opt.tf1 = subs(tf1, solution);
            opt.t1 = subs(icollocate(phase1, t1), solution);
            opt.gama1 = subs(icollocate(phase1, gama1), solution);
            opt.gamad1 = subs(icollocate(phase1, gamad1), solution);
            opt.a_pos1 = subs(icollocate(phase1, a_pos1), solution);
            opt.a_neg1 = subs(icollocate(phase1, a_neg1), solution);
            opt.u_pos1 = subs(icollocate(phase1, u_pos1), solution);
            opt.u_neg1 = subs(icollocate(phase1, u_neg1), solution);
            opt.nn1 = numNodesPhase1;

            opt.x01 = -(opt.gama1 - opt.gama1(1)) * p * R2;
            opt.gamaw1 = opt.gama1 * p;
            opt.gamawd1 = opt.gamad1 * p;

            % Process results for phase 2
            opt.tf2 = subs(tf2, solution);
            opt.t2 = subs(icollocate(phase2, t2), solution);
            opt.gama2 = subs(icollocate(phase2, gama2), solution);
            opt.x02 = subs(icollocate(phase2, x02), solution);
            opt.gamad2 = subs(icollocate(phase2, gamad2), solution);
            opt.x02d = subs(icollocate(phase2, x02d), solution);
            opt.a_pos2 = subs(icollocate(phase2, a_pos2), solution);
            opt.a_neg2 = subs(icollocate(phase2, a_neg2), solution);
            opt.u_pos2 = subs(icollocate(phase2, u_pos2), solution);
            opt.u_neg2 = subs(icollocate(phase2, u_neg2), solution);
            opt.objective = subs(objective, solution);
            opt.nn2 = numNodesPhase2;

            opt.gamawd2 = -opt.x02d / R2;

            opt.speed = speed;

            % Consolidate results
            opt.t = [opt.t1; opt.t2];
            opt.a_pos = [opt.a_pos1; opt.a_pos2];
            opt.a_neg = [opt.a_neg1; opt.a_neg2];
            opt.u_pos = [opt.u_pos1; opt.u_pos2];
            opt.u_neg = [opt.u_neg1; opt.u_neg2];
            opt.gama = [opt.gama1; opt.gama2];
            opt.gamad = [opt.gamad1; opt.gamad2];
            opt.x0 = [opt.x01; opt.x02];
            opt.gamawd = [opt.gamawd1; opt.gamawd2];

            % Compute angles
            [opt.alfa, opt.betae, opt.beta] = ang(opt.gama, lax, lay, L3);
            opt.exit = prop.ExitFlag;
            opt.exit_text = prop.ExitText;

            % Save results
            if ni_dg == 0
                save(['inicial/musc_config_' num2str(cg) '_p_' num2str(p) '_v_' num2str(speed) '_ni_' num2str(ni_dg) '.mat'], 'opt');
                save(['plano/musc_config_' num2str(cg) '_p_' num2str(p) '_v_' num2str(speed) '_ni_' num2str(ni_dg) '.mat'], 'opt', 'lax', 'lay', 'L3', 'p', 'ni', 'ml_s', 'Jl', 'Froll', 'pwd_ini');
            else
                save(['inicial/musc_config_' num2str(cg) '_p_' num2str(p) '_v_' num2str(speed) '_ni_' num2str(ni_dg) '.mat'], 'opt');
                save(['inclinado/musc_config_' num2str(cg) '_p_' num2str(p) '_v_' num2str(speed) '_ni_' num2str(ni_dg) '.mat'], 'opt', 'lax', 'lay', 'L3', 'p', 'ni', 'ml_s', 'Jl', 'Froll', 'pwd_ini');
            end
        end
        end
    end
end



