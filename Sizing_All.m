%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                SECTION #1: AIRCRAFT AND ENGINE SIZING                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Aircraft Dyanmics
% Inputs
A.Vel = 300;          % Aircaft velocity [m/s]
A.Vel0 = 100;          % Aircaft velocity [m/s]
A.M_dry = 108500;     % Dry weight [kg]
A.M_payload = 21337;  % Payload weight [kg]

% Parameters    
A.rho = 0.243;        % Air density [kg/m^3]
A.A = 360;            % Reference area [m^2]
A.Cd = 0.02439;       % Drag coefficient [-]

% Calculated Variables
A.F_drag = 0.5*A.rho*A.A*A.Cd*A.Vel^2;      % Drag force [N]
A.F_thrust = 0.5*A.F_drag;          % EngRine thrust [N] (assumed 2 EngRines)

% Additional Parameters that need sizing or sizing comes from other models
A.M_fuel = 86073;   % Total sass in fuel tanks [kg]

%% Right EngRine Dynamics
% Inputs
EngR.Omega = 1000;       % Engine shaft speed [rad/s]
EngR.Omega0 = 500;       % Engine shaft speed [rad/s]
EngR.eta = 0.5;          % Engine efficiency [-]
EngR.R_elect = 0.05;     % Ratio of electrical power to propulsive power
EngR.F_thrust_max = 100000;    % Maximum thrust force [N]
EngR.P = 3500;           % Engine pressure [kPa]
EngR.J = 100;            % Engine inertia [kg m^2]

% Parameters
EngR.U = 46000;          % Fuel specific energy [kJ/kg]
% EngR.alpha = 150/EngR.Omega;  % coefficient relating bearing heat gen to shaft speed [kW/rad/s]
EngR.alpha = 50/EngR.Omega;  % coefficient relating bearing heat gen to shaft speed [kW/rad/s]

% Calculated Variables
EngR.Q_bearings = EngR.alpha*EngR.Omega;           % Heat from bearings [kW]
EngR.mdot_fuel = 1/(1000*EngR.eta*EngR.U)*((1+EngR.R_elect)*A.F_thrust*A.Vel + 1000*EngR.Q_bearings); % Fuel mass flow rate [kg/s]
EngR.Q_burn = (1-EngR.eta)*EngR.U*EngR.mdot_fuel;     % EngRine heat generation [kW]
EngR.tau = 1/EngR.Omega*EngR.R_elect*A.F_thrust*A.Vel; % Torque on EngRine from generator [Nm]
EngR.P_elect = 1/1000*EngR.tau*EngR.Omega;                % Electrical power generation [kW]
EngR.Omega_max = EngR.Omega*(EngR.F_thrust_max/A.F_thrust)^(1/3); % Maximum Engine speed [rad/s]

% Additional Parameters that need sizing or sizing comes from other models
EngR.Tin_fuel = 100;    % Fuel inlet temperature [C]

%% Left EngRine Dynamics
% Inputs
EngL.Omega = 1000;       % Engine shaft speed [rad/s]
EngL.Omega0 = 500;       % Engine shaft speed [rad/s]
EngL.eta = 0.5;          % Engine efficiency [-]
EngL.R_elect = 0.05;     % Ratio of electrical power to propulsive power
EngL.F_thrust_max = 100000;    % Maximum thrust force [N]
EngL.P = 3500;           % Engine pressure [kPa]
EngL.J = 100;            % Engine inertia [kg m^2]

% Parameters
EngL.U = 46000;          % Fuel specific energy [kJ/kg]
% EngL.alpha = 150/EngL.Omega;  % coefficient relating bearing heat gen to shaft speed [kW/rad/s]
EngL.alpha = 50/EngL.Omega;  % coefficient relating bearing heat gen to shaft speed [kW/rad/s]

% Calculated Variables
EngL.Q_bearings = EngL.alpha*EngL.Omega;           % Heat from bearings [kW]
EngL.mdot_fuel = 1/(1000*EngL.eta*EngL.U)*((1+EngL.R_elect)*A.F_thrust*A.Vel + 1000*EngL.Q_bearings); % Fuel mass flow rate [kg/s]
EngL.Q_burn = (1-EngL.eta)*EngL.U*EngL.mdot_fuel;     % EngLine heat generation [kW]
EngL.tau = 1/EngL.Omega*EngL.R_elect*A.F_thrust*A.Vel; % Torque on EngLine from generator [Nm]
EngL.P_elect = 1/1000*EngL.tau*EngL.Omega;                % Electrical power generation [kW]
EngL.Omega_max = EngL.Omega*(EngL.F_thrust_max/A.F_thrust)^(1/3); % Maximum Engine speed [rad/s]

% Additional Parameters that need sizing or sizing comes from other models
EngL.Tin_fuel = 100;    % Fuel inlet temperature [C]

%% Right Generator Dynamics
% Inputs
GenR.V = 230;        % Generator voltage (VAC)
% GenR.eta = 0.98;     % Generator efficiency (-)
GenR.eta = 0.90;     % Generator efficiency (-)

% Calculated Variables
GenR.I = 1/GenR.V*GenR.eta*1000*EngR.P_elect;   % Generator Amps (A)
GenR.Q = (1-GenR.eta)*EngR.tau*EngR.Omega/1000; % Generator Heat (kW)
GenR.P_total = GenR.I*GenR.V/1000;              % Generator Power (kW)

% Additional Parameters that need sizing or sizing comes from other models
GenR.T = 100;       % Generator temperature [C]

%% Left Generator Dynamics
% Inputs
GenL.V = 230;        % Generator voltage (VAC)
% GenL.eta = 0.98;     % Generator efficiency (-)
GenL.eta = 0.9;     % Generator efficiency (-)


% Calculated Variables
GenL.I = 1/GenL.V*GenL.eta*1000*EngR.P_elect;   % Generator Amps (A)
GenL.Q = (1-GenL.eta)*EngR.tau*EngR.Omega/1000; % Generator Heat (kW)
GenL.P_total = GenL.I*GenL.V/1000;              % Generator Power (kW)

% Additional Parameters that need sizing or sizing comes from other models
GenL.T = 100;       % Generator temperature [C]

%% Left HVAC Bus Dynamics
HVACL.frac_Other = 0.15;         % Fraction of power to other loads
HVACL.frac_Wing = 0.15;          % Fraction of power to wing de-icing 
HVACL.frac_FuelPumps = 0.05;     % Fraction of power to fuel pumps
HVACL.frac_CargoHeater = 0.05;   % Fraction of power to cargo heater
HVACL.frac_ACDC = 0.60;          % Fraction of power to ACDC inverter for HVDC bus loads

%% Righ HVAC Bus Dynamics
HVACR.frac_Other = 0.20;         % Fraction of power to other loads
HVACR.frac_Wing = 0.15;          % Fraction of power to wing de-icing 
HVACR.frac_FuelPumps = 0.05;     % Fraction of power to fuel pumps
HVACR.frac_AEE = 0.00;           % Fraction of power to AEE
HVACR.frac_ACDC = 0.30;          % Fraction of power to ACDC inverter for LVDC bus loads
HVACR.frac_ACAC = 0.30;          % Fraction of power to ACAC inverter for LVAC bus loads

