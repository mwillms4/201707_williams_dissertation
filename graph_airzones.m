%% air zones graph
Graph.AirZones.Name = 'AirZones';

Graph.AirZones.DT   = 1;
Graph.AirZones.Cp_fluid = 1.006;
Graph.AirZones.Pin0 = [0.5*300*3.53;0.5*300*3.53;1;1.2;1.2;ones(15,1)];
eta_pump = 0.8;

%% SECTION 2 -- Graph structure
Graph.AirZones.Nv      = 11;             % Number of vertices 
Graph.AirZones.Ne      = 23;             % Number of edges (Power flows)
Graph.AirZones.Ns      = 2 ;             % Number of sources
Graph.AirZones.Ns_aux  = 6;             % Number of auxiliary sources
Graph.AirZones.Nt      = 2 ;             % Number of sinks
Graph.AirZones.Nt_aux  = 2 ;             % Number of auxiliar sinks
Graph.AirZones.NuC     = 8;              % Number of unique continuous inputs
Graph.AirZones.NuB     = 0 ;             % Number of unique binary inputs

% Edge matrix 
Graph.AirZones.E = [1  3        % 1
                    2  4        %
                    3  5        %
                    4  5        %
                    5  6        % 5
                    5  7        %
                    5  8        %
                    5  9        %
                    5  10       %
                    6  11       % 10
                    7  11       %
                    8  11       %
                    9  11       %
                    10 11       %
                    1  12       % 15
                    2  12       %
                    6  13       %
                    7  13       %
                    8  13       %
                    9  13       % 20
                    10 13       %
                    11 14       %
                    11 15];     % 23                 
                     
                     
% INPUT ORDERING:

% constraints on min/max flow rates
Graph.AirZones.u_min    = zeros(Graph.AirZones.NuC,1);
Graph.AirZones.u_max    = 4*ones(Graph.AirZones.NuC,1);
Graph.AirZones.u_max(8) = 50;
Graph.AirZones.u_max(3) = 4;

% initializing the graph B matrix
Graph.AirZones.B        = zeros(Graph.AirZones.Ne,Graph.AirZones.NuC);

Graph.AirZones.B(3,1)   = 1;   % edge 3  -- In flow #1
Graph.AirZones.B(22,1)  = 1;   % edge 22 -- Out flow #1

Graph.AirZones.B(4,2)   = 1;   % edge 4  -- In flow #2
Graph.AirZones.B(23,2)  = 1;   % edge 23 -- Out flow #2

Graph.AirZones.B(5,3)   = 1;   % edge 5  -- Cabin
Graph.AirZones.B(10,3)  = 1;   % edge 10 -- Cabin

Graph.AirZones.B(6,4)   = 1;   % edge 6  -- Cockpit
Graph.AirZones.B(11,4)  = 1;   % edge 11 -- Cockpit

Graph.AirZones.B(7,5)   = 1;   % edge 7  -- Electronics Bay E
Graph.AirZones.B(12,5)  = 1;   % edge 12 -- Electronics Bay E

Graph.AirZones.B(8,6)   = 1;   % edge 8  -- Electronics Bay F
Graph.AirZones.B(13,6)  = 1;   % edge 13 -- Electronics Bay F

Graph.AirZones.B(9,7)   = 1;   % edge 9 -- Cargo
Graph.AirZones.B(14,7)  = 1;   % edge 14 -- Cargo


