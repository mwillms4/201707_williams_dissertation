%% ELECTRICAL LEFT GRAPH
Graph.ElecLeft.Name = 'ElecLeft';
Graph.ElecLeft.DT   = 1;

% efficiency definitions
eta_gen = GenL.eta;
eta_bat = HVbatt.eff.max_eta;
eta_inv1 = Converters.HVDC.eff.max_eta;
eta_inv2 = Converters.HVDC.eff.max_eta;
eta_inv3 = Converters.HVDC.eff.max_eta;
eta_inv4 = Converters.HVDC.eff.max_eta;
eta_inv5 = Converters.HVDC.eff.max_eta;

Graph.ElecLeft.Pin0 = [1000; 0];

%% SECTION 2 -- Graph structure
Graph.ElecLeft.Nv       = 11;             % Number of vertices 
Graph.ElecLeft.Ne       = 34;             % Number of edges (Power flows)
Graph.ElecLeft.Ns       = 1 ;             % Number of sources
Graph.ElecLeft.Ns_aux   = 1 ;             % Number of auxiliary sources
Graph.ElecLeft.Nt       = 4 ;             % Number of sinks
Graph.ElecLeft.Nt_aux   = 14;             % Number of auxiliary sinks
Graph.ElecLeft.NuC      = 2 ;             % Number of unique continuous inputs
Graph.ElecLeft.NuB      = 6 ;             % Number of unique binary inputs


% Edge matrix 
Graph.ElecLeft.E = [2  3        % 
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
                    3  13       % 
                    11 14       % 
                    11 15       % 
                    2  16       % 20
                    3  17       % 
                    3  18       % 
                    3  19       % 
                    3  20       % 
                    5  21       % 
                    6  22       % 
                    7  23       % 
                    8  24       % 
                    9  25       % 
                    11 26       % 30
                    11 27       % 
                    11 28       % 
                    11 29       %  
                    1  29];     % 34
 
% INPUT ORDERING:

% constraints on min/max flow rates
Graph.ElecLeft.u_min    = zeros(Graph.ElecLeft.NuC,1);
Graph.ElecLeft.u_max    = 100*ones(Graph.ElecLeft.NuC,1);

% initializing the graph B matrix
Graph.ElecLeft.B        = zeros(Graph.ElecLeft.Ne,Graph.ElecLeft.NuC);
Graph.ElecLeft.B(14,1)  = 1;   % edge 14 -- battery charge
Graph.ElecLeft.B(15,2)  = 1;   % edge 15 -- battery discharge

% number of algebraic relationships
No_Alg = 16;

% W capatures the algebraic relationships in graphs
Graph.ElecLeft.W       = zeros(No_Alg,Graph.ElecLeft.Ne);
Graph.ElecLeft.W(1,1)                  =  1;
Graph.ElecLeft.W(1,[2 16 17 21:24])    = -1;   % edge 2,16,17,21-24 = 1
Graph.ElecLeft.W(2,3)                  =  1;
Graph.ElecLeft.W(2,[8 25])             = -1;   % edge 8 & 25 = 3
Graph.ElecLeft.W(3,4)                  =  1;
Graph.ElecLeft.W(3,[9 26])             = -1;   % edge 9 & 26 = 4
Graph.ElecLeft.W(4,5)                  =  1;
Graph.ElecLeft.W(4,[10 27])            = -1;   % edge 10 & 27 = 5
Graph.ElecLeft.W(5,6)                  =  1;
Graph.ElecLeft.W(5,[11 28])            = -1;   % edge 11 & 28 = 6
Graph.ElecLeft.W(6,7)                  =  1;
Graph.ElecLeft.W(6,[12 29])            = -1;   % edge 12 & 29 = 7
Graph.ElecLeft.W(7,13)                 =  1;
Graph.ElecLeft.W(7,[8:12])             = -1;   % edge 8-12 = 13
Graph.ElecLeft.W(8,[13 15])            =  1;
Graph.ElecLeft.W(8,[14 18:19 30:33])   = -1;   % edge 14,18,19,30-33=13+15
Graph.ElecLeft.W(9,20)                =  -1;
Graph.ElecLeft.W(9,1)                 = (1/eta_gen-1); % eta*20=(1-eta)*1
Graph.ElecLeft.W(10,34)                =  -1;
Graph.ElecLeft.W(10,15)                = (1/eta_bat-1); %eta*34=(1-eta)*15
Graph.ElecLeft.W(11,33)                =  -1;
Graph.ElecLeft.W(11,14)                = (1/eta_bat-1); %eta*33=(1-eta)*14
Graph.ElecLeft.W(12,25)                =  -1;
Graph.ElecLeft.W(12,8)                 = (1/eta_inv1-1); %eta*25=(1-eta)*8
Graph.ElecLeft.W(13,26)                =  -1;
Graph.ElecLeft.W(13,9)                 = (1/eta_inv2-1); %eta*26=(1-eta)*9
Graph.ElecLeft.W(14,27)                =  -1;
Graph.ElecLeft.W(14,10)                = (1/eta_inv3-1); %eta*27=(1-eta)*10
Graph.ElecLeft.W(15,28)                =  -1;
Graph.ElecLeft.W(15,11)                = (1/eta_inv4-1); %eta*28=(1-eta)*11
Graph.ElecLeft.W(16,29)                =  -1;
Graph.ElecLeft.W(16,12)                = (1/eta_inv5-1); %eta*29=(1-eta)*12