%% Advanced Electrioncs Equipment
AEE.P_max        = 500;
AEE.eff.maxT     = 30;  %
AEE.eff.max_eta  = 0.98; % Maximum efficiency [-]
AEE.eff.min_eta  = 0.8;  % Minimium efficiency [-]
AEE.Tmax         = 100;  % Maximium temperature [C]

%% HVDC Converter Dynamics
Converters.HVDC.N = 5;          % Number of converters in bank
Converters.HVDC.P_in = HVACL.frac_ACDC*GenL.P_total/Converters.HVDC.N;   % Inlet power [kW]
% Converters.HVDC.eta  = 0.98;    % Desired efficiency
Converters.HVDC.eta  = 0.96;    % Desired efficiency
Converters.HVDC.P_out = Converters.HVDC.eta*Converters.HVDC.P_in;   % Outlet power [kW]
Converters.HVDC.Q = (1-Converters.HVDC.eta)*Converters.HVDC.P_in;   % Heat generation [kW]
Converters.HVDC.V            = 270; % Output voltage
Converters.HVDC.I = 1000*Converters.HVDC.P_out/Converters.HVDC.V;   % Current per converter in bank [A]
Converters.HVDC.eff.maxI     = Converters.HVDC.I;   % Current corresponding to maximium efficiency [A]
Converters.HVDC.eff.max_eta  = Converters.HVDC.eta; % Maximum efficiency [-]
Converters.HVDC.eff.min_eta  = 0.92; % Minimium efficiency [-]
Converters.HVDC.eff.min_eta  = 0.8; % Minimium efficiency [-]

%% LVDC Converter Dynamics
Converters.LVDC.N = 5;          % Number of converters in bank
Converters.LVDC.P_in = HVACR.frac_ACDC*GenL.P_total/Converters.LVDC.N;   % Inlet power [kW]
% Converters.LVDC.eta  = 0.98;    % Desired efficiency
Converters.LVDC.eta  = 0.96;    % Desired efficiency
Converters.LVDC.P_out = Converters.LVDC.eta*Converters.LVDC.P_in;   % Outlet power [kW]
Converters.LVDC.Q = (1-Converters.LVDC.eta)*Converters.LVDC.P_in;   % Heat generation [kW]
Converters.LVDC.V            = 28; % Output voltage
Converters.LVDC.I = 1000*Converters.LVDC.P_out/Converters.LVDC.V;   % Current per converter in bank [A]
% Converters.LVDC.eff.maxI     = Converters.LVDC.I;   % Current corresponding to maximium efficiency [A]
Converters.LVDC.eff.maxI     = 1400;   % Current corresponding to maximium efficiency [A]
Converters.LVDC.eff.max_eta  = Converters.LVDC.eta; % Maximum efficiency [-]
Converters.LVDC.eff.min_eta  = 0.92; % Minimium efficiency [-]
Converters.LVDC.eff.min_eta  = 0.8; % Minimium efficiency [-]

%% LVAC Converter Dynamics
Converters.LVAC.N = 5;          % Number of converters in bank
Converters.LVAC.P_in = HVACR.frac_ACAC*GenL.P_total/Converters.LVAC.N;   % Inlet power [kW]
% Converters.LVAC.eta  = 0.98;    % Desired efficiency
Converters.LVAC.eta  = 0.96;    % Desired efficiency
Converters.LVAC.P_out = Converters.LVAC.eta*Converters.LVAC.P_in;   % Outlet power [kW]
Converters.LVAC.Q = (1-Converters.LVAC.eta)*Converters.LVAC.P_in;   % Heat generation [kW]
Converters.LVAC.V            = 115; % Output voltage
Converters.LVAC.I = 1000*Converters.LVAC.P_out/Converters.LVAC.V;   % Current per converter in bank [A]
Converters.LVAC.eff.maxI     = Converters.LVAC.I;   % Current corresponding to maximium efficiency [A]
Converters.LVAC.eff.max_eta  = Converters.LVAC.eta; % Maximum efficiency [-]
Converters.LVAC.eff.min_eta  = 0.92; % Minimium efficiency [-]
Converters.LVAC.eff.min_eta  = 0.8; % Minimium efficiency [-]

%% HVDC Bus Dynamics
HVDC.P_in = Converters.HVDC.P_out*Converters.HVDC.N; % Power into bus [kW]
HVDC.frac_Battery = 0.20;       % Fraction of power to battery
HVDC.frac_ACMmotor = 0.20;      % Fraction of power to ACM motor
HVDC.frac_ECSblowers = 0.20;    % Fraction of power to ECS blowers
HVDC.frac_Hydraulics = 0.20;    % Fraction of power to hydraulic loads
HVDC.frac_Other = 0.20;         % Fraction of power to other loads

%% LVDC Bus Dynamics
LVDC.P_in = Converters.LVDC.P_out*Converters.LVDC.N; % Power into bus [kW]
LVDC.frac_Battery = 0.20;       % Fraction of power to battery
LVDC.frac_FADECs = 0.20;        % Fraction of power to FADECs
LVDC.frac_Oilpumps = 0.20;      % Fraction of power to Oil and PAO pumps
LVDC.frac_Shed = 0.20;          % Fraction of power to sheddable loads
LVDC.frac_NoShed = 0.20;        % Fraction of power to non sheddable loads

%% LVAC Bus Dynamics
LVAC.P_in = Converters.LVAC.P_out*Converters.LVAC.N; % Power into bus [kW]
LVAC.frac_Fans = 0.25;          % Fraction of power to fans
LVAC.frac_Pumps = 0.25;         % Fraction of power to pumps
LVAC.frac_Shed = 0.25;          % Fraction of power to sheddable loads
LVAC.frac_NoShed = 0.25;        % Fraction of power to non sheddable loads

%% HVDC Battery
HVbatt.T0 = 20;      % Initial temperature [C]
HVbatt.SOC0 = 0.5;   % Initial state of charge [0-1]
HVbatt.Cap = 100;    % Capacitiance [MJ]
HVbatt.Pmax = 100;   % Maximium power [kW]
HVbatt.Tmax = 100;   % Maximium temperature [C]
HVbatt.eff.maxT = HVbatt.T0;  % Temperature of maximum efficiency [C]
% HVbatt.eff.max_eta  = 0.98; % Maximum efficiency [-]
HVbatt.eff.max_eta  = 0.96; % Maximum efficiency [-]
HVbatt.eff.min_eta  = 0.8;  % Minimium efficiency [-]
HVbatt.usage = HVbatt.eff.max_eta*HVDC.frac_Battery*HVDC.P_in/HVbatt.Pmax; % Usage [percent of max power]
HVbatt.Q = HVbatt.Pmax*HVbatt.usage*(1-HVbatt.eff.max_eta)/HVbatt.eff.max_eta; % Heat generation [kW]

%% LVDC Battery
LVbatt.T0 = 20;      % Initial temperature [C]
LVbatt.SOC0 = 0.5;   % Initial state of charge [0-1]
LVbatt.Cap = 100;    % Capacitiance [MJ]
LVbatt.Pmax = 100;   % Maximium power [kW]
LVbatt.Tmax = 100;   % Maximium temperature [C]
LVbatt.eff.maxT = LVbatt.T0;  % Temperature of maximum efficiency [C]
% LVbatt.eff.max_eta  = 0.98; % Maximum efficiency [-]
LVbatt.eff.max_eta  = 0.96; % Maximum efficiency [-]
LVbatt.eff.min_eta  = 0.8;  % Minimium efficiency [-]
LVbatt.usage = LVbatt.eff.max_eta*LVDC.frac_Battery*LVDC.P_in/LVbatt.Pmax; % Usage [percent of max power]
LVbatt.Q = LVbatt.Pmax*LVbatt.usage*(1-LVbatt.eff.max_eta)/LVbatt.eff.max_eta; % Heat generation [kW]

