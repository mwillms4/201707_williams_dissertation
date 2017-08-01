%% ELECTRICAL LEFT GRAPH
Graph.ElecRight.Name = 'ElecRight';
Graph.ElecRight.DT   = 1;

eta_gen = GenL.eta;
eta_bat = LVbatt.eff.max_eta;
eta_FAD = FADEC.eff.max_eta;
eta_load = LOAD.eff.max_eta;
eta_inv1 = Converters.LVDC.eff.max_eta;
eta_inv2 = Converters.LVDC.eff.max_eta;
eta_inv3 = Converters.LVDC.eff.max_eta;
eta_inv4 = Converters.LVDC.eff.max_eta;
eta_inv5 = Converters.LVDC.eff.max_eta;

eta_inv6 = Converters.LVAC.eff.max_eta;
eta_inv7 = Converters.LVAC.eff.max_eta;
eta_inv8 = Converters.LVAC.eff.max_eta;
eta_inv9 = Converters.LVAC.eff.max_eta;
eta_inv10 = Converters.LVAC.eff.max_eta;

eta_AEE = AEE.eff.max_eta;


Graph.ElecRight.Pin0 = [1000; 0; 0];

%% SECTION 2 -- Graph structure
Graph.ElecRight.Nv      = 26;             % Number of vertices 
Graph.ElecRight.Ne      = 67;             % Number of edges (Power flows)
Graph.ElecRight.Ns      = 1 ;             % Number of sources
Graph.ElecRight.Ns_aux  = 2 ;             % Number of auxiliary sources
Graph.ElecRight.Nt      = 8 ;             % Number of sinks
Graph.ElecRight.Nt_aux  = 20;             % Number of auxiliary sinks
Graph.ElecRight.NuC     = 2 ;             % Number of unique continuous inputs
Graph.ElecRight.NuB     = 11 ;            % Number of unique binary inputs

% Edge matrix 
Graph.ElecRight.E = [2  3        % 1
                     3  4        % 
                     4  5        % 
                     4  6        % 
                     4  7        % 
                     4  8        % 
                     4  9        % 
                     5  10       % 
                     6  10       % 
                     7  10       % 10
                     8  10       % 
                     9  10       % 
                     10 11       % 
                     11 1        % 
                     1  11       % 
                     3  12       %
                     11 13       %
                     11 24       %
                     13 14       %
                     13 15       % 20
                     3  16       %
                     16 17       %
                     16 18       %
                     16 19       %
                     16 20       %
                     16 21       %
                     17 22       %
                     18 22       %
                     19 22       % 
                     20 22       % 30
                     21 22       % 
                     22 23       % 
                     23 24       % 
                     23 13       % 
                     24 26       % 
                     24 25       % 
                     3  27       % 
                     3  28       % 
                     12 29       % 
                     23 30       % 40
                     14 31       % 
                     15 32       % 
                     25 33       % 
                     26 34       % 
                     2  35       % 
                     12 36       % 
                     3  38       % 
                     3  37       % 
                     5  39       % 
                     6  40       % 50
                     7  41       % 
                     8  42       % 
                     9  43       % 
                     17 44       % 
                     18 45       % 
                     19 46       % 
                     20 47       % 
                     21 48       % 
                     11 49       % 
                     1  49       % 60
                     11 50       % 
                     11 51       % 
                     14 52       % 
                     15 52       % 
                     25 53       % 
                     26 53       % 
                     23 54];     % 67
                     
% INPUT ORDERING:

% constraints on min/max flow rates
Graph.ElecRight.u_min    = zeros(Graph.ElecRight.NuC,1);
Graph.ElecRight.u_max    = 100*ones(Graph.ElecRight.NuC,1);

% initializing the graph B matrix
Graph.ElecRight.B        = zeros(Graph.ElecRight.Ne,Graph.ElecRight.NuC);

Graph.ElecRight.B(14,1)  = 1;   % edge 14 -- battery charge
Graph.ElecRight.B(15,2)  = 1;   % edge 15 -- battery discharge

