GRAPH.A = Graph.ElecLeft;
GRAPH.B = Graph.ElecRight;
GRAPH.C = Graph.AirZones;
GRAPH.D = Graph.FluidLoop;

GRAPH.A.E_coeff = zeros(GRAPH.A.Ne,4);
GRAPH.A = rmfield(GRAPH.A,'P_max');
GRAPH.B.E_coeff = zeros(GRAPH.B.Ne,4);
GRAPH.B = rmfield(GRAPH.B,'P_max');
GRAPH.C = rmfield(GRAPH.C,'Cp_fluid');
GRAPH.C = rmfield(GRAPH.C,'D');
GRAPH.D = rmfield(GRAPH.D,'Cp_fluid');
GRAPH.D = rmfield(GRAPH.D,'D');


% Sink/Source relations  (Sink number is row, Graph power is flowing to is first column,
% Corresponding vertex in the graph power is flowing to)
GRAPH.A.SinkSource = cell(GRAPH.A.Nt_aux+GRAPH.A.Nt,2);
GRAPH.A.SinkSource{1,1}  = 'Ex';     % Electrical load -- "Other"
GRAPH.A.SinkSource{2,1}  = 'Ex';     % Electrical load -- "de-ice"
GRAPH.A.SinkSource{3,1}  = 'Ex';     % Electrical load -- "Other"
GRAPH.A.SinkSource{4,1}  = 'Ex';     % Electrical load -- "hydraulics"
GRAPH.A.SinkSource{5,1}  = 'Ex';     % Generator temperature
GRAPH.A.SinkSource{6,1}  = 'C';      GRAPH.A.SinkSource{6,2} = 10; % heater
GRAPH.A.SinkSource{7,1}  = 'B';      GRAPH.A.SinkSource{7,2} = 16; % bus xfer
GRAPH.A.SinkSource{8,1}  = 'B';      GRAPH.A.SinkSource{8,2} = 4;  % bus xfer
GRAPH.A.SinkSource{9,1}  = 'Ex';     % Boost pump load
GRAPH.A.SinkSource{10,1} = 'D';      GRAPH.A.SinkSource{10,2} = 30; % HVDC CP 
GRAPH.A.SinkSource{11,1} = 'D';      GRAPH.A.SinkSource{11,2} = 31; % HVDC CP 
GRAPH.A.SinkSource{12,1} = 'D';      GRAPH.A.SinkSource{12,2} = 32; % HVDC CP 
GRAPH.A.SinkSource{13,1} = 'D';      GRAPH.A.SinkSource{13,2} = 33; % HVDC CP 
GRAPH.A.SinkSource{14,1} = 'D';      GRAPH.A.SinkSource{14,2} = 34; % HVDC CP 
GRAPH.A.SinkSource{15,1} = 'C';      GRAPH.A.SinkSource{15,2} = 2;  % R blower power
GRAPH.A.SinkSource{16,1} = 'C';      GRAPH.A.SinkSource{16,2} = 1;  % L blower power
GRAPH.A.SinkSource{17,1} = 'Ex';     % ACM power
GRAPH.A.SinkSource{18,1} = 'D';      GRAPH.A.SinkSource{18,2} = 29; % HVDC battery CP