%% FADECs
FADEC.P_max        = LVDC.P_in;
FADEC.eff.maxT     = 30;  %
FADEC.eff.max_eta  = 0.975; % Maximum efficiency [-]
FADEC.eff.min_eta  = 0.975;  % Minimium efficiency [-]
FADEC.Tmax         = 100;  % Maximium temperature [C]

%% Loads
LOAD.P_max        = LVDC.P_in;
LOAD.eff.maxT     = 30;  %
LOAD.eff.max_eta  = 0.9; % Maximum efficiency [-]
LOAD.eff.min_eta  = 0.9;  % Minimium efficiency [-]
LOAD.Tmax         = 100;  % Maximium temperature [C]
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        SECTION #2: CONVERTER & BATTERY COOLING LOOPS SIZING             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% nominal values for HVDC cold plates
Converters.HVDC.CP.delT = 10;   % temp. between outlet fluid and wall
hAnom                   = Converters.HVDC.Q*1000/Converters.HVDC.CP.delT;
mdotnom                 = 0.06478;
Cp                      = 3.53;
% cold plate parameters
Converters.HVDC.CP.mass         = 0.5;      % cold plate mass [kg]
Converters.HVDC.CP.Cp           = 0.9;      % specific heat [kJ/kgK]
% Converters.HVDC.CP.ID           = 0.01;     % internal diameter [m]
Converters.HVDC.CP.ID           = 0.005;     % internal diameter [m]
% Converters.HVDC.CP.L            = 1.25;     % heat transfer length [m]
Converters.HVDC.CP.L            = 3;     % heat transfer length [m]
Converters.HVDC.CP.t_wall       = 0.002;    % wall thickness [m]

% calculating the heat transfer coeff. [W/m^2K]
H = hAnom / (pi() * Converters.HVDC.CP.ID *  Converters.HVDC.CP.L);
Converters.HVDC.CP.H            = H;     

% cold plate initial conditions
Converters.HVDC.CP.init.P       = 230.2;      % initial pressure [kPa]
Converters.HVDC.CP.init.Tin     = 33.63;       % initial inlet temp. [°C]
% initial outlet temp. [°C]
Converters.HVDC.CP.init.Tout    = Converters.HVDC.CP.init.Tin + ...
                                  Converters.HVDC.Q/(mdotnom * Cp);  
% initial wall temp. [°C]
Converters.HVDC.CP.init.Twall   = Converters.HVDC.CP.init.Tout + ...
                                  Converters.HVDC.CP.delT;       

%% nominal values for LVDC cold plates
Converters.LVDC.CP.delT = 10;   % temp. between outlet fluid and wall
hAnom                   = Converters.LVDC.Q*1000/Converters.LVDC.CP.delT;

% cold plate parameters
Converters.LVDC.CP.mass         = 0.5;      % cold plate mass [kg]
Converters.LVDC.CP.Cp           = 0.9;      % specific heat [kJ/kgK]
% Converters.LVDC.CP.ID           = 0.01;     % internal diameter [m]
Converters.LVDC.CP.ID           = 0.005;     % internal diameter [m]
% Converters.LVDC.CP.L            = 1.25;     % heat transfer length [m]
Converters.LVDC.CP.L            = 3;     % heat transfer length [m]
Converters.LVDC.CP.t_wall       = 0.002;    % wall thickness [m]

% calculating the heat transfer coeff. [W/m^2K]
H = hAnom / (pi() * Converters.LVDC.CP.ID *  Converters.LVDC.CP.L);
Converters.LVDC.CP.H            = H;     

% cold plate initial conditions
Converters.LVDC.CP.init.P       = 230.2;      % initial pressure [kPa]
Converters.LVDC.CP.init.Tin     = 33.63;       % initial inlet temp. [°C]
% initial outlet temp. [°C]
Converters.LVDC.CP.init.Tout    = Converters.LVDC.CP.init.Tin + ...
                                  Converters.LVDC.Q/(mdotnom * Cp);  
% initial wall temp. [°C]
Converters.LVDC.CP.init.Twall   = Converters.LVDC.CP.init.Tout + ...
                                  Converters.LVDC.CP.delT;       

%% nominal values for LVAC cold plates
Converters.LVAC.CP.delT = 10;   % temp. between outlet fluid and wall
hAnom                   = Converters.LVAC.Q*1000/Converters.LVAC.CP.delT;

% cold plate parameters
Converters.LVAC.CP.mass         = 0.5;        % cold plate mass [kg]
Converters.LVAC.CP.Cp           = 0.9;      % specific heat [kJ/kgK]
% Converters.LVAC.CP.ID           = 0.01;     % internal diameter [m]
Converters.LVAC.CP.ID           = 0.005;     % internal diameter [m]
% Converters.LVAC.CP.L            = 1.25;     % heat transfer length [m]
Converters.LVAC.CP.L            = 3;     % heat transfer length [m]
Converters.LVAC.CP.t_wall       = 0.002;    % wall thickness [m]

% calculating the heat transfer coeff. [W/m^2K]
H = hAnom / (pi() * Converters.LVAC.CP.ID *  Converters.LVAC.CP.L);
Converters.LVAC.CP.H            = H;     

% cold plate initial conditions
Converters.LVAC.CP.init.P       = 230.2;      % initial pressure [kPa]
Converters.LVAC.CP.init.Tin     = 33.63;       % initial inlet temp. [°C]
% initial outlet temp. [°C]
Converters.LVAC.CP.init.Tout    = Converters.LVAC.CP.init.Tin + ...
                                  Converters.LVAC.Q/(mdotnom * Cp);  
% initial wall temp. [°C]
Converters.LVAC.CP.init.Twall   = Converters.LVAC.CP.init.Tout + ...
                                  Converters.LVAC.CP.delT;       

%% nominal values for battery cold plates     
HVbatt.CP.delT = 10;   % temp. between outlet fluid and wall
hAnom                   = HVbatt.Q*1000/HVbatt.CP.delT;
mdotnom                 = 0.07202;
Cp                      = 3.53;

HVbatt.CP.mass              = 0.5;        % cold plate mass [kg]
HVbatt.CP.Cp                = 0.9;      % specific heat [kJ/kgK]
HVbatt.CP.ID                = 0.01;     % internal diameter [m]
% HVbatt.CP.L                 = 1.25;     % heat transfer length [m]
HVbatt.CP.L                 = 5;     % heat transfer length [m]
HVbatt.CP.t_wall            = 0.002;    % wall thickness [m]

% calculating the heat transfer coeff. [W/m^2K]
H = hAnom / (pi() * HVbatt.CP.ID *  HVbatt.CP.L);
HVbatt.CP.H                 = H;     

% cold plate initial conditions
HVbatt.CP.init.P            = 230.2;      % initial pressure [kPa]
HVbatt.CP.init.Tin          = 33.63;       % initial inlet temp. [°C]
% initial outlet temp. [°C]
HVbatt.CP.init.Tout         = HVbatt.CP.init.Tin + HVbatt.Q/(mdotnom * Cp);  
% initial wall temp. [°C]
HVbatt.CP.init.Twall        = HVbatt.CP.init.Tout + HVbatt.CP.delT;       

