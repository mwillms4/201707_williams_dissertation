%% Fluid loops graph
Graph.FluidLoop.Name = 'FluidLoop';
Graph.FluidLoop.DT   = 1;
Graph.FluidLoop.Cp_fluid = 3.59;
Graph.FluidLoop.Pin0 = [0.5*300*3.53;0.5*300*3.53;1;1.2;1.2;ones(15,1)];
eta_pump = 0.8;

%% SECTION 2 -- Graph structure
Graph.FluidLoop.Nv      = 45;             % Number of vertices 
Graph.FluidLoop.Ne      = 63;             % Number of edges (Power flows)
Graph.FluidLoop.Ns      = 0 ;             % Number of sources
Graph.FluidLoop.Ns_aux  = 20;             % Number of auxiliary sources
Graph.FluidLoop.Nt      = 1 ;             % Number of sinks
Graph.FluidLoop.Nt_aux  = 2 ;             % Number of auxiliar sinks
Graph.FluidLoop.NuC     = 23;             % Number of unique continuous inputs
Graph.FluidLoop.NuB     = 0 ;             % Number of unique binary inputs

% Edge matrix 
Graph.FluidLoop.E = [1  2        % 1
                     3  2        %
                     2  4        %
                     4  5        %
                     4  7        %
                     4  8        %
                     4  9        %
                     4  6        %
                     5  28       %
                     25 28       % 10
                     26 28       %
                     27 28       %
                     6  28       %
                     7  10       %
                     7  11       %
                     7  12       %
                     7  13       %
                     7  14       %
                     10 25       %
                     11 25       % 20
                     12 25       %
                     13 25       %
                     14 25       %
                     8  15       %
                     8  16       %
                     8  17       %
                     8  18       %
                     8  19       %
                     15 26       %
                     16 26       % 30
                     17 26       %
                     18 26       %
                     19 26       %
                     9  20       %
                     9  21       %
                     9  22       %
                     9  23       %
                     9  24       %
                     20 27       %
                     21 27       % 40
                     22 27       %
                     23 27       %
                     24 27       % 
                     29 5        % 
                     30 10       % 
                     31 11       % 
                     32 12       % 
                     33 13       % 
                     34 14       % 
                     35 15       % 50 
                     36 16       % 
                     37 17       % 
                     38 18       % 
                     39 19       % 
                     40 20       % 
                     41 21       % 
                     42 22       % 
                     43 23       % 
                     44 24       % 
                     45 6        % 60
                     3  46       %
                     28 47       %
                     28 48];     % 
                     
                     
% INPUT ORDERING:

% constraints on min/max flow rates
Graph.FluidLoop.u_min    = zeros(Graph.FluidLoop.NuC,1)+1e-2;
Graph.FluidLoop.u_max    = 2*ones(Graph.FluidLoop.NuC,1);

% initializing the graph B matrix
Graph.FluidLoop.B        = zeros(Graph.FluidLoop.Ne,Graph.FluidLoop.NuC);

Graph.FluidLoop.B(1,1)   = 1;   % edge 1  -- Inflow
Graph.FluidLoop.B(3,1)   = 1;   % edge 3  -- Inflow

Graph.FluidLoop.B(4,2)   = 1;   % edge 4  -- HV Battery
Graph.FluidLoop.B(9,2)   = 1;   % edge 9  -- HV Battery

Graph.FluidLoop.B(5,3)   = 1;   % edge 5  -- HVDC Inverters
Graph.FluidLoop.B(10,3)  = 1;   % edge 10 -- HVDC Inverters

Graph.FluidLoop.B(6,4)   = 1;   % edge 6  -- LVDC Inverters
Graph.FluidLoop.B(11,4)  = 1;   % edge 11 -- LVDC Inverters

Graph.FluidLoop.B(7,5)   = 1;   % edge 7  -- LVAC Inverters
Graph.FluidLoop.B(12,5)  = 1;   % edge 12 -- LVAC Inverters

Graph.FluidLoop.B(8,6)   = 1;   % edge 8  -- LV Battery
Graph.FluidLoop.B(13,6)  = 1;   % edge 13 -- LV Battery

Graph.FluidLoop.B(14,7)  = 1;   % edge 14 -- HVDC Inverter 1
Graph.FluidLoop.B(19,7)  = 1;   % edge 19 -- HVDC Inverter 1

Graph.FluidLoop.B(15,8)  = 1;   % edge 15 -- HVDC Inverter 2
Graph.FluidLoop.B(20,8)  = 1;   % edge 20 -- HVDC Inverter 2

