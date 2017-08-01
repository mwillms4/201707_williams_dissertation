%% ACM graph
Graph.ACM.Name = 'ACM';
Valves.ACM.Geom.L = 20;
Splits.ACM.Geom.L = 10;

%% Fluid loops graph

Graph.ACM.DT   = 2;
Graph.ACM.Cp_fluid = 1;  % For air
Graph.ACM.Pin0 = [57*1*(50+273);2.25*2*(35+273);0.25*3.58*(40+273);1.25*1*(25.5+273)];

%% SECTION 2 -- Graph structure
Graph.ACM.Nv      = 16;             % Number of vertices 
Graph.ACM.Ne      = 22;             % Number of edges (Power flows)
Graph.ACM.Ns      = 1 ;             % Number of sources
Graph.ACM.Ns_aux  = 3;              % Number of auxiliary sources
Graph.ACM.Nt      = 1 ;             % Number of sinks
Graph.ACM.Nt_aux  = 3 ;             % Number of auxiliar sinks
Graph.ACM.NuC     = 10;             % Number of unique continuous inputs
Graph.ACM.NuB     = 0 ;             % Number of unique binary inputs

% Edge matrix 
Graph.ACM.E = [2 1
               3 2
               4 3
               5 4
               6 5
               7 6
               3 8
               4 8
              12 5
               8 11
              10 9
              11 10
               8 15
              13 12
              14 13
              11 15
              15 16
              16 12
               1 17
               9 18
               7 19
              14 20];
              
                        
% INPUT ORDERING:

% constraints on min/max flow rates
Graph.ACM.u_min    = [3000;zeros(Graph.ACM.NuC-1,1)+1e-2];
% Graph.ACM.u_max    = [7000;2*ones(5,1);inf*ones(4,1)];
Graph.ACM.u_max    = [7000;20*ones(5,1);inf*ones(4,1)];

% initializing the graph B matrix
Graph.ACM.B        = zeros(Graph.ACM.Ne,Graph.ACM.NuC);

% Compressor speed (u1) does not directly affect any power flow but will
% be used in controller constraints

Graph.ACM.B(4,2)   = 1;   % edge 4  -- mdot total
Graph.ACM.B(9,2)   = 1;   % edge 9  -- mdot total
Graph.ACM.B(17,2)  = 1;   % edge 17 -- mdot total
Graph.ACM.B(18,2)  = 1;   % edge 18 -- mdot total

Graph.ACM.B(3,3)   = 1;   % edge 3  -- mdot to bypass HX
Graph.ACM.B(7,3)   = 1;   % edge 7  -- mdot from bypass HX

Graph.ACM.B(8,4)   = 1;   % edge 8  -- mdot bypassing bypass HX

Graph.ACM.B(10,5)  = 1;   % edge 10 -- mdot to fuel HX
Graph.ACM.B(16,5)  = 1;   % edge 16 -- mdot from fuel HX

Graph.ACM.B(13,6)  = 1;   % edge 13 -- mdot bypassing fuel HX

Graph.ACM.B(19,7)  = 1;   % edge 19 -- mdot ambient air through bypass HX

Graph.ACM.B(20,8)  = 1;   % edge 20 -- mdot fuel through fuel HX

Graph.ACM.B(21,9)  = 1;   % edge 21 -- mdot liquid through liq HX

Graph.ACM.B(22,10) = 1;   % edge 22 -- mdot air through air HX