LVbatt.CP.delT = 10;   % temp. between outlet fluid and wall
hAnom                   = LVbatt.Q*1000/LVbatt.CP.delT;

LVbatt.CP.mass              = 0.5;        % cold plate mass [kg]
LVbatt.CP.Cp                = 0.9;      % specific heat [kJ/kgK]
LVbatt.CP.ID                = 0.01;     % internal diameter [m]
% LVbatt.CP.L                 = 1.25;     % heat transfer length [m]
LVbatt.CP.L                 = 5;     % heat transfer length [m]
LVbatt.CP.t_wall            = 0.002;    % wall thickness [m]

% calculating the heat transfer coeff. [W/m^2K]
H = hAnom / (pi() * LVbatt.CP.ID *  LVbatt.CP.L);
LVbatt.CP.H                 = H;     

% cold plate initial conditions
LVbatt.CP.init.P            = 230.2;      % initial pressure [kPa]
LVbatt.CP.init.Tin          = 33.63;       % initial inlet temp. [°C]
% initial outlet temp. [°C]
LVbatt.CP.init.Tout         = LVbatt.CP.init.Tin + LVbatt.Q/(mdotnom * Cp);  
% initial wall temp. [°C]
LVbatt.CP.init.Twall        = LVbatt.CP.init.Tout + ...
                                  LVbatt.CP.delT;       


%% nominal values for inverter & battery coolant pump
Pumps.InvrtrPump.ID             = 0.03;     % internal diameter [m]
Pumps.InvrtrPump.OmegaMax       = 5000;     % max shaft speed [RPM]
% Pumps.InvrtrPump.dPMax          = 150;      % max pressure difference [kPa]
Pumps.InvrtrPump.dPMax          = 350;      % max pressure difference [kPa]
Pumps.InvrtrPump.dPMax          = 650;      % max pressure difference [kPa]
% Pumps.InvrtrPump.mdotMax        = 2.5;      % max flow rate [kg/s]
Pumps.InvrtrPump.mdotMax        = 5;      % max flow rate [kg/s]
Pumps.InvrtrPump.alpha          = 1e-5;     % heat gen. coeff [kW/RPM]

Pumps.InvrtrPump.init.P         = 244.2;      % initial outlet pressure [kPa]
Pumps.InvrtrPump.init.T         = 33.64;       % initial outlet temp. [°C]

%% nominal values for ACM heat exchangers -- ACM1 - liquid, ACM2 - air
% Note, side1 and side 2 are identical
HX.ACM1.mass                    = 0.1;      % single wall mass [kg]
HX.ACM1.Cp_wall                 = 0.9;      % wall specific heat [kJ/kgK]
HX.ACM1.side1.N                 = 5;        % number of passes
HX.ACM1.side1.W                 = 87e-2;    % Plate width [m]
HX.ACM1.side1.t                 = 1e-2;     % Plate spacing [m]
HX.ACM1.side1.L                 = 2e-1;     % Plate width [m]

HX.ACM1.delTw = 12;       % temp. between outlet fluid and wall
Qtot                    = (HVbatt.Q + LVbatt.Q + Converters.LVDC.Q + ...
                           Converters.LVAC.Q + Converters.HVDC.Q)*0.5;
hAnom                   = Qtot * 1000 / HX.ACM1.delTw;

Ar = HX.ACM1.side1.L*(2*HX.ACM1.side1.t+2*HX.ACM1.side1.W);
H = hAnom/Ar;

% HX.ACM1.delTf = 3;       % temp. between outlet fluid and wall

HX.ACM1.side1.H                 = H;        % heat transfer coeff. [W/m^2K]
HX.ACM1.side2                   = HX.ACM1.side1;

% initial conditions
HX.ACM1.init.Twall              = 31.65;       % initial wall temp. [°C]
HX.ACM1.init.Twall              = 26.8669;       % initial wall temp. [°C]
HX.ACM1.init.P1                 = 99.0945;      % initial outlet pressure [kPa]
% initial outlet temp. [°C]
HX.ACM1.init.T1                 = HX.ACM1.init.Twall - Qtot/hAnom*1000;       
HX.ACM1.init.T1                 = 19.6801;       
HX.ACM1.init.P2                 = 99.9998;      % initial outlet pressure [kPa]
% initial outlet temp. [°C]
HX.ACM1.init.T2                 = HX.ACM1.init.Twall + Qtot/hAnom*1000;       
HX.ACM1.init.T2                 = 34.0536;       



Junction.No6.init.T     = (LVbatt.CP.init.Tout+HVbatt.CP.init.Tout+ ...
    Converters.HVDC.CP.init.Tout+Converters.LVDC.CP.init.Tout + ...
    Converters.LVAC.CP.init.Tout)/5;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                SECTION #4: AIR CYCLE MACHINE SIZING                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ACM map creation
clear ACM
ACM.MAP.PwrComp = generate_comp_map(4,2.5,10000,80,70,1,2,1);
ACM.MAP.Comp    = generate_comp_map(3,2.75,65000,75,70,1,2,1);
ACM.MAP.Turb    = generate_turb_map(3,1.75,95,90,0);

%% nominal values for ACM junctions

Splits.ACM.Geom.D       = 0.08;          % diameter [m]
Splits.ACM.Geom.L       = 0.1;          % length [m]
Splits.ACM.Geom.t_wall  = 0.0015;       % wall thickness [m]

Valves.ACM.Geom.D       = 0.2;          % diameter [m]
Valves.ACM.Geom.L       = 0.2;          % length [m]
Valves.ACM.Geom.t_wall  = 0.0015;       % wall thickness [m]

Valves.ACM.IC.P         = [278.303464521142, 277.7020838769718];
Valves.ACM.IC.T         = [124.282503406670, 101.8393518772119];

Splits.ACM.IC.P         = [147.3304322852672, 278.2879456244837, 278.9258788625671, 99.451194530004320];
Splits.ACM.IC.T         = [65.18470360145118, 124.2825034066700, 155.6373551288449, 11.386700349818450];


%% nominal values for ACM heat exchangers -- ACM1 - liquid, ACM2 - air
% Note, side1 and side 2 are identical
HX.ACM2.mass                    = 0.1;      % single wall mass [kg]
HX.ACM2.Cp_wall                 = 0.9;      % wall specific heat [kJ/kgK]
HX.ACM2.side1.N                 = 5;        % number of passes
HX.ACM2.side1.W                 = 80e-2;    % Plate width [m]
HX.ACM2.side1.t                 = 3e-2;     % Plate spacing [m]
HX.ACM2.side1.L                 = 4e-1;     % Plate width [m]

HX.ACM2.delTw = 20;       % temp. between outlet fluid and wall
% Qtot                    = 10;
Qtot                    = 30;
hAnom                   = Qtot * 1000 / HX.ACM2.delTw;

Ar = HX.ACM2.side1.L*(2*HX.ACM2.side1.t+2*HX.ACM2.side1.W);
H = hAnom/Ar;

HX.ACM2.side1.H                 = H;        % heat transfer coeff. [W/m^2K]
HX.ACM2.side2                   = HX.ACM2.side1;

