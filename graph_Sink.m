% run Sizing_All
% run define_mission
% run graph_fuelloop
% run graph_ACM

%%
GRAPH.A = Graph.FuelLoop;
GRAPH.B = Graph.ACM;

GRAPH.A = rmfield(GRAPH.A,'rho');
GRAPH.B = rmfield(GRAPH.B,'Pin0');

GRAPH.C = GRAPH.B;

% Sink/Source relations  (Sink number is row, Graph power is flowing to is first column,
% Corresponding vertex in the graph power is flowing to)
GRAPH.A.SinkSource = cell(GRAPH.A.Nt_aux+GRAPH.A.Nt,2);
GRAPH.A.SinkSource{1,1}  = 'Ex';     % RAM air
GRAPH.A.SinkSource{2,1}  = 'Ex';     % Pump Hydr
GRAPH.A.SinkSource{3,1}  = 'Ex';     % Tank Mass
GRAPH.A.SinkSource{4,1}  = 'B';      GRAPH.A.SinkSource{4,2} = 9; % Left ACM HX
GRAPH.A.SinkSource{5,1}  = 'C';      GRAPH.A.SinkSource{5,2} = 9; % Right ACM HX
GRAPH.A.SinkSource{6,1}  = 'Ex';     % Left Engine
GRAPH.A.SinkSource{7,1}  = 'Ex';     % Right Engine

GRAPH.B.SinkSource = cell(GRAPH.B.Nt_aux+GRAPH.B.Nt,2);
GRAPH.B.SinkSource{1,1}  = 'Ex';     % Bypass air
GRAPH.B.SinkSource{2,1}  = 'A';      GRAPH.B.SinkSource{2,2} = 19; % Left Fuel Loop
GRAPH.B.SinkSource{3,1}  = 'Ex';     % Liquid Loop
GRAPH.B.SinkSource{4,1}  = 'Ex';     % Air Zones

GRAPH.C.SinkSource = cell(GRAPH.C.Nt_aux+GRAPH.C.Nt,2);
GRAPH.C.SinkSource{1,1}  = 'Ex';     % Bypass air
GRAPH.C.SinkSource{2,1}  = 'A';      GRAPH.C.SinkSource{2,2} = 48; % Right Fuel Loop
GRAPH.C.SinkSource{3,1}  = 'Ex';     % Liquid Loop
GRAPH.C.SinkSource{4,1}  = 'Ex';     % Air Zones

% External Sources -- "global sources"
GRAPH.A.Sources = cell(GRAPH.A.Ns+GRAPH.A.Ns_aux,2);
GRAPH.A.Sources{1,1} = 'Ex';  GRAPH.A.Sources{1,2} = 7;
GRAPH.A.Sources{2,1} = 'Ex';  GRAPH.A.Sources{2,2} = 36;
GRAPH.A.Sources{3,1} = 'Ex';  GRAPH.A.Sources{3,2} = 27;
GRAPH.A.Sources{4,1} = 'Ex';  GRAPH.A.Sources{4,2} = 56;
GRAPH.A.Sources{5,1} = 'Ex';  GRAPH.A.Sources{5,2} = 32;
GRAPH.A.Sources{6,1} = 'Ex';  GRAPH.A.Sources{6,2} = 61;
GRAPH.A.Sources{7,1} = 'Ex';  GRAPH.A.Sources{7,2} = 17;
GRAPH.A.Sources{8,1} = 'Ex';  GRAPH.A.Sources{8,2} = 46;
GRAPH.A.Sources{9,1} = 'Ex';  GRAPH.A.Sources{9,2} = 35;
GRAPH.A.Sources{10,1} = 'Ex';  GRAPH.A.Sources{10,2} = 64;
GRAPH.A.Sources{11,1} = 'Ex';  GRAPH.A.Sources{11,2} = 34;
GRAPH.A.Sources{12,1} = 'Ex';  GRAPH.A.Sources{12,2} = 63;
GRAPH.A.Sources{13,1} = 'Ex';  GRAPH.A.Sources{13,2} = 33;
GRAPH.A.Sources{14,1} = 'Ex';  GRAPH.A.Sources{14,2} = 62;
% GRAPH.A.Sources{15,1} = 'B';  GRAPH.A.Sources{15,2} = 19;
% GRAPH.A.Sources{16,1} = 'C';  GRAPH.A.Sources{16,2} = 48;
GRAPH.A.Sources{17,1} = 'Ex';  GRAPH.A.Sources{17,2} = 5;
GRAPH.A.Sources{18,1} = 'Ex';  GRAPH.A.Sources{18,2} = 6;

GRAPH.B.Sources = cell(GRAPH.B.Ns+GRAPH.B.Ns_aux,2);
GRAPH.B.Sources{1,1} = 'Ex';  GRAPH.B.Sources{1,2} = 1;
% GRAPH.B.Sources{2,1} = 'A';  GRAPH.B.Sources{2,2} = 9;
GRAPH.B.Sources{3,1} = 'Ex';  GRAPH.B.Sources{3,2} = 7;
GRAPH.B.Sources{4,1} = 'Ex';  GRAPH.B.Sources{4,2} = 14;