% Vertices connected to sources, formatted as (vertex# , source#)
% Graph.ElecRight.D        = zeros(Graph.ElecRight.Nv,Graph.ElecRight.Ns);
% Graph.ElecRight.D(2 ,1)  = 1;          % shaft speed to generator (vertex 2)
% Graph.ElecRight.D(4 ,2)  = 1;          % Transfer from HVAC bus
% Graph.ElecRight.D(16,3)  = 1;          % Transfer from HVAC bus

% number of algebraic relationships
No_Alg = 40;

% W capatures the algebraic relationships in graphs
Graph.ElecRight.W       = zeros(No_Alg,Graph.ElecRight.Ne);

Graph.ElecRight.W(1,1)                     =  1;
Graph.ElecRight.W(1,[2 16 21 37 38 47 48]) = -1;   % summation at V(3)
Graph.ElecRight.W(2,3)                     =  1;
Graph.ElecRight.W(2,[8 49])                = -1;   % LVDC INV1 inefficiency
Graph.ElecRight.W(3,4)                     =  1;
Graph.ElecRight.W(3,[9 50])                = -1;   % LVDC INV2 inefficiency
Graph.ElecRight.W(4,5)                     =  1;
Graph.ElecRight.W(4,[10 51])               = -1;   % LVDC INV3 inefficiency
Graph.ElecRight.W(5,6)                     =  1;
Graph.ElecRight.W(5,[11 52])               = -1;   % LVDC INV4 inefficiency
Graph.ElecRight.W(6,7)                     =  1;
Graph.ElecRight.W(6,[12 53])               = -1;   % LVDC INV5 inefficiency
Graph.ElecRight.W(7,13)                    =  1;
Graph.ElecRight.W(7,[8:12])                = -1;   % summation at V(10)
Graph.ElecRight.W(8,[13 15])               =  1;
Graph.ElecRight.W(8,[14 17 18 59 61 62])   = -1;   % summation at V(11)
Graph.ElecRight.W(9,45)                    =  -1;
Graph.ElecRight.W(9,1)                     = (1/eta_gen-1); % gen losses
Graph.ElecRight.W(10,60)                   =  -1;
Graph.ElecRight.W(10,15)                   = (1/eta_bat-1); % batt losses
Graph.ElecRight.W(11,59)                   =  -1;
Graph.ElecRight.W(11,14)                   = (1/eta_bat-1); % batt losses
Graph.ElecRight.W(12,49)                   =  -1;
Graph.ElecRight.W(12,8)                    = (1/eta_inv1-1); % LVDC INV1 
Graph.ElecRight.W(13,50)                   =  -1;
Graph.ElecRight.W(13,9)                    = (1/eta_inv2-1); % LVDC INV2
Graph.ElecRight.W(14,51)                   =  -1;
Graph.ElecRight.W(14,10)                   = (1/eta_inv3-1); % LVDC INV3
Graph.ElecRight.W(15,52)                   =  -1;
Graph.ElecRight.W(15,11)                   = (1/eta_inv4-1); % LVDC INV4
Graph.ElecRight.W(16,53)                   =  -1;
Graph.ElecRight.W(16,12)                   = (1/eta_inv5-1); % LVDC INV5
Graph.ElecRight.W(17,22)                   =  1;
Graph.ElecRight.W(17,[27 54])              = -1;   % LVAC INV1 inefficiency
Graph.ElecRight.W(18,23)                   =  1;
Graph.ElecRight.W(18,[28 55])              = -1;   % LVAC INV2 inefficiency
Graph.ElecRight.W(19,24)                   =  1;
Graph.ElecRight.W(19,[29 56])              = -1;   % LVAC INV3 inefficiency
Graph.ElecRight.W(20,25)                   =  1;
Graph.ElecRight.W(20,[30 57])              = -1;   % LVAC INV4 inefficiency
Graph.ElecRight.W(21,26)                   =  1;
Graph.ElecRight.W(21,[31 58])              = -1;   % LVAC INV5 inefficiency
Graph.ElecRight.W(22,32)                   =  1;   % summation at V(22)
Graph.ElecRight.W(22,[27:31])              = -1;
Graph.ElecRight.W(23,32)                   =  1;   % summation at V(23)
Graph.ElecRight.W(23,[33 34 40 67])        = -1;
Graph.ElecRight.W(24,16)                   =  1;   % summation at V(12)
Graph.ElecRight.W(24,[39 46])              = -1;
Graph.ElecRight.W(25,[17 34])              =  1;   % summation at V(13)
Graph.ElecRight.W(25,[19 20])              = -1;
Graph.ElecRight.W(26,19)                   =  1;   % summation at V(14)
Graph.ElecRight.W(26,[41 63])              = -1;
Graph.ElecRight.W(27,20)                   =  1;   % summation at V(15)
Graph.ElecRight.W(27,[42 64])              = -1;
Graph.ElecRight.W(28,[33 18])              =  1;   % summation at V(24)
Graph.ElecRight.W(28,[35 36])              = -1;
Graph.ElecRight.W(29,36)                   =  1;   % summation at V(25)
Graph.ElecRight.W(29,[43 65])              = -1;
Graph.ElecRight.W(30,35)                   =  1;   % summation at V(26)
Graph.ElecRight.W(30,[ 44 66])             = -1;
Graph.ElecRight.W(31,54)                   = -1;
Graph.ElecRight.W(31,27)                   = (1/eta_inv6-1); % LVAC INV1
Graph.ElecRight.W(32,55)                   =  -1;
Graph.ElecRight.W(32,28)                   = (1/eta_inv7-1); % LVAC INV2
Graph.ElecRight.W(33,56)                   =  -1;
Graph.ElecRight.W(33,29)                   = (1/eta_inv8-1); % LVAC INV3
Graph.ElecRight.W(34,57)                   =  -1;
Graph.ElecRight.W(34,30)                   = (1/eta_inv9-1); % LVAC INV4
Graph.ElecRight.W(35,58)                   =  -1;
Graph.ElecRight.W(35,31)                   = (1/eta_inv10-1);% LVAC INV5
Graph.ElecRight.W(36,46)                   =  -1;
Graph.ElecRight.W(36,39)                   = (1/eta_AEE-1);  % AEE losses
Graph.ElecRight.W(37,63)                   =  -1;
Graph.ElecRight.W(37,41)                   = (1/eta_load-1); % gen losses
Graph.ElecRight.W(38,64)                   =  -1;
Graph.ElecRight.W(38,42)                   = (1/eta_load-1); % gen losses
Graph.ElecRight.W(39,65)                   =  -1;
Graph.ElecRight.W(39,43)                   = (1/eta_load-1); % gen losses
Graph.ElecRight.W(40,66)                   =  -1;
Graph.ElecRight.W(40,44)                   = (1/eta_load-1); % gen losses

% Incidence Matrix
Graph.ElecRight.M = zeros(Graph.ElecRight.Nv+Graph.ElecRight.Nt,Graph.ElecRight.Ne);
for i = 1:Graph.ElecRight.Ne;
    Graph.ElecRight.M(Graph.ElecRight.E(i,1),i) = 1;
    Graph.ElecRight.M(Graph.ElecRight.E(i,2),i) = -1;
end
clear i
Graph.ElecRight.M_upper = Graph.ElecRight.M(1:Graph.ElecRight.Nv,:);
Graph.ElecRight.M_lower = Graph.ElecRight.M(1+Graph.ElecRight.Nv:end,:);
Graph.ElecRight.Tail    = (Graph.ElecRight.M'== 1);
Graph.ElecRight.Head    = (Graph.ElecRight.M'==-1);

%% SECTION 3 -- Vertex definitions
% Graph Parameters
% Vertex Capacitances and Initial Temperatures
Graph.ElecRight.x0      = zeros(Graph.ElecRight.Nv,1);
Graph.ElecRight.Caps    = zeros(Graph.ElecRight.Nv,1);
Graph.ElecRight.x_min   = zeros(Graph.ElecRight.Nv,1);
Graph.ElecRight.x_max   = zeros(Graph.ElecRight.Nv,1);

% v1 Battery -- dynamic
Graph.ElecRight.x_min(1)    = 0.05;
Graph.ElecRight.x_max(1)    = 0.95;
Graph.ElecRight.x0(1)       = 0.5;
Graph.ElecRight.Caps(1)     = LVbatt.Cap*1e3; % [MJ * 1000]
% v2 Generator -- Algebraic
Graph.ElecRight.x_min(2)    = 230;
Graph.ElecRight.x_max(2)    = 230;
Graph.ElecRight.x0(2)       = 230;
Graph.ElecRight.Caps(2)     = inf;
% v3 HVAC Buss -- Algebraic
Graph.ElecRight.x_min(3)    = 230;
Graph.ElecRight.x_max(3)    = 230;
Graph.ElecRight.x0(3)       = 230;
Graph.ElecRight.Caps(3)     = inf;
% v4 LVDC Inverter Bus 1 -- Algebraic
Graph.ElecRight.x_min(4)    = 230;
Graph.ElecRight.x_max(4)    = 230;
Graph.ElecRight.x0(4)       = 230;
Graph.ElecRight.Caps(4)     = inf;
% v5 Inverter 1 -- Algebraic
Graph.ElecRight.x_min(5)    = 28;
Graph.ElecRight.x_max(5)    = 28;
Graph.ElecRight.x0(5)       = 28;
Graph.ElecRight.Caps(5)     = inf;
% v6 Inverter 2 -- Algebraic
Graph.ElecRight.x_min(6)    = 28;
Graph.ElecRight.x_max(6)    = 28;
Graph.ElecRight.x0(6)       = 28;
Graph.ElecRight.Caps(6)     = inf;
% v7 Inverter 3 -- Algebraic
Graph.ElecRight.x_min(7)    = 28;
Graph.ElecRight.x_max(7)    = 28;
Graph.ElecRight.x0(7)       = 28;
Graph.ElecRight.Caps(7)     = inf;
% v8 Inverter 4 -- Algebraic
Graph.ElecRight.x_min(8)    = 28;
Graph.ElecRight.x_max(8)    = 28;
Graph.ElecRight.x0(8)       = 28;
Graph.ElecRight.Caps(8)     = inf;
% v9 Inverter 5 -- Algebraic
Graph.ElecRight.x_min(9)    = 28;
Graph.ElecRight.x_max(9)    = 28;
Graph.ElecRight.x0(9)       = 28;
Graph.ElecRight.Caps(9)     = inf;
% v10 LVDC Inverter Bus 2 -- Algebraic
Graph.ElecRight.x_min(10)   = 28;
Graph.ElecRight.x_max(10)   = 28;
Graph.ElecRight.x0(10)      = 28;
Graph.ElecRight.Caps(10)    = inf;
% v11 LVDC Bus -- Algebraic
Graph.ElecRight.x_min(11)   = 28;
Graph.ElecRight.x_max(11)   = 28;
Graph.ElecRight.x0(11)      = 28;
Graph.ElecRight.Caps(11)    = inf;
% v 12 AEE -- Algebraic
Graph.ElecRight.x_min(12)   = 230;
Graph.ElecRight.x_max(12)   = 230;
Graph.ElecRight.x0(12)      = 230;
Graph.ElecRight.Caps(12)    = inf;
% v 13 LVDC RDPU -- Algebraic
Graph.ElecRight.x_min(13)   = 28;
Graph.ElecRight.x_max(13)   = 28;
Graph.ElecRight.x0(13)      = 28;
Graph.ElecRight.Caps(13)    = inf;
% v 14 LVDC RDPU Sheddable -- Algebraic
Graph.ElecRight.x_min(14)   = 28;
Graph.ElecRight.x_max(14)   = 28;
Graph.ElecRight.x0(14)      = 28;
Graph.ElecRight.Caps(14)    = inf;
% v 15 LVDC RDPU Non sheddable -- Algebraic
Graph.ElecRight.x_min(15)   = 28;
Graph.ElecRight.x_max(15)   = 28;
Graph.ElecRight.x0(15)      = 28;
Graph.ElecRight.Caps(15)    = inf;
% v 16 LVAC Inverter Bus 1 -- Algebraic
Graph.ElecRight.x_min(16)   = 230;
Graph.ElecRight.x_max(16)   = 230;
Graph.ElecRight.x0(16)      = 230;
Graph.ElecRight.Caps(16)    = inf;
% v 17 LVAC Inverter 1 -- Algebraic
Graph.ElecRight.x_min(17)   = 115;
Graph.ElecRight.x_max(17)   = 115;
Graph.ElecRight.x0(17)      = 115;
Graph.ElecRight.Caps(17)    = inf;
% v 18 LVAC Inverter 2 -- Algebraic
Graph.ElecRight.x_min(18)   = 115;
Graph.ElecRight.x_max(18)   = 115;
Graph.ElecRight.x0(18)      = 115;
Graph.ElecRight.Caps(18)    = inf;
% v 19 LVAC Inverter 3 -- Algebraic
Graph.ElecRight.x_min(19)   = 115;
Graph.ElecRight.x_max(19)   = 115;
Graph.ElecRight.x0(19)      = 115;
Graph.ElecRight.Caps(19)    = inf;
% v 20 LVAC Inverter 4 -- Algebraic
Graph.ElecRight.x_min(20)   = 115;
Graph.ElecRight.x_max(20)   = 115;
Graph.ElecRight.x0(20)      = 115;
Graph.ElecRight.Caps(20)    = inf;
% v 21 LVAC Inverter 5 -- Algebraic
Graph.ElecRight.x_min(21)   = 115;
Graph.ElecRight.x_max(21)   = 115;
Graph.ElecRight.x0(21)      = 115;
Graph.ElecRight.Caps(21)    = inf;
% v 22 LVAC LVDC Inverter Bus 2 -- Algebraic
Graph.ElecRight.x_min(22)   = 115;
Graph.ElecRight.x_max(22)   = 115;
Graph.ElecRight.x0(22)      = 115;
Graph.ElecRight.Caps(22)    = inf;
% v 23 LVAC Bus  -- Algebraic
Graph.ElecRight.x_min(23)   = 115;
Graph.ElecRight.x_max(23)   = 115;
Graph.ElecRight.x0(23)      = 115;
Graph.ElecRight.Caps(23)    = inf;
% v 24 LVAC RDPU  -- Algebraic
Graph.ElecRight.x_min(24)   = 115;
Graph.ElecRight.x_max(24)   = 115;
Graph.ElecRight.x0(24)      = 115;
Graph.ElecRight.Caps(24)    = inf;
% v 25 LVAC RDPU Non sheddable -- Algebraic
Graph.ElecRight.x_min(25)   = 115;
Graph.ElecRight.x_max(25)   = 115;
Graph.ElecRight.x0(25)      = 115;
Graph.ElecRight.Caps(25)    = inf;
% v 26 LVAC RDPU Sheddable  -- Algebraic
Graph.ElecRight.x_min(26)   = 115;
Graph.ElecRight.x_max(26)   = 115;
Graph.ElecRight.x0(26)      = 115;
Graph.ElecRight.Caps(26)    = inf;

%% SECTION 4 -- Edge definitions
  
% P = (c1+u)*(c2*x_in + c3*x_out) 
% Graph.ElecRight.E_coeff         = zeros(Graph.ElecRight.Ne,4);

Graph.ElecRight.P_max           = 1000*ones(Graph.ElecRight.Ne,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Left Electrical System Controller Definition
CTRL = Graph.ElecRight;
CTRL.track.Nx = 0;
CTRL.track.NP = 0;
CTRL.track.Nu = 0;
CTRL.hor = 5;

% Initial conditions
% battery charge and discharge rates
CTRL.uC0 = [ 50 0];
% LVDC inverters 1-5; LVDC battery charge; LVAC interverts 1-5
CTRL.uB0 = [ 1 1 0 0 0, 1, 1 1 1 0 0 ];

% sdpvar will not accept an input of 0 in the first argument
% if Ntanks, track.Nx, track.NP, track.Nu, Nm equal 0, these lines set 
% them equal to 1
CTRL.track.Nx   = max(1,CTRL.track.Nx);
CTRL.track.NP   = max(1,CTRL.track.NP);
CTRL.track.Nu   = max(1,CTRL.track.Nu);
%% definiing variables for use with YALMIP
% Sources (Pin_) and sinks (xt_) -- including preview across the horizon
Pin_  = sdpvar(repmat(CTRL.Ns + CTRL.Ns_aux, 1, CTRL.hor), ones(1,CTRL.hor));
xt_   = sdpvar(repmat(CTRL.Nt + CTRL.Nt_aux, 1, CTRL.hor), ones(1,CTRL.hor));

% states (x_), power flows (P_), and inputs (u_) across the horizon
% states are represented as delta variables [i.e. delta_x = x_ = x-x(0)]
% inputs are not delta variables [i.e. u_ = delta_u + u(0)]
x_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor+1) ,ones(1,CTRL.hor+1));
P_    = sdpvar(repmat(CTRL.Ne         ,1,CTRL.hor)   ,ones(1,CTRL.hor));
uC_   = sdpvar(repmat(CTRL.NuC        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
uB_   = binvar(repmat(CTRL.NuB        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
 
% shed allocation variable
shed = sdpvar(1        ,ones(1,1));  

% previous inputs and states
u0_ = sdpvar(repmat(CTRL.NuC+CTRL.NuB ,1,1)          ,ones(1,1));  
x0_ = sdpvar(repmat(CTRL.Nv ,1,1)                    ,ones(1,1));  

% slack variable for all states across the horizon
s_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% all state (xall_), tracked states (xtr_), and tracked power flows (Ptr_)
% across the horizon
Nx_total = CTRL.Nv+CTRL.Nt+CTRL.Nt_aux;
xall_ = sdpvar(repmat(Nx_total        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
xtr_  = sdpvar(repmat(CTRL.track.Nx   ,1,CTRL.hor)   ,ones(1,CTRL.hor));
Ptr_  = sdpvar(repmat(CTRL.track.NP   ,1,CTRL.hor)   ,ones(1,CTRL.hor));

objs = 0;       % initializing the objective function at 0
cons = [];      % initializing the contraints as an empty set

%% definiing the objective function and constraints

V1 = 28; % 28V bus
I1 = Converters.LVDC.eff.maxI;
V2 = 115; % 115V bus
I2 = Converters.LVAC.eff.maxI;

% minimize inverter switching -- 1 to 5 and 7 to 11 are inverter on/off
for i = [1:5 7:11]
    %  change in input [u(k-1)-u(k)]^2
    objs = objs + 1e1*norm(u0_(i+2) - uB_{1}(i),1);   
end
for k = 2:CTRL.hor
    for i = [1:5 7:11]
        % change in input [u(k-1)-u(k)]^2
        objs = objs + 1e1*norm(uB_{k-1}(i) - uB_{k}(i),1);
    end
end    
% switching of booleans has to occur on the first step if at all
for k = 1:CTRL.hor-1
    cons = [cons, uB_{k}(6) == uB_{k+1}(6)];
    cons = [cons, uB_{k}(1:5) == uB_{k+1}(1:5)];
    cons = [cons, uB_{k}(7:11) == uB_{k+1}(7:11)];
    cons = [cons, uC_{k}(1:2) == uC_{k+1}(1:2)];
end
for k = 1:CTRL.hor    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%% OBJECTIVE FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % minimize - slack on states
    objs = objs + 1e12*norm(s_{k},2)^2;   
  
    % minimize the sheddable loads along edges 37, 41, 34, 40, 29 
    objs = objs  + 1e1*norm(P_{k}(37) - xt_{k}(1),2)^2;     % HVAC misc
    objs = objs  + 1e3*norm(P_{k}(39) - xt_{k}(3),2)^2;     % AEE
    objs = objs  + 1e1*norm(P_{k}(41) - xt_{k}(5),2)^2;     % LVDC RPDU
    objs = objs  + 1e1*norm(P_{k}(44) - xt_{k}(8),2)^2;     % LVAC RPDU
    
    % minimize to the shed authority
    objs = objs  + 2e1*norm(sum(P_{k}([37 39 41 44])) - shed*sum(xt_{k}([1 3 5 8])),2)^2;     % LVAC RPDU
    
    % power delivered to loads cannot be greater than the load
    cons = [cons, P_{k}([37 39 41 44]) <= xt_{k}([1 3 5 8])];
                            
    % push converters towards their power of max efficiency
    % I_ is binary -- 0 implies inverter is off, 1 implied inverter is on
    % P_/(V0*I0) == 1 if the inverter is operating at peak efficiency
    objs = objs + 1e4*norm((P_{k}(8:12)*1000)/(V1*I1)  - uB_{k}(1:5),2)^2;
    objs = objs + 1e4*norm((P_{k}(27:31)*1000)/(V2*I2) - uB_{k}(7:11),2)^2;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
    % system dynamics -- only the battery has a dynamic state
    cons = [cons, x_{k+1}(1) == CTRL.DT*(-diag(1./CTRL.Caps(1))*CTRL.M_upper(1,:)*P_{k}) + x_{k}(1) ];
    
    % battery charge and discharge decision variables
    cons = [cons, P_{k}(14) == uC_{k}(1)];   % charge rate along edge 14
    cons = [cons, P_{k}(15) == uC_{k}(2)];   % discharge rate along edge 15
    
    cons = [cons, P_{k}(18) == 0];
    cons = [cons, P_{k}(34) == 0];
        
    % uB_{k}(6) == 1 implies charge mode; uB_{k}(6) == 0 implies discharge
    cons = [cons, implies(uB_{k}(6)  , uC_{k}(2) <= 0)];
    cons = [cons, implies(~uB_{k}(6) , uC_{k}(1) <= 0)];
    
    % ~uB_{k}(#) == 1 implies that the inverter is off, and power is 0
    cons = [cons, implies(~uB_{k}(1)  , P_{k}(3)  <= 0)];
    cons = [cons, implies(~uB_{k}(2)  , P_{k}(4)  <= 0)];
    cons = [cons, implies(~uB_{k}(3)  , P_{k}(5)  <= 0)];
    cons = [cons, implies(~uB_{k}(4)  , P_{k}(6)  <= 0)];
    cons = [cons, implies(~uB_{k}(5)  , P_{k}(7)  <= 0)];
    cons = [cons, implies(~uB_{k}(7)  , P_{k}(22) <= 0)];
    cons = [cons, implies(~uB_{k}(8)  , P_{k}(23) <= 0)];
    cons = [cons, implies(~uB_{k}(9)  , P_{k}(24) <= 0)];
    cons = [cons, implies(~uB_{k}(10) , P_{k}(25) <= 0)];
    cons = [cons, implies(~uB_{k}(11) , P_{k}(26) <= 0)];
    
    % at least 1 inverter has to remain on
    cons = [cons, uB_{k}(1) == 1];
    cons = [cons, uB_{k}(7) == 1];
       
    % maximum charge and discharge rates
    cons = [cons, CTRL.u_min <= uC_{k} <= CTRL.u_max ];   
    
    % power cannot be greater than what is supplied 
    % generator supply is edge 1 and 45
    cons = [cons, P_{k}(1) + P_{k}(45) <= Pin_{k}(1) ];  
                 
    % x-fer bus supply from Pin(2)
    % first constraint limits P3-P7 to be under input power if it is >0
    % second constraint sets P2=0 since both generators cant pwr the bus
    % third constraint sets P2 = P3 thought P7 if no input power
    cons = [cons, implies(Pin_{k}(2) >= 1, P_{k}(3)+P_{k}(4)+P_{k}(5)+P_{k}(6)+P_{k}(7) <= Pin_{k}(2))];
    cons = [cons, implies(Pin_{k}(2) >= 1, P_{k}(2) == 0)];
    cons = [cons, implies(Pin_{k}(2) <= 1, P_{k}(3)+P_{k}(4)+P_{k}(5)+P_{k}(6)+P_{k}(7) == P_{k}(2))];

    % x-fer bus supply from Pin(3)
    % first constraint limits P22-P26 to be under input power if it is >0
    % second constraint sets P21=0 since both generators cant pwr the bus
    % third constraint sets P21 = P22 thought P26 if no input power
    cons = [cons, implies(Pin_{k}(3) >= 1, P_{k}(22)+P_{k}(23)+P_{k}(24)+P_{k}(25)+P_{k}(26) <= Pin_{k}(3))];
    cons = [cons, implies(Pin_{k}(3) >= 1, P_{k}(21) == 0)];
    cons = [cons, implies(Pin_{k}(3) <= 1, P_{k}(22)+P_{k}(23)+P_{k}(24)+P_{k}(25)+P_{k}(26) == P_{k}(21))];

    % input power is not greater than 1000kW
    cons = [cons, 0 <= Pin_{k} <= 1000];
    
    % algebraic constraints on powers
    cons = [cons, CTRL.W*P_{k} == 0];  
    
    % powers must be greater than 0 and less than max
    cons = [cons, 0 <= P_{k} <= CTRL.P_max];
    
    %27 29 31 34 37 39 41 44
    % power along edges 38, 42, 43, 47, 48, 61, 62, 67 equal the sink state
    cons = [cons, P_{k}([38 40 42 43 47 48 62 67 ]) == ...
                                xt_{k}([28 30 32 33 38 37 51 54 ]-CTRL.Nv)];
    cons = [cons, P_{k}(61) == xt_{k}(50-CTRL.Nv)/eta_FAD];
       
    % min/max state constraints with slack
    cons = [cons, CTRL.x_min - s_{k} <= x_{k+1} <= CTRL.x_max + s_{k}];                                           
             
    % keep slack positive
    cons = [cons, 0 <= s_{k}];      % Keep slack non-negative
    
end

opts = sdpsettings('solver','gurobi');  % Solve with gurobi
Ctrl.ElecRight = CTRL;
% Create exported optimization model object
Ctrl.ElecRight.Controller = optimizer(cons,objs,opts,{x0_,x_{1},xt_{:},Pin_{:},u0_,shed},[x_,uC_,uB_,P_,s_]); 