% initial conditions
HX.ACM2.init.Twall              = 16.87327;       % initial wall temp. [°C]
HX.ACM2.init.P1                 = 99.999;      % initial outlet pressure [kPa]
HX.ACM2.init.P2                 = 99.4;      % initial outlet pressure [kPa]
% initial outlet temp. [°C]
HX.ACM2.init.T1                 = HX.ACM2.init.Twall - Qtot/hAnom*1000;
HX.ACM2.init.T1 = 21.37428;
% initial outlet temp. [°C]
HX.ACM2.init.T2                 = HX.ACM2.init.Twall + Qtot/hAnom*1000;           
HX.ACM2.init.T2 = 14.62277;
%% nominal values for ACMBYss-acm HX
% Note, side1 and side 2 are identical
HX.ACMBY.mass                    = 0.1;      % single wall mass [kg]
HX.ACMBY.Cp_wall                 = 0.9;      % wall specific heat [kJ/kgK]
HX.ACMBY.side1.N                 = 5;        % number of passes
HX.ACMBY.side1.W                 = 80e-2;    % Plate width [m]
HX.ACMBY.side1.t                 = 3e-2;     % Plate spacing [m]
HX.ACMBY.side1.L                 = 4e-1;     % Plate width [m]

HX.ACMBY.delTw = 20;       % temp. between outlet fluid and wall
% Qtot                    = 10;
Qtot                    = 30;
hAnom                   = Qtot * 1000 / HX.ACMBY.delTw;

Ar = HX.ACMBY.side1.L*(2*HX.ACMBY.side1.t+2*HX.ACMBY.side1.W);
H = hAnom/Ar;

HX.ACMBY.side1.H                 = H;        % heat transfer coeff. [W/m^2K]
HX.ACMBY.side2                   = HX.ACMBY.side1;

% initial conditions
HX.ACMBY.init.Twall              = 70.887458;       % initial wall temp. [°C]
HX.ACMBY.init.P1                 = 49.956;      % initial outlet pressure [kPa]
HX.ACMBY.init.P2                 = 278.980;      % initial outlet pressure [kPa]
% initial outlet temp. [°C]
HX.ACMBY.init.T1                 = HX.ACMBY.init.Twall - Qtot/hAnom*1000;             
HX.ACMBY.init.T1 = 48.93259;
% initial outlet temp. [°C]
HX.ACMBY.init.T2                 = HX.ACMBY.init.Twall + Qtot/hAnom*1000;           
HX.ACMBY.init.T2 = 92.842325;
%% nominal values for ACMBYss-acm HX
% Note, side1 and side 2 are identical
HX.ACMFUEL.mass                    = 0.1;      % single wall mass [kg]
HX.ACMFUEL.Cp_wall                 = 0.9;      % wall specific heat [kJ/kgK]
HX.ACMFUEL.side1.N                 = 5;        % number of passes
HX.ACMFUEL.side1.W                 = 80e-2;    % Plate width [m]
HX.ACMFUEL.side1.t                 = 3e-2;     % Plate spacing [m]
HX.ACMFUEL.side1.L                 = 4e-1;     % Plate width [m]

HX.ACMFUEL.delTw = 20;       % temp. between outlet fluid and wall
% Qtot                    = 10;
Qtot                    = 30;
hAnom                   = Qtot * 1000 / HX.ACMFUEL.delTw;

Ar = HX.ACMFUEL.side1.L*(2*HX.ACMFUEL.side1.t+2*HX.ACMFUEL.side1.W);
H = hAnom/Ar;

% 7500 1500
HX.ACMFUEL.side1.H                 = H;        % heat transfer coeff. [W/m^2K]
HX.ACMFUEL.side2                   = HX.ACMFUEL.side1;

% initial conditions
HX.ACMFUEL.init.Twall              = 63.7338;       % initial wall temp. [°C]
HX.ACMFUEL.init.P1                 = 278.34817;      % initial outlet pressure [kPa]
HX.ACMFUEL.init.P2                 = 98.5;      % initial outlet pressure [kPa]
% initial outlet temp. [°C]
HX.ACMFUEL.init.T1                 = HX.ACMFUEL.init.Twall - Qtot/hAnom*1000;             
HX.ACMFUEL.init.T1 = 79.43317;
% initial outlet temp. [°C]
HX.ACMFUEL.init.T2                 = HX.ACMBY.init.Twall + Qtot/hAnom*1000;           
HX.ACMFUEL.init.T2 = 48.03451;

%% nominal shaft values
ACM.Shaft.init.omega            = 41663.5;    % initial shaft speed [RPM]

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         SECTION #5: CABIN, COCKPIT, ELECTRONICS BAY SIZING              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cabins and bays

AirZone.Cabin.init.T        = 22.0;   % cabin temperature [°C]
AirZone.Cabin.init.Tamb     = 0;    % ambient temperature [°C]
AirZone.Cabin.init.P        = 79.35;   % cabin pressure [kPa]

% AirZone.Cabin.H_amb         = 2;    % heat trans coeff w/amb [W/m^2K]
AirZone.Cabin.H_amb         = 0.5;    % heat trans coeff w/amb [W/m^2K]
AirZone.Cabin.D             = 3;    % cabin diameter [m]
AirZone.Cabin.L             = 20;   % cabin length [m]

AirZone.Cockpit.init.T      = 21.1;   % cabin temperature [°C]
AirZone.Cockpit.init.Tamb   = 0;    % ambient temperature [°C]
AirZone.Cockpit.init.P      = 80.24;   % cabin pressure [kPa]

% AirZone.Cockpit.H_amb       = 1.5;    % heat trans coeff w/amb [W/m^2K]
AirZone.Cockpit.H_amb       = 0.5;    % heat trans coeff w/amb [W/m^2K]
AirZone.Cockpit.D           = 3;    % cabin diameter [m]
AirZone.Cockpit.L           = 3;    % cabin length [m]

AirZone.ElecBay1.init.T     = 30.2;   % cabin temperature [°C]
AirZone.ElecBay1.init.Tamb  = 0;    % ambient temperature [°C]
AirZone.ElecBay1.init.P     = 85.02;   % cabin pressure [kPa]

AirZone.ElecBay1.H_amb      = 0;    % heat trans coeff w/amb [W/m^2K]
AirZone.ElecBay1.D          = 1;    % cabin diameter [m]
AirZone.ElecBay1.L          = 1;    % cabin length [m]

AirZone.ElecBay2.init.T     = 30.2;   % cabin temperature [°C]
AirZone.ElecBay2.init.Tamb  = 0;    % ambient temperature [°C]
AirZone.ElecBay2.init.P     = 85.02;   % cabin pressure [kPa]

AirZone.ElecBay2.H_amb      = 0;    % heat trans coeff w/amb [W/m^2K]
AirZone.ElecBay2.D          = 1;    % cabin diameter [m]
AirZone.ElecBay2.L          = 1;    % cabin length [m]

AirZone.CargoBay.init.T     = 19.79;   % cabin temperature [°C]
AirZone.CargoBay.init.Tamb  = 0;    % ambient temperature [°C]
AirZone.CargoBay.init.P     = 78.07;   % cabin pressure [kPa]

AirZone.CargoBay.H_amb      = 50; % heat trans coeff w/amb [W/m^2K]
AirZone.CargoBay.D          = 2;    % cabin diameter [m]
AirZone.CargoBay.L          = 2;    % cabin length [m]

%% Ducts