Graph.FluidLoop.B(16,9)  = 1;   % edge 16 -- HVDC Inverter 3
Graph.FluidLoop.B(21,9)  = 1;   % edge 21 -- HVDC Inverter 3

Graph.FluidLoop.B(17,10) = 1;   % edge 17 -- HVDC Inverter 4
Graph.FluidLoop.B(22,10) = 1;   % edge 22 -- HVDC Inverter 4

Graph.FluidLoop.B(18,11) = 1;   % edge 18 -- HVDC Inverter 5
Graph.FluidLoop.B(23,11) = 1;   % edge 23 -- HVDC Inverter 5

Graph.FluidLoop.B(24,12) = 1;   % edge 24 -- LVDC Inverter 1
Graph.FluidLoop.B(29,12) = 1;   % edge 29 -- LVDC Inverter 1

Graph.FluidLoop.B(25,13) = 1;   % edge 25 -- LVDC Inverter 2
Graph.FluidLoop.B(30,13) = 1;   % edge 30 -- LVDC Inverter 2

Graph.FluidLoop.B(26,14) = 1;   % edge 26 -- LVDC Inverter 3
Graph.FluidLoop.B(31,14) = 1;   % edge 31 -- LVDC Inverter 3

Graph.FluidLoop.B(27,15) = 1;   % edge 27 -- LVDC Inverter 4
Graph.FluidLoop.B(32,15) = 1;   % edge 32 -- LVDC Inverter 4

Graph.FluidLoop.B(28,16) = 1;   % edge 28 -- LVDC Inverter 5
Graph.FluidLoop.B(33,16) = 1;   % edge 33 -- LVDC Inverter 5

Graph.FluidLoop.B(34,17) = 1;   % edge 34 -- LVAC Inverter 1
Graph.FluidLoop.B(39,17) = 1;   % edge 39 -- LVAC Inverter 1

Graph.FluidLoop.B(35,18) = 1;   % edge 35 -- LVAC Inverter 2
Graph.FluidLoop.B(40,18) = 1;   % edge 40 -- LVAC Inverter 2

Graph.FluidLoop.B(36,19) = 1;   % edge 36 -- LVAC Inverter 3
Graph.FluidLoop.B(41,19) = 1;   % edge 41 -- LVAC Inverter 3

Graph.FluidLoop.B(37,20) = 1;   % edge 37 -- LVAC Inverter 4
Graph.FluidLoop.B(42,20) = 1;   % edge 42 -- LVAC Inverter 4

Graph.FluidLoop.B(38,21) = 1;   % edge 38 -- LVAC Inverter 5
Graph.FluidLoop.B(43,21) = 1;   % edge 43 -- LVAC Inverter 5

Graph.FluidLoop.B(62,22) = 1;   % edge 62 -- ACM Split

Graph.FluidLoop.B(63,23) = 1;   % edge 63 -- ACM Split

