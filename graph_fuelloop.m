%% ELECTRICAL LEFT GRAPH
Graph.FuelLoop.Name = 'FuelLoop';
Graph.FuelLoop.DT   = 10;
Graph.FuelLoop.Cp_fluid = 2;
Graph.FuelLoop.rho = 800;
rc = Graph.FuelLoop.rho*Graph.FuelLoop.Cp_fluid;
rc_PG = 3.8*990;

CP.Eng.init.Twall = 30;
HX.LubeOil.init.Twall = 20;
Pumps.EngGenPump.init.T = 25;


%% SECTION 2 -- Graph structure
Graph.FuelLoop.Nv     = 64;             % Number of vertices 
Graph.FuelLoop.Ne     = 98;             % Number of edges (Power flows)
Graph.FuelLoop.Ns     = 2 ;             % Number of sources
Graph.FuelLoop.Ns_aux = 16;             % Number of aux sources
Graph.FuelLoop.Nt     = 3 ;             % Number of sinks
Graph.FuelLoop.Nt_aux = 4 ;             % Number of aux sinks
Graph.FuelLoop.NuC    = 36;             % Number of unique inputs
Graph.FuelLoop.NuB    = 0 ;             % Number of unique binary inputs


% Edge matrix 
Graph.FuelLoop.E = [1  2
                    2  3
                    6  3
                    3  4
                    5  4
                    4  11
                    4  40
                    8  7
                    9  8
                    9  10        % 10
                    10 13
                    11 12
                    10 12
                    11 13
                    12 15
                    13 14
                    14 15
                    14 2
                    15 16
                    16 18        % 20
                    17 18
                    18 21
                    21 22
                    35 22
                    22 9
                    20 21
                    19 20
                    23 20
                    24 23
                    25 24        % 30
                    26 25
                    24 26
                    27 26
                    34 25
                    28 19
                    29 28
                    30 29
                    31 30
                    29 31
                    32 31        % 40
                    33 30
                    37 36
                    38 37
                    38 39
                    39 42
                    40 41
                    39 41
                    40 42
                    41 44
                    42 43        % 50
                    43 44
                    43 2
                    44 45
                    45 47
                    46 47
                    47 50
                    50 51
                    64 51
                    51 38
                    49 50        % 60
                    48 49
                    52 49
                    53 52
                    54 53
                    55 54
                    53 55
                    56 55
                    63 54
                    57 48
                    58 57        % 70
                    59 58
                    60 59
                    58 60
                    61 60
                    62 59        % 75
                    7  65
                    36 65
                    12 65 
                    13 65 
                    1  65        % 80
                    42 65 
                    41 65
                    35 66
                    6  66
                    64 66
                    34 66
                    33 66
                    62 66
                    63 66
                    12 67        % 90
                    13 67
                    1  67
                    42 67
                    41 67
                    22 70 
                    51 71
                    16 68
                    45 69];        % 98

% INPUT ORDERING:
% constraints on min/max flow rates
Graph.FuelLoop.u_min    = 1e-3*ones(Graph.FuelLoop.NuC,1);
Graph.FuelLoop.u_max    = ones(Graph.FuelLoop.NuC,1);
Graph.FuelLoop.u_max([1:8 10 14]) = 0.6275;
Graph.FuelLoop.u_max([9 11:13 15:26 31:34]) = 5;
Graph.FuelLoop.u_max([27:30]) = 4;
Graph.FuelLoop.u_max([35:36]) = 100;
Graph.FuelLoop.u_min(2) = 0.2;

% initializing the graph B matrix
Graph.FuelLoop.B        = zeros(Graph.FuelLoop.Ne,Graph.FuelLoop.NuC);

Graph.FuelLoop.B(1 , 1)  = 1;   % edge 1
Graph.FuelLoop.B(2 , 2)  = 1;   % edge 2
Graph.FuelLoop.B(4 , 2)  = 1;   % edge 4
Graph.FuelLoop.B(7 , 3)  = 1;   % edge 7
Graph.FuelLoop.B(6 , 4)  = 1;   % edge 6
Graph.FuelLoop.B(46, 5)  = 1;   % edge 46
Graph.FuelLoop.B(48, 6)  = 1;   % edge 48
Graph.FuelLoop.B(12, 7)  = 1;   % edge 12
Graph.FuelLoop.B(14, 8)  = 1;   % edge 14
Graph.FuelLoop.B(16, 9)  = 1;   % edge 16
Graph.FuelLoop.B(18,10)  = 1;   % edge 18
Graph.FuelLoop.B(17,11)  = 1;   % edge 17
Graph.FuelLoop.B(15,12)  = 1;   % edge 15
Graph.FuelLoop.B(50,13)  = 1;   % edge 50
Graph.FuelLoop.B(52,14)  = 1;   % edge 52
Graph.FuelLoop.B(51,15)  = 1;   % edge 51
Graph.FuelLoop.B(49,16)  = 1;   % edge 49
Graph.FuelLoop.B(19,17)  = 1;   % edge 19
Graph.FuelLoop.B(23,17)  = 1;   % edge 23
Graph.FuelLoop.B(97,18)  = 1;   % edge 97
Graph.FuelLoop.B(27,18)  = 1;   % edge 27
Graph.FuelLoop.B(26,18)  = 1;   % edge 26
Graph.FuelLoop.B(20,19)  = 1;   % edge 20
Graph.FuelLoop.B(22,19)  = 1;   % edge 22
Graph.FuelLoop.B(11,20)  = 1;   % edge 11
Graph.FuelLoop.B(13,21)  = 1;   % edge 13
Graph.FuelLoop.B(53,22)  = 1;   % edge 53
Graph.FuelLoop.B(57,22)  = 1;   % edge 57
Graph.FuelLoop.B(98,23)  = 1;   % edge 98
Graph.FuelLoop.B(60,23)  = 1;   % edge 60
Graph.FuelLoop.B(61,23)  = 1;   % edge 61
Graph.FuelLoop.B(54,24)  = 1;   % edge 54
Graph.FuelLoop.B(56,24)  = 1;   % edge 56
Graph.FuelLoop.B(45,25)  = 1;   % edge 45
Graph.FuelLoop.B(47,26)  = 1;   % edge 47
Graph.FuelLoop.B(30:32,27)  = 1;   % edges 30, 31, 32
Graph.FuelLoop.B(37:39,28)  = 1;   % edges 37, 38, 39
Graph.FuelLoop.B(71:73,29)  = 1;   % edges 71, 72, 73
Graph.FuelLoop.B(64:66,30)  = 1;   % edges 64, 65, 66
Graph.FuelLoop.B(25,31)  = 1;   % edge 25
Graph.FuelLoop.B(10,31)  = 1;   % edge 10
Graph.FuelLoop.B(95,32)  = 1;   % edge 95
Graph.FuelLoop.B(59,33)  = 1;   % edge 59
Graph.FuelLoop.B(44,33)  = 1;   % edge 44
Graph.FuelLoop.B(96,34)  = 1;   % edge 96
Graph.FuelLoop.B(76,35)  = 1;   % edge 76
Graph.FuelLoop.B(77,36)  = 1;   % edge 77
% add for mass drain mdot_in - mdot_out
Graph.FuelLoop.B(90,21)  =  1;   % edge 90
Graph.FuelLoop.B(90, 7)  =  1;   % edge 90
Graph.FuelLoop.B(90,12)  = -1;   % edge 90
Graph.FuelLoop.B(91, 8)  =  1;   % edge 91
Graph.FuelLoop.B(91,20)  =  1;   % edge 91
Graph.FuelLoop.B(91, 9)  = -1;   % edge 91
Graph.FuelLoop.B(92, 1)  = -1;   % edge 92
Graph.FuelLoop.B(93, 6)  =  1;   % edge 93
Graph.FuelLoop.B(93,25)  =  1;   % edge 93
Graph.FuelLoop.B(93,13)  = -1;   % edge 93
Graph.FuelLoop.B(94, 5)  =  1;   % edge 94
Graph.FuelLoop.B(94,26)  =  1;   % edge 94
Graph.FuelLoop.B(94,16)  = -1;   % edge 94