AirZone.Duct1.init.T        = 22.621;   % initial temperature [°C]
AirZone.Duct1.f             = 0.5; % friction factor
AirZone.Duct1.D             = 0.3;  % diameter [m]
AirZone.Duct1.L             = 3;    % length [m]

AirZone.Duct2 = AirZone.Duct1;
AirZone.Duct2.init.T        = 22.0706;   % initial temperature [°C]

AirZone.Duct3.init.T        = 22.6216;   % initial temperature [°C]
AirZone.Duct3.f             = 0.5; % friction factor
AirZone.Duct3.D             = 0.1;  % diameter [m]
AirZone.Duct3.L             = 2;    % length [m]

AirZone.Duct4 = AirZone.Duct3;
AirZone.Duct4.init.T        = 21.1045;   % initial temperature [°C]

AirZone.Duct5.init.T        = 22.6216;   % initial temperature [°C]
AirZone.Duct5.f             = 0.5; % friction factor
AirZone.Duct5.D             = 0.1;  % diameter [m]
AirZone.Duct5.L             = 0.1;    % length [m]

AirZone.Duct6 = AirZone.Duct5;
AirZone.Duct6.init.T        = 30.2;   % initial temperature [°C]

AirZone.Duct7.init.T        = 22.6216;   % initial temperature [°C]
AirZone.Duct7.f             = 0.5; % friction factor
AirZone.Duct7.D             = 0.1;  % diameter [m]
AirZone.Duct7.L             = 0.1;    % length [m]

AirZone.Duct8 = AirZone.Duct7;
AirZone.Duct8.init.T        = 30.2;   % initial temperature [°C]

AirZone.Duct9.init.T        = 22;   % initial temperature [°C]
AirZone.Duct9.f             = 0.5; % friction factor
AirZone.Duct9.D             = 0.1;  % diameter [m]
AirZone.Duct9.L             = 0.1;    % length [m]

AirZone.Duct10 = AirZone.Duct9;
AirZone.Duct10.init.T       = 22.072;   % initial temperature [°C]

AirZone.Duct11.init.T       = 22.6216;   % initial temperature [°C]
AirZone.Duct11.f            = 0.5; % friction factor
AirZone.Duct11.D            = 0.1;  % diameter [m]
AirZone.Duct11.L            = 0.1;    % length [m]


%% Junction and splits
AirZone.Junc.init.P         = 78.0676;
AirZone.Junc.init.T         = 26.9547;
AirZone.Junc.D              = 0.5;
AirZone.Junc.L              = 0.3;
AirZone.Junc.t_wall         = 0.0015;

AirZone.Split.init.P        = 92.5793;
AirZone.Split.init.T        = 22.6216;
AirZone.Split.D             = 0.5;
AirZone.Split.L             = 0.3;
AirZone.Split.t_wall        = 0.0015;

%% Fans
AirZone.Fan1.init.P         = 140.1319;
AirZone.Fan1.init.T         = 22.6216;
AirZone.Fan1.D              = 0.3;
AirZone.Fan1.L              = 0.1;
AirZone.Fan1.OmegaMax       = 5000;     % max shaft speed [RPM]
AirZone.Fan1.dPMax          = 100;      % max pressure difference [kPa]
AirZone.Fan1.mdotMax        = 5;      % max flow rate [kg/s]
AirZone.Fan1.alpha          = 0e-5;     % heat gen. coeff [kW/RPM]

AirZone.Fan2.init.P         = 140.1319;
AirZone.Fan2.init.T         = 22.6216;
AirZone.Fan2.D              = 0.3;
AirZone.Fan2.L              = 0.1;
AirZone.Fan2.OmegaMax       = 5000;     % max shaft speed [RPM]
AirZone.Fan2.dPMax          = 100;      % max pressure difference [kPa]
AirZone.Fan2.mdotMax        = 5;      % max flow rate [kg/s]
AirZone.Fan2.alpha          = 0e-5;     % heat gen. coeff [kW/RPM]


%% Valves
AirZone.Valve1.init.P       = 138.98378;
AirZone.Valve1.init.T       = 22.6216;
AirZone.Valve1.D            = AirZone.Duct1.D;
AirZone.Valve1.L            = 0.1;
AirZone.Valve1.t_wall       = 0.0015;

AirZone.Valve2.init.P       = 80.6210;
AirZone.Valve2.init.T       = 22.6216;
AirZone.Valve2.D            = AirZone.Duct1.D/10;
AirZone.Valve2.L            = AirZone.Valve2.D*5;
AirZone.Valve2.t_wall       = 0.0015;
 
AirZone.Valve3.init.P       = 82.3611;
AirZone.Valve3.init.T       = 22.6216;
AirZone.Valve3.D            = AirZone.Duct3.D/10;
AirZone.Valve3.L            = AirZone.Valve3.D;
AirZone.Valve3.t_wall       = 0.0015;
 
AirZone.Valve4.init.P       = 91.4725;
AirZone.Valve4.init.T       = 22.6216;
AirZone.Valve4.D            = AirZone.Duct5.D/2;
AirZone.Valve4.L            = AirZone.Valve4.D;
AirZone.Valve4.t_wall       = 0.0015;
 
AirZone.Valve5.init.P       = 91.4725;
AirZone.Valve5.init.T       = 22.6216;
AirZone.Valve5.D            = AirZone.Duct7.D/2;
AirZone.Valve5.L            = AirZone.Valve5.D;
AirZone.Valve5.t_wall       = 0.0015;
 
AirZone.Valve6.init.P       = 78.06763;
AirZone.Valve6.init.T       = 22;
AirZone.Valve6.D            = AirZone.Duct9.D/10;
AirZone.Valve6.L            = AirZone.Valve6.D;
AirZone.Valve6.t_wall       = 0.0015;
 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            SECTION #5: FUEL LOOP AND COOLING LOOPS SIZING               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fuel tanks

Tanks.LWmain.init.T         = 22;       % inital temperature [°C]
Tanks.LWmain.init.M         = 4000;     % inital mass [kg]
Tanks.LWmain.init.P         = 101;      % initial pressure [kPa]
Tanks.LWmain.init.Tamb      = 22;       % initial ambient temp [°C]

Tanks.LWmain.Hamb           = 0;        % heat trans coeff w/amb [W/m^2K]
Tanks.LWmain.V              = 7.5;      % tank volume [m^3]
Tanks.LWmain.SA             = 10;       % tank surface area [m^2]
Tanks.LWmain.Pamb           = 100;      % ambient pressure [kPa]

Tanks.RWmain = Tanks.LWmain;            % symmetric tanks

Tanks.LWaux.init.T          = 22;       % inital temperature [°C]
Tanks.LWaux.init.M          = 4000;     % inital mass [kg]
Tanks.LWaux.init.P          = 101;      % initial pressure [kPa]
Tanks.LWaux.init.Tamb       = 22;       % initial ambient temp [°C]

Tanks.LWaux.Hamb            = 0;        % heat trans coeff w/amb [W/m^2K]
Tanks.LWaux.V               = 7.5;      % tank volume [m^3]
Tanks.LWaux.SA              = 10;       % tank surface area [m^2]
Tanks.LWaux.Pamb            = 100;      % ambient pressure [kPa]

Tanks.RWaux = Tanks.LWaux;              % symmetric tanks