% Vertices connected to sources, formatted as (vertex# , source#)
Graph.FluidLoop.D        = zeros(Graph.FluidLoop.Nv,Graph.FluidLoop.Ns+Graph.FluidLoop.Ns_aux);
Graph.FluidLoop.D(1 ,1)  = 1;          % return from left ACM
Graph.FluidLoop.D(1 ,2)  = 1;          % return from righ ACM
Graph.FluidLoop.D(3 ,3)  = 1;          % Pump power
Graph.FluidLoop.D(29,4)  = 1;          % HV battery heat
Graph.FluidLoop.D(45,5)  = 1;          % LV battery heat
Graph.FluidLoop.D(30,6)  = 1;          % HVDC heat for inverter 1
Graph.FluidLoop.D(31,7)  = 1;          % HVDC heat for inverter 2
Graph.FluidLoop.D(32,8)  = 1;          % HVDC heat for inverter 3
Graph.FluidLoop.D(33,9)  = 1;          % HVDC heat for inverter 4
Graph.FluidLoop.D(34,10) = 1;          % HVDC heat for inverter 5
Graph.FluidLoop.D(35,11) = 1;          % LVDC heat for inverter 1
Graph.FluidLoop.D(36,12) = 1;          % LVDC heat for inverter 2
Graph.FluidLoop.D(37,13) = 1;          % LVDC heat for inverter 3
Graph.FluidLoop.D(38,14) = 1;          % LVDC heat for inverter 4
Graph.FluidLoop.D(39,15) = 1;          % LVDC heat for inverter 5
Graph.FluidLoop.D(40,16) = 1;          % LVAC heat for inverter 1
Graph.FluidLoop.D(41,17) = 1;          % LVAC heat for inverter 2
Graph.FluidLoop.D(42,18) = 1;          % LVAC heat for inverter 3
Graph.FluidLoop.D(43,19) = 1;          % LVAC heat for inverter 4
Graph.FluidLoop.D(44,20) = 1;          % LVAC heat for inverter 5

% number of algebraic relationships
No_Alg = 1;

% W capatures the algebraic relationships in graphs
Graph.FluidLoop.W       = zeros(No_Alg,Graph.FluidLoop.Ne);
% 
Graph.FluidLoop.W(1,2)          = -1;
Graph.FluidLoop.W(1,61)         = (1/eta_pump-1);   % pump inefficiencies 
% Graph.FluidLoop.W(2,[1 2])      = 0;
% Graph.FluidLoop.W(2,3)          = 0;   % summation at V(2) -- Pump
% Graph.FluidLoop.W(3,3)          =  1;
% Graph.FluidLoop.W(3,4:8)        = -1;   % split 1
% Graph.FluidLoop.W(4,5)          =  1;
% Graph.FluidLoop.W(4,14:18)      = -1;   % split 2
% Graph.FluidLoop.W(5,6)          =  1;
% Graph.FluidLoop.W(5,24:28)      = -1;   % split 3
% Graph.FluidLoop.W(6,7)          =  1;
% Graph.FluidLoop.W(6,34:38)      = -1;   % split 4
% Graph.FluidLoop.W(7,10)         =  1;
% Graph.FluidLoop.W(7,19:23)      = -1;   % junc 1
% Graph.FluidLoop.W(8,11)         =  1;
% Graph.FluidLoop.W(8,29:33)      = -1;   % junc 2
% Graph.FluidLoop.W(9,12)         =  1;
% Graph.FluidLoop.W(9,39:43)      = -1;   % junc 3
% Graph.FluidLoop.W(10,45:46)     =  1;
% Graph.FluidLoop.W(10,9:13)      = -1;   % junc 4

% Incidence Matrix
Graph.FluidLoop.M = zeros(Graph.FluidLoop.Nv+Graph.FluidLoop.Nt,Graph.FluidLoop.Ne);
for i = 1:Graph.FluidLoop.Ne;
    Graph.FluidLoop.M(Graph.FluidLoop.E(i,1),i) = 1;
    Graph.FluidLoop.M(Graph.FluidLoop.E(i,2),i) = -1;
end
clear i
Graph.FluidLoop.M_upper = Graph.FluidLoop.M(1:Graph.FluidLoop.Nv,:);
Graph.FluidLoop.M_lower = Graph.FluidLoop.M(1+Graph.FluidLoop.Nv:end,:);
Graph.FluidLoop.Tail    = (Graph.FluidLoop.M'== 1);
Graph.FluidLoop.Head    = (Graph.FluidLoop.M'==-1);

%% SECTION 3 -- Vertex definitions
% Graph Parameters
% Vertex Capacitances and Initial Temperatures
Graph.FluidLoop.x0      = zeros(Graph.FluidLoop.Nv,1);
Graph.FluidLoop.Caps    = zeros(Graph.FluidLoop.Nv,1);
Graph.FluidLoop.x_min   = zeros(Graph.FluidLoop.Nv,1);
Graph.FluidLoop.x_max   = zeros(Graph.FluidLoop.Nv,1);

% v1 T junc -- dynamic
Graph.FluidLoop.x_min(1)   = 0;
Graph.FluidLoop.x_max(1)   = 100;
Graph.FluidLoop.x0(1)      = 20;
Graph.FluidLoop.Caps(1)    = 0.05^3*1034*3.5; 
% v2 T pump -- dynamic 
Graph.FluidLoop.x_min(2)   = 0;
Graph.FluidLoop.x_max(2)   = 100;
Graph.FluidLoop.x0(2)      = 20;
Graph.FluidLoop.Caps(2)    = pi*(Pumps.InvrtrPump.ID/2)^2*0.1*1034*3.5; 
% v3 Pump -- dynamic
Graph.FluidLoop.x_min(3)   = 0;
Graph.FluidLoop.x_max(3)   = 100;
Graph.FluidLoop.x0(3)      = 20;
Graph.FluidLoop.Caps(3)    = 0.05^3*1034*3.5;
% v4 split -- dynamic
Graph.FluidLoop.x_min(4)   = 0;
Graph.FluidLoop.x_max(4)   = 100;
Graph.FluidLoop.x0(4)      = 20;
Graph.FluidLoop.Caps(4)    = 0.05^3*1034*3.5;
% v5 T battery -- dynamic
Graph.FluidLoop.x_min(5)   = 0;
Graph.FluidLoop.x_max(5)   = 100;
Graph.FluidLoop.x0(5)      = 30;
Graph.FluidLoop.Caps(5)    = 0.05^3*1034*3.5;
% v6 T battery -- dynamic
Graph.FluidLoop.x_min(6)   = 0;
Graph.FluidLoop.x_max(6)   = 100;
Graph.FluidLoop.x0(6)      = 30;
Graph.FluidLoop.Caps(6)    = 0.05^3*1034*3.5;
% v7 split -- dynamic
Graph.FluidLoop.x_min(7)   = 0;
Graph.FluidLoop.x_max(7)   = 100;
Graph.FluidLoop.x0(7)      = 20;
Graph.FluidLoop.Caps(7)    = 0.05^3*1034*3.5;
% v8 split -- dynamic
Graph.FluidLoop.x_min(8)   = 0;
Graph.FluidLoop.x_max(8)   = 100;
Graph.FluidLoop.x0(8)      = 20;
Graph.FluidLoop.Caps(8)    = 0.05^3*1034*3.5;
% v9 split -- dynamic
Graph.FluidLoop.x_min(9)   = 0;
Graph.FluidLoop.x_max(9)   = 100;
Graph.FluidLoop.x0(9)      = 20;
Graph.FluidLoop.Caps(9)    = 0.05^3*1034*3.5;
% v10 HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(10)  = 0;
Graph.FluidLoop.x_max(10)  = 100;
Graph.FluidLoop.x0(10)     = 30;
Graph.FluidLoop.Caps(10)   = 0.05^3*1034*3.5;
% v11 HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(11)  = 0;
Graph.FluidLoop.x_max(11)  = 100;
Graph.FluidLoop.x0(11)     = 30;
Graph.FluidLoop.Caps(11)   = 0.05^3*1034*3.5;
% v HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(12)  = 0;
Graph.FluidLoop.x_max(12)  = 100;
Graph.FluidLoop.x0(12)     = 30;
Graph.FluidLoop.Caps(12)   = 0.05^3*1034*3.5;
% v HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(13)  = 0;
Graph.FluidLoop.x_max(13)  = 100;
Graph.FluidLoop.x0(13)     = 30;
Graph.FluidLoop.Caps(13)   = 0.05^3*1034*3.5;
% v HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(14)  = 0;
Graph.FluidLoop.x_max(14)  = 100;
Graph.FluidLoop.x0(14)     = 30;
Graph.FluidLoop.Caps(14)   = 0.05^3*1034*3.5;
% v 15 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(15)  = 0;
Graph.FluidLoop.x_max(15)  = 100;
Graph.FluidLoop.x0(15)     = 30;
Graph.FluidLoop.Caps(15)   = 0.05^3*1034*3.5;
% v 16 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(16)  = 0;
Graph.FluidLoop.x_max(16)  = 100;
Graph.FluidLoop.x0(16)     = 30;
Graph.FluidLoop.Caps(16)   = 0.05^3*1034*3.5;
% v 17 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(17)  = 0;
Graph.FluidLoop.x_max(17)  = 100;
Graph.FluidLoop.x0(17)     = 30;
Graph.FluidLoop.Caps(17)   = 0.05^3*1034*3.5;
% v 18 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(18)  = 0;
Graph.FluidLoop.x_max(18)  = 100;
Graph.FluidLoop.x0(18)     = 30;
Graph.FluidLoop.Caps(18)   = 0.05^3*1034*3.5;
% v 19 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(19)  = 0;
Graph.FluidLoop.x_max(19)  = 100;
Graph.FluidLoop.x0(19)     = 30;
Graph.FluidLoop.Caps(19)   = 0.05^3*1034*3.5;
% v 20 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(20)  = 0;
Graph.FluidLoop.x_max(20)  = 100;
Graph.FluidLoop.x0(20)     = 30;
Graph.FluidLoop.Caps(20)   = 0.05^3*1034*3.5;
% v 21 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(21)  = 0;
Graph.FluidLoop.x_max(21)  = 100;
Graph.FluidLoop.x0(21)     = 30;
Graph.FluidLoop.Caps(21)   = 0.05^3*1034*3.5;
% v 22 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(22)  = 0;
Graph.FluidLoop.x_max(22)  = 100;
Graph.FluidLoop.x0(22)     = 30;
Graph.FluidLoop.Caps(22)   = 0.05^3*1034*3.5;
% v 23 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(23)  = 0;
Graph.FluidLoop.x_max(23)  = 100;
Graph.FluidLoop.x0(23)     = 30;
Graph.FluidLoop.Caps(23)   = 0.05^3*1034*3.5;
% v 24 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(24)  = 0;
Graph.FluidLoop.x_max(24)  = 100;
Graph.FluidLoop.x0(24)     = 30;
Graph.FluidLoop.Caps(24)   = 0.05^3*1034*3.5;
% v 25 junction -- dynamic
Graph.FluidLoop.x_min(25)  = 0;
Graph.FluidLoop.x_max(25)  = 100;
Graph.FluidLoop.x0(25)     = 20;
Graph.FluidLoop.Caps(25)   = 0.05^3*1034*3.5;
% v 26 junction  -- dynamic
Graph.FluidLoop.x_min(26)  = 0;
Graph.FluidLoop.x_max(26)  = 100;
Graph.FluidLoop.x0(26)     = 20;
Graph.FluidLoop.Caps(26)   = 0.05^3*1034*3.5;
% v 27 junction  -- dynamic
Graph.FluidLoop.x_min(27)  = 0;
Graph.FluidLoop.x_max(27)  = 100;
Graph.FluidLoop.x0(27)     = 20;
Graph.FluidLoop.Caps(27)   = 0.05^3*1034*3.5;
% v 28 junction  -- dynamic
Graph.FluidLoop.x_min(28)  = 0;
Graph.FluidLoop.x_max(28)  = 100;
Graph.FluidLoop.x0(28)     = 20;
Graph.FluidLoop.Caps(28)   = 0.05^3*1034*3.5;


% v 29 T battery -- dynamic
Graph.FluidLoop.x_min(29)   = 0;
Graph.FluidLoop.x_max(29)   = 100;
Graph.FluidLoop.x0(29)      = 20;
Graph.FluidLoop.Caps(29)    = HVbatt.CP.mass*HVbatt.CP.Cp;
% v 30 HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(30)  = 0;
Graph.FluidLoop.x_max(30)  = 100;
Graph.FluidLoop.x0(30)     = 20;
Graph.FluidLoop.Caps(30)   = Converters.HVDC.CP.mass*Converters.HVDC.CP.Cp;
% v 31 HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(31)  = 0;
Graph.FluidLoop.x_max(31)  = 100;
Graph.FluidLoop.x0(31)     = 20;
Graph.FluidLoop.Caps(31)   = Converters.HVDC.CP.mass*Converters.HVDC.CP.Cp;
% v 32 HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(32)  = 0;
Graph.FluidLoop.x_max(32)  = 100;
Graph.FluidLoop.x0(32)     = 20;
Graph.FluidLoop.Caps(32)   = Converters.HVDC.CP.mass*Converters.HVDC.CP.Cp;
% v 33 HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(33)  = 0;
Graph.FluidLoop.x_max(33)  = 100;
Graph.FluidLoop.x0(33)     = 20;
Graph.FluidLoop.Caps(33)   = Converters.HVDC.CP.mass*Converters.HVDC.CP.Cp;
% v 34 HVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(34)  = 0;
Graph.FluidLoop.x_max(34)  = 100;
Graph.FluidLoop.x0(34)     = 20;
Graph.FluidLoop.Caps(34)   = Converters.HVDC.CP.mass*Converters.HVDC.CP.Cp;
% v 35 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(35)  = 0;
Graph.FluidLoop.x_max(35)  = 100;
Graph.FluidLoop.x0(35)     = 20;
Graph.FluidLoop.Caps(35)   = Converters.LVDC.CP.mass*Converters.LVDC.CP.Cp;
% v 36 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(36)  = 0;
Graph.FluidLoop.x_max(36)  = 100;
Graph.FluidLoop.x0(36)     = 20;
Graph.FluidLoop.Caps(36)   = Converters.LVDC.CP.mass*Converters.LVDC.CP.Cp;
% v 37 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(37)  = 0;
Graph.FluidLoop.x_max(37)  = 100;
Graph.FluidLoop.x0(37)     = 20;
Graph.FluidLoop.Caps(37)   = Converters.LVDC.CP.mass*Converters.LVDC.CP.Cp;
% v 38 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(38)  = 0;
Graph.FluidLoop.x_max(38)  = 100;
Graph.FluidLoop.x0(38)     = 20;
Graph.FluidLoop.Caps(38)   = Converters.LVDC.CP.mass*Converters.LVDC.CP.Cp;
% v 39 LVDC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(39)  = 0;
Graph.FluidLoop.x_max(39)  = 100;
Graph.FluidLoop.x0(39)     = 20;
Graph.FluidLoop.Caps(39)   = Converters.LVDC.CP.mass*Converters.LVDC.CP.Cp;
% v 40 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(40)  = 0;
Graph.FluidLoop.x_max(40)  = 100;
Graph.FluidLoop.x0(40)     = 20;
Graph.FluidLoop.Caps(40)   = Converters.LVAC.CP.mass*Converters.LVAC.CP.Cp;
% v 41 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(41)  = 0;
Graph.FluidLoop.x_max(41)  = 100;
Graph.FluidLoop.x0(41)     = 20;
Graph.FluidLoop.Caps(41)   = Converters.LVAC.CP.mass*Converters.LVAC.CP.Cp;
% v 42 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(42)  = 0;
Graph.FluidLoop.x_max(42)  = 100;
Graph.FluidLoop.x0(42)     = 20;
Graph.FluidLoop.Caps(42)   = Converters.LVAC.CP.mass*Converters.LVAC.CP.Cp;
% v 43 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(43)  = 0;
Graph.FluidLoop.x_max(43)  = 100;
Graph.FluidLoop.x0(43)     = 20;
Graph.FluidLoop.Caps(43)   = Converters.LVAC.CP.mass*Converters.LVAC.CP.Cp;
% v 44 LVAC Inverter Temp -- dynamic
Graph.FluidLoop.x_min(44)  = 0;
Graph.FluidLoop.x_max(44)  = 100;
Graph.FluidLoop.x0(44)     = 20;
Graph.FluidLoop.Caps(44)   = Converters.LVAC.CP.mass*Converters.LVAC.CP.Cp;
% v 45 T battery -- dynamic
Graph.FluidLoop.x_min(45)  = 0;
Graph.FluidLoop.x_max(45)  = 100;
Graph.FluidLoop.x0(45)     = 20;
Graph.FluidLoop.Caps(45)   = LVbatt.CP.mass*LVbatt.CP.Cp;

% Graph.FluidLoop.Caps = Graph.FluidLoop.Caps * 10;

% °C to K
Graph.FluidLoop.x_min  = Graph.FluidLoop.x_min + 273.15-10; 
Graph.FluidLoop.x_max  = Graph.FluidLoop.x_max + 273.15-20; 
Graph.FluidLoop.x0     = Graph.FluidLoop.x0 + 273.15;

% Graph.FluidLoop.Caps = Graph.FluidLoop.Caps*1000;
%% SECTION 4 -- Edge definitions
  
% P = (c1+u)*(c2*x_from + c3*x_to + c4) 
Graph.FluidLoop.E_coeff         = zeros(Graph.FluidLoop.Ne,4);

indx_fld  = [1 3 4:46 62 63];

% all edges that use Cp of the fluid 
Graph.FluidLoop.E_coeff(indx_fld,2)  = Graph.FluidLoop.Cp_fluid;

% HV Battery wall heat transfer
hA = (pi * HVbatt.CP.ID *  HVbatt.CP.L) * HVbatt.CP.H;
Graph.FluidLoop.E_coeff(44,1) = hA / 1000;  % units: kW/K
Graph.FluidLoop.E_coeff(44,2) =  1;
Graph.FluidLoop.E_coeff(44,3) = -1;

% LV Battery wall heat transfer
hA = (pi * LVbatt.CP.ID *  LVbatt.CP.L) * LVbatt.CP.H;
Graph.FluidLoop.E_coeff(60,1) = hA / 1000;  % units: kW/K
Graph.FluidLoop.E_coeff(60,2) =  1;
Graph.FluidLoop.E_coeff(60,3) = -1;

% HVDC inverter bank wall heat transfer
hA = (pi*Converters.HVDC.CP.ID* Converters.HVDC.CP.L)*Converters.HVDC.CP.H;
Graph.FluidLoop.E_coeff(45:49,1) = hA / 1000;  % units: kW/K
Graph.FluidLoop.E_coeff(45:49,2) =  1;
Graph.FluidLoop.E_coeff(45:49,3) = -1;

% LVDC inverter bank wall heat transfer
hA = (pi*Converters.LVDC.CP.ID* Converters.LVDC.CP.L)*Converters.LVDC.CP.H;
Graph.FluidLoop.E_coeff(50:54,1) = hA / 1000;  % units: kW/K
Graph.FluidLoop.E_coeff(50:54,2) =  1;
Graph.FluidLoop.E_coeff(50:54,3) = -1;

% LVAC inverter bank wall heat transfer
hA = (pi*Converters.LVAC.CP.ID* Converters.LVAC.CP.L)*Converters.LVAC.CP.H;
Graph.FluidLoop.E_coeff(55:59,1) = hA / 1000;  % units: kW/K
Graph.FluidLoop.E_coeff(55:59,2) =  1;
Graph.FluidLoop.E_coeff(55:59,3) = -1;

clear hA indx_fld
% Graph.FluidLoop.P_max           = 5000*ones(Graph.FluidLoop.Ne,1);

% return
Graph.FluidLoop.Caps(Graph.FluidLoop.Caps < 1) = 0; % Make small capacitances zero

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Liquid loop controller definition
CTRL = Graph.FluidLoop;
CTRL.track.Nx = 0;
CTRL.track.NP = 0;
CTRL.track.Nu = 0;
CTRL.hor = 5;
CTRL.NuB = max(CTRL.NuB,1);
CTRL.FluidCp = 3.5;

CTRL.x_reg_set = [29 45];   % batteries and Cold plates

CTRL.uC0 = [Graph.FluidLoop.u_max']/2;
CTRL.uC0 = [.33 .06 .07 .07 .07 .06 .21/15*ones(1,15) .165 .165];
CTRL.uB0 = [ 0 ];

% sdpvar will not accept an input of 0 in the first argument
% if Ntanks, track.Nx, track.NP, track.Nu, Nm equal 0, these lines set 
% them equal to 1
CTRL.track.Nx   = max(1,CTRL.track.Nx);
CTRL.track.NP   = max(1,CTRL.track.NP);
CTRL.track.Nu   = max(1,CTRL.track.Nu);
%% definiing variables for use with YALMIP
yalmip('clear')
% Sources (Pin_) and sinks (xt_) -- including preview across the horizon
Pin_  = sdpvar(repmat(CTRL.Ns+CTRL.Ns_aux, 1, CTRL.hor), ones(1,CTRL.hor));
xt_   = sdpvar(repmat(CTRL.Nt+CTRL.Nt_aux, 1, CTRL.hor), ones(1,CTRL.hor));

% states (x_), power flows (P_), and inputs (u_) across the horizon
% states are represented as delta variables [i.e. delta_x = x_ = x-x(0)]
% inputs are not delta variables [i.e. u_ = delta_u + u(0)]
x_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor+1) ,ones(1,CTRL.hor+1));
P_    = sdpvar(repmat(CTRL.Ne         ,1,CTRL.hor)   ,ones(1,CTRL.hor));
uC_   = sdpvar(repmat(CTRL.NuC        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
uB_   = binvar(repmat(CTRL.NuB        ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% previous inputs
u0_ = sdpvar(repmat(CTRL.NuC+CTRL.NuB ,1,1)          ,ones(1,1));  
x0_ = sdpvar(repmat(CTRL.Nv ,1,1)          ,ones(1,1));  

% slack variable for all states across the horizon
s_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor)   ,ones(1,CTRL.hor));
% slack variable for all inputs across the horizon
s2_    = sdpvar(repmat(4       ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% all state (xall_), tracked states (xtr_), and tracked power flows (Ptr_)
% across the horizon
Nx_total = CTRL.Nv+CTRL.Nt+CTRL.Nt_aux;
xall_ = sdpvar(repmat(Nx_total        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
xtr_  = sdpvar(repmat(CTRL.track.Nx   ,1,CTRL.hor)   ,ones(1,CTRL.hor));
Ptr_  = sdpvar(repmat(CTRL.track.NP   ,1,CTRL.hor)   ,ones(1,CTRL.hor));

objs = 0;       % initializing the objective function at 0
cons = [];      % initializing the contraints as an empty set

%% definiing the objective function and constraints
for k = 1:CTRL.hor    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%% OBJECTIVE FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % minimize - slack on states
    objs = objs + 1e6*norm(s_{k},2)^2;   
    objs = objs + 1e9*norm(s2_{k},2)^2;   
    
    objs = objs + 1e2*norm(x_{k+1}(28)  - (273.15+35),2)^2;  
    % minimize - inputs
    objs = objs + 1e3*norm(uC_{k}-u0_(1:CTRL.NuC),2)^2;    

    % regulate states
    objs = objs + 0.1*norm(x_{k+1}(CTRL.x_reg_set) - (273.15+20),2)^2;    
    objs = objs + 0.05*norm(x_{k+1}([30:44]) - (273.15+60),2)^2;    
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
    % system dynamics
    dyn = find(CTRL.Caps~=0);
    cons = [cons, 1/CTRL.DT*diag(CTRL.Caps(dyn))*(x_{k+1}(dyn)- x_{k}(dyn)) == ...
        (-CTRL.M_upper(dyn,:)*P_{k} + CTRL.D(dyn,:)*Pin_{k})  ];
    if k > 1
        alg = find(CTRL.Caps==0);
        cons = [cons, 0 == (-CTRL.M_upper(alg,:)*P_{k} + CTRL.D(alg,:)*Pin_{k})  ];
    end
        
    % power flows in
    cons = [cons, P_{k}(2) + P_{k}(61) == Pin_{k}(3) ];  

    % algebraic constraints on powers
    cons = [cons, CTRL.W*P_{k} == 0];  
    
    % min/max state constraints with slack
    cons = [cons, CTRL.x_min - s_{k} <= x_{k+1} <= CTRL.x_max + s_{k}];                                           
             
    % keep slack positive
    cons = [cons, 0 <= s_{k}];      % Keep slack non-negative
    
    % min/max constraints on continuous inputs
    cons = [cons, CTRL.u_min <= uC_{k} <= CTRL.u_max];
    
    % squeeze mass flow rates to minimum values when heat load is zero
    cons = [cons, uC_{k}([2 6 7:21]) <= Pin_{k}([4 5 6:20]) + CTRL.u_min([2 6 7:21])];
        
    % concatenating states with sinks
    cons = [cons, xall_{k} == [x_{k};xt_{k}]];
    
    % split and junction constraints
    cons = [cons, uC_{k}(1) + s2_{k}(1) == uC_{k}(2) + uC_{k}(3) + uC_{k}(4) + uC_{k}(5) + uC_{k}(6)];
    cons = [cons, uC_{k}(3) + s2_{k}(2) == uC_{k}(7) + uC_{k}(8) + uC_{k}(9) + uC_{k}(10) + uC_{k}(11)];
    cons = [cons, uC_{k}(4) + s2_{k}(3) == uC_{k}(12) + uC_{k}(13) + uC_{k}(14) + uC_{k}(15) + uC_{k}(16)];
    cons = [cons, uC_{k}(5) + s2_{k}(4) == uC_{k}(17) + uC_{k}(18) + uC_{k}(19) + uC_{k}(20) + uC_{k}(21)];
    
    % dummy variable -- set it equal to zero
    cons = [cons, uB_{k} == 0];
    
    % edges that follow an mdot*Cp*T power flow
    for i_edge = find(any(CTRL.B,2)')
        % this power flow is relinearized at each update
        cons = [cons, P_{k}(i_edge) == u0_(find(CTRL.B(i_edge,:)))*...
            (CTRL.E_coeff(i_edge,2) * (xall_{k}(CTRL.E(i_edge,1)) - x0_(CTRL.E(i_edge,1))))+...
            (uC_{k}(find(CTRL.B(i_edge,:)))*CTRL.E_coeff(i_edge,2)*x0_(CTRL.E(i_edge,1))) ];

        % power flows should be greater than zero
        cons = [cons, 0 <= P_{k}(i_edge)];
    end
    
    % edges that follow an hA*deltaT power flow
    for i_edge = find(~any(CTRL.B,2)'-any(CTRL.W,1)) 
        cons = [cons, P_{k}(i_edge) == (CTRL.E_coeff(i_edge,1)) * ...
                     (CTRL.E_coeff(i_edge,2) * xall_{k}(CTRL.E(i_edge,1)) +...
          	          CTRL.E_coeff(i_edge,3) * xall_{k}(CTRL.E(i_edge,2)))];
    end

end

opts = sdpsettings('solver','gurobi');  % Solve with gurobi
Ctrl.FluidLoop = CTRL;
% Create exported optimization model object
Ctrl.FluidLoop.Controller = optimizer(cons,objs,opts,{x0_,x_{1},xt_{:},Pin_{:},u0_},[x_,uC_,uB_,P_,s_,s2_]); 