GRAPH.B.SinkSource = cell(GRAPH.B.Nt_aux+GRAPH.B.Nt,2);
GRAPH.B.SinkSource{1,1}  = 'Ex';     % Electrical load -- "Other"
GRAPH.B.SinkSource{2,1}  = 'Ex';     % Electrical load -- "de-ice"
GRAPH.B.SinkSource{3,1}  = 'Ex';     % Electrical load -- "AEE"
GRAPH.B.SinkSource{4,1}  = 'Ex';     % Electrical load -- "misc"
GRAPH.B.SinkSource{5,1}  = 'Ex';     % Electrical load -- "shed"
GRAPH.B.SinkSource{6,1}  = 'Ex';     % Electrical load -- "no shed"
GRAPH.B.SinkSource{7,1}  = 'Ex';     % Electrical load -- "no shed"
GRAPH.B.SinkSource{8,1}  = 'Ex';     % Electrical load -- "shed"
GRAPH.B.SinkSource{9,1}  = 'Ex';     % Generator temperature
GRAPH.B.SinkSource{10,1} = 'Ex';     % AEE temperature
GRAPH.B.SinkSource{11,1} = 'Ex';     % Boost pump load
GRAPH.B.SinkSource{12,1} = 'A';      GRAPH.B.SinkSource{12,2} = 4;
GRAPH.B.SinkSource{13,1} = 'D';      GRAPH.B.SinkSource{13,2} = 35; % LVDC CP 
GRAPH.B.SinkSource{14,1} = 'D';      GRAPH.B.SinkSource{14,2} = 36; % LVDC CP 
GRAPH.B.SinkSource{15,1} = 'D';      GRAPH.B.SinkSource{15,2} = 37; % LVDC CP 
GRAPH.B.SinkSource{16,1} = 'D';      GRAPH.B.SinkSource{16,2} = 38; % LVDC CP 
GRAPH.B.SinkSource{17,1} = 'D';      GRAPH.B.SinkSource{17,2} = 39; % LVDC CP 
GRAPH.B.SinkSource{18,1} = 'D';      GRAPH.B.SinkSource{18,2} = 40; % LVAC CP 
GRAPH.B.SinkSource{19,1} = 'D';      GRAPH.B.SinkSource{19,2} = 41; % LVAC CP 
GRAPH.B.SinkSource{20,1} = 'D';      GRAPH.B.SinkSource{20,2} = 42; % LVAC CP 
GRAPH.B.SinkSource{21,1} = 'D';      GRAPH.B.SinkSource{21,2} = 43; % LVAC CP 
GRAPH.B.SinkSource{22,1} = 'D';      GRAPH.B.SinkSource{22,2} = 44; % LVAC CP 
GRAPH.B.SinkSource{23,1} = 'D';      GRAPH.B.SinkSource{23,2} = 45; % LV battery
GRAPH.B.SinkSource{24,1} = 'Ex';     % FADEC load
GRAPH.B.SinkSource{25,1} = 'Ex';     % Generator/engine pumps
GRAPH.B.SinkSource{26,1} = 'C';      GRAPH.B.SinkSource{26,2} = 8; % Bay E Temp.
GRAPH.B.SinkSource{27,1} = 'C';      GRAPH.B.SinkSource{27,2} = 9; % Bay F Temp.
GRAPH.B.SinkSource{28,1} = 'D';      GRAPH.B.SinkSource{28,2} = 3; % liquid pump

GRAPH.C.SinkSource = cell(GRAPH.C.Nt_aux+GRAPH.C.Nt,2);
GRAPH.C.SinkSource{1,1}  = 'Ex';     % Ex = global sink
GRAPH.C.SinkSource{2,1}  = 'Ex';     % Ex = global sink
GRAPH.C.SinkSource{3,1}  = 'Ex';     % Ex = global sink
GRAPH.C.SinkSource{4,1}  = 'Ex';     % Ex = global sink

GRAPH.D.SinkSource = cell(GRAPH.D.Nt_aux+GRAPH.D.Nt,2);
GRAPH.D.SinkSource{1,1}  = 'Ex';     % Ex = global sink
GRAPH.D.SinkSource{2,1}  = 'Ex';     % Ex = global sink
GRAPH.D.SinkSource{3,1}  = 'Ex';     % Ex = global sink

% External Sources -- "global sources"
GRAPH.A.Sources = cell(GRAPH.A.Ns+GRAPH.A.Ns_aux,2);
% global index for source = 1
% source is going into Graph A vertex 1
GRAPH.A.Sources{1,1} = 'Ex';  GRAPH.A.Sources{1,2} = 2;
% GRAPH.A.Sources{2,1} = 'B';   GRAPH.A.Sources{2,2} = 4;

GRAPH.B.Sources = cell(GRAPH.B.Ns+GRAPH.B.Ns_aux,1);
GRAPH.B.Sources{1,1} = 'Ex';  GRAPH.B.Sources{1,2} = 2;
% GRAPH.B.Sources{2,1} = 'A';   GRAPH.B.Sources{2,2} = 4;
% GRAPH.B.Sources{3,1} = 'A';   GRAPH.B.Sources{3,2} = 16;