Tanks.Centr.init.T          = 22;       % inital temperature [°C]
Tanks.Centr.init.M          = 3000;     % inital mass [kg]
Tanks.Centr.init.P          = 101;      % initial pressure [kPa]
Tanks.Centr.init.Tamb       = 22;       % initial ambient temp [°C]

Tanks.Centr.Hamb            = 0;        % heat trans coeff w/amb [W/m^2K]
Tanks.Centr.V               = 4.5;      % tank volume [m^3]
Tanks.Centr.SA              = 10;       % tank surface area [m^2]
Tanks.Centr.Pamb            = 100;      % ambient pressure [kPa]

%% Valves
Valves.Tank1.init.P         = 100.9008; % initial pressure [kPa]
Valves.Tank1.init.T         = 22;       % inital temperature [°C]
Valves.Tank1.D              = 0.1;      % diameter [m]
Valves.Tank1.L              = 0.1;      % length [m]
Valves.Tank1.t_wall         = 0.0015;   % wall thickness [m]

Valves.AEE.init.P           = 100.9958; % initial pressure [kPa]
Valves.AEE.init.T           = 22;       % inital temperature [°C]
Valves.AEE.D                = 0.05;     % diameter [m]
Valves.AEE.L                = 0.1;      % length [m]
Valves.AEE.t_wall           = 0.0015;   % wall thickness [m]

Valves.Generic.D            = 0.1;      % diameter [m]
Valves.Generic.L            = 0.1;      % length [m]
Valves.Generic.t_wall       = 0.0015;   % wall thickness [m]

%% Junctions Splits
Splits.FuelGen.D            = 0.1;      % diameter [m]
Splits.FuelGen.L            = 0.1;      % length [m]
Splits.FuelGen.t_wall       = 0.0015;   % wall thickness [m]

Splits.FuelGen.init.P       = 101.0347; 

%% Pumps
Pumps.FuelPump.ID           = 0.03;     % internal diameter [m]
Pumps.FuelPump.OmegaMax     = 5000;     % max shaft speed [RPM]
% Pumps.FuelPump.dPMax        = 150;      % max pressure difference [kPa]
Pumps.FuelPump.dPMax        = 350;      % max pressure difference [kPa]
Pumps.FuelPump.mdotMax      = 4.5;      % max flow rate [kg/s]
Pumps.FuelPump.alpha        = 1e-5;     % heat gen. coeff [kW/RPM]
Pumps.FuelPump.init.P       = 102.8033; % initial outlet pressure [kPa]
Pumps.FuelPump.init.T       = 22.0056;  % initial outlet temp. [°C]

Pumps.AEEPump.ID            = 0.03;     % internal diameter [m]
Pumps.AEEPump.OmegaMax      = 5000;     % max shaft speed [RPM]
% Pumps.AEEPump.dPMax         = 150;      % max pressure difference [kPa]
Pumps.AEEPump.dPMax         = 350;      % max pressure difference [kPa]
% Pumps.AEEPump.mdotMax       = 2.5;      % max flow rate [kg/s]
Pumps.AEEPump.mdotMax       = 15;      % max flow rate [kg/s]
Pumps.AEEPump.alpha         = 1e-5;     % heat gen. coeff [kW/RPM]
Pumps.AEEPump.init.P        = 174.8174; % initial outlet pressure [kPa]
Pumps.AEEPump.init.T        = 22.0801;  % initial outlet temp. [°C]

Pumps.BoostPump.ID          = 0.3;      % internal diameter [m]
Pumps.BoostPump.OmegaMax    = 50000;    % max shaft speed [RPM]
Pumps.BoostPump.dPMax       = 5000;     % max pressure difference [kPa]
Pumps.BoostPump.mdotMax     = 10;       % max flow rate [kg/s]
% Pumps.BoostPump.alpha       = 5e-4;     % heat gen. coeff [kW/RPM]
Pumps.BoostPump.alpha       = 2e-4;     % heat gen. coeff [kW/RPM]
Pumps.BoostPump.init.P      = 294.8308; % initial outlet pressure [kPa]
Pumps.BoostPump.init.T      = 80.034;   % initial outlet temp. [°C]

Pumps.EngGenPump.ID         = 0.03;     % internal diameter [m]
Pumps.EngGenPump.OmegaMax   = 5000;     % max shaft speed [RPM]
% Pumps.EngGenPump.dPMax      = 150;      % max pressure difference [kPa]
Pumps.EngGenPump.dPMax      = 350;      % max pressure difference [kPa]
% Pumps.EngGenPump.mdotMax    = 2.5;      % max flow rate [kg/s]
Pumps.EngGenPump.mdotMax    = 5;      % max flow rate [kg/s]
Pumps.EngGenPump.alpha      = 1e-5;     % heat gen. coeff [kW/RPM]
Pumps.EngGenPump.init.P     = 125.1312; % initial outlet pressure [kPa]
Pumps.EngGenPump.init.T     = 117.4321;  % initial outlet temp. [°C]

%% Cold plates
CP.FADEC.init.P             = 101.1178; % initial outlet pressure [kPa]
CP.FADEC.init.Tout          = 23.3821;  % initial outlet temp. [°C]
CP.FADEC.init.Twall         = 24.6064;  % initial outlet temp. [°C]
CP.FADEC.mass               = 0.5;      % cold plate mass [kg]
CP.FADEC.Cp                 = 0.9;      % specific heat [kJ/kgK]
CP.FADEC.ID                 = 0.02;     % internal diameter [m]
CP.FADEC.L                  = 3.25;     % heat transfer length [m]
CP.FADEC.t_wall             = 0.002;    % wall thickness [m]
CP.FADEC.H                  = 2000;     % heat transfer coeff. [W/m^2K]

CP.Gen.init.P               = 125.9483; % initial outlet pressure [kPa]
CP.Gen.init.Tout            = 41.0867;  % initial outlet temp. [°C]
CP.Gen.init.Twall           = 41.82;    % initial outlet temp. [°C]
CP.Gen.mass                 = 2.5;      % cold plate mass [kg]
CP.Gen.Cp                   = 0.9;      % specific heat [kJ/kgK]
% CP.Gen.ID                   = 0.1;      % internal diameter [m]
CP.Gen.ID                   = 0.04;      % internal diameter [m]
CP.Gen.L                    = 6.00;     % heat transfer length [m]
CP.Gen.t_wall               = 0.002;    % wall thickness [m]
CP.Gen.H                    = 10000;    % heat transfer coeff. [W/m^2K]

CP.Eng.init.P               = 125.092;  % initial outlet pressure [kPa]
CP.Eng.init.Tout            = 117.4266; % initial outlet temp. [°C]
CP.Eng.init.Twall           = 125.3843; % initial outlet temp. [°C]
CP.Eng.mass                 = 2.5;      % cold plate mass [kg]
CP.Eng.Cp                   = 0.9;      % specific heat [kJ/kgK]
% CP.Eng.ID                   = 0.1;      % internal diameter [m]
CP.Eng.ID                   = 0.04;      % internal diameter [m]
CP.Eng.L                    = 6.00;     % heat transfer length [m]
CP.Eng.t_wall               = 0.002;    % wall thickness [m]
CP.Eng.H                    = 10000;    % heat transfer coeff. [W/m^2K]