% Incidence Matrix
Graph.ElecLeft.M = zeros(Graph.ElecLeft.Nv+Graph.ElecLeft.Nt,Graph.ElecLeft.Ne);
for i = 1:Graph.ElecLeft.Ne;
    Graph.ElecLeft.M(Graph.ElecLeft.E(i,1),i) = 1;
    Graph.ElecLeft.M(Graph.ElecLeft.E(i,2),i) = -1;
end
clear i
Graph.ElecLeft.M_upper = Graph.ElecLeft.M(1:Graph.ElecLeft.Nv,:);
Graph.ElecLeft.M_lower = Graph.ElecLeft.M(1+Graph.ElecLeft.Nv:end,:);
Graph.ElecLeft.Tail    = (Graph.ElecLeft.M'== 1);
Graph.ElecLeft.Head    = (Graph.ElecLeft.M'==-1);

%% SECTION 3 -- Vertex definitions
% Graph Parameters
% Vertex Capacitances and Initial Temperatures
Graph.ElecLeft.x0      = zeros(Graph.ElecLeft.Nv,1);
Graph.ElecLeft.Caps    = zeros(Graph.ElecLeft.Nv,1);
Graph.ElecLeft.x_min   = zeros(Graph.ElecLeft.Nv,1);
Graph.ElecLeft.x_max   = zeros(Graph.ElecLeft.Nv,1);

% v1 Battery -- dynamic
Graph.ElecLeft.x_min(1)    = 0;
Graph.ElecLeft.x_max(1)    = 1;
Graph.ElecLeft.x0(1)       = 0.5;
Graph.ElecLeft.Caps(1)     = HVbatt.Cap*1e3;
% v2 Generator -- Algebraic
Graph.ElecLeft.x_min(2)    = 230;
Graph.ElecLeft.x_max(2)    = 230;
Graph.ElecLeft.x0(2)       = 230;
Graph.ElecLeft.Caps(2)     = inf;
% v3 HVAC Buss -- Algebraic
Graph.ElecLeft.x_min(3)    = 230;
Graph.ElecLeft.x_max(3)    = 230;
Graph.ElecLeft.x0(3)       = 230;
Graph.ElecLeft.Caps(3)     = inf;
% v4 Inverter Bus 1 -- Algebraic
Graph.ElecLeft.x_min(4)    = 230;
Graph.ElecLeft.x_max(4)    = 230;
Graph.ElecLeft.x0(4)       = 230;
Graph.ElecLeft.Caps(4)     = inf;
% v5 Inverter 1 -- Algebraic
Graph.ElecLeft.x_min(5)    = 270;
Graph.ElecLeft.x_max(5)    = 270;
Graph.ElecLeft.x0(5)       = 270;
Graph.ElecLeft.Caps(5)     = inf;
% v6 Inverter 2 -- Algebraic
Graph.ElecLeft.x_min(6)    = 270;
Graph.ElecLeft.x_max(6)    = 270;
Graph.ElecLeft.x0(6)       = 270;
Graph.ElecLeft.Caps(6)     = inf;
% v7 Inverter 3 -- Algebraic
Graph.ElecLeft.x_min(7)    = 270;
Graph.ElecLeft.x_max(7)    = 270;
Graph.ElecLeft.x0(7)       = 270;
Graph.ElecLeft.Caps(7)     = inf;
% v8 Inverter 4 -- Algebraic
Graph.ElecLeft.x_min(8)    = 270;
Graph.ElecLeft.x_max(8)    = 270;
Graph.ElecLeft.x0(8)       = 270;
Graph.ElecLeft.Caps(8)     = inf;
% v9 Inverter 5 -- Algebraic
Graph.ElecLeft.x_min(9)    = 270;
Graph.ElecLeft.x_max(9)    = 270;
Graph.ElecLeft.x0(9)       = 270;
Graph.ElecLeft.Caps(9)     = inf;
% v10 Inverter Bus 2 -- Algebraic
Graph.ElecLeft.x_min(10)   = 270;
Graph.ElecLeft.x_max(10)   = 270;
Graph.ElecLeft.x0(10)      = 270;
Graph.ElecLeft.Caps(10)    = inf;
% v11 HVDC Bus -- Algebraic
Graph.ElecLeft.x_min(11)   = 270;
Graph.ElecLeft.x_max(11)   = 270;
Graph.ElecLeft.x0(11)      = 270;
Graph.ElecLeft.Caps(11)    = inf;

%% SECTION 4 -- Edge definitions
  
% P = (c1+u)*(c2*x_in + c3*x_out) 
Graph.ElecLeft.P_max           = 1000*ones(Graph.ElecLeft.Ne,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Left Electrical System Controller
CTRL = Graph.ElecLeft;
CTRL.track.Nx = 0;
CTRL.track.NP = 0;
CTRL.track.Nu = 0;
CTRL.hor = 5;

CTRL.uC0 = [ 50 0];
CTRL.uB0 = [ 1 1 1 0 0 1];

% sdpvar will not accept an input of 0 in the first argument
% if Ntanks, track.Nx, track.NP, track.Nu, Nm equal 0, these lines set 
% them equal to 1
CTRL.track.Nx   = max(1,CTRL.track.Nx);
CTRL.track.NP   = max(1,CTRL.track.NP);
CTRL.track.Nu   = max(1,CTRL.track.Nu);
CTRL.Nu         = max(1,CTRL.NuC);
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

% previous inputs
u0_ = sdpvar(repmat(CTRL.NuC+CTRL.NuB ,1,1)          ,ones(1,1));  
x0_ = sdpvar(repmat(CTRL.Nv ,1,1)          ,ones(1,1));  

% slack variable for all states across the horizon
s_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor)   ,ones(1,CTRL.hor));

objs = 0;       % initializing the objective function at 0
cons = [];      % initializing the contraints as an empty set

%% definiing the objective function and constraints

V0 = 270; % 270V bus
I0 = Converters.HVDC.eff.maxI;

% change in input [u(k-1)-u(k)]^2
for i = 1:5
    % change in input [u(k-1)-u(k)]^2
    objs = objs + 1e1*norm(u0_(i+2) - uB_{1}(i),1);
end
for k = 2:CTRL.hor
    for i = 1:5
        % change in input [u(k-1)-u(k)]^2
        objs = objs + 1e1*norm(uB_{k-1}(i) - uB_{k}(i),1);
    end
end
for k = 1:CTRL.hor    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%% OBJECTIVE FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % minimize - slack on states
    objs = objs + 1e9*norm(s_{k},2)^2;   
 
    % minimize the sheddable loads along edges 16, 18
    objs = objs  + 1e3*norm(P_{k}(16) - xt_{k}(1),2)^2;
    objs = objs  + 1e3*norm(P_{k}(18) - xt_{k}(3),2)^2;
    
    % if shedding, decrease the power
    objs = objs  + 2e3*norm(sum(P_{k}([16 18])) - shed*sum(xt_{k}([1 3])),2)^2;   
    cons = [cons, P_{k}([16 18]) <= xt_{k}([1 3])];
    
    % push inverters towards their power of max efficiency
    % I_ is binary -- 0 implies inverter is off, 1 implied inverter is on
    % P_/(V0*I0) == 1 if the inverter is operating at peak efficiency
    objs = objs + 1e4*norm((P_{k}(8:12)*1000)/(V0*I0) - uB_{k}(1:5),2)^2;
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
    % system dynamics -- only the battery has a dynamic state
    cons = [cons, x_{k+1}(1) == CTRL.DT*(-diag(1./CTRL.Caps(1))*CTRL.M_upper(1,:)*P_{k}) + x_{k}(1) ];
    
    % battery charge and discharge decision variables
    cons = [cons, P_{k}(14) == uC_{k}(1)];   % charge rate along edge 14
    cons = [cons, P_{k}(15) == uC_{k}(2)];   % discharge rate along edge 15
    
    % uB_{k}(6) == 1 implies charge mode; uB_{k}(6) == 0 implies discharge
    cons = [cons, implies(uB_{k}(6)  , uC_{k}(2) <= 0)];
    cons = [cons, implies(~uB_{k}(6) , uC_{k}(1) <= 0)];
    
    % ~uB_{k}(#) == 1 implies that the inverter is off, and power is 0
    cons = [cons, implies(~uB_{k}(1) , P_{k}(3) <= 0)];
    cons = [cons, implies(~uB_{k}(2) , P_{k}(4) <= 0)];
    cons = [cons, implies(~uB_{k}(3) , P_{k}(5) <= 0)];
    cons = [cons, implies(~uB_{k}(4) , P_{k}(6) <= 0)];
    cons = [cons, implies(~uB_{k}(5) , P_{k}(7) <= 0)];
    
    % maximum charge and discharge rates
    cons = [cons, CTRL.u_min <= uC_{k} <= CTRL.u_max ];   
    
    % power cannot be greater than what is supplied 
    % generator supply is edge 1 and 20
    cons = [cons, P_{k}(1) + P_{k}(20) <= Pin_{k}(1) ];  
    
    % x-fer bus supply is Pin(2)
    cons = [cons, implies(Pin_{k}(2) >= 1, P_{k}(3)+P_{k}(4)+P_{k}(5)+P_{k}(6)+P_{k}(7) <= Pin_{k}(2))];
    cons = [cons, implies(Pin_{k}(2) >= 1, P_{k}(2) == 0)];
    cons = [cons, implies(Pin_{k}(2) <= 1, P_{k}(3)+P_{k}(4)+P_{k}(5)+P_{k}(6)+P_{k}(7) == P_{k}(2))];
    
    % bounds on Pin to avoid Big-M relaxation errors. Pin should be between
    % 0 and 1000, but large bounds have been given for now
    cons = [cons, -1e4 <= Pin_{k} <= 1e4];
    
    % algebraic constraints on powers
    cons = [cons, CTRL.W*P_{k} == 0];  
    
    % powers must be greater than 0 and less than max
    cons = [cons, 0 <= P_{k} <= CTRL.P_max];
    
    % power along edges 17, 19, 21-24, and 31-33 equal the sink state value
    cons = [cons, P_{k}([17 19 21:24 30:32]) == xt_{k}([2 4 6:9 15:17])];
       
    % min/max state constraints with slack
    cons = [cons, CTRL.x_min - s_{k} <= x_{k+1} <= CTRL.x_max + s_{k}];                                           
             
    % keep slack positive
    cons = [cons, 0 <= s_{k}];      % Keep slack non-negative
    
end

opts = sdpsettings('solver','gurobi');  % Solve with gurobi
Ctrl.ElecLeft = CTRL;
% Create exported optimization model object
Ctrl.ElecLeft.Controller = optimizer(cons,objs,opts,{x0_,x_{1},xt_{:},Pin_{:},u0_,shed},[x_,uC_,uB_,P_,s_]); 