GRAPH.C.Sources = cell(GRAPH.C.Ns+GRAPH.C.Ns_aux+1,1);
GRAPH.C.Sources{1,1} = 'Ex';  GRAPH.C.Sources{1,2} = 6;
GRAPH.C.Sources{2,1} = 'Ex';  GRAPH.C.Sources{2,2} = 7;
% GRAPH.C.Sources{3,1} = 'A';   GRAPH.C.Sources{3,2} = 1;
% GRAPH.C.Sources{4,1} = 'A';   GRAPH.C.Sources{4,2} = 2;
GRAPH.C.Sources{5,1} = 'Ex';  GRAPH.C.Sources{5,2} = 3;
GRAPH.C.Sources{6,1} = 'Ex';  GRAPH.C.Sources{6,2} = 4;
% GRAPH.C.Sources{7,1} = 'B';   GRAPH.C.Sources{7,2} = 8;
% GRAPH.C.Sources{8,1} = 'B';   GRAPH.C.Sources{8,2} = 9;
% GRAPH.C.Sources{9,1} = 'A';   GRAPH.C.Sources{9,2} = 10;

GRAPH.D.Sources = cell(GRAPH.D.Ns+GRAPH.D.Ns_aux,1);
GRAPH.D.Sources{1,1} = 'Ex';  GRAPH.D.Sources{1,2} = 1;   
GRAPH.D.Sources{2,1} = 'Ex';  GRAPH.D.Sources{2,2} = 1;   
% GRAPH.D.Sources{3,1} = 'B';   GRAPH.D.Sources{3,2} = 3; 
% GRAPH.D.Sources{4,1} = 'A';   GRAPH.D.Sources{4,2} = 29; 
% GRAPH.D.Sources{5,1} = 'A';   GRAPH.D.Sources{5,2} = 30;   
% GRAPH.D.Sources{6,1} = 'A';   GRAPH.D.Sources{6,2} = 31;   
% GRAPH.D.Sources{7,1} = 'A';   GRAPH.D.Sources{7,2} = 32;   
% GRAPH.D.Sources{8,1} = 'A';   GRAPH.D.Sources{8,2} = 33;   
% GRAPH.D.Sources{9,1} = 'A';   GRAPH.D.Sources{9,2} = 34;   
% GRAPH.D.Sources{10,1} = 'B';  GRAPH.D.Sources{10,2} = 35;   
% GRAPH.D.Sources{11,1} = 'B';  GRAPH.D.Sources{11,2} = 36;     
% GRAPH.D.Sources{12,1} = 'B';  GRAPH.D.Sources{12,2} = 37;     
% GRAPH.D.Sources{13,1} = 'B';  GRAPH.D.Sources{13,2} = 38;     
% GRAPH.D.Sources{14,1} = 'B';  GRAPH.D.Sources{14,2} = 39;     
% GRAPH.D.Sources{15,1} = 'B';  GRAPH.D.Sources{15,2} = 40;     
% GRAPH.D.Sources{16,1} = 'B';  GRAPH.D.Sources{16,2} = 41;     
% GRAPH.D.Sources{17,1} = 'B';  GRAPH.D.Sources{17,2} = 42;     
% GRAPH.D.Sources{18,1} = 'B';  GRAPH.D.Sources{18,2} = 43;     
% GRAPH.D.Sources{19,1} = 'B';  GRAPH.D.Sources{19,2} = 44;     
% GRAPH.D.Sources{20,1} = 'B';  GRAPH.D.Sources{20,2} = 45;     


Graph.SourceMgmt = Graph_Combine_Code(GRAPH.A, GRAPH.B, GRAPH.C, GRAPH.D);


%% Source Controller definition
Graph.SourceMgmt.Name = 'SourceMgmt';
Graph.SourceMgmt.DT   = 60;
Graph.SourceMgmt.Pin0 = 0;