CP.AEE.init.P               = 101;      % initial outlet pressure [kPa]
CP.AEE.init.Tout            = 28.0239;  % initial outlet temp. [°C]
CP.AEE.init.Twall           = 29.6155;  % initial outlet temp. [°C]
CP.AEE.mass                 = 2.5;      % cold plate mass [kg]
CP.AEE.Cp                   = 0.9;      % specific heat [kJ/kgK]
% CP.AEE.ID                   = 0.01;     % internal diameter [m]
CP.AEE.ID                   = 0.015;     % internal diameter [m]
% CP.AEE.L                    = 6.00;     % heat transfer length [m]
CP.AEE.L                    = 12.00;    % heat transfer length [m]
CP.AEE.t_wall               = 0.002;    % wall thickness [m]
% CP.AEE.H                    = 5000;     % heat transfer coeff. [W/m^2K]
CP.AEE.H                    = 15000;     % heat transfer coeff. [W/m^2K]

CP.BoostPump = CP.FADEC;
CP.BoostPump.ID             = 0.1;      % internal diameter [m]
CP.BoostPump.init.P         = 101.0372; % initial outlet pressure [kPa]
CP.BoostPump.init.Tout      = 65.5319;  % initial outlet temp. [°C]
CP.BoostPump.init.Twall     = 67.9804;  % initial outlet temp. [°C]

%% Heat exchangers
HX.Generator.mass           = 0.1;      % single wall mass [kg]
HX.Generator.Cp_wall        = 0.9;      % wall specific heat [kJ/kgK]
% HX.Generator.side1.N        = 5;        % number of passes
HX.Generator.side1.N        = 25;        % number of passes
% HX.Generator.side1.W        = 80e-2;    % Plate width [m]
HX.Generator.side1.W        = 8e-2;    % Plate width [m]
% HX.Generator.side1.t        = 3e-2;     % Plate spacing [m]
HX.Generator.side1.t        = 3e-3;     % Plate spacing [m]
HX.Generator.side1.L        = 4e-1;     % Plate width [m]
% HX.Generator.side1.H        = 5000;     % heat transfer coeff. [W/m^2K]
HX.Generator.side1.H        = 15000;     % heat transfer coeff. [W/m^2K]
HX.Generator.side2          = HX.Generator.side1;

% initial conditions
HX.Generator.init.Twall     = 37.0329;  % initial wall temp. [°C]
HX.Generator.init.P1        = 125.987;  % initial outlet pressure [kPa]
HX.Generator.init.P2        = 101.12;   % initial outlet pressure [kPa]
HX.Generator.init.T1        = 37.8990;  % initial outlet temp. [°C]
HX.Generator.init.T2        = 31.2820;  % initial outlet temp. [°C]

HX.LubeOil.mass             = 0.1;      % single wall mass [kg]
HX.LubeOil.Cp_wall          = 0.9;      % wall specific heat [kJ/kgK]
% HX.LubeOil.side1.N          = 5;        % number of passes
HX.LubeOil.side1.N          = 15;        % number of passes
% HX.LubeOil.side1.W          = 80e-2;    % Plate width [m]
HX.LubeOil.side1.W          = 8e-2;    % Plate width [m]
% HX.LubeOil.side1.t          = 3e-2;     % Plate spacing [m]
HX.LubeOil.side1.t          = 3e-3;     % Plate spacing [m]
HX.LubeOil.side1.L          = 4e-1;     % Plate width [m]
% HX.LubeOil.side1.H          = 5000;     % heat transfer coeff. [W/m^2K]
HX.LubeOil.side1.H          = 15000;     % heat transfer coeff. [W/m^2K]
HX.LubeOil.side2            = HX.LubeOil.side1;

% initial conditions
HX.LubeOil.init.Twall       = 77.0972;  % initial wall temp. [°C]
HX.LubeOil.init.P1          = 101.12;   % initial outlet pressure [kPa]
HX.LubeOil.init.P2          = 125.13;   % initial outlet pressure [kPa]
HX.LubeOil.init.T1          = 68.0594;  % initial outlet temp. [°C]
HX.LubeOil.init.T2          = 86.1349;  % initial outlet temp. [°C]

HX.Ram_Air.mass             = 0.1;      % single wall mass [kg]
HX.Ram_Air.Cp_wall          = 0.9;      % wall specific heat [kJ/kgK]
HX.Ram_Air.side1.N          = 5;        % number of passes
HX.Ram_Air.side1.W          = 80e-2;    % Plate width [m]
HX.Ram_Air.side1.t          = 3e-2;     % Plate spacing [m]
HX.Ram_Air.side1.L          = 4e-1;     % Plate width [m]
HX.Ram_Air.side1.H          = 4000;     % heat transfer coeff. [W/m^2K]
HX.Ram_Air.side2            = HX.Ram_Air.side1;

% initial conditions
HX.Ram_Air.init.Twall       = 39.9664; % initial wall temp. [°C]
HX.Ram_Air.init.P1          = 79.9466; % initial outlet pressure [kPa]
HX.Ram_Air.init.P2          = 101.0345;% initial outlet pressure [kPa]
HX.Ram_Air.init.T1          = 34.7034; % initial outlet temp. [°C]
HX.Ram_Air.init.T2          = 45.2294; % initial outlet temp. [°C]

% initial conditions
HX.ACMFUEL.init.Twall       = 37.1433; % initial wall temp. [°C]
HX.ACMFUEL.init.P1          = 99.9690; % initial outlet pressure [kPa]
HX.ACMFUEL.init.P2          = 101.120; % initial outlet pressure [kPa]
HX.ACMFUEL.init.T1          = 46.5290; % initial outlet temp. [°C]
HX.ACMFUEL.init.T2          = 27.7576; % initial outlet temp. [°C]

clear Cp Ar hAnom Qtot mdotnom H

%% Resizing for larger masses and thermal capacitances
Converters.HVDC.CP.mass         = 5;      % cold plate mass [kg]
Converters.LVDC.CP.mass         = 5;      % cold plate mass [kg]
Converters.LVAC.CP.mass         = 5;        % cold plate mass [kg]
HVbatt.CP.mass              = 25;        % cold plate mass [kg]
LVbatt.CP.mass              = 25;        % cold plate mass [kg]
HX.ACM1.mass                    = 5;      % single wall mass [kg] (5 walls)
HX.ACM2.mass                    = 5;      % single wall mass [kg] (5 walls)
HX.ACMBY.mass                    = 5;      % single wall mass [kg] (5 walls)
HX.ACMFUEL.mass                    = 5;      % single wall mass [kg] (5 walls)
CP.FADEC.mass               = 10;      % cold plate mass [kg]
CP.Gen.mass                 = 30;      % cold plate mass [kg]
CP.Eng.mass                 = 15;      % cold plate mass [kg]
CP.AEE.mass                 = 50;      % cold plate mass [kg]
HX.Generator.mass           = 1;      % single wall mass [kg] (25 walls)
HX.LubeOil.mass             = 1;      % single wall mass [kg] (15 walls)
HX.Ram_Air.mass             = 10;      % single wall mass [kg] (5 walls)
% For ACM
Valves.ACM.Geom.L = 20;
Splits.ACM.Geom.L = 10;
% for air zones
% AirZone.Valve4.D            = AirZone.Duct5.D/2*0.75;
% AirZone.Valve5.D            = AirZone.Duct5.D/2*0.75;


tau = 1; % Time constant for input filters
t_ctrl_start = 200; % Time (s) when controllers are enabled 