% Vertices connected to sources, formatted as (vertex# , source#)
Graph.FuelLoop.D        = zeros(Graph.FuelLoop.Nv,Graph.FuelLoop.Ns);
Graph.FuelLoop.D(7,1)   = 1;     % Pin1 - ram air left wing
Graph.FuelLoop.D(36,2)  = 1;     % Pin2 - ram air right wing
Graph.FuelLoop.D(27,3)  = 1;     % Pin3 - left engine heat
Graph.FuelLoop.D(56,4)  = 1;     % Pin4 - right engine heat
Graph.FuelLoop.D(32,5)  = 1;     % Pin5 - left generator heat
Graph.FuelLoop.D(61,6)  = 1;     % Pin6 - right generator heat
Graph.FuelLoop.D(17,7)  = 1;     % Pin7 - left fadec
Graph.FuelLoop.D(46,8)  = 1;     % Pin8 - right fadec
Graph.FuelLoop.D(35,9)  = 1;     % Pin9 - left wing boost pump power
Graph.FuelLoop.D(64,10) = 1;     % Pin10 - right wing boost pump power
Graph.FuelLoop.D(34,11) = 1;     % Pin11 - left wing engine pump power
Graph.FuelLoop.D(63,12) = 1;     % Pin12 - right wing engine pump power
Graph.FuelLoop.D(33,13) = 1;     % Pin13 - left wing generator pump power
Graph.FuelLoop.D(62,14) = 1;     % Pin14 - right wing generator pump power
Graph.FuelLoop.D(19,15) = 1;     % Pin15 - return from left FuelLoop
Graph.FuelLoop.D(48,16) = 1;     % Pin16 - return from right FuelLoop
Graph.FuelLoop.D(5,17)  = 1;     % Pin17 - AEE heat
Graph.FuelLoop.D(6,18)  = 1;     % Pin18 - AEE pump power

% number of algebraic relationships
No_Alg = 7;

% W capatures the algebraic relationships in graphs
Graph.FuelLoop.W       = zeros(No_Alg,Graph.FuelLoop.Ne);
eta_pump = 0.8;                 %%%%%%%%%%%% eta_pump may not be accurate %%%%%%%
Graph.FuelLoop.W(1,3)          = -1;
Graph.FuelLoop.W(1,84)         = (1/eta_pump-1);   % pump inefficiencies 
eta_pump = 0.6;                 %%%%%%%%%%%% eta_pump may not be accurate %%%%%%%
Graph.FuelLoop.W(2,24)         = -1;
Graph.FuelLoop.W(2,83)         = (1/eta_pump-1);   % pump inefficiencies 
Graph.FuelLoop.W(3,34)         = -1;
Graph.FuelLoop.W(3,86)         = (1/eta_pump-1);   % pump inefficiencies 
Graph.FuelLoop.W(4,41)         = -1;
Graph.FuelLoop.W(4,87)         = (1/eta_pump-1);   % pump inefficiencies 
Graph.FuelLoop.W(5,58)         = -1;
Graph.FuelLoop.W(5,85)         = (1/eta_pump-1);   % pump inefficiencies 
Graph.FuelLoop.W(6,68)         = -1;
Graph.FuelLoop.W(6,89)         = (1/eta_pump-1);   % pump inefficiencies 
Graph.FuelLoop.W(7,75)         = -1;
Graph.FuelLoop.W(7,88)         = (1/eta_pump-1);   % pump inefficiencies 

% Incidence Matrix
Graph.FuelLoop.M = zeros(Graph.FuelLoop.Nv+Graph.FuelLoop.Nt,Graph.FuelLoop.Ne);
for i = 1:Graph.FuelLoop.Ne;
    Graph.FuelLoop.M(Graph.FuelLoop.E(i,1),i) = 1;
    Graph.FuelLoop.M(Graph.FuelLoop.E(i,2),i) = -1;
end
clear i
Graph.FuelLoop.M_upper = Graph.FuelLoop.M(1:Graph.FuelLoop.Nv,:);
Graph.FuelLoop.M_lower = Graph.FuelLoop.M(1+Graph.FuelLoop.Nv:end,:);
Graph.FuelLoop.Tail    = (Graph.FuelLoop.M'== 1);
Graph.FuelLoop.Head    = (Graph.FuelLoop.M'==-1);


%% SECTION 3 -- Vertex definitions
% Graph Parameters
% Vertex Capacitances and Initial Temperatures
Graph.FuelLoop.x0      = zeros(Graph.FuelLoop.Nv,1);
Graph.FuelLoop.Caps    = zeros(Graph.FuelLoop.Nv,1);
Graph.FuelLoop.x_min   = zeros(Graph.FuelLoop.Nv,1);
Graph.FuelLoop.x_max   = zeros(Graph.FuelLoop.Nv,1);

% v1 Center fuel tank -- dynamic
Graph.FuelLoop.x_min(1)   = -20;
Graph.FuelLoop.x_max(1)   = 100;
Graph.FuelLoop.x0(1)      = Tanks.Centr.init.T;
Graph.FuelLoop.Caps(1)    = Tanks.Centr.init.M*Graph.FuelLoop.Cp_fluid; 

% v2 Center fuel junc -- dynamic
Graph.FuelLoop.x_min(2)   = -20;
Graph.FuelLoop.x_max(2)   = 100;
Graph.FuelLoop.x0(2)      = Valves.AEE.init.T;
Graph.FuelLoop.Caps(2)    = pi*Valves.AEE.D^2/4*Valves.AEE.L*rc; 

% v3 fuel pump outlet -- dynamic
Graph.FuelLoop.x_min(3)   = -20;
Graph.FuelLoop.x_max(3)   = 100;
Graph.FuelLoop.x0(3)      = Pumps.AEEPump.init.T;
Graph.FuelLoop.Caps(3)    = pi*Pumps.AEEPump.ID^2/4*Pumps.AEEPump.ID*rc; 

% v4 fuel outlet of AEE -- dynamic
Graph.FuelLoop.x_min(4)   = -20;
Graph.FuelLoop.x_max(4)   = 100;
Graph.FuelLoop.x0(4)      = CP.AEE.init.Tout;
Graph.FuelLoop.Caps(4)    = pi*CP.AEE.ID^2/4*CP.AEE.L*rc; 

% v5 wall of AEE -- dynamic
Graph.FuelLoop.x_min(5)   = -20;
Graph.FuelLoop.x_max(5)   = 100;
Graph.FuelLoop.x0(5)      = CP.AEE.init.Twall;
Graph.FuelLoop.Caps(5)    = CP.AEE.mass*CP.AEE.Cp; 

% v6 AEE -- algebraic
Graph.FuelLoop.x_min(6)   = -20;
Graph.FuelLoop.x_max(6)   = 100;
Graph.FuelLoop.x0(6)      = 0;
Graph.FuelLoop.Caps(6)    = inf; 

% v7 LW ram air outlet T -- dynamic
Graph.FuelLoop.x_min(7)   = -inf;
Graph.FuelLoop.x_max(7)   = inf;
Graph.FuelLoop.x0(7)      = HX.Ram_Air.init.T1;
Graph.FuelLoop.Caps(7)    = HX.Ram_Air.side1.N*HX.Ram_Air.side1.t*HX.Ram_Air.side1.W*HX.Ram_Air.side1.L*rc; 

% v8 LW ram air wall -- dynamic
Graph.FuelLoop.x_min(8)   = -inf;
Graph.FuelLoop.x_max(8)   = inf;
Graph.FuelLoop.x0(8)      = HX.Ram_Air.init.Twall;
Graph.FuelLoop.Caps(8)    = HX.Ram_Air.side1.N*HX.Ram_Air.mass*HX.Ram_Air.Cp_wall; 

% v9 LW fuel out ram air HX -- dynamic
Graph.FuelLoop.x_min(9)   = -20;
Graph.FuelLoop.x_max(9)   = 100;
Graph.FuelLoop.x0(9)      = HX.Ram_Air.init.T2;
Graph.FuelLoop.Caps(9)    = HX.Ram_Air.side2.N*HX.Ram_Air.side2.t*HX.Ram_Air.side2.W*HX.Ram_Air.side2.L*rc; 

% v 10 Split to LW tanks T -- dynamic
Graph.FuelLoop.x_min(10)   = -20;
Graph.FuelLoop.x_max(10)   = 100;
Graph.FuelLoop.x0(10)      = (CP.AEE.init.Tout + HX.Ram_Air.init.T2)/2;
Graph.FuelLoop.Caps(10)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc; 

% v 11 split to LW tanks T -- dynamic
Graph.FuelLoop.x_min(11)   = -20;
Graph.FuelLoop.x_max(11)   = 100;
Graph.FuelLoop.x0(11)      = (CP.AEE.init.Tout + HX.Ram_Air.init.T2)/2;
Graph.FuelLoop.Caps(11)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc; 

% v 12 LW tank -- dynamic
Graph.FuelLoop.x_min(12)   = -20;
Graph.FuelLoop.x_max(12)   = 100;
Graph.FuelLoop.x0(12)      = Tanks.LWmain.init.T;
Graph.FuelLoop.Caps(12)    = Tanks.LWmain.init.M*Graph.FuelLoop.Cp_fluid; 

% v 13 LW aux tank -- dynamic
Graph.FuelLoop.x_min(13)   = -20;
Graph.FuelLoop.x_max(13)   = 100;
Graph.FuelLoop.x0(13)      = Tanks.LWaux.init.T;
Graph.FuelLoop.Caps(13)    = Tanks.LWaux.init.M*Graph.FuelLoop.Cp_fluid; 

% v 14 LW aux tank split -- dynamic
Graph.FuelLoop.x_min(14)   = -20;
Graph.FuelLoop.x_max(14)   = 100;
Graph.FuelLoop.x0(14)      = Tanks.LWaux.init.T;
Graph.FuelLoop.Caps(14)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc;  

% v 15 LW tank junction -- dynamic
Graph.FuelLoop.x_min(15)   = -20;
Graph.FuelLoop.x_max(15)   = 100;
Graph.FuelLoop.x0(15)      = Valves.Tank1.init.T;
Graph.FuelLoop.Caps(15)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc;   

% v 16 LW fadec split -- dynamic
Graph.FuelLoop.x_min(16)   = -20;
Graph.FuelLoop.x_max(16)   = 100;
Graph.FuelLoop.x0(16)      = Pumps.FuelPump.init.T;
Graph.FuelLoop.Caps(16)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc; 

% v 17 LW FADEC wall -- dynamic
Graph.FuelLoop.x_min(17)   = -20;
Graph.FuelLoop.x_max(17)   = 100;
Graph.FuelLoop.x0(17)      = CP.FADEC.init.Twall ;
Graph.FuelLoop.Caps(17)    = CP.FADEC.mass*CP.FADEC.Cp; 

% v 18 LW fuel out from FADEC CP -- dynamic
Graph.FuelLoop.x_min(18)   = -20;
Graph.FuelLoop.x_max(18)   = 100;
Graph.FuelLoop.x0(18)      = CP.FADEC.init.Tout;
Graph.FuelLoop.Caps(18)    = pi*CP.FADEC.ID^2/4*CP.FADEC.L*rc; 

% v 19 LW fuel outlet from gen HX -- dynamic
Graph.FuelLoop.x_min(19)   = -20;
Graph.FuelLoop.x_max(19)   = 100;
Graph.FuelLoop.x0(19)      = HX.Generator.init.T2;
Graph.FuelLoop.Caps(19)    = HX.Generator.side2.N*HX.Generator.side2.t*HX.Generator.side2.W*HX.Generator.side2.L*rc; 

% v 20 LW fuel outlet from eng HX -- dynamic
Graph.FuelLoop.x_min(20)   = -20;
Graph.FuelLoop.x_max(20)   = 100;
Graph.FuelLoop.x0(20)      = HX.LubeOil.init.T1;
Graph.FuelLoop.Caps(20)    = HX.LubeOil.side1.N*HX.LubeOil.side1.t*HX.LubeOil.side1.W*HX.LubeOil.side1.L*rc; 

% v 21 LW fuel T at FADEC junc -- dynamic
Graph.FuelLoop.x_min(21)   = -20;
Graph.FuelLoop.x_max(21)   = 100;
Graph.FuelLoop.x0(21)      = Pumps.BoostPump.init.T;
Graph.FuelLoop.Caps(21)    = pi*Splits.FuelGen.D^2/4*Splits.FuelGen.L*rc; 

% v 22 LW fuel to engine T -- dynamic
Graph.FuelLoop.x_min(22)   = -20;
Graph.FuelLoop.x_max(22)   = 100;
Graph.FuelLoop.x0(22)      = Pumps.BoostPump.init.T;
Graph.FuelLoop.Caps(22)    = pi*Pumps.BoostPump.ID^2/4*Pumps.BoostPump.ID*rc; 

% v 23 LW engine HX wall temp -- dynamic
Graph.FuelLoop.x_min(23)   = -20;
Graph.FuelLoop.x_max(23)   = 100;
Graph.FuelLoop.x0(23)      = HX.LubeOil.init.Twall;
Graph.FuelLoop.Caps(23)    = HX.LubeOil.side1.N*HX.LubeOil.mass*HX.LubeOil.Cp_wall; 

% v 24 LW engine cooling loop T -- dynamic
Graph.FuelLoop.x_min(24)   = -20;
Graph.FuelLoop.x_max(24)   = 100;
Graph.FuelLoop.x0(24)      = HX.LubeOil.init.T2;
Graph.FuelLoop.Caps(24)    = HX.LubeOil.side1.N*HX.LubeOil.side1.t*HX.LubeOil.side1.W*HX.LubeOil.side1.L*rc_PG; 

% v 25 LW engine cooling loop T -- dynamic
Graph.FuelLoop.x_min(25)   = -20;
Graph.FuelLoop.x_max(25)   = 100;
Graph.FuelLoop.x0(25)      = Pumps.EngGenPump.init.T;
Graph.FuelLoop.Caps(25)    = pi*Pumps.EngGenPump.ID ^2/4*Pumps.EngGenPump.ID *rc_PG;

% v 26 LW engine cooling loop T -- dynamic
Graph.FuelLoop.x_min(26)   = -20;
Graph.FuelLoop.x_max(26)   = 100;
Graph.FuelLoop.x0(26)      = CP.Eng.init.Tout;
Graph.FuelLoop.Caps(26)    = pi*CP.Eng.ID^2/4*CP.Eng.L*rc_PG; 

% v 27 LW engine CP wall temp -- dynamic
Graph.FuelLoop.x_min(27)   = -20;
Graph.FuelLoop.x_max(27)   = 100;
Graph.FuelLoop.x0(27)      = CP.Eng.init.Twall ;
Graph.FuelLoop.Caps(27)    = CP.Eng.mass*CP.Eng.Cp; 

% v 28 LW generator HX wall temp -- dynamic
Graph.FuelLoop.x_min(28)   = -20;
Graph.FuelLoop.x_max(28)   = 100;
Graph.FuelLoop.x0(28)      = HX.Generator.init.Twall;
Graph.FuelLoop.Caps(28)    = HX.Generator.side1.N*HX.Generator.mass*HX.Generator.Cp_wall; 

% v 29 LW generator cooling loop T -- dynamic
Graph.FuelLoop.x_min(29)   = -20;
Graph.FuelLoop.x_max(29)   = 100;
Graph.FuelLoop.x0(29)      = HX.Generator.init.T1;
Graph.FuelLoop.Caps(29)    = HX.Generator.side1.N*HX.Generator.side1.t*HX.Generator.side1.W*HX.Generator.side1.L*rc_PG; 

% v 30 LW generator cooling loop T -- dynamic
Graph.FuelLoop.x_min(30)   = -20;
Graph.FuelLoop.x_max(30)   = 100;
Graph.FuelLoop.x0(30)      = Pumps.EngGenPump.init.T;
Graph.FuelLoop.Caps(30)    = pi*Pumps.EngGenPump.ID^2/4*Pumps.EngGenPump.ID*rc_PG; 

% v 31 LW generator cooling loop T -- dynamic
Graph.FuelLoop.x_min(31)   = -20;
Graph.FuelLoop.x_max(31)   = 100;
Graph.FuelLoop.x0(31)      = CP.Gen.init.Tout;
Graph.FuelLoop.Caps(31)    = pi*CP.Gen.ID^2/4*CP.Gen.L*rc_PG; 

% v 32 LW generator CP wall temp -- dynamic
Graph.FuelLoop.x_min(32)   = -20;
Graph.FuelLoop.x_max(32)   = 100;
Graph.FuelLoop.x0(32)      = CP.Gen.init.Twall;
Graph.FuelLoop.Caps(32)    = CP.Gen.mass*CP.Gen.Cp; 

% v 33 Gen PUMP -- algebraic
Graph.FuelLoop.x_min(33)   = -20;
Graph.FuelLoop.x_max(33)   = 100;
Graph.FuelLoop.x0(33)      = 0;
Graph.FuelLoop.Caps(33)    = inf; 

% v 34 Eng PUMP -- algebraic
Graph.FuelLoop.x_min(34)   = -20;
Graph.FuelLoop.x_max(34)   = 100;
Graph.FuelLoop.x0(34)      = 0;
Graph.FuelLoop.Caps(34)    = inf; 

% v 35 Fuel PUMP -- algebraic
Graph.FuelLoop.x_min(35)   = -20;
Graph.FuelLoop.x_max(35)   = 100;
Graph.FuelLoop.x0(35)      = 0;
Graph.FuelLoop.Caps(35)    = inf; 

% v 36 RW ram air outlet T -- dynamic
Graph.FuelLoop.x_min(36)   = -20;
Graph.FuelLoop.x_max(36)   = 100;
Graph.FuelLoop.x0(36)      = HX.Ram_Air.init.T1;
Graph.FuelLoop.Caps(36)    = HX.Ram_Air.side1.N*HX.Ram_Air.side1.t*HX.Ram_Air.side1.W*HX.Ram_Air.side1.L*rc; 

% v 37 RW ram air wall -- dynamic
Graph.FuelLoop.x_min(37)   = -20;
Graph.FuelLoop.x_max(37)   = 100;
Graph.FuelLoop.x0(37)      = HX.Ram_Air.init.Twall;
Graph.FuelLoop.Caps(37)    = HX.Ram_Air.side1.N*HX.Ram_Air.mass*HX.Ram_Air.Cp_wall; 

% v 38 RW fuel out ram air HX -- dynamic
Graph.FuelLoop.x_min(38)   = -20;
Graph.FuelLoop.x_max(38)   = 100;
Graph.FuelLoop.x0(38)      = HX.Ram_Air.init.T2;
Graph.FuelLoop.Caps(38)    = HX.Ram_Air.side2.N*HX.Ram_Air.side2.t*HX.Ram_Air.side2.W*HX.Ram_Air.side2.L*rc; 

% v 39 Split to RW tanks T -- dynamic
Graph.FuelLoop.x_min(39)   = -20;
Graph.FuelLoop.x_max(39)   = 100;
Graph.FuelLoop.x0(39)      = (CP.AEE.init.Tout + HX.Ram_Air.init.T2)/2;
Graph.FuelLoop.Caps(39)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc; 

% v 40 split to RW tanks T -- dynamic
Graph.FuelLoop.x_min(40)   = -20;
Graph.FuelLoop.x_max(40)   = 100;
Graph.FuelLoop.x0(40)      = (CP.AEE.init.Tout + HX.Ram_Air.init.T2)/2;
Graph.FuelLoop.Caps(40)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc; 

% v 41 RW tank -- dynamic
Graph.FuelLoop.x_min(41)   = -20;
Graph.FuelLoop.x_max(41)   = 100;
Graph.FuelLoop.x0(41)      = Tanks.RWmain.init.T;
Graph.FuelLoop.Caps(41)    = Tanks.RWmain.init.M*Graph.FuelLoop.Cp_fluid; 

% v 42 RW aux tank -- dynamic
Graph.FuelLoop.x_min(42)   = -20;
Graph.FuelLoop.x_max(42)   = 100;
Graph.FuelLoop.x0(42)      = Tanks.RWaux.init.T;
Graph.FuelLoop.Caps(42)    = Tanks.RWaux.init.M*Graph.FuelLoop.Cp_fluid; 

% v 43 RW aux tank split -- dynamic
Graph.FuelLoop.x_min(43)   = -20;
Graph.FuelLoop.x_max(43)   = 100;
Graph.FuelLoop.x0(43)      = Tanks.LWaux.init.T;
Graph.FuelLoop.Caps(43)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc; 

% v 44 RW tank junction -- dynamic
Graph.FuelLoop.x_min(44)   = -20;
Graph.FuelLoop.x_max(44)   = 100;
Graph.FuelLoop.x0(44)      = Valves.Tank1.init.T;
Graph.FuelLoop.Caps(44)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc; 

% v 45 RW fadec split -- dynamic
Graph.FuelLoop.x_min(45)   = -20;
Graph.FuelLoop.x_max(45)   = 100;
Graph.FuelLoop.x0(45)      = Pumps.FuelPump.init.T;
Graph.FuelLoop.Caps(45)    = pi*Valves.Generic.D^2/4*Valves.Generic.L*rc; 

% v 46 RW FADEC wall -- dynamic
Graph.FuelLoop.x_min(46)   = -20;
Graph.FuelLoop.x_max(46)   = 100;
Graph.FuelLoop.x0(46)      = CP.FADEC.init.Twall;
Graph.FuelLoop.Caps(46)    = CP.FADEC.mass*CP.FADEC.Cp; 

% v 47 RW fuel out from FADEC CP -- dynamic
Graph.FuelLoop.x_min(47)   = -20;
Graph.FuelLoop.x_max(47)   = 100;
Graph.FuelLoop.x0(47)      = CP.FADEC.init.Tout;
Graph.FuelLoop.Caps(47)    = pi*CP.FADEC.ID^2/4*CP.FADEC.L*rc; 

% v 48 RW fuel outlet from gen HX -- dynamic
Graph.FuelLoop.x_min(48)   = -20;
Graph.FuelLoop.x_max(48)   = 100;
Graph.FuelLoop.x0(48)      = HX.Generator.init.T2;
Graph.FuelLoop.Caps(48)    = HX.Generator.side2.N*HX.Generator.side2.t*HX.Generator.side2.W*HX.Generator.side2.L*rc; 

% v 49 RW fuel outlet from eng HX -- dynamic
Graph.FuelLoop.x_min(49)   = -20;
Graph.FuelLoop.x_max(49)   = 100;
Graph.FuelLoop.x0(49)      = HX.LubeOil.init.T1;
Graph.FuelLoop.Caps(49)    = HX.LubeOil.side1.N*HX.LubeOil.side1.t*HX.LubeOil.side1.W*HX.LubeOil.side1.L*rc; 

% v 50 RW fuel T at FADEC junc -- dynamic
Graph.FuelLoop.x_min(50)   = -20;
Graph.FuelLoop.x_max(50)   = 100;
Graph.FuelLoop.x0(50)      = Pumps.BoostPump.init.T;
Graph.FuelLoop.Caps(50)    = pi*Splits.FuelGen.D^2/4*Splits.FuelGen.L*rc; 

% v 51 RW fuel to engine T -- dynamic
Graph.FuelLoop.x_min(51)   = -20;
Graph.FuelLoop.x_max(51)   = 100;
Graph.FuelLoop.x0(51)      = Pumps.BoostPump.init.T;
Graph.FuelLoop.Caps(51)    = pi*Pumps.BoostPump.ID^2/4*Pumps.BoostPump.ID*rc; 

% v 52 RW engine HX wall temp -- dynamic
Graph.FuelLoop.x_min(52)   = -20;
Graph.FuelLoop.x_max(52)   = 100;
Graph.FuelLoop.x0(52)      = HX.LubeOil.init.Twall;
Graph.FuelLoop.Caps(52)    = HX.LubeOil.side1.N*HX.LubeOil.mass*HX.LubeOil.Cp_wall; 

% v 53 RW engine cooling loop T -- dynamic
Graph.FuelLoop.x_min(53)   = -20;
Graph.FuelLoop.x_max(53)   = 100;
Graph.FuelLoop.x0(53)      = HX.LubeOil.init.T2;
Graph.FuelLoop.Caps(53)    = HX.LubeOil.side1.N*HX.LubeOil.side1.t*HX.LubeOil.side1.W*HX.LubeOil.side1.L*rc_PG; 

% v 54 RW engine cooling loop T -- dynamic
Graph.FuelLoop.x_min(54)   = -20;
Graph.FuelLoop.x_max(54)   = 100;
Graph.FuelLoop.x0(54)      = Pumps.EngGenPump.init.T;
Graph.FuelLoop.Caps(54)    = pi*Pumps.EngGenPump.ID ^2/4*Pumps.EngGenPump.ID *rc_PG; 

% v 55 RW engine cooling loop T -- dynamic
Graph.FuelLoop.x_min(55)   = -20;
Graph.FuelLoop.x_max(55)   = 100;
Graph.FuelLoop.x0(55)      = CP.Eng.init.Tout;
Graph.FuelLoop.Caps(55)    = pi*CP.Eng.ID^2/4*CP.Eng.L*rc_PG; 

% v 56 RW engine CP wall temp -- dynamic
Graph.FuelLoop.x_min(56)   = -20;
Graph.FuelLoop.x_max(56)   = 100;
Graph.FuelLoop.x0(56)      = CP.Eng.init.Twall;
Graph.FuelLoop.Caps(56)    = CP.Eng.mass*CP.Eng.Cp; 

% v 57 RW generator HX wall temp -- dynamic
Graph.FuelLoop.x_min(57)   = -20;
Graph.FuelLoop.x_max(57)   = 100;
Graph.FuelLoop.x0(57)      = HX.Generator.init.Twall;
Graph.FuelLoop.Caps(57)    = HX.Generator.side1.N*HX.Generator.mass*HX.Generator.Cp_wall; 

% v 58 RW generator cooling loop T -- dynamic
Graph.FuelLoop.x_min(58)   = -20;
Graph.FuelLoop.x_max(58)   = 100;
Graph.FuelLoop.x0(58)      = HX.Generator.init.T1;
Graph.FuelLoop.Caps(58)    = HX.Generator.side1.N*HX.Generator.side1.t*HX.Generator.side1.W*HX.Generator.side1.L*rc_PG; 

% v 59 RW generator cooling loop T -- dynamic
Graph.FuelLoop.x_min(59)   = -20;
Graph.FuelLoop.x_max(59)   = 100;
Graph.FuelLoop.x0(59)      = Pumps.EngGenPump.init.T;
Graph.FuelLoop.Caps(59)    = pi*Pumps.EngGenPump.ID^2/4*Pumps.EngGenPump.ID*rc_PG; 

% v 60 RW generator cooling loop T -- dynamic
Graph.FuelLoop.x_min(60)   = -20;
Graph.FuelLoop.x_max(60)   = 100;
Graph.FuelLoop.x0(60)      = CP.Gen.init.Tout;
Graph.FuelLoop.Caps(60)    = pi*CP.Gen.ID^2/4*CP.Gen.L*rc_PG; 

% v 61 RW generator CP wall temp -- dynamic
Graph.FuelLoop.x_min(61)   = -20;
Graph.FuelLoop.x_max(61)   = 100;
Graph.FuelLoop.x0(61)      = CP.Gen.init.Twall;
Graph.FuelLoop.Caps(61)    = CP.Gen.mass*CP.Gen.Cp; 

% v 62 Gen PUMP -- algebraic
Graph.FuelLoop.x_min(62)   = -20;
Graph.FuelLoop.x_max(62)   = 100;
Graph.FuelLoop.x0(62)      = 0;
Graph.FuelLoop.Caps(62)    = inf; 

% v 63 Eng PUMP -- algebraic
Graph.FuelLoop.x_min(63)   = -20;
Graph.FuelLoop.x_max(63)   = 100;
Graph.FuelLoop.x0(63)      = 0;
Graph.FuelLoop.Caps(63)    = inf; 

% v 64 Feul PUMP -- algebraic
Graph.FuelLoop.x_min(64)   = -20;
Graph.FuelLoop.x_max(64)   = 100;
Graph.FuelLoop.x0(64)      = 0;
Graph.FuelLoop.Caps(64)    = inf; 

% °C to K
Graph.FuelLoop.x_min  = Graph.FuelLoop.x_min + 273.15; 
Graph.FuelLoop.x_max  = Graph.FuelLoop.x_max + 273.15; 
Graph.FuelLoop.x0     = Graph.FuelLoop.x0 + 273.15;

%% SECTION 4 -- Edge definitions
  
% P = (c1+u)*(c2*x_from + c3*x_to + c4) 
Graph.FuelLoop.E_coeff         = zeros(Graph.FuelLoop.Ne,4);

% all edges that use Cp of the fluid 
indx_fld  = [1:2 4 6 7 10:20 22:23 25:27 44:54 56:57 59:61 95:98];
Graph.FuelLoop.E_coeff(indx_fld,2)  = Graph.FuelLoop.Cp_fluid;

% all edges that use Cp of PG_50
indx_fld_PG  = [30:32 37:39 64:66 71:73];
Graph.FuelLoop.E_coeff(indx_fld_PG,2)  = 3.6;

% all edges that have heat from a pump
% indx_pump_heat = [3 24 34 41 58 68 75];  % No edge equation, just a
% algebraic constraint and a W contraint based on eta

% all edges that have work from a pump
% indx_pump_sink = [83 84 85 86 87 88 89]; % No edge equation, just a
% algebraic constraint and a W contraint based on eta

% all edges that use Cp of air
indx_fld_Air = [76 77];
Graph.FuelLoop.E_coeff(indx_fld_Air,2)  = 1;

% all edges for tank mass drain
indx_mass_drain = [90 91 92 93 94];
Graph.FuelLoop.E_coeff(indx_mass_drain,2)  = Graph.FuelLoop.Cp_fluid;

% all edges that have hA heat transfer
% indx_hA = [5 8 9 21 28 29 33 35 36 40 42 43 55 62 63 67 69 70 74 78 79 80 81 82];

% e5 AEE wall heat transfer
hA = (pi * CP.AEE.ID *  CP.AEE.L) * CP.AEE.H;
Graph.FuelLoop.E_coeff(5,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(5,2) =  1;
Graph.FuelLoop.E_coeff(5,3) = -1;

% e8 RAM size 1 wall heat transfer
hA = 2*HX.Ram_Air.side1.N*HX.Ram_Air.side1.W*HX.Ram_Air.side1.L*HX.Ram_Air.side1.H;
Graph.FuelLoop.E_coeff(8,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(8,2) =  1;
Graph.FuelLoop.E_coeff(8,3) = -1;

% e9 RAM size 2 wall heat transfer
hA = 2*HX.Ram_Air.side1.N*HX.Ram_Air.side1.W*HX.Ram_Air.side1.L*HX.Ram_Air.side1.H;
Graph.FuelLoop.E_coeff(9,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(9,2) =  1;
Graph.FuelLoop.E_coeff(9,3) = -1;

% e21 FADEC wall heat transfer
hA = (pi * CP.FADEC.ID *  CP.FADEC.L) * CP.FADEC.H;
Graph.FuelLoop.E_coeff(21,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(21,2) =  1;
Graph.FuelLoop.E_coeff(21,3) = -1;

% e28 Eng HX side 1 wall heat transfer
hA = 2*HX.LubeOil.side1.N*HX.LubeOil.side1.W*HX.LubeOil.side1.L*HX.LubeOil.side1.H;
Graph.FuelLoop.E_coeff(28,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(28,2) =  1;
Graph.FuelLoop.E_coeff(28,3) = -1;

% e29 Eng HX side 2 wall heat transfer
hA = 2*HX.LubeOil.side1.N*HX.LubeOil.side1.W*HX.LubeOil.side1.L*HX.LubeOil.side1.H;
Graph.FuelLoop.E_coeff(29,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(29,2) =  1;
Graph.FuelLoop.E_coeff(29,3) = -1;

% e33 Eng wall heat transfer
hA = (pi * CP.Eng.ID *  CP.Eng.L) * CP.Eng.H;
Graph.FuelLoop.E_coeff(33,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(33,2) =  1;
Graph.FuelLoop.E_coeff(33,3) = -1;

% e35 Gen HX side 2 wall heat transfer
hA = 2*HX.Generator.side2.N*(HX.Generator.side2.W+HX.Generator.side2.t)*HX.Generator.side2.L*HX.Generator.side2.H;
Graph.FuelLoop.E_coeff(35,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(35,2) =  1;
Graph.FuelLoop.E_coeff(35,3) = -1;

% e36 Gen HX side 1 wall heat transfer
hA = 2*HX.Generator.side1.N*(HX.Generator.side1.W+HX.Generator.side1.t)*HX.Generator.side1.L*HX.Generator.side1.H;
Graph.FuelLoop.E_coeff(36,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(36,2) =  1;
Graph.FuelLoop.E_coeff(36,3) = -1;

% e40 Eng wall heat transfer
hA = (pi * CP.Gen.ID *  CP.Gen.L) * CP.Gen.H;
Graph.FuelLoop.E_coeff(40,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(40,2) =  1;
Graph.FuelLoop.E_coeff(40,3) = -1;

% e42 RAM size 1 wall heat transfer
hA = 2*HX.Ram_Air.side1.N*HX.Ram_Air.side1.W*HX.Ram_Air.side1.L*HX.Ram_Air.side1.H;
Graph.FuelLoop.E_coeff(42,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(42,2) =  1;
Graph.FuelLoop.E_coeff(42,3) = -1;

% e43 RAM size 2 wall heat transfer
hA = 2*HX.Ram_Air.side1.N*HX.Ram_Air.side1.W*HX.Ram_Air.side1.L*HX.Ram_Air.side1.H;
Graph.FuelLoop.E_coeff(43,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(43,2) =  1;
Graph.FuelLoop.E_coeff(43,3) = -1;

% e55 FADEC wall heat transfer
hA = (pi * CP.FADEC.ID *  CP.FADEC.L) * CP.FADEC.H;
Graph.FuelLoop.E_coeff(55,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(55,2) =  1;
Graph.FuelLoop.E_coeff(55,3) = -1;

% e62 Eng HX side 1 wall heat transfer
hA = 2*HX.LubeOil.side1.N*HX.LubeOil.side1.W*HX.LubeOil.side1.L*HX.LubeOil.side1.H;
Graph.FuelLoop.E_coeff(62,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(62,2) =  1;
Graph.FuelLoop.E_coeff(62,3) = -1;

% e63 Eng HX side 2 wall heat transfer
hA = 2*HX.LubeOil.side1.N*HX.LubeOil.side1.W*HX.LubeOil.side1.L*HX.LubeOil.side1.H;
Graph.FuelLoop.E_coeff(63,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(63,2) =  1;
Graph.FuelLoop.E_coeff(63,3) = -1;

% e67 Eng wall heat transfer
hA = (pi * CP.Eng.ID *  CP.Eng.L) * CP.Eng.H;
Graph.FuelLoop.E_coeff(67,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(67,2) =  1;
Graph.FuelLoop.E_coeff(67,3) = -1;

% e69 Gen HX side 2 wall heat transfer
hA = 2*HX.Generator.side2.N*(HX.Generator.side2.W+HX.Generator.side2.t)*HX.Generator.side2.L*HX.Generator.side2.H;
Graph.FuelLoop.E_coeff(69,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(69,2) =  1;
Graph.FuelLoop.E_coeff(69,3) = -1;

% e70 Gen HX side 1 wall heat transfer
hA = 2*HX.Generator.side1.N*(HX.Generator.side1.W+HX.Generator.side1.t)*HX.Generator.side1.L*HX.Generator.side1.H;
Graph.FuelLoop.E_coeff(70,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(70,2) =  1;
Graph.FuelLoop.E_coeff(70,3) = -1;

% e74 Eng wall heat transfer
hA = (pi * CP.Gen.ID *  CP.Gen.L) * CP.Gen.H;
Graph.FuelLoop.E_coeff(74,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(74,2) =  1;
Graph.FuelLoop.E_coeff(74,3) = -1;

% e78 Tank wall heat transfer
hA = Tanks.LWmain.SA*Tanks.LWmain.Hamb ;
Graph.FuelLoop.E_coeff(78,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(78,2) =  1;
Graph.FuelLoop.E_coeff(78,3) = -1;

% e79 Tank wall heat transfer
hA = Tanks.LWaux.SA*Tanks.LWaux.Hamb ;
Graph.FuelLoop.E_coeff(79,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(79,2) =  1;
Graph.FuelLoop.E_coeff(79,3) = -1;

% e80 Tank wall heat transfer
hA = Tanks.Centr.SA*Tanks.Centr.Hamb ;
Graph.FuelLoop.E_coeff(80,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(80,2) =  1;
Graph.FuelLoop.E_coeff(80,3) = -1;

% e81 Tank wall heat transfer
hA = Tanks.RWaux.SA*Tanks.RWaux.Hamb ;
Graph.FuelLoop.E_coeff(81,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(81,2) =  1;
Graph.FuelLoop.E_coeff(81,3) = -1;

% e82 Tank wall heat transfer
hA = Tanks.RWmain.SA*Tanks.RWmain.Hamb ;
Graph.FuelLoop.E_coeff(82,1) = hA / 1000;  % units: kW/K
Graph.FuelLoop.E_coeff(82,2) =  1;
Graph.FuelLoop.E_coeff(82,3) = -1;
%%
% return
Graph.FuelLoop.Caps;
Graph.FuelLoop.Caps(Graph.FuelLoop.Caps < 15) = 0; % Make small capacitances zero
% Graph.FuelLoop.Caps(Graph.FuelLoop.Caps < 100) = 0; % Make small capacitances zero
Graph.FuelLoop.Caps([7 36 8 37]) = 0; % Make small capacitances zero
Graph.FuelLoop.Caps;

% set max temps on engine and generators
Graph.FuelLoop.x_max([27 32 56 61])  = 100 + 273.15;
Graph.FuelLoop.x_max([5])  = 40 + 273.15;

Graph.FuelLoop.x_max([12 13 41 42]) = 70+273.15;
%% Fuel system controller definition
CTRL = Graph.FuelLoop;
CTRL.hor = 5;

CTRL.N_track = 4;
CTRL.indx_track = [12 13 41 42];    % track fuel tank temperatures


%% defining variables for use with YALMIP
yalmip('clear')
% Sources (Pin_) and sinks (xt_) -- including preview across the horizon
Pin_  = sdpvar(repmat(CTRL.Ns+CTRL.Ns_aux, 1, CTRL.hor), ones(1,CTRL.hor));
xt_   = sdpvar(repmat(CTRL.Nt+CTRL.Nt_aux, 1, CTRL.hor), ones(1,CTRL.hor));

% states (x_), power flows (P_), and inputs (u_) across the horizon
x_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor+1) ,ones(1,CTRL.hor+1));
P_    = sdpvar(repmat(CTRL.Ne         ,1,CTRL.hor)   ,ones(1,CTRL.hor));
uC_   = sdpvar(repmat(CTRL.NuC        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
z_   = sdpvar(repmat(CTRL.N_track     ,1,CTRL.hor+1)   ,ones(1,CTRL.hor+1));
ref_   = sdpvar(repmat(CTRL.N_track+15     ,1,1)   ,ones(1,1));
Caps_    = sdpvar(repmat(5         ,1,1) ,ones(1,1));
Mtanks_  = sdpvar(repmat(5         ,1,CTRL.hor+1) ,ones(1,CTRL.hor+1));

% inputs (mdots) set outside of subsystem used to constrain inputs for flow
% to sinks
uext_   = sdpvar(repmat(4        ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% previous inputs and current states
u0_ = sdpvar(repmat(CTRL.NuC+CTRL.NuB ,1,1)          ,ones(1,1));  
x0_ = sdpvar(repmat(CTRL.Nv ,1,1)          ,ones(1,1));  

% slack variable for all states across the horizon
s_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor)   ,ones(1,CTRL.hor));
% slack variable for input constraints across the horizon
s2_    = sdpvar(repmat(14       ,1,CTRL.hor)   ,ones(1,CTRL.hor));
% soft slack near constraints
s3_   = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% all state (xall_), tracked states (xtr_), and tracked power flows (Ptr_)
% across the horizon
Nx_total = CTRL.Nv+CTRL.Nt+CTRL.Nt_aux;
xall_ = sdpvar(repmat(Nx_total        ,1,CTRL.hor)   ,ones(1,CTRL.hor));

objs = 0;       % initializing the objective function at 0
cons = [];      % initializing the contraints as an empty set

%% definiing the objective function and constraints

for k = 1:CTRL.hor    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%% OBJECTIVE FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%% REMOVE for hierarchy  %%%%%
    objs = objs + 1e0*norm(uC_{k}(3)-uC_{k}(4),2)^2;
    objs = objs + 1e0*norm(uC_{k}(10)-uC_{k}(14),2)^2;
    objs = objs + 1e1*norm(uC_{k}(10),2)^2;
    objs = objs + 1e1*norm(uC_{k}(14),2)^2;
    objs = objs + 1e2*norm(uC_{k}(2),2)^2;
    
    if k == 1
        objs = objs + 1e1*norm(uC_{k}(10),2)^2;
        objs = objs + 1e1*norm(uC_{k}(14),2)^2;
    else
        objs = objs + 1e3*norm(uC_{k}(1)-uC_{k-1}(1),2)^2;
    end
    cons = [cons, -0.02 <= uC_{k}(1)-u0_(1) <= 0.02];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % minimize - slack on states
    objs = objs + 1e3*norm(s_{k},2)^2;   
    objs = objs + 1e6*norm(s2_{k},2)^2; 
    objs = objs + 1e0*norm(s3_{k},2)^2;   
    % minimize - tank mass differnces
    objs = objs + 2e-2*norm(Mtanks_{k+1}(1)-3/4*sum(Mtanks_{k+1}(2:5))/4,2)^2;
    objs = objs + 2e-3*norm(Mtanks_{k+1}(2)-Mtanks_{k+1}(3),2)^2;
    objs = objs + 2e-3*norm(Mtanks_{k+1}(4)-Mtanks_{k+1}(5),2)^2;
    objs = objs + 2e-3*norm(Mtanks_{k+1}(2)-Mtanks_{k+1}(4),2)^2;
    % minimize - rate of input changes
    if k == 1
        objs = objs + 1e1*norm(uC_{k}-u0_,2)^2;
    else
        objs = objs + 1e1*norm(uC_{k}-uC_{k-1},2)^2;
    end
    % Minimize generator and engine pumps
    objs = objs + 1e0*norm((uC_{k}(27:30)-CTRL.u_min(27:30))./CTRL.u_max(27:30),2)^2;  
    % Minimize AEE pump
    objs = objs + 1e-1*norm(uC_{k}(2)-CTRL.u_min(2),2)^2;  
 
    % track desired recirculation flow rate
    objs = objs + 1e1*norm(uC_{k}([31 33]) - ref_([18 19]) ,2)^2;  
    
    objs = objs + 1e-2*norm(x_{k+1}(CTRL.indx_track)-ref_(1:4),2)^2;  
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % system dynamics
    tanks = [1 12 13 41 42];
    cons = [cons, 1/CTRL.DT*diag(Caps_)*(x_{k+1}(tanks)- x_{k}(tanks)) == ...
        (-CTRL.M_upper(tanks,:)*P_{k} + CTRL.D(tanks,:)*Pin_{k})  ];
    
    dyn = setdiff(setdiff(find(CTRL.Caps~=0),find(CTRL.Caps==inf)),tanks);
    cons = [cons, 1/CTRL.DT*diag(CTRL.Caps(dyn))*(x_{k+1}(dyn)- x_{k}(dyn)) == ...
        (-CTRL.M_upper(dyn,:)*P_{k} + CTRL.D(dyn,:)*Pin_{k})  ];
    
    alg = find(CTRL.Caps==0);
    if k == 1
        objs = objs + 1e3*norm(-CTRL.M_upper(alg,:)*P_{k} + CTRL.D(alg,:)*Pin_{k},2)^2;
    end
    if k > 1
        cons = [cons, 0 == (-CTRL.M_upper(alg,:)*P_{k} + CTRL.D(alg,:)*Pin_{k})  ];
    end

    fixed = find(CTRL.Caps==inf);
    cons = [cons, x_{k+1}(fixed) == x_{k}(fixed)];
    
    cons = [cons, z_{k+1} == z_{k} + CTRL.DT*(x_{k+1}(CTRL.indx_track)-ref_(1:4))];
    
    % min/max state constraints with slack
    cons = [cons, CTRL.x_min - s_{k} <= x_{k+1} <= CTRL.x_max + s_{k}]; 
    cons = [cons, x_{k+1}+2 <= CTRL.x_max + s3_{k}]; 
    
    % keep slack positive
    cons = [cons, 0 <= s_{k}];      % Keep slack non-negative
    
    % min/max input constraints
    cons = [cons, CTRL.u_min <= uC_{k} <= CTRL.u_max];
    
    % set minimum recirc flow rate
    cons = [cons, 0.25 <= uC_{k}([31 33])];

    % concatenating states with sinks
    cons = [cons, xall_{k} == [x_{k};xt_{k}]];
    
    % Mass of tanks
    if k == 1
        cons = [cons, Mtanks_{k} == Caps_/Graph.FuelLoop.Cp_fluid];
    end
    cons = [cons, Mtanks_{k+1}(1) == Mtanks_{k}(1) - CTRL.DT*uC_{k}(1)];
    cons = [cons, Mtanks_{k+1}(2) == Mtanks_{k}(2) + CTRL.DT*(uC_{k}(7)+uC_{k}(21)-uC_{k}(12))];
    cons = [cons, Mtanks_{k+1}(3) == Mtanks_{k}(3) + CTRL.DT*(uC_{k}(8)+uC_{k}(20)-uC_{k}(9))];
    cons = [cons, Mtanks_{k+1}(4) == Mtanks_{k}(4) + CTRL.DT*(uC_{k}(5)+uC_{k}(26)-uC_{k}(16))];
    cons = [cons, Mtanks_{k+1}(5) == Mtanks_{k}(5) + CTRL.DT*(uC_{k}(6)+uC_{k}(25)-uC_{k}(13))];
    
    cons = [cons, 10 <= Mtanks_{k+1}]; % keep tanks above 10kg
    
    % split and junction constraints
    cons = [cons, s2_{k}(1) == uC_{k}(1) + uC_{k}(10) + uC_{k}(14) - uC_{k}(2)];
    cons = [cons, s2_{k}(2) == uC_{k}(2) - uC_{k}(3) - uC_{k}(4)];
    cons = [cons, s2_{k}(3) == uC_{k}(3) - uC_{k}(5) - uC_{k}(6)];
    cons = [cons, s2_{k}(4) == uC_{k}(4) - uC_{k}(7) - uC_{k}(8)];
    cons = [cons, s2_{k}(5) == uC_{k}(9) - uC_{k}(10) - uC_{k}(11)];
    cons = [cons, s2_{k}(6) == uC_{k}(13) - uC_{k}(14) - uC_{k}(15)];
    cons = [cons, s2_{k}(7) == uC_{k}(11) + uC_{k}(12) - uC_{k}(17)];
    cons = [cons, s2_{k}(8) == uC_{k}(15) + uC_{k}(16) - uC_{k}(22)];
    cons = [cons, s2_{k}(9) == uC_{k}(17) - uC_{k}(18) - uC_{k}(19)];
    cons = [cons, s2_{k}(10) == uC_{k}(22) - uC_{k}(23) - uC_{k}(24)];
    cons = [cons, s2_{k}(11) == uC_{k}(17) - uC_{k}(31) - uC_{k}(32)];
    cons = [cons, s2_{k}(12) == uC_{k}(22) - uC_{k}(33) - uC_{k}(34)];
    cons = [cons, s2_{k}(13) == uC_{k}(31) - uC_{k}(20) - uC_{k}(21)];
    cons = [cons, s2_{k}(14) == uC_{k}(33) - uC_{k}(25) - uC_{k}(26)];
        
    % sink flow constraints
    cons = [cons, uC_{k}([32 34 35 36]) == uext_{k}];
    
    % edges that follow an mdot*Cp*T power flow
    for i_edge = setdiff(find(any(CTRL.B,2)'),[90:94])
        cons = [cons, P_{k}(i_edge) == u0_(find(CTRL.B(i_edge,:)))*...
            (CTRL.E_coeff(i_edge,2) * (xall_{k}(CTRL.E(i_edge,1)) - x0_(CTRL.E(i_edge,1))))+...
            (uC_{k}(find(CTRL.B(i_edge,:)))*CTRL.E_coeff(i_edge,2)*x0_(CTRL.E(i_edge,1))) ];
    end
    
    % edges that follow an mass drain compensation
    for i_edge = [90:91 93:94]
        cons = [cons, P_{k}(i_edge) ==  (sum(uC_{k}(find(CTRL.B(i_edge,:)==1)))-uC_{k}(find(CTRL.B(i_edge,:)==-1)))*...
            CTRL.E_coeff(i_edge,2)*x0_(CTRL.E(i_edge,1))];
    end
    for i_edge = [92]
        cons = [cons, P_{k}(i_edge) ==  (-uC_{k}(find(CTRL.B(i_edge,:)==-1)))*...
            CTRL.E_coeff(i_edge,2)*x0_(CTRL.E(i_edge,1))];
    end
    
    % edges that follow an hA*deltaT power flow
    for i_edge = find(~any(CTRL.B,2)'-any(CTRL.W,1)) 
        cons = [cons, P_{k}(i_edge) == (CTRL.E_coeff(i_edge,1)) * ...
                     (CTRL.E_coeff(i_edge,2) * xall_{k}(CTRL.E(i_edge,1)) +...
          	          CTRL.E_coeff(i_edge,3) * xall_{k}(CTRL.E(i_edge,2)))];
    end
    
    % algebraic constraints on powers
    cons = [cons, CTRL.W*P_{k} == 0];  
    
    % power flows in
    cons = [cons, P_{k}(24) + P_{k}(83) == Pin_{k}(9) ];
    cons = [cons, P_{k}(58) + P_{k}(85) == Pin_{k}(10)];
    cons = [cons, P_{k}(34) + P_{k}(86) == Pin_{k}(11)];
    cons = [cons, P_{k}(68) + P_{k}(89) == Pin_{k}(12)];
    cons = [cons, P_{k}(41) + P_{k}(87) == Pin_{k}(13)];
    cons = [cons, P_{k}(75) + P_{k}(88) == Pin_{k}(14)];
    cons = [cons, P_{k}( 3) + P_{k}(84) == Pin_{k}(18)];
    
%     cons = [cons, P_{k} >= 0];  % Had to remove, caused infeasible during
%     transients
end

opts = sdpsettings('solver','gurobi','gurobi.TimeLimit',0.1);  % Solve with gurobi
Ctrl.FuelLoop = CTRL;
% Create exported optimization model object
Ctrl.FuelLoop.Controller = optimizer(cons,objs,opts,{x0_,x_{1},xt_{:},Pin_{:},u0_,uext_{:},z_{1},ref_,Caps_},[x_,uC_,P_,s_,s2_]); 