% SINK ORDER: 94-125
% 94  (1)  - Left HVAC P_other
% 95  (2)  - Left HVAC Deice
% 96  (3)  - HVDC P_other
% 97  (4)  - HVDC P_hydraulic
% 98  (5)  - Left generator temperature
% 99  (6)  - Left wing boost pump power
% 100 (7)  - summation of ACM motors
% 101 (8)  - Right HVAC P_other
% 102 (9)  - Right HVAC deice
% 103 (10) - AEE power
% 104 (11) - LVAC P_other
% 105 (12) - LVDC P shed
% 106 (13) - LVDC P no shed
% 107 (14) - LVAC P no shed
% 108 (15) - LVAC P shed
% 109 (16) - Right generator temperature
% 110 (17) - AEE temperature
% 111 (18) - Right wing boost pump power
% 112 (19) - FADEC power
% 113 (20) - Oil pumps power
% 114 (21) - Hydraulic (not used)
% 115 (22) - Hydraulic (not used)
% 116 (23) - Ambient temperature
% 117 (24) - Ambient temperature
% 118 (25) - Ambient temperature
% 119 (26) - Ambient temperature
% 120 (27) - Ambient temperature
% 121 (28) - Air to left ACM (not used)
% 122 (29) - Air to right ACM (not used)
% 123 (30) - Hydraulic (not used)
% 124 (31) - Liquid to left ACM (not used)
% 125 (32) - Liquid to right ACM (not used)

Graph.SourceMgmt.xt0(1)  = Mission.HVACL_Other.data(1);
Graph.SourceMgmt.xt0(2)  = Mission.HVACL_Wing.data(1);
Graph.SourceMgmt.xt0(3)  = Mission.HVDC_Other.data(1);
Graph.SourceMgmt.xt0(4)  = Mission.HVDC_Hydr.data(1);
Graph.SourceMgmt.xt0(5)  = 50+273;
Graph.SourceMgmt.xt0(6)  = 10;
Graph.SourceMgmt.xt0(7)  = 160;
Graph.SourceMgmt.xt0(8)  = Mission.HVACR_Other.data(1);
Graph.SourceMgmt.xt0(9)  = Mission.HVACR_Wing.data(1);
Graph.SourceMgmt.xt0(10) = Mission.HVAC_AEE.data(1);
Graph.SourceMgmt.xt0(11) = Mission.LVAC_Misc.data(1);
Graph.SourceMgmt.xt0(12) = Mission.LVDC_Shed.data(1);
Graph.SourceMgmt.xt0(13) = Mission.LVDC_NoShed.data(1);
Graph.SourceMgmt.xt0(14) = Mission.LVAC_NoShed.data(1);
Graph.SourceMgmt.xt0(15) = Mission.LVAC_Shed.data(1);
Graph.SourceMgmt.xt0(16) = 50+273;
Graph.SourceMgmt.xt0(17) = 50+273;
Graph.SourceMgmt.xt0(18) = 10;
Graph.SourceMgmt.xt0(19) = Mission.LVDC_FADECs.data(1);
Graph.SourceMgmt.xt0(20) = 10;
Graph.SourceMgmt.xt0(21) = 0;
Graph.SourceMgmt.xt0(22) = 0;
Graph.SourceMgmt.xt0([23:27]) = 273;
Graph.SourceMgmt.xt0([28:32])  = 0;

% INPUT POWER ORDER:
% 1 - Left generator electrical power (max)
% 2 - Right generator electrical power (max)
% 3 - Q into cabin
% 4 - Q into cockpit
% 5 - From left ACM into air loop
% 6 - From right ACM into air loop
% 7 - From left ACM into liquid loop
% 8 - From right ACM into liquid loop

Graph.SourceMgmt.Pin0(1) = 1000;
Graph.SourceMgmt.Pin0(2) = 1000; 
Graph.SourceMgmt.Pin0(3) = 10;
Graph.SourceMgmt.Pin0(4) = 1.5;
Graph.SourceMgmt.Pin0(5) = 1*1*293;         % mdot * Cp * T
Graph.SourceMgmt.Pin0(6) = 1*1*293;         % mdot * Cp * T
Graph.SourceMgmt.Pin0(7) = 0.17*3.53*305;   % mdot * Cp * T
Graph.SourceMgmt.Pin0(8) = 0.17*3.53*305;   % mdot * Cp * T