% Vertices connected to sources, formatted as (vertex# , source#)
Graph.AirZones.D        = zeros(Graph.AirZones.Nv,Graph.AirZones.Ns+Graph.AirZones.Ns_aux);
Graph.AirZones.D(6 ,1)  = 1;          % Cabin heat
Graph.AirZones.D(7 ,2)  = 1;          % Cockpit heat
Graph.AirZones.D(1 ,3)  = 1;          % Power to left blower
Graph.AirZones.D(2 ,4)  = 1;          % Power to right blower
Graph.AirZones.D(3 ,5)  = 1;          % return from Left ACM
Graph.AirZones.D(4 ,6)  = 1;          % return from right ACM
Graph.AirZones.D(8 ,7)  = 1;          % Electronics bay E heat
Graph.AirZones.D(9 ,8)  = 1;          % Electronics bay F heat
Graph.AirZones.D(10,9)  = 1;          % cargo heater


% number of algebraic relationships
No_Alg = 2;

% W capatures the algebraic relationships in graphs
Graph.AirZones.W       = zeros(No_Alg,Graph.AirZones.Ne);
% 
Graph.AirZones.W(1,1)          = -1;
Graph.AirZones.W(1,15)         = (1/eta_pump-1);   % pump inefficiencies 
Graph.AirZones.W(2,2)          = -1;
Graph.AirZones.W(2,16)         = (1/eta_pump-1);   % pump inefficiencies 

% Incidence Matrix
Graph.AirZones.M = zeros(Graph.AirZones.Nv+Graph.AirZones.Nt,Graph.AirZones.Ne);
for i = 1:Graph.AirZones.Ne;
    Graph.AirZones.M(Graph.AirZones.E(i,1),i) = 1;
    Graph.AirZones.M(Graph.AirZones.E(i,2),i) = -1;
end
clear i
Graph.AirZones.M_upper = Graph.AirZones.M(1:Graph.AirZones.Nv,:);
Graph.AirZones.M_lower = Graph.AirZones.M(1+Graph.AirZones.Nv:end,:);
Graph.AirZones.Tail    = (Graph.AirZones.M'== 1);
Graph.AirZones.Head    = (Graph.AirZones.M'==-1);

%% SECTION 3 -- Vertex definitions
% Graph Parameters
% Vertex Capacitances and Initial Temperatures
Graph.AirZones.x0      = zeros(Graph.AirZones.Nv,1);
Graph.AirZones.Caps    = zeros(Graph.AirZones.Nv,1);
Graph.AirZones.x_min   = zeros(Graph.AirZones.Nv,1);
Graph.AirZones.x_max   = zeros(Graph.AirZones.Nv,1);

% v1 junc -- algebraic
Graph.AirZones.x_min(1)   = -inf;
Graph.AirZones.x_max(1)   = inf;
Graph.AirZones.x0(1)      = 20;
Graph.AirZones.Caps(1)    = inf; 
% v2 pump -- algebraic 
Graph.AirZones.x_min(2)   = -inf;
Graph.AirZones.x_max(2)   = inf;
Graph.AirZones.x0(2)      = 20;
Graph.AirZones.Caps(2)    = inf; 
% v3 Pump -- dynamic
Graph.AirZones.x_min(3)   = 0;
Graph.AirZones.x_max(3)   = 100;
Graph.AirZones.x0(3)      = AirZone.Split.init.T;
Graph.AirZones.Caps(3)    = AirZone.Split.L*AirZone.Split.D^2*pi/4;
% v4 pump -- dynamic
Graph.AirZones.x_min(4)   = 0;
Graph.AirZones.x_max(4)   = 100;
Graph.AirZones.x0(4)      = AirZone.Split.init.T;
Graph.AirZones.Caps(4)    = AirZone.Split.L*AirZone.Split.D^2*pi/4;
% v5 T split Temp -- dynamic
Graph.AirZones.x_min(5)   = 0;
Graph.AirZones.x_max(5)   = 100;
Graph.AirZones.x0(5)      = AirZone.Split.init.T;
Graph.AirZones.Caps(5)    = AirZone.Split.L*AirZone.Split.D^2*pi/4;
% v6 T cabin Temp -- dynamic
Graph.AirZones.x_min(6)   = 18;
Graph.AirZones.x_max(6)   = 23.85;
Graph.AirZones.x0(6)      = AirZone.Cabin.init.T;
Graph.AirZones.Caps(6)    = AirZone.Cabin.L*AirZone.Cabin.D^2*pi/4;
% v7 cockpit Temp -- dynamic
Graph.AirZones.x_min(7)   = 18;
Graph.AirZones.x_max(7)   = 23.85;
Graph.AirZones.x0(7)      = AirZone.Cockpit.init.T;
Graph.AirZones.Caps(7)    = AirZone.Cockpit.L*AirZone.Cockpit.D^2*pi/4;
% v8 bay E Temp -- dynamic
Graph.AirZones.x_min(8)   = 0;
Graph.AirZones.x_max(8)   = 35;
Graph.AirZones.x0(8)      = AirZone.ElecBay1.init.T;
Graph.AirZones.Caps(8)    = AirZone.ElecBay1.L*AirZone.ElecBay1.D^2*pi/4;
% v9 bay F Temp -- dynamic
Graph.AirZones.x_min(9)   = 0;
Graph.AirZones.x_max(9)   = 35;
Graph.AirZones.x0(9)      = AirZone.ElecBay2.init.T;
Graph.AirZones.Caps(9)    = AirZone.ElecBay2.L*AirZone.ElecBay2.D^2*pi/4;
% v10 cago bay Temp -- dynamic
Graph.AirZones.x_min(10)  = 2;
Graph.AirZones.x_max(10)  = 30;
Graph.AirZones.x0(10)     = AirZone.CargoBay.init.T;
Graph.AirZones.Caps(10)   = AirZone.CargoBay.L*AirZone.CargoBay.D^2*pi/4;
% v11 junction Temp -- dynamic
Graph.AirZones.x_min(11)  = 0;
Graph.AirZones.x_max(11)  = 100;
Graph.AirZones.x0(11)     = AirZone.Junc.init.T;
Graph.AirZones.Caps(11)   = AirZone.Junc.L*AirZone.Junc.D^2*pi/4;


% °C to K
Graph.AirZones.x_min  = Graph.AirZones.x_min + 273.15; 
Graph.AirZones.x_max  = Graph.AirZones.x_max + 273.15; 
Graph.AirZones.x0     = Graph.AirZones.x0    + 273.15;

%% SECTION 4 -- Edge definitions
  
% P = (c1+u)*(c2*x_from + c3*x_to + c4) 
Graph.AirZones.E_coeff         = zeros(Graph.AirZones.Ne,4);

indx_fld  = [3:14 22 23];

% all edges that use Cp of the fluid 
Graph.AirZones.E_coeff(indx_fld,2)  = Graph.AirZones.Cp_fluid;

% cabin/ambient heat transfer
hA = 2*pi*(AirZone.Cabin.D/2*AirZone.Cabin.L + AirZone.Cabin.D^2/4) * AirZone.Cabin.H_amb;
Graph.AirZones.E_coeff(17,1) = hA / 1000;  % units: kW/K
Graph.AirZones.E_coeff(17,2) =  1;
Graph.AirZones.E_coeff(17,3) = -1;

% cockpit/ambient heat transfer
hA = 2*pi*(AirZone.Cockpit.D/2*AirZone.Cockpit.L + AirZone.Cockpit.D^2/4) * AirZone.Cockpit.H_amb;
Graph.AirZones.E_coeff(18,1) = hA / 1000;  % units: kW/K
Graph.AirZones.E_coeff(18,2) =  1;
Graph.AirZones.E_coeff(18,3) = -1;

% electronics bay E/ambient heat transfer
hA = 2*pi*(AirZone.ElecBay1.D/2*AirZone.ElecBay1.L + AirZone.ElecBay1.D^2/4) * AirZone.ElecBay1.H_amb;
Graph.AirZones.E_coeff(19,1) = hA / 1000;  % units: kW/K
Graph.AirZones.E_coeff(19,2) =  1;
Graph.AirZones.E_coeff(19,3) = -1;

% electronics bay F/ambient heat transfer
hA = 2*pi*(AirZone.ElecBay2.D/2*AirZone.ElecBay2.L + AirZone.ElecBay2.D^2/4) * AirZone.ElecBay2.H_amb;
Graph.AirZones.E_coeff(20,1) = hA / 1000;  % units: kW/K
Graph.AirZones.E_coeff(20,2) =  1;
Graph.AirZones.E_coeff(20,3) = -1;

% cargobay/ambient heat transfer
hA = 2*pi*(AirZone.CargoBay.D/2*AirZone.CargoBay.L + AirZone.CargoBay.D^2/4) * AirZone.CargoBay.H_amb;
Graph.AirZones.E_coeff(21,1) = hA / 1000;  % units: kW/K
Graph.AirZones.E_coeff(21,2) =  1;
Graph.AirZones.E_coeff(21,3) = -1;

clear hA indx_fld

Graph.AirZones.Caps(Graph.AirZones.Caps < 0.5) = 0; % Make small capacitances zero


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Air zone controller definition
CTRL = Graph.AirZones;

CTRL.track.x = [6 7]; % cabin and cockpit
CTRL.track.Nx = 2;
CTRL.track.NP = 0;
CTRL.track.Nu = 0;
CTRL.hor = 5;
CTRL.NuB = max(CTRL.NuB,1);
CTRL.FluidCp = Graph.AirZones.Cp_fluid;

CTRL.uC0 = [.97 .97 1.4 .14 .2 .2 0 5];
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
s2_    = sdpvar(repmat(1       ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% all state (xall_), tracked states (xtr_), and tracked power flows (Ptr_)
% across the horizon
Nx_total = CTRL.Nv+CTRL.Nt+CTRL.Nt_aux;
xall_ = sdpvar(repmat(Nx_total        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
xtr_  = sdpvar(repmat(CTRL.track.Nx   ,1,1)          ,ones(1,1));
Ptr_  = sdpvar(repmat(CTRL.track.NP   ,1,CTRL.hor)   ,ones(1,CTRL.hor));

objs = 0;       % initializing the objective function at 0
cons = [];      % initializing the contraints as an empty set

%% definiing the objective function and constraints
for k = 1:CTRL.hor    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%% OBJECTIVE FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % minimize - slack on states
    objs = objs + 1e6*norm(s_{k},2)^2;   
    objs = objs + 1e11*norm(s2_{k},2)^2;   
    
    % minimize - inputs
    objs = objs + 1e1*norm(uC_{k}(8),2)^2;    
    objs = objs + 1e0*norm(uC_{k}(1:7),2)^2;      
    
    % minimize switching
    if k == 1
        objs = objs + 1e-1*norm(uC_{k}-u0_(1:CTRL.NuC),2)^2;
    else
        objs = objs + 1e-1*norm(uC_{k}-uC_{k-1},2)^2;
    end
        
    % minimize - difference between tracked states and setpoint
    objs = objs + 5e1*norm(x_{k+1}(6:7)-xtr_,2)^2;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
    % system dynamics
    dyn = find(and(CTRL.Caps~=0,CTRL.Caps~=inf));
    cons = [cons, 1/CTRL.DT*diag(CTRL.Caps(dyn))*(x_{k+1}(dyn)- x_{k}(dyn)) == ...
        (-CTRL.M_upper(dyn,:)*P_{k} + CTRL.D(dyn,:)*[Pin_{k}; uC_{k}(CTRL.NuC)])  ];
    
    % fixed system states (i.e. pumps)
    fix = find(CTRL.Caps==inf);
    cons = [cons, x_{k+1}(fix) == x_{k}(fix)];
    
    % algebraic states
    if k > 1
        alg = find(CTRL.Caps==0);
        cons = [cons, 0 == (-CTRL.M_upper(alg,:)*P_{k} + CTRL.D(alg,:)*[Pin_{k}; uC_{k}(CTRL.NuC)])  ];
    end
 
    % mass flow along these edges has been restricted to zero
    cons = [cons, P_{k}([9 14]) == 0];
        
    % power flows in
    cons = [cons, P_{k}(1) + P_{k}(15) == Pin_{k}(3) ];  
    cons = [cons, P_{k}(2) + P_{k}(16) == Pin_{k}(4) ];  
    
    % algebraic constraints on powers
    cons = [cons, CTRL.W*P_{k} == 0];  
    
    % min/max state constraints with slack
    cons = [cons, CTRL.x_min - s_{k} <= x_{k+1} <= CTRL.x_max + s_{k}];
             
    % keep slack positive
    cons = [cons, 0 <= s_{k}];      % Keep slack non-negative
    
    % keep inputs between constraints
    cons = [cons, CTRL.u_min <= uC_{k} <= CTRL.u_max];
    
    % concatenating states with sinks
    cons = [cons, xall_{k} == [x_{k};xt_{k}]];
    
    % split and junction constraints
    cons = [cons, uC_{k}(1) + uC_{k}(2) + s2_{k} == uC_{k}(3) + uC_{k}(4) + uC_{k}(5) + uC_{k}(6) + uC_{k}(7)];
    
    % binary variable is not needed -- it is set to 0 (no impact on speed)
    cons = [cons, uB_{k} == 0];
    
    % re-linearized power flow equation for edges of form: mdot*Cp*T
    for i_edge = find(any(CTRL.B,2)')
        cons = [cons, P_{k}(i_edge) == u0_(find(CTRL.B(i_edge,:)))*...
            (CTRL.E_coeff(i_edge,2) * (xall_{k}(CTRL.E(i_edge,1)) - x0_(CTRL.E(i_edge,1))))+...
            (uC_{k}(find(CTRL.B(i_edge,:)))*CTRL.E_coeff(i_edge,2)*x0_(CTRL.E(i_edge,1))) ];
    end
    
    % edges that follow an hA*deltaT power flow
    for i_edge = find(~any(CTRL.B,2)'-any(CTRL.W,1)) 
        cons = [cons, P_{k}(i_edge) == (CTRL.E_coeff(i_edge,1)) * ...
                     (CTRL.E_coeff(i_edge,2) * xall_{k}(CTRL.E(i_edge,1)) +...
          	          CTRL.E_coeff(i_edge,3) * xall_{k}(CTRL.E(i_edge,2)))];
    end
end

opts = sdpsettings('solver','gurobi');  % Solve with gurobi
Ctrl.AirZones = CTRL;
% Create exported optimization model object
Ctrl.AirZones.Controller = optimizer(cons,objs,opts,{x0_,x_{1},xt_{:},Pin_{:},u0_,xtr_},[x_,uC_,uB_,P_,s_,s2_]); 