% Vertices connected to sources, formatted as (vertex# , source#)
Graph.ACM.D        = zeros(Graph.ACM.Nv,Graph.ACM.Ns+Graph.ACM.Ns_aux);
Graph.ACM.D(1 ,1)  = 1;          % ambient air entering bypass HX
Graph.ACM.D(9 ,2)  = 1;          % fuel entering fuel HX
Graph.ACM.D(7 ,3)  = 1;          % liquid entering liquid HX
Graph.ACM.D(14,4)  = 1;          % air entering air zone HX

% number of algebraic relationships
No_Alg = 0;

% W capatures the algebraic relationships in graphs
Graph.ACM.W       = zeros(No_Alg,Graph.ACM.Ne);

% Incidence Matrix
Graph.ACM.M = zeros(Graph.ACM.Nv+Graph.ACM.Nt,Graph.ACM.Ne);
for i = 1:Graph.ACM.Ne;
    Graph.ACM.M(Graph.ACM.E(i,1),i) = 1;
    Graph.ACM.M(Graph.ACM.E(i,2),i) = -1;
end
clear i
Graph.ACM.M_upper = Graph.ACM.M(1:Graph.ACM.Nv,:);
Graph.ACM.M_lower = Graph.ACM.M(1+Graph.ACM.Nv:end,:);
Graph.ACM.Tail    = (Graph.ACM.M'== 1);
Graph.ACM.Head    = (Graph.ACM.M'==-1);

%% SECTION 3 -- Vertex definitions
% Graph Parameters
% Vertex Capacitances and Initial Temperatures
Graph.ACM.x0      = zeros(Graph.ACM.Nv,1);
Graph.ACM.Caps    = zeros(Graph.ACM.Nv,1);
Graph.ACM.x_min   = zeros(Graph.ACM.Nv,1);
Graph.ACM.x_max   = zeros(Graph.ACM.Nv,1);

% v1 T bypass HX side 1 -- dynamic
Graph.ACM.x_min(1)   = -inf;
Graph.ACM.x_max(1)   = inf;
Graph.ACM.x0(1)      = HX.ACMBY.init.T1;
Graph.ACM.Caps(1)    = HX.ACMBY.side1.N*HX.ACMBY.side1.t*HX.ACMBY.side1.W*HX.ACMBY.side1.L*0.54*1; 
% v2 T bypass HX wall -- dynamic 
Graph.ACM.x_min(2)   = -inf;
Graph.ACM.x_max(2)   = inf;
Graph.ACM.x0(2)      = HX.ACMBY.init.Twall;
Graph.ACM.Caps(2)    = HX.ACMBY.side1.N*HX.ACMBY.mass*HX.ACMBY.Cp_wall; 
% v3 T bypass HX side 2
Graph.ACM.x_min(3)   = -inf;
Graph.ACM.x_max(3)   = inf;
Graph.ACM.x0(3)      = HX.ACMBY.init.T2;
Graph.ACM.Caps(3)    = HX.ACMBY.side2.N*HX.ACMBY.side2.t*HX.ACMBY.side2.W*HX.ACMBY.side2.L*2.65*1; 
% v4 T Split_Junction2 -- dynamic
Graph.ACM.x_min(4)   = -inf;
Graph.ACM.x_max(4)   = inf;
Graph.ACM.x0(4)      = Splits.ACM.IC.T(3);
Graph.ACM.Caps(4)    = pi*Splits.ACM.Geom.D^2/4*Splits.ACM.Geom.L*2.26*1;
% v5 T Liq HX side 1 -- dynamic
Graph.ACM.x_min(5)   = -inf;
Graph.ACM.x_max(5)   = inf;
Graph.ACM.x0(5)      = HX.ACM1.init.T1;
Graph.ACM.Caps(5)    = HX.ACM1.side1.N*HX.ACM1.side1.t*HX.ACM1.side1.W*HX.ACM1.side1.L*1*1;
% v6 T T Liq HX wall -- dynamic
Graph.ACM.x_min(6)   = -inf;
Graph.ACM.x_max(6)   = inf;
Graph.ACM.x0(6)      = HX.ACM1.init.Twall;
Graph.ACM.Caps(6)    = HX.ACM1.side1.N*HX.ACM1.mass*HX.ACM1.Cp_wall;
% v7 T Liq HX side 2 -- dynamic
Graph.ACM.x_min(7)   = -inf;
Graph.ACM.x_max(7)   = inf;
Graph.ACM.x0(7)      = HX.ACM1.init.T2;
Graph.ACM.Caps(7)    = HX.ACM1.side2.N*HX.ACM1.side2.t*HX.ACM1.side2.W*HX.ACM1.side2.L*3.58*1000;
% v8 T Split_Juction1 -- dynamic
Graph.ACM.x_min(8)   = -inf;
Graph.ACM.x_max(8)   = inf;
Graph.ACM.x0(8)      = Splits.ACM.IC.T(2);
Graph.ACM.Caps(8)    = pi*Splits.ACM.Geom.D^2/4*Splits.ACM.Geom.L*2.26*1;
% v9 T Fuel HX Side 2 -- dynamic
Graph.ACM.x_min(9)   = -inf;
Graph.ACM.x_max(9)   = inf;
Graph.ACM.x0(9)      = HX.ACMFUEL.init.T2;
Graph.ACM.Caps(9)    = HX.ACMFUEL.side1.N*HX.ACMFUEL.side1.t*HX.ACMFUEL.side1.W*HX.ACMFUEL.side1.L*2*800;
% v10 T Fuel HX wall -- dynamic
Graph.ACM.x_min(10)  = -inf;
Graph.ACM.x_max(10)  = inf;
Graph.ACM.x0(10)     = HX.ACMFUEL.init.Twall;
Graph.ACM.Caps(10)   = HX.ACMFUEL.side1.N*HX.ACMFUEL.mass*HX.ACMFUEL.Cp_wall;
% v11 T Fuel HX Side 1 -- dynamic
Graph.ACM.x_min(11)  = -inf;
Graph.ACM.x_max(11)  = inf;
Graph.ACM.x0(11)     = HX.ACMFUEL.init.T1;
Graph.ACM.Caps(11)   = HX.ACMFUEL.side1.N*HX.ACMFUEL.side1.t*HX.ACMFUEL.side1.W*HX.ACMFUEL.side1.L*1*1;
% v12 T Air HX Side 2 -- dynamic
Graph.ACM.x_min(12)  = -inf;
Graph.ACM.x_max(12)  = inf;
Graph.ACM.x0(12)     = HX.ACM2.init.T2;
Graph.ACM.Caps(12)   = HX.ACM2.side2.N*HX.ACM2.side2.t*HX.ACM2.side2.W*HX.ACM2.side2.L*1*1;
% v13 T Air HX wall -- dynamic
Graph.ACM.x_min(13)  = -inf;
Graph.ACM.x_max(13)  = inf;
Graph.ACM.x0(13)     = HX.ACM2.init.Twall;
Graph.ACM.Caps(13)   = HX.ACM2.side1.N*HX.ACM2.mass*HX.ACM2.Cp_wall ;
% v14 T Air HX Side 1 -- dynamic
Graph.ACM.x_min(14)  = -inf;
Graph.ACM.x_max(14)  = inf;
Graph.ACM.x0(14)     = HX.ACM2.init.T1;
Graph.ACM.Caps(14)   = HX.ACM2.side1.N*HX.ACM2.side1.t*HX.ACM2.side1.W*HX.ACM2.side1.L*1*1;
% v15 T Valve 1 -- dynamic
Graph.ACM.x_min(15)  = -inf;
Graph.ACM.x_max(15)  = inf;
Graph.ACM.x0(15)     = Valves.ACM.IC.T(2);
Graph.ACM.Caps(15)   = pi*Valves.ACM.Geom.D^2/4*Valves.ACM.Geom.L*2.3*1;
% v 16 Split_Junction3 -- dynamic
Graph.ACM.x_min(16)  = -inf;
Graph.ACM.x_max(16)  = inf;
Graph.ACM.x0(16)     = Splits.ACM.IC.T(4);
Graph.ACM.Caps(16)   = pi*Splits.ACM.Geom.D^2/4*Splits.ACM.Geom.L*1.4*1;

% °C to K
Graph.ACM.x_min  = Graph.ACM.x_min + 273.15; 
Graph.ACM.x_max  = Graph.ACM.x_max + 273.15; 
Graph.ACM.x0     = Graph.ACM.x0 + 273.15;

%% SECTION 4 -- Edge definitions
  
% P = (c1+u)*(c2*x_from + c3*x_to + c4) 
Graph.ACM.E_coeff         = zeros(Graph.ACM.Ne,4);

% e1 bypass HX wall heat transfer side 1
hA = 2*HX.ACMBY.side1.N*HX.ACMBY.side1.W*HX.ACMBY.side1.L*HX.ACMBY.side1.H;
Graph.ACM.E_coeff(1,1) = hA / 1000;  % units: kW/K
Graph.ACM.E_coeff(1,2) =  1;
Graph.ACM.E_coeff(1,3) = -1;

% e2 bypass HX wall heat transfer side 2
hA = 2*HX.ACMBY.side2.N*HX.ACMBY.side2.W*HX.ACMBY.side2.L*HX.ACMBY.side2.H;
Graph.ACM.E_coeff(2,1) = hA / 1000;  % units: kW/K
Graph.ACM.E_coeff(2,2) =  1;
Graph.ACM.E_coeff(2,3) = -1;

% e3 Split_Junction2
Graph.ACM.E_coeff(3,2)  = 1;

% e4 T Liq HX side 1
Graph.ACM.E_coeff(4,2)  = 1;

% e5 Liquid HX wall heat transfer side 1
hA = 2*HX.ACM1.side1.N*HX.ACM1.side1.W*HX.ACM1.side1.L*HX.ACM1.side1.H;
Graph.ACM.E_coeff(5,1) = hA / 1000;  % units: kW/K
Graph.ACM.E_coeff(5,2) =  1;
Graph.ACM.E_coeff(5,3) = -1;

% e6 Liquid HX wall heat transfer side 2
hA = 2*HX.ACM1.side2.N*HX.ACM1.side2.W*HX.ACM1.side2.L*HX.ACM1.side2.H;
Graph.ACM.E_coeff(6,1) = hA / 1000;  % units: kW/K
Graph.ACM.E_coeff(6,2) =  1;
Graph.ACM.E_coeff(6,3) = -1;

% e7 T bypass HX side 2
Graph.ACM.E_coeff(7,2)  = 1;

% e8 Split_Junction2
Graph.ACM.E_coeff(8,2)  = 1;

% e9 T Air HX Side 2
Graph.ACM.E_coeff(9,2)  = 1;

% e10 Split_Juction1
Graph.ACM.E_coeff(10,2)  = 1;

% e11 Feul HX wall heat transfer side 2
hA = 2*HX.ACMFUEL.side2.N*HX.ACMFUEL.side2.W*HX.ACMFUEL.side2.L*HX.ACMFUEL.side2.H;
Graph.ACM.E_coeff(11,1) = hA / 1000;  % units: kW/K
Graph.ACM.E_coeff(11,2) =  1;
Graph.ACM.E_coeff(11,3) = -1;

% e12 Feul HX wall heat transfer side 1
hA = 2*HX.ACMFUEL.side1.N*HX.ACMFUEL.side1.W*HX.ACMFUEL.side1.L*HX.ACMFUEL.side1.H;
Graph.ACM.E_coeff(12,1) = hA / 1000;  % units: kW/K
Graph.ACM.E_coeff(12,2) =  1;
Graph.ACM.E_coeff(12,3) = -1;

% e13 Split_Juction1
Graph.ACM.E_coeff(13,2)  = 1;

% e14 Air HX wall heat transfer side 2
hA = 2*HX.ACM2.side2.N*HX.ACM2.side2.W*HX.ACM2.side2.L*HX.ACM2.side2.H;
Graph.ACM.E_coeff(14,1) = hA / 1000;  % units: kW/K
Graph.ACM.E_coeff(14,2) =  1;
Graph.ACM.E_coeff(14,3) = -1;

% e15 Air HX wall heat transfer side 1
hA = 2*HX.ACM2.side1.N*HX.ACM2.side1.W*HX.ACM2.side1.L*HX.ACM2.side1.H;
Graph.ACM.E_coeff(15,1) = hA / 1000;  % units: kW/K
Graph.ACM.E_coeff(15,2) =  1;
Graph.ACM.E_coeff(15,3) = -1;

% e16 Fuel HX Side 1
Graph.ACM.E_coeff(16,2)  = 1;

% e17 Valve 1
Graph.ACM.E_coeff(17,2)  = 1;

% e18 Split_Junction3
Graph.ACM.E_coeff(18,2)  = 1;

% e19 bypass HX side 1
Graph.ACM.E_coeff(19,2)  = 1;

% e20 T Fuel HX Side 2
Graph.ACM.E_coeff(20,2)  = 2;

% e21 T Liq HX side 2
Graph.ACM.E_coeff(21,2)  = 3.58;

% e22 T Air HX Side 1
Graph.ACM.E_coeff(22,2)  = 1;

clear hA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Graph.ACM.Caps(Graph.ACM.Caps < 1) = 0; % Make small capacitances zero
Graph.ACM.Caps([4 16]) = 0; % Make turbomachinery outputs algebraic


%% ACM Controller definition
CTRL = Graph.ACM;
CTRL.hor = 5;

CTRL.N_track = 4;

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
ref_   = sdpvar(repmat(CTRL.N_track     ,1,1)   ,ones(1,1));

% inputs (mdots) set outside of subsystem used to constrain inputs for flow
% to sinks
uext_   = sdpvar(repmat(4        ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% previous inputs and current states
u0_ = sdpvar(repmat(CTRL.NuC+CTRL.NuB ,1,1)          ,ones(1,1));  
x0_ = sdpvar(repmat(CTRL.Nv ,1,1)          ,ones(1,1));  

% slack variable for all states across the horizon
s_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor)   ,ones(1,CTRL.hor));
% slack variable for input constraints across the horizon
s2_    = sdpvar(repmat(3       ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% all state (xall_), tracked states (xtr_), and tracked power flows (Ptr_)
% across the horizon
Nx_total = CTRL.Nv+CTRL.Nt+CTRL.Nt_aux;
xall_ = sdpvar(repmat(Nx_total        ,1,CTRL.hor)   ,ones(1,CTRL.hor));

objs = 0;       % initializing the objective function at 0
cons = [];      % initializing the contraints as an empty set

%% definiing the objective function and constraints
for k = 1:CTRL.hor    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%% OBJECTIVE FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % minimize - slack on states 
    objs = objs + 1e9*norm(s2_{k},2)^2;   
    
    % minimize - push states to references
    objs = objs + 3e0*norm(x_{k+1}(9)-ref_(2),2)^2;
    objs = objs + 5e0*norm(x_{k+1}(14)-ref_(4),2)^2;
    
    % minimize intergrator error
    objs = objs + 5e-3*norm(z_{k+1}(4),2)^2;
    
    % minimize switching
    if k == 1
        objs = objs + 1e-2*norm(uC_{k}(1)-u0_(1),2)^2;
        objs = objs + 1e1*norm(uC_{k}(2:6)-u0_(2:6),2)^2;
    else
        objs = objs + 1e-2*norm(uC_{k}(1)-uC_{k-1}(1),2)^2;
        objs = objs + 1e2*norm(uC_{k}(2:6)-uC_{k-1}(2:6),2)^2;
    end
    objs = objs + 1e-5*norm(uC_{k}(1)-CTRL.u_min(1),2)^2;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % system dynamics (for all but x(4) and x(16) which are algebraically
    % constrainted based on shaft speed)
    dyn = find(CTRL.Caps~=0);
    cons = [cons, 1/CTRL.DT*diag(CTRL.Caps(dyn))*(x_{k+1}(dyn)- x_{k}(dyn)) == ...
        (-CTRL.M_upper(dyn,:)*P_{k} + CTRL.D(dyn,:)*Pin_{k})  ];
    if k > 1
        alg = setdiff(find(CTRL.Caps==0),[4 16]);
        cons = [cons, 0 == (-CTRL.M_upper(alg,:)*P_{k} + CTRL.D(alg,:)*Pin_{k})  ];
    end
    
    cons = [cons, z_{k+1} == z_{k} + CTRL.DT*(x_{k+1}([1 9 7 14])-ref_)];
    
    % Constraints for turbomachinery exit temperatures
    cons = [cons, x_{k+1}(15) - x_{k+1}(16) == 3.5991e-6*u0_(1)*uC_{k}(1) - 3.0449e-3*uC_{k}(1) + 6.8272e0];
    cons = [cons, x_{k+1}(4)  - x_{k+1}(5)  == 7.5455e-6*u0_(1)*uC_{k}(1) - 1.9692e-2*uC_{k}(1) + 3.5914e1];

    % min/max state constraints with slack
    cons = [cons, CTRL.x_min - s_{k} <= x_{k+1} <= CTRL.x_max + s_{k}]; 
    
    % keep slack positive
    cons = [cons, 0 <= s_{k}];      % Keep slack non-negative
    
    % min/max input constraints
    cons = [cons, CTRL.u_min <= uC_{k} <= CTRL.u_max];

    % concatenating states with sinks
    cons = [cons, xall_{k} == [x_{k};xt_{k}]];
    
    % split and junction constraints
    cons = [cons, uC_{k}(2) + s2_{k}(1) == uC_{k}(3) + uC_{k}(4)];
    cons = [cons, uC_{k}(2) + s2_{k}(2) == uC_{k}(5) + uC_{k}(6)];
    cons = [cons, uC_{k}(2) + s2_{k}(3) == -7.1181e-8*u0_(1)*uC_{k}(1) + 8.6399e-4*uC_{k}(1) - 8.2273e-1];  
    
    % sink flow constraints
    cons = [cons, uC_{k}(7:10) == uext_{k}];
    
    % edges that follow an mdot*Cp*T power flow
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
Ctrl.ACM = CTRL;
% Create exported optimization model object
Ctrl.ACM.Controller = optimizer(cons,objs,opts,{x0_,x_{1},xt_{:},Pin_{:},u0_,uext_{:},z_{1},ref_},[x_,uC_,P_,s_,s2_]); 