% baseline control inputs
Graph.SourceMgmt.uC0 = [Ctrl.ElecLeft.uC0 Ctrl.ElecRight.uC0 Ctrl.AirZones.uC0 Ctrl.FluidLoop.uC0]';
Graph.SourceMgmt.uB0 = [Ctrl.ElecLeft.uB0 Ctrl.ElecRight.uB0 [] []]';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Source controller definition
Graph.SourceMgmt.Caps(Graph.SourceMgmt.Caps < 10) = 0; % Make small capacitances zero

eta_FAD = FADEC.eff.max_eta;

CTRL = Graph.SourceMgmt;
CTRL.track.Nx = 0;
CTRL.track.NP = 0;
CTRL.track.Nu = 0;
CTRL.hor = 5;

% sdpvar will not accept an input of 0 in the first argument
% if Ntanks, track.Nx, track.NP, track.Nu, Nm equal 0, these lines set 
% them equal to 1
CTRL.track.Nx   = max(1,CTRL.track.Nx);
CTRL.track.NP   = max(1,CTRL.track.NP);
CTRL.track.Nu   = max(1,CTRL.track.Nu);
CTRL.Nu         = max(1,CTRL.NuC);

%% definiing variables for use with YALMIP
yalmip('clear')
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

% previous inputs
u0_ = sdpvar(repmat(CTRL.NuC+CTRL.NuB ,1,1)          ,ones(1,1));  
x0_ = sdpvar(repmat(CTRL.Nv ,1,1)          ,ones(1,1));  

% slack variable for all states across the horizon
s_    = sdpvar(repmat(CTRL.Nv         ,1,CTRL.hor)   ,ones(1,CTRL.hor));
s2_   = sdpvar(repmat(5       ,1,CTRL.hor)   ,ones(1,CTRL.hor));

% all state (xall_), tracked states (xtr_), and tracked power flows (Ptr_)
% across the horizon
Nx_total = CTRL.Nv+CTRL.Nt+CTRL.Nt_aux;
xall_ = sdpvar(repmat(Nx_total        ,1,CTRL.hor)   ,ones(1,CTRL.hor));
xtr_  = sdpvar(repmat(CTRL.track.Nx   ,1,CTRL.hor)   ,ones(1,CTRL.hor));
Ptr_  = sdpvar(repmat(CTRL.track.NP   ,1,CTRL.hor)   ,ones(1,CTRL.hor));

objs = 0;       % initializing the objective function at 0
cons = [];      % initializing the contraints as an empty set

%% definiing the objective function and constraints

V0 = 270; % 270V bus
I0 = Converters.HVDC.eff.maxI;
V1 = 28; % 28V bus
I1 = Converters.LVDC.eff.maxI;
V2 = 115; % 115V bus
I2 = Converters.LVAC.eff.maxI;