GRAPH.C.Sources = cell(GRAPH.C.Ns+GRAPH.C.Ns_aux,2);
GRAPH.C.Sources{1,1} = 'Ex';  GRAPH.C.Sources{1,2} = 1;
% GRAPH.C.Sources{2,1} = 'A';  GRAPH.C.Sources{2,2} = 9;
GRAPH.C.Sources{3,1} = 'Ex';  GRAPH.C.Sources{3,2} = 7;
GRAPH.C.Sources{4,1} = 'Ex';  GRAPH.C.Sources{4,2} = 14;

Graph.SinkMgmt = Graph_Combine_Code(GRAPH.A, GRAPH.B, GRAPH.C);

%%
Graph.SinkMgmt.Caps;
Graph.SinkMgmt.Caps(Graph.SinkMgmt.Caps < 100) = 0; % Make small capacitances zero
Graph.SinkMgmt.Caps;

%% Sink mgmt controller definition
Graph.SinkMgmt.Name = 'SinkMgmt';
Graph.SinkMgmt.DT   = 60;
Graph.SinkMgmt.Pin0 = 0;

CTRL = Graph.SinkMgmt;
CTRL.hor = 5;

CTRL.N_track = 1;
CTRL.indx_track = [5]; 

%% defining variables for use with YALMIP
yalmip('clear')
% Sources (Pin_) and sinks (xt_) -- including preview across the horizon
Pin_  = sdpvar(repmat(CTRL.Ns+CTRL.Ns_aux, 1, CTRL.hor), ones(1,CTRL.hor));
xt_   = sdpvar(repmat(CTRL.Nt+CTRL.Nt_aux, 1, CTRL.hor), ones(1,CTRL.hor));