for k = 1:CTRL.hor    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%% OBJECTIVE FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % minimize - slack on states
    objs = objs + 1e4*norm(s_{k},2)^2;   
    objs = objs + 1e2*norm(s2_{k},2)^2;    
    
    % balance generator loading
    objs = objs + .1*norm(P_{k}(1) - P_{k}(35),2)^2;    
    
    % minimize power consumption
    objs = objs + .01*norm(P_{k}(1),2)^2;    
    objs = objs + .01*norm(P_{k}(35),2)^2;  
    
    % minimize number of active converters
    objs = objs + norm(uC_{k}([5:11 13:35]),2)^2;  
         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    % system dynamics
    dyn = find(and(CTRL.Caps~=0,CTRL.Caps~=inf));
    cons = [cons, 1/CTRL.DT*diag(CTRL.Caps(dyn))*(x_{k+1}(dyn)- x_{k}(dyn)) == ...
        (-CTRL.M_upper(dyn,:)*P_{k} + CTRL.D(dyn,:)*Pin_{k})  ];
    
    % fixed system states (i.e. pumps and voltages)
    fix = find(CTRL.Caps==inf);
    cons = [cons, x_{k+1}(fix) == x_{k}(fix)];
    
    % algebraic states
    if k > 1
        alg = find(CTRL.Caps==0);
        cons = [cons, 0 == (-CTRL.M_upper(alg,:)*P_{k} + CTRL.D(alg,:)*Pin_{k})  ];
    end
            
    % battery charge and discharge decision variables - VERIFIED
    cons = [cons, P_{k}(14) == uC_{k}(1)];   % charge rate along edge 14
    cons = [cons, P_{k}(15) == uC_{k}(2)];   % discharge rate along edge 15
    
    % heater power is an input
    cons = [cons, P_{k}(21) == uC_{k}(12)];  
    
    % battery charge and discharge decision variables - VERIFIED
    cons = [cons, P_{k}(48) == uC_{k}(3)];   % charge rate along edge 48
    cons = [cons, P_{k}(49) == uC_{k}(4)];   % discharge rate along edge 49
    
    % no cross over between RPDU source bus - VERIFIED
    cons = [cons, P_{k}(52) == 0];
    cons = [cons, P_{k}(68) == 0];
           
    % uB_{k}(6) == 1 implies charge mode; uB_{k}(6) == 0 implies discharge
    cons = [cons, implies(uB_{k}(6)  , uC_{k}(2) <= 0)];
    cons = [cons, implies(~uB_{k}(6) , uC_{k}(1) <= 0)];
    % uB_{k}(6) == 1 implies charge mode; uB_{k}(6) == 0 implies discharge
    cons = [cons, implies(uB_{k}(12)  , uC_{k}(4) <= 0)];
    cons = [cons, implies(~uB_{k}(12) , uC_{k}(3) <= 0)];
    
    % ~uB_{k}(#) == 1 implies that the inverter is off, and power is 0 - VERIFIED
    cons = [cons, implies(~uB_{k}(2) , P_{k}(4) <= 0)];
    cons = [cons, implies(~uB_{k}(3) , P_{k}(5) <= 0)];
    cons = [cons, implies(~uB_{k}(4) , P_{k}(6) <= 0)];
    cons = [cons, implies(~uB_{k}(5) , P_{k}(7) <= 0)];
    
    % ~uB_{k}(#) == 1 implies that the inverter is off, and power is 0  - VERIFIED
    cons = [cons, implies(~uB_{k}(8)  , P_{k}(38) <= 0)];
    cons = [cons, implies(~uB_{k}(9)  , P_{k}(39) <= 0)];
    cons = [cons, implies(~uB_{k}(10) , P_{k}(40) <= 0)];
    cons = [cons, implies(~uB_{k}(11) , P_{k}(41) <= 0)];
    cons = [cons, implies(~uB_{k}(14) , P_{k}(57) <= 0)];
    cons = [cons, implies(~uB_{k}(15) , P_{k}(58) <= 0)];
    cons = [cons, implies(~uB_{k}(16) , P_{k}(59) <= 0)];
    cons = [cons, implies(~uB_{k}(17) , P_{k}(60) <= 0)];
    
    % at least 1 inverter has to remain on - VERIFIED
    cons = [cons, uB_{k}(1)  == 1];
    cons = [cons, uB_{k}(7)  == 1];
    cons = [cons, uB_{k}(13) == 1];
        
    % bounds on inputs
    cons = [cons, CTRL.u_min <= uC_{k} <= CTRL.u_max ];   
        
    %%%%% vvvv TRANSFER BUS LOGIC vvvv %%%%%
    % if edge 2 == 0, then left HVAC bus is not powering HVDC bus. In this
    % case, right HVAC bus must power the HVDC bus via edge 81
    cons = [cons, P_{k}(81)+P_{k}(2) == P_{k}(3)+P_{k}(4)+P_{k}(5)+P_{k}(6)+P_{k}(7)];
    cons = [cons, implies(P_{k}(81) >= 1, P_{k}(2) == 0)];
    cons = [cons, implies(P_{k}(2) >= 1, P_{k}(81) == 0)];
        
    % if edge 36 == 0, then right HVAC bus is not powering LVDC bus. In this
    % case, left HVAC bus must power the LVDC bus via edge 23
    cons = [cons, P_{k}(23)+P_{k}(36) == P_{k}(37)+P_{k}(38)+P_{k}(39)+P_{k}(40)+P_{k}(41)];
    cons = [cons, implies(P_{k}(23) >= 1, P_{k}(36) == 0)];
    cons = [cons, implies(P_{k}(36) >= 1, P_{k}(23) == 0)];
    
    % if edge 55 == 0, then right HVAC bus is not powering LVAC bus. In this
    % case, left HVAC bus must power the LVAC bus via edge 22
    cons = [cons, P_{k}(22)+P_{k}(55) == P_{k}(56)+P_{k}(57)+P_{k}(58)+P_{k}(59)+P_{k}(60)];
    cons = [cons, implies(P_{k}(22) >= 1, P_{k}(55) == 0)];
    cons = [cons, implies(P_{k}(55) >= 1, P_{k}(22) == 0)];
    %%%%% ^^^^ TRANSFER BUS LOGIC ^^^^ %%%%%
        
    % power supplied by the generators are limited by Pin
    cons = [cons, P_{k}(1)  + P_{k}(20) <= Pin_{k}(1) ];  % left wing generator
    cons = [cons, P_{k}(35) + P_{k}(79) <= Pin_{k}(2) ];  % right wing generator
        
    % algebraic constraints on powers
    cons = [cons, CTRL.W*P_{k} == 0];  
    
    % powers must be greater than 0 and less than max
    cons = [cons, P_{k}(1:101) <= 1000]; % 1000 kW is max electrical load
    cons = [cons, 0 <= P_{k}([1:29 32:100]) ];
    
    % power along edges 16 17 18 19 24 32 71 72 73 74 75 76 77 78 95 96
    % equal the sink state value
    cons = [cons, P_{k}(16)    == xt_{k}(94-CTRL.Nv)];  % Left HVAC Other
    cons = [cons, P_{k}(17)    == xt_{k}(95-CTRL.Nv)];  % Left HVAC Deice
    cons = [cons, P_{k}(18)    == xt_{k}(96-CTRL.Nv)];  % Left HVDC Other
    cons = [cons, P_{k}(19)    == xt_{k}(97-CTRL.Nv)];  % Left HVDC Hydraul
    cons = [cons, P_{k}(24)    == xt_{k}(99-CTRL.Nv)];  % Left HVAC Boost
    cons = [cons, P_{k}(32)    == xt_{k}(100-CTRL.Nv)]; % HVDC ACM motors
    cons = [cons, P_{k}(37+34) == xt_{k}(101-CTRL.Nv)]; % Right HVAC other
    cons = [cons, P_{k}(38+34) == xt_{k}(102-CTRL.Nv)]; % Right HVAC deice
    cons = [cons, P_{k}(39+34) == xt_{k}(103-CTRL.Nv)]; % AEE
    cons = [cons, P_{k}(40+34) == xt_{k}(104-CTRL.Nv)]; % Right LVAC other
    cons = [cons, P_{k}(41+34) == xt_{k}(105-CTRL.Nv)]; % LVDC shed
    cons = [cons, P_{k}(42+34) == xt_{k}(106-CTRL.Nv)]; % LVDC no shed
    cons = [cons, P_{k}(43+34) == xt_{k}(107-CTRL.Nv)]; % LVAC no shed
    cons = [cons, P_{k}(44+34) == xt_{k}(108-CTRL.Nv)]; % LVAC shed
    cons = [cons, P_{k}(48+34) == xt_{k}(111-CTRL.Nv)]; % Right HVAC Boost
    cons = [cons, P_{k}(61+34) == xt_{k}(112-CTRL.Nv)/eta_FAD];% LVDC FADEC
    cons = [cons, P_{k}(62+34) == xt_{k}(113-CTRL.Nv)]; % LVDC oil pumps
    
    % FAN AND PUMP POWER AS A FUNCTION OF FLOW RATES
    % fan power is related to mass flow rate by P =-16.066u^2+47.662x-6.128
    % pump power is related to mass flow rate by P = 0.25733u-0.037658
    cons = [cons, P_{k}(30) == -16.066*uC_{k}(5)*u0_(5)+47.662*uC_{k}(5)-6.128];
    cons = [cons, P_{k}(31) == -16.066*uC_{k}(6)*u0_(6)+47.662*uC_{k}(6)-6.128];
    
    cons = [cons, P_{k}(101) == 0.25733*uC_{k}(13)-0.037658];
        
    % SPLIT AND JUNCTION CONSTRAINTS
    % Air zone -- split and junction between cabin, cockpit, bays
    cons = [cons, uC_{k}(1+4) + uC_{k}(1+4) + s2_{k}(1) == uC_{k}(3+4) + uC_{k}(4+4) + uC_{k}(5+4) + uC_{k}(6+4) + uC_{k}(7+4)];
    
    % fluid loop junctions and splits
    cons = [cons, uC_{k}(1+12) + s2_{k}(2) == uC_{k}(2 +12) + uC_{k}(3 +12) + uC_{k}(4 +12) + uC_{k}(5 +12) + uC_{k}(6 +12)];
    cons = [cons, uC_{k}(3+12) + s2_{k}(3) == uC_{k}(7 +12) + uC_{k}(8 +12) + uC_{k}(9 +12) + uC_{k}(10+12) + uC_{k}(11+12)];
    cons = [cons, uC_{k}(4+12) + s2_{k}(4) == uC_{k}(12+12) + uC_{k}(13+12) + uC_{k}(14+12) + uC_{k}(15+12) + uC_{k}(16+12)];
    cons = [cons, uC_{k}(5+12) + s2_{k}(5) == uC_{k}(17+12) + uC_{k}(18+12) + uC_{k}(19+12) + uC_{k}(20+12) + uC_{k}(21+12)];
    
    % power for blowers - used to be power input, so it did not appear in W
    cons = [cons, P_{k}(1+101) + P_{k}(15+101) == P_{k}(31) ];  
    cons = [cons, P_{k}(2+101) + P_{k}(16+101) == P_{k}(30) ];  
    
    % power to liquid loop pump - used to be a power input, was not in W
    cons = [cons, P_{k}(2+124) + P_{k}(61+124) == P_{k}(101) ];  
    
    % mass flow along these edges has been restricted to zero
    cons = [cons, P_{k}([9 14]+101) == 0];
    
    % squeeze mass flow rates to minimum values when heat load to battery
    % and converter cold plates is zero
    Pndx = [4 5 6:20]+124;
    cons = [cons, uC_{k}([2 6 7:21]+12) <= P_{k}(Pndx) + CTRL.u_min([2 6 7:21]+12)];
        
    % min/max state constraints with slack
    cons = [cons, CTRL.x_min - s_{k} <= x_{k+1} <= CTRL.x_max + s_{k}];       
    
    % concatenating states with sinks
    cons = [cons, xall_{k} == [x_{k};xt_{k}]];
    
    % re-linearized power flow equation for edges of form: mdot*Cp*T
    for i_edge = find(any(CTRL.B,2)')
        if i_edge > 50
            cons = [cons, P_{k}(i_edge) == u0_(find(CTRL.B(i_edge,:)))*...
                (CTRL.E_coeff(i_edge,2) * (xall_{k}(CTRL.E(i_edge,1)) - x0_(CTRL.E(i_edge,1))))+...
                (uC_{k}(find(CTRL.B(i_edge,:)))*CTRL.E_coeff(i_edge,2)*x0_(CTRL.E(i_edge,1))) ];
        end
    end
    
    % edges that follow an hA*deltaT power flow
    for i_edge = find(~any(CTRL.B,2)'-any(CTRL.W,1)) 
        if i_edge > 50
            cons = [cons, P_{k}(i_edge) == (CTRL.E_coeff(i_edge,1)) * ...
                         (CTRL.E_coeff(i_edge,2) * xall_{k}(CTRL.E(i_edge,1)) +...
                          CTRL.E_coeff(i_edge,3) * xall_{k}(CTRL.E(i_edge,2)))];
        end
    end
             
    % keep slack positive
    cons = [cons, 0 <= s_{k}];      % Keep slack non-negative
end

opts = sdpsettings('solver','gurobi');  % Solve with gurobi
Ctrl.SourceMgmt = CTRL;
% Create exported optimization model object
Ctrl.SourceMgmt.Controller = optimizer(cons,objs,opts,{x0_,x_{1},xt_{:},Pin_{:},u0_},[x_,uC_,uB_,P_,s_,s2_]); 