% states (x_), power flows (P_), and inputs (u_) across the horizon
x_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor+1) ,ones(1,CTRL.hor+1));
P_    = sdpvar(repmat(CTRL.Ne         ,1,CTRL.hor)   ,ones(1,CTRL.hor));
uC_   = sdpvar(repmat(CTRL.NuC        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
% uB_   = binvar(repmat(CTRL.NuB        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
z_   = sdpvar(repmat(CTRL.N_track     ,1,CTRL.hor+1)   ,ones(1,CTRL.hor+1));
ref_   = sdpvar(repmat(CTRL.N_track     ,1,1)   ,ones(1,1));
Caps_    = sdpvar(repmat(5         ,1,1) ,ones(1,1));
Mtanks_  = sdpvar(repmat(5         ,1,CTRL.hor+1) ,ones(1,CTRL.hor+1));
% inputs (mdots) set outside of subsystem used to constrain inputs for flow
% to sinks
uext_   = sdpvar(repmat(10        ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% previous inputs and current states
u0_ = sdpvar(repmat(CTRL.NuC+CTRL.NuB ,1,1)          ,ones(1,1));  
x0_ = sdpvar(repmat(CTRL.Nv ,1,1)          ,ones(1,1));  

% slack variable for all states across the horizon
s_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor)   ,ones(1,CTRL.hor));
% slack variable for input constraints across the horizon
s2_    = sdpvar(repmat(14+6     ,1,CTRL.hor)   ,ones(1,CTRL.hor));
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
 
    % minimize fuel tank temperatures (auxiliary)
    objs = objs + 1e-4*norm(x_{k+1}([13  42]),2)^2;
    
    % minimize power into the fuel loop from the ACM
    objs = objs + 1e-1*norm(P_{k}(109),2)^2;
    objs = objs + 1e-1*norm(P_{k}(131),2)^2;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % system dynamics - tanks with time varying capacitance
    tanks = [1 12 13 41 42];
    cons = [cons, 1/CTRL.DT*diag(Caps_)*(x_{k+1}(tanks)- x_{k}(tanks)) == ...
        (-CTRL.M_upper(tanks,:)*P_{k} + CTRL.D(tanks,:)*Pin_{k})  ];
    
    % dynamic system states
    dyn = setdiff(setdiff(find(CTRL.Caps~=0),find(CTRL.Caps==inf)),tanks);
    cons = [cons, 1/CTRL.DT*diag(CTRL.Caps(dyn))*(x_{k+1}(dyn)- x_{k}(dyn)) == ...
        (-CTRL.M_upper(dyn,:)*P_{k} + CTRL.D(dyn,:)*Pin_{k})  ];
    
    % algebraic system states
    alg = find(CTRL.Caps==0);
    if k == 1
        objs = objs + 1e3*norm(-CTRL.M_upper(alg,:)*P_{k} + CTRL.D(alg,:)*Pin_{k},2)^2;
    end
    if k > 1
        cons = [cons, 0 == (-CTRL.M_upper(alg,:)*P_{k} + CTRL.D(alg,:)*Pin_{k})  ];
    end

    % fixed system states
    fixed = find(CTRL.Caps==inf);
    cons = [cons, x_{k+1}(fixed) == x_{k}(fixed)];
    
    % integral constraint on tracked state
    cons = [cons, z_{k+1} == z_{k} + CTRL.DT*(x_{k+1}(CTRL.indx_track)-ref_)];
    
    % Constraints for turbomachinery exit temperatures
    cons = [cons, x_{k+1}(15+64) - x_{k+1}(16+64) == 3.5991e-6*u0_(1+36)*uC_{k}(1+36) - 3.0449e-3*uC_{k}(1+36) + 6.8272e0];
    cons = [cons, x_{k+1}(4+64)  - x_{k+1}(5+64)  == 7.5455e-6*u0_(1+36)*uC_{k}(1+36) - 1.9692e-2*uC_{k}(1+36) + 3.5914e1];
    cons = [cons, x_{k+1}(15+80) - x_{k+1}(16+80) == 3.5991e-6*u0_(1+46)*uC_{k}(1+46) - 3.0449e-3*uC_{k}(1+46) + 6.8272e0];
    cons = [cons, x_{k+1}(4+80)  - x_{k+1}(5+80)  == 7.5455e-6*u0_(1+46)*uC_{k}(1+46) - 1.9692e-2*uC_{k}(1+46) + 3.5914e1];
    
    % min/max state constraints with slack
    cons = [cons, CTRL.x_min - s_{k} <= x_{k+1} <= CTRL.x_max + s_{k}]; 
    cons = [cons, x_{k+1}+5 <= CTRL.x_max + s3_{k}]; 
    
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
    
    cons = [cons, 10 <= Mtanks_{k+1}];
    
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
    cons = [cons, uC_{k}(2+36) + s2_{k}(15) == uC_{k}(3+36) + uC_{k}(4+36)];
    cons = [cons, uC_{k}(2+36) + s2_{k}(16) == uC_{k}(5+36) + uC_{k}(6+36)];
    cons = [cons, uC_{k}(2+36) + s2_{k}(17) == -7.1181e-8*u0_(1+36)*uC_{k}(1+36) + 8.6399e-4*uC_{k}(1+36) - 8.2273e-1];  
    cons = [cons, uC_{k}(2+46) + s2_{k}(18) == uC_{k}(3+46) + uC_{k}(4+46)];
    cons = [cons, uC_{k}(2+46) + s2_{k}(19) == uC_{k}(5+46) + uC_{k}(6+46)];
    cons = [cons, uC_{k}(2+46) + s2_{k}(20) == -7.1181e-8*u0_(1+46)*uC_{k}(1+46) + 8.6399e-4*uC_{k}(1+46) - 8.2273e-1];  
    
    % sink flow constraints
    cons = [cons, uC_{k}([32 34 35 36]) == uext_{k}(1:4)];
    cons = [cons, uC_{k}([7 9 10]+36) == uext_{k}(5:7)];
    cons = [cons, uC_{k}([7 9 10]+46) == uext_{k}(8:10)];
    
    % flow through ACM fuel heat exchanger
    cons = [cons, uC_{k}(8+36) == uC_{k}(18)];
    cons = [cons, uC_{k}(8+46) == uC_{k}(23)];
    
    % edges that follow an mdot*Cp*T power flow
    for i_edge = setdiff(find(any(CTRL.B,2)'),[90:94])
        cons = [cons, P_{k}(i_edge) == u0_(find(CTRL.B(i_edge,:)))*...
            (CTRL.E_coeff(i_edge,2) * (xall_{k}(CTRL.E(i_edge,1)) - x0_(CTRL.E(i_edge,1))))+...
            (uC_{k}(find(CTRL.B(i_edge,:)))*CTRL.E_coeff(i_edge,2)*x0_(CTRL.E(i_edge,1))) ];
    end
    
    % edges that follow a mass drain compensation
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
    
    % power flows input constraints
    cons = [cons, P_{k}(24) + P_{k}(83) == Pin_{k}(9) ];
    cons = [cons, P_{k}(58) + P_{k}(85) == Pin_{k}(10)];
    cons = [cons, P_{k}(34) + P_{k}(86) == Pin_{k}(11)];
    cons = [cons, P_{k}(68) + P_{k}(89) == Pin_{k}(12)];
    cons = [cons, P_{k}(41) + P_{k}(87) == Pin_{k}(13)];
    cons = [cons, P_{k}(75) + P_{k}(88) == Pin_{k}(14)];
    cons = [cons, P_{k}( 3) + P_{k}(84) == Pin_{k}(16)];

end

opts = sdpsettings('solver','gurobi','gurobi.TimeLimit',5);  % Solve with gurobi
Ctrl.SinkMgmt = CTRL;
% Create exported optimization model object
Ctrl.SinkMgmt.Controller = optimizer(cons,objs,opts,{x0_,x_{1},xt_{:},Pin_{:},u0_,uext_{:},z_{1},ref_,Caps_},[x_,uC_,P_,s_,s2_]); 