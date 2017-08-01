%% NOTE: THE VEHICLE CONTROLLER COMBINES GRAPHS SOURCEMGMT AND SINKMGMT. 
% THIS CODE SETS CTRL1 EQUAL TO SOURCEMGMT AND CTRL2 EQUAL TO SINKMGMT

CTRL1 = Graph.SourceMgmt;
CTRL1.track.Nx = 0;
CTRL1.track.NP = 0;
CTRL1.track.Nu = 0;
CTRL1.hor = 5;


% sdpvar will not accept an input of 0 in the first argument
% if Ntanks, track.Nx, track.NP, track.Nu, Nm equal 0, these lines set 
% them equal to 1
CTRL1.track.Nx   = max(1,CTRL1.track.Nx);
CTRL1.track.NP   = max(1,CTRL1.track.NP);
CTRL1.track.Nu   = max(1,CTRL1.track.Nu);
CTRL1.Nu         = max(1,CTRL1.NuC);

CTRL2 = Ctrl.SinkMgmt;

CTRL2.N_track = 1;
CTRL2.indx_track = [5];

CTRL1.Caps(CTRL1.Caps < 200) = 0; % Make small capacitances zero
CTRL2.Caps(CTRL2.Caps < 200) = 0; % Make small capacitances zero

clear CTRL
CTRL.DT = 600;
CTRL.hor = 5;

CTRL.Nv     = CTRL1.Nv+CTRL2.Nv;
CTRL.Ne     = CTRL1.Nv+CTRL2.Ne;
CTRL.Ns     = CTRL1.Nv+CTRL2.Ns;
CTRL.Nt     = CTRL1.Nv+CTRL2.Nt;
CTRL.NuC    = CTRL1.NuC+CTRL2.NuC;

CTRL.Nv1    = CTRL1.Nv;
CTRL.Ne1    = CTRL1.Ne;
CTRL.Ns1    = CTRL1.Ns;
CTRL.Nt1    = CTRL1.Nt;
CTRL.NuC1   = CTRL1.NuC;
CTRL.NuB1   = CTRL1.NuB;

CTRL.Nv2    = CTRL2.Nv;
CTRL.Ne2    = CTRL2.Ne;
CTRL.Ns2    = CTRL2.Ns;
CTRL.Nt2    = CTRL2.Nt;
CTRL.NuC2   = CTRL2.NuC;

%% defining variables for use with YALMIP
yalmip('clear')
% Sources (Pin_) and sinks (xt_) -- including preview across the horizon
Pin1_  = sdpvar(repmat(CTRL1.Ns + CTRL1.Ns_aux, 1, CTRL1.hor), ones(1,CTRL1.hor));
xt1_   = sdpvar(repmat(CTRL1.Nt + CTRL1.Nt_aux, 1, CTRL1.hor), ones(1,CTRL1.hor));
Pin2_  = sdpvar(repmat(CTRL2.Ns+CTRL2.Ns_aux, 1, CTRL2.hor), ones(1,CTRL2.hor));
xt2_   = sdpvar(repmat(CTRL2.Nt+CTRL2.Nt_aux, 1, CTRL2.hor), ones(1,CTRL2.hor));
Pin1    = sdpvar(repmat(CTRL1.Ns + CTRL1.Ns_aux, 1, CTRL1.hor), ones(1,CTRL1.hor));
Pin2    = sdpvar(repmat(CTRL2.Ns+CTRL2.Ns_aux, 1, CTRL2.hor), ones(1,CTRL2.hor));

% states (x_), power flows (P_), and inputs (u_) across the horizon
x1_    = sdpvar(repmat(CTRL1.Nv         ,1,CTRL1.hor+1) ,ones(1,CTRL1.hor+1));
P1_    = sdpvar(repmat(CTRL1.Ne         ,1,CTRL1.hor)   ,ones(1,CTRL1.hor));
uC1_   = sdpvar(repmat(CTRL1.NuC        ,1,CTRL1.hor)   ,ones(1,CTRL1.hor));
uB1_   = binvar(repmat(CTRL1.NuB        ,1,CTRL1.hor)   ,ones(1,CTRL1.hor));
x2_    = sdpvar(repmat(CTRL2.Nv         ,1,CTRL2.hor+1) ,ones(1,CTRL2.hor+1));
P2_    = sdpvar(repmat(CTRL2.Ne         ,1,CTRL2.hor)   ,ones(1,CTRL2.hor));
uC2_   = sdpvar(repmat(CTRL2.NuC        ,1,CTRL2.hor)   ,ones(1,CTRL2.hor));
shed   = sdpvar(repmat(1         ,1,1) ,ones(1,1));
z2_    = sdpvar(repmat(CTRL2.N_track     ,1,CTRL2.hor+1)   ,ones(1,CTRL2.hor+1));
ref2_  = sdpvar(repmat(CTRL2.N_track     ,1,1)   ,ones(1,1));
Caps_  = sdpvar(repmat(5         ,1,1) ,ones(1,1));

% mass of fuel tanks
Mtanks2_  = sdpvar(repmat(5         ,1,CTRL2.hor+1) ,ones(1,CTRL2.hor+1));

% inputs (mdots) set outside of subsystem used to constrain inputs for flow
% to sinks
uext2_   = sdpvar(repmat(10        ,1,CTRL2.hor)   ,ones(1,CTRL2.hor));

% previous inputs and current states
u01_ = sdpvar(repmat(CTRL1.NuC+CTRL1.NuB ,1,1)          ,ones(1,1));  
x01_ = sdpvar(repmat(CTRL1.Nv ,1,1)          ,ones(1,1));  
u02_ = sdpvar(repmat(CTRL2.NuC+CTRL2.NuB ,1,1)          ,ones(1,1));  
x02_ = sdpvar(repmat(CTRL2.Nv ,1,1)          ,ones(1,1));  
x0all = sdpvar(repmat(CTRL1.Nv+CTRL2.Nv ,1,1)          ,ones(1,1));  

% slack variable for all states across the horizon
s11_    = sdpvar(repmat(CTRL1.Nv         ,1,CTRL1.hor)   ,ones(1,CTRL1.hor));
s21_   = sdpvar(repmat(5       ,1,CTRL1.hor)   ,ones(1,CTRL1.hor));
s31_   = sdpvar(repmat(CTRL1.NuC       ,1,CTRL1.hor)   ,ones(1,CTRL1.hor));
s12_    = sdpvar(repmat(CTRL2.Nv         ,1,CTRL2.hor)   ,ones(1,CTRL2.hor));
% slack variable for input constraints across the horizon
s22_    = sdpvar(repmat(14+6     ,1,CTRL2.hor)   ,ones(1,CTRL2.hor));
% soft slack near constraints
s32_   = sdpvar(repmat(CTRL2.Nv         ,1,CTRL2.hor)   ,ones(1,CTRL2.hor));

% all state (xall_), tracked states (xtr_), and tracked power flows (Ptr_)
% across the horizon
Nx_total = CTRL1.Nv+CTRL1.Nt+CTRL1.Nt_aux;
xall1_   = sdpvar(repmat(Nx_total        ,1,CTRL1.hor)   ,ones(1,CTRL1.hor));
Nx_total = CTRL2.Nv+CTRL2.Nt+CTRL2.Nt_aux;
xall2_   = sdpvar(repmat(Nx_total        ,1,CTRL2.hor)   ,ones(1,CTRL2.hor));

objs = 0;       % initializing the objective function at 0
cons = [];      % initializing the contraints as an empty set

%% definiing the objective function and constraints
for k = 1:CTRL.hor    
    
%%%%%%%%%%%%%%%%%%%%%%% OBJECTIVE FUNCTION SOURCES %%%%%%%%%%%%%%%%%%%%%%%%
    % minimize - slack on states
    objs = objs + 1e9*norm(s11_{k},2)^2;   
    objs = objs + 1e6*norm(s21_{k},2)^2;   
    objs = objs + 1e6*norm(s31_{k},2)^2;   
          
%%%%%%%%%%%%%%%%%%%%%%%% OBJECTIVE FUNCTION SINKS %%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % minimize - slack on states
    objs = objs + 1e6*norm(s12_{k},2)^2;   
    objs = objs + 1e6*norm(s22_{k},2)^2; 
    objs = objs + 1e0*norm(s32_{k},2)^2;  
    
    % minimize auxiliary tank temperatures (v(12 and v(41))
    objs = objs + 1e-2*norm(x2_{k+1}([12 41]),2)^2;
    
    % minimize load shedding
    objs = objs + 1e0*norm(P1_{k}(41+34) - xt1_{k}(105-CTRL1.Nv),2)^2; % LVDC shed
    objs = objs + 1e0*norm(P1_{k}(44+34) - xt1_{k}(108-CTRL1.Nv),2)^2; % LVAC shed
    objs = objs + 1e0*norm(P1_{k}(37+34) - xt1_{k}(101-CTRL1.Nv),2)^2; % Right HVAC other
    objs = objs + 1e0*norm(P1_{k}(16)    - xt1_{k}(94-CTRL1.Nv) ,2)^2;  % Left HVAC Other
    objs = objs + 1e0*norm(P1_{k}(18)    - xt1_{k}(96-CTRL1.Nv) ,2)^2;  % Left HVDC Other

%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS SOURCES %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % system dynamics
    dyn = find(and(CTRL1.Caps~=0,CTRL1.Caps~=inf));
    cons = [cons, 1/CTRL1.DT*diag(CTRL1.Caps(dyn))*(x1_{k+1}(dyn)- x1_{k}(dyn)) == ...
        (-CTRL1.M_upper(dyn,:)*P1_{k} + CTRL1.D(dyn,:)*Pin1{k})  ];
    
    % replacing the input powers with the coupled powers to the other graph
    cons = [cons, Pin1{k} == [Pin1_{k}(1:4); P2_{k}(120); P2_{k}(142); P2_{k}(119); P2_{k}(141)]];
    
    % fixed system states (i.e. pumps and voltages)
    fix = find(CTRL1.Caps==inf);
    cons = [cons, x1_{k+1}(fix) == x1_{k}(fix)];
    
    % algebraic states
    if k > 1
        alg = find(CTRL1.Caps==0);
        cons = [cons, 0 == (-CTRL1.M_upper(alg,:)*P1_{k} + CTRL1.D(alg,:)*Pin1{k})  ];
    end
            
    % battery charge and discharge decision variables - VERIFIED
    cons = [cons, P1_{k}(14) == uC1_{k}(1)];   % charge rate along edge 14
    cons = [cons, P1_{k}(15) == uC1_{k}(2)];   % discharge rate along edge 15
    
    % heater power is an input
    cons = [cons, P1_{k}(21) == uC1_{k}(12)];  
    
    % battery charge and discharge decision variables - VERIFIED
    cons = [cons, P1_{k}(48) == uC1_{k}(3)];   % charge rate along edge 48
    cons = [cons, P1_{k}(49) == uC1_{k}(4)];   % discharge rate along edge 49
    
    % no cross over between RPDU source bus - VERIFIED
    cons = [cons, P1_{k}(52) == 0];
    cons = [cons, P1_{k}(68) == 0];
           
    % uB_{k}(6) == 1 implies charge mode; uB_{k}(6) == 0 implies discharge
    cons = [cons, implies(uB1_{k}(6)  , uC1_{k}(2) <= 0)];
    cons = [cons, implies(~uB1_{k}(6) , uC1_{k}(1) <= 0)];
    % uB_{k}(6) == 1 implies charge mode; uB_{k}(6) == 0 implies discharge
    cons = [cons, implies(uB1_{k}(12)  , uC1_{k}(4) <= 0)];
    cons = [cons, implies(~uB1_{k}(12) , uC1_{k}(3) <= 0)];
    
    % ~uB_{k}(#) == 1 implies that the inverter is off, and power is 0 - VERIFIED
    cons = [cons, implies(~uB1_{k}(2) , P1_{k}(4) <= 0)];
    cons = [cons, implies(~uB1_{k}(3) , P1_{k}(5) <= 0)];
    cons = [cons, implies(~uB1_{k}(4) , P1_{k}(6) <= 0)];
    cons = [cons, implies(~uB1_{k}(5) , P1_{k}(7) <= 0)];
    
    % ~uB_{k}(#) == 1 implies that the inverter is off, and power is 0  - VERIFIED
    cons = [cons, implies(~uB1_{k}(8)  , P1_{k}(38) <= 0)];
    cons = [cons, implies(~uB1_{k}(9)  , P1_{k}(39) <= 0)];
    cons = [cons, implies(~uB1_{k}(10) , P1_{k}(40) <= 0)];
    cons = [cons, implies(~uB1_{k}(11) , P1_{k}(41) <= 0)];
    cons = [cons, implies(~uB1_{k}(14) , P1_{k}(57) <= 0)];
    cons = [cons, implies(~uB1_{k}(15) , P1_{k}(58) <= 0)];
    cons = [cons, implies(~uB1_{k}(16) , P1_{k}(59) <= 0)];
    cons = [cons, implies(~uB1_{k}(17) , P1_{k}(60) <= 0)];
    
    % at least 1 inverter has to remain on - VERIFIED
    cons = [cons, uB1_{k}(1)  == 1];
    cons = [cons, uB1_{k}(7)  == 1];
    cons = [cons, uB1_{k}(13) == 1];
    
    % bounds on inputs
    cons = [cons, CTRL1.u_min <= uC1_{k} <= CTRL1.u_max ];   
        
    %%%%% vvvv TRANSFER BUS LOGIC vvvv %%%%%
    % if edge 2 == 0, then left HVAC bus is not powering HVDC bus. In this
    % case, right HVAC bus must power the HVDC bus via edge 81
    cons = [cons, P1_{k}(81)+P1_{k}(2) == P1_{k}(3)+P1_{k}(4)+P1_{k}(5)+P1_{k}(6)+P1_{k}(7)];
    cons = [cons, implies(P1_{k}(81) >= 1, P1_{k}(2) == 0)];
    cons = [cons, implies(P1_{k}(2) >= 1, P1_{k}(81) == 0)];
        
    % if edge 36 == 0, then right HVAC bus is not powering LVDC bus. In this
    % case, left HVAC bus must power the LVDC bus via edge 23
    cons = [cons, P1_{k}(23)+P1_{k}(36) == P1_{k}(37)+P1_{k}(38)+P1_{k}(39)+P1_{k}(40)+P1_{k}(41)];
    cons = [cons, implies(P1_{k}(23) >= 1, P1_{k}(36) == 0)];
    cons = [cons, implies(P1_{k}(36) >= 1, P1_{k}(23) == 0)];
    
    % if edge 55 == 0, then right HVAC bus is not powering LVAC bus. In this
    % case, left HVAC bus must power the LVAC bus via edge 22
    cons = [cons, P1_{k}(22)+P1_{k}(55) == P1_{k}(56)+P1_{k}(57)+P1_{k}(58)+P1_{k}(59)+P1_{k}(60)];
    cons = [cons, implies(P1_{k}(22) >= 1, P1_{k}(55) == 0)];
    cons = [cons, implies(P1_{k}(55) >= 1, P1_{k}(22) == 0)];
    %%%%% ^^^^ TRANSFER BUS LOGIC ^^^^ %%%%%
        
    % power supplied by the generators are limited by Pin
    cons = [cons, P1_{k}(1)  + P1_{k}(20) <= Pin1_{k}(1) ];  % left wing generator
    cons = [cons, P1_{k}(35) + P1_{k}(79) <= Pin1_{k}(2) ];  % right wing generator
        
    % algebraic constraints on powers
    cons = [cons, CTRL1.W*P1_{k} == 0];  
    
    % powers must be greater than 0 and less than max
    cons = [cons, P1_{k}(1:100) <= 1000]; % 1000 kW is max electrical load
    cons = [cons, 0 <= P1_{k}([1:29 32:100]) ];
       
    eta_FAD = 0.9;  % FADEC efficiency
    
    % constrain power flows to equal the loads
    cons = [cons, P1_{k}(17)    == xt1_{k}(95-CTRL1.Nv)];  % Left HVAC Deice
    cons = [cons, P1_{k}(19)    == xt1_{k}(97-CTRL1.Nv)];  % Left HVDC Hydraul   
    cons = [cons, P1_{k}(24)    == xt1_{k}(99-CTRL1.Nv)];  % Left HVAC Boost
    cons = [cons, P1_{k}(32)    == xt1_{k}(100-CTRL1.Nv)]; % HVDC ACM motors
    cons = [cons, P1_{k}(38+34) == xt1_{k}(102-CTRL1.Nv)]; % Right HVAC deice
    cons = [cons, P1_{k}(39+34) == xt1_{k}(103-CTRL1.Nv)]; % AEE
    cons = [cons, P1_{k}(40+34) == xt1_{k}(104-CTRL1.Nv)]; % Right LVAC other
    cons = [cons, P1_{k}(42+34) == xt1_{k}(106-CTRL1.Nv)]; % LVDC no shed
    cons = [cons, P1_{k}(43+34) == xt1_{k}(107-CTRL1.Nv)]; % LVAC no shed
    cons = [cons, P1_{k}(48+34) == xt1_{k}(111-CTRL1.Nv)]; % Right HVAC Boost
    cons = [cons, P1_{k}(61+34) == xt1_{k}(112-CTRL1.Nv)/eta_FAD];% LVDC FADEC
    cons = [cons, P1_{k}(62+34) == xt1_{k}(113-CTRL1.Nv)]; % LVDC oil pumps
       
    % FAN AND PUMP POWER AS A FUNCTION OF FLOW RATES
    % fan power is related to mass flow rate by P =-16.066u^2+47.662x-6.128
    % pump power is related to mass flow rate by P = 0.25733u-0.037658
    cons = [cons, P1_{k}(30) == -16.066*uC1_{k}(5)*u01_(5)+47.662*uC1_{k}(5)-6.128];
    cons = [cons, P1_{k}(31) == -16.066*uC1_{k}(6)*u01_(6)+47.662*uC1_{k}(6)-6.128];
    
    cons = [cons, P1_{k}(101) == 0.25733*uC1_{k}(13)-0.037658];
        
    % SPLIT AND JUNCTION CONSTRAINTS
    % Air zone -- split and junction between cabin, cockpit, bays
    cons = [cons, uC1_{k}(1+4) + uC1_{k}(1+4) + s21_{k}(1) == uC1_{k}(3+4) + uC1_{k}(4+4) + uC1_{k}(5+4) + uC1_{k}(6+4) + uC1_{k}(7+4)];
    
    % fluid loop junctions and splits
    cons = [cons, uC1_{k}(1+12) + s21_{k}(2) == uC1_{k}(2 +12) + uC1_{k}(3 +12) + uC1_{k}(4 +12) + uC1_{k}(5 +12) + uC1_{k}(6 +12)];
    cons = [cons, uC1_{k}(3+12) + s21_{k}(3) == uC1_{k}(7 +12) + uC1_{k}(8 +12) + uC1_{k}(9 +12) + uC1_{k}(10+12) + uC1_{k}(11+12)];
    cons = [cons, uC1_{k}(4+12) + s21_{k}(4) == uC1_{k}(12+12) + uC1_{k}(13+12) + uC1_{k}(14+12) + uC1_{k}(15+12) + uC1_{k}(16+12)];
    cons = [cons, uC1_{k}(5+12) + s21_{k}(5) == uC1_{k}(17+12) + uC1_{k}(18+12) + uC1_{k}(19+12) + uC1_{k}(20+12) + uC1_{k}(21+12)];
    
    % power for blowers - used to be power input, so it did not appear in W
    cons = [cons, P1_{k}(1+101) + P1_{k}(15+101) == P1_{k}(31) ];  
    cons = [cons, P1_{k}(2+101) + P1_{k}(16+101) == P1_{k}(30) ];  
    
    % power to liquid loop pump - used to be a power input, was not in W
    cons = [cons, P1_{k}(2+124) + P1_{k}(61+124) == P1_{k}(101) ];  
    
    % mass flow along these edges has been restricted to zero
    cons = [cons, P1_{k}([9 14]+101) == 0];
    
    % squeeze mass flow rates to minimum values when heat load to battery
    % and converter cold plates is zero
    Pndx = [4 5 6:20]+124;
    cons = [cons, uC1_{k}([2 6 7:21]+12) <= P1_{k}(Pndx) + CTRL1.u_min([2 6 7:21]+12)];
        
    % min/max state constraints with slack
    cons = [cons, CTRL1.x_min - s11_{k} <= x1_{k+1} <= CTRL1.x_max + s11_{k}];       
    
    % concatenating states with sinks
    cons = [cons, xall1_{k} == [x1_{k};xt1_{k}]];
    
    % re-linearized power flow equation for edges of form: mdot*Cp*T
    for i_edge = find(any(CTRL1.B,2)')
        if i_edge > 50
            cons = [cons, P1_{k}(i_edge) == u01_(find(CTRL1.B(i_edge,:)))*...
                (CTRL1.E_coeff(i_edge,2) * (xall1_{k}(CTRL1.E(i_edge,1)) - x01_(CTRL1.E(i_edge,1))))+...
                (uC1_{k}(find(CTRL1.B(i_edge,:)))*CTRL1.E_coeff(i_edge,2)*x01_(CTRL1.E(i_edge,1))) ];
        end
    end
    
    % edges that follow an hA*deltaT power flow
    for i_edge = find(~any(CTRL1.B,2)'-any(CTRL1.W,1)) 
        if i_edge > 50
            cons = [cons, P1_{k}(i_edge) == (CTRL1.E_coeff(i_edge,1)) * ...
                         (CTRL1.E_coeff(i_edge,2) * xall1_{k}(CTRL1.E(i_edge,1)) +...
                          CTRL1.E_coeff(i_edge,3) * xall1_{k}(CTRL1.E(i_edge,2)))];
        end
    end
             
    % keep slack positive
    cons = [cons, 0 <= s11_{k}];      % Keep slack non-negative
    
%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS SINKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % system dynamics
    tanks = [12 13 41 42];
    cons = [cons, 1/CTRL2.DT*diag(Caps_(2:5))*(x2_{k+1}(tanks)- x2_{k}(tanks)) == ...
        (-CTRL2.M_upper(tanks,:)*P2_{k}*0 + ones(4,1)*sum([33 40 67 74]))  ];
    
    % dynamic states
    dyn = setdiff(setdiff(find(CTRL2.Caps~=0),find(CTRL2.Caps==inf)),tanks);
    cons = [cons, 1/CTRL2.DT*diag(CTRL2.Caps(dyn))*(x2_{k+1}(dyn)- x2_{k}(dyn)) == ...
        (-CTRL2.M_upper(dyn,:)*P2_{k} + CTRL2.D(dyn,:)*Pin2_{k})  ];
    
    % algebraic states
    alg = find(CTRL2.Caps==0);
    if k == 1
        objs = objs + 1e3*norm(-CTRL2.M_upper(alg,:)*P2_{k} + CTRL2.D(alg,:)*Pin2_{k},2)^2;
    end
    if k > 1
        cons = [cons, 0 == (-CTRL2.M_upper(alg,:)*P2_{k} + CTRL2.D(alg,:)*Pin2_{k})  ];
    end
    
    % fixed states
    fixed = find(CTRL2.Caps==inf);
    cons = [cons, x2_{k+1}(fixed) == x2_{k}(fixed)];
        
    % Constraints for turbomachinery exit temperatures
    cons = [cons, x2_{k+1}(15+64) - x2_{k+1}(16+64) == 3.5991e-6*u02_(1+36)*uC2_{k}(1+36) - 3.0449e-3*uC2_{k}(1+36) + 6.8272e0];
    cons = [cons, x2_{k+1}(4+64)  - x2_{k+1}(5+64)  == 7.5455e-6*u02_(1+36)*uC2_{k}(1+36) - 1.9692e-2*uC2_{k}(1+36) + 3.5914e1];
    cons = [cons, x2_{k+1}(15+80) - x2_{k+1}(16+80) == 3.5991e-6*u02_(1+46)*uC2_{k}(1+46) - 3.0449e-3*uC2_{k}(1+46) + 6.8272e0];
    cons = [cons, x2_{k+1}(4+80)  - x2_{k+1}(5+80)  == 7.5455e-6*u02_(1+46)*uC2_{k}(1+46) - 1.9692e-2*uC2_{k}(1+46) + 3.5914e1];
    
    % min/max state constraints with slack
    cons = [cons, CTRL2.x_min - s12_{k} <= x2_{k+1} <= CTRL2.x_max + s12_{k}]; 
    cons = [cons, x2_{k+1}+2 <= CTRL2.x_max + s32_{k}]; 
    
    % keep slack positive
    cons = [cons, 0 <= s12_{k}];      % Keep slack non-negative
    
    % min/max input constraints
    cons = [cons, CTRL2.u_min <= uC2_{k} <= CTRL2.u_max];
    
    % set minimum recirc flow rate
    cons = [cons, 0.25 <= uC2_{k}([31 33])];

    % concatenating states with sinks
    cons = [cons, xall2_{k} == [x2_{k};xt2_{k}]];
    
    % Mass of tanks
    if k == 1
        cons = [cons, Mtanks2_{k} == Caps_/Graph.FuelLoop.Cp_fluid];
    end
    cons = [cons, Mtanks2_{k+1}(1) == Mtanks2_{k}(1) - CTRL2.DT*uC2_{k}(1)];
    cons = [cons, Mtanks2_{k+1}(2) == Mtanks2_{k}(2) + CTRL2.DT*(uC2_{k}(7)+uC2_{k}(21)-uC2_{k}(12))];
    cons = [cons, Mtanks2_{k+1}(3) == Mtanks2_{k}(3) + CTRL2.DT*(uC2_{k}(8)+uC2_{k}(20)-uC2_{k}(9))];
    cons = [cons, Mtanks2_{k+1}(4) == Mtanks2_{k}(4) + CTRL2.DT*(uC2_{k}(5)+uC2_{k}(26)-uC2_{k}(16))];
    cons = [cons, Mtanks2_{k+1}(5) == Mtanks2_{k}(5) + CTRL2.DT*(uC2_{k}(6)+uC2_{k}(25)-uC2_{k}(13))];
    
    cons = [cons, 10 <= Mtanks2_{k+1}];
    
    % split and junction constraints
    cons = [cons, s22_{k}(1) == uC2_{k}(1) + uC2_{k}(10) + uC2_{k}(14) - uC2_{k}(2)];
    cons = [cons, s22_{k}(2) == uC2_{k}(2) - uC2_{k}(3) - uC2_{k}(4)];
    cons = [cons, s22_{k}(3) == uC2_{k}(3) - uC2_{k}(5) - uC2_{k}(6)];
    cons = [cons, s22_{k}(4) == uC2_{k}(4) - uC2_{k}(7) - uC2_{k}(8)];
    cons = [cons, s22_{k}(5) == uC2_{k}(9) - uC2_{k}(10) - uC2_{k}(11)];
    cons = [cons, s22_{k}(6) == uC2_{k}(13) - uC2_{k}(14) - uC2_{k}(15)];
    cons = [cons, s22_{k}(7) == uC2_{k}(11) + uC2_{k}(12) - uC2_{k}(17)];
    cons = [cons, s22_{k}(8) == uC2_{k}(15) + uC2_{k}(16) - uC2_{k}(22)];
    cons = [cons, s22_{k}(9) == uC2_{k}(17) - uC2_{k}(18) - uC2_{k}(19)];
    cons = [cons, s22_{k}(10) == uC2_{k}(22) - uC2_{k}(23) - uC2_{k}(24)];
    cons = [cons, s22_{k}(11) == uC2_{k}(17) - uC2_{k}(31) - uC2_{k}(32)];
    cons = [cons, s22_{k}(12) == uC2_{k}(22) - uC2_{k}(33) - uC2_{k}(34)];
    cons = [cons, s22_{k}(13) == uC2_{k}(31) - uC2_{k}(20) - uC2_{k}(21)];
    cons = [cons, s22_{k}(14) == uC2_{k}(33) - uC2_{k}(25) - uC2_{k}(26)];
    cons = [cons, uC2_{k}(2+36) + s22_{k}(15) == uC2_{k}(3+36) + uC2_{k}(4+36)];
    cons = [cons, uC2_{k}(2+36) + s22_{k}(16) == uC2_{k}(5+36) + uC2_{k}(6+36)];
    cons = [cons, uC2_{k}(2+36) + s22_{k}(17) == -7.1181e-8*u02_(1+36)*uC2_{k}(1+36) + 8.6399e-4*uC2_{k}(1+36) - 8.2273e-1];  
    cons = [cons, uC2_{k}(2+46) + s22_{k}(18) == uC2_{k}(3+46) + uC2_{k}(4+46)];
    cons = [cons, uC2_{k}(2+46) + s22_{k}(19) == uC2_{k}(5+46) + uC2_{k}(6+46)];
    cons = [cons, uC2_{k}(2+46) + s22_{k}(20) == -7.1181e-8*u02_(1+46)*uC2_{k}(1+46) + 8.6399e-4*uC2_{k}(1+46) - 8.2273e-1];  
    
    % sink flow constraints
    cons = [cons, uC2_{k}([32 34 35 36]) == uext2_{k}(1:4)];
    cons = [cons, uC2_{k}([7 9 10]+36) == uext2_{k}(5:7)];
    cons = [cons, uC2_{k}([7 9 10]+46) == uext2_{k}(8:10)];
    
    % flow through ACM fuel heat exchanger
    cons = [cons, uC2_{k}(8+36) == uC2_{k}(18)];
    cons = [cons, uC2_{k}(8+46) == uC2_{k}(23)];
    
    % edges that follow an mdot*Cp*T power flow
    for i_edge = setdiff(find(any(CTRL2.B,2)'),[90:94 140 98 97 118])
        cons = [cons, P2_{k}(i_edge) == u02_(find(CTRL2.B(i_edge,:)))*...
            (CTRL2.E_coeff(i_edge,2) * (xall2_{k}(CTRL2.E(i_edge,1)) - x02_(CTRL2.E(i_edge,1))))+...
            (uC2_{k}(find(CTRL2.B(i_edge,:)))*CTRL2.E_coeff(i_edge,2)*x02_(CTRL2.E(i_edge,1))) ];
    end
    
    % edges that follow an mass drain compensation
    for i_edge = [90:91 93:94]
        cons = [cons, P2_{k}(i_edge) ==  (sum(uC2_{k}(find(CTRL2.B(i_edge,:)==1)))-uC2_{k}(find(CTRL2.B(i_edge,:)==-1)))*...
            CTRL2.E_coeff(i_edge,2)*x02_(CTRL2.E(i_edge,1))];
    end
    for i_edge = [92]
        cons = [cons, P2_{k}(i_edge) ==  (-uC2_{k}(find(CTRL2.B(i_edge,:)==-1)))*...
            CTRL2.E_coeff(i_edge,2)*x02_(CTRL2.E(i_edge,1))];
    end
    
    % edges that follow an hA*deltaT power flow
    for i_edge = find(~any(CTRL2.B,2)'-any(CTRL2.W,1)) 
        cons = [cons, P2_{k}(i_edge) == (CTRL2.E_coeff(i_edge,1)) * ...
                     (CTRL2.E_coeff(i_edge,2) * xall2_{k}(CTRL2.E(i_edge,1)) +...
          	          CTRL2.E_coeff(i_edge,3) * xall2_{k}(CTRL2.E(i_edge,2)))];
    end
    
    % algebraic constraints on powers
    cons = [cons, CTRL2.W*P2_{k} == 0];  
    
    % power flows in
    cons = [cons, P2_{k}(24) + P2_{k}(83) == Pin2_{k}(9) ];
    cons = [cons, P2_{k}(58) + P2_{k}(85) == Pin2_{k}(10)];
    cons = [cons, P2_{k}(34) + P2_{k}(86) == Pin2_{k}(11)];
    cons = [cons, P2_{k}(68) + P2_{k}(89) == Pin2_{k}(12)];
    cons = [cons, P2_{k}(41) + P2_{k}(87) == Pin2_{k}(13)];
    cons = [cons, P2_{k}(75) + P2_{k}(88) == Pin2_{k}(14)];
    cons = [cons, P2_{k}( 3) + P2_{k}(84) == Pin2_{k}(16)];
    
    
    %% coupling the generators and fuel
    cons = [cons, Pin2_{k}(5) == P1_{k}(20)];
    cons = [cons, Pin2_{k}(6) == P1_{k}(45+34)];
    
    %% coupling the ACMS and the liquid
    cons = [cons, Pin2_{k}(18) == P1_{k}(34+67+23+32)];
    cons = [cons, Pin2_{k}(21) == P1_{k}(34+67+23+32)];
    
    %% coupling the ACMS and the air
    cons = [cons, Pin2_{k}(19) == P1_{k}(34+67+22)];
    cons = [cons, Pin2_{k}(22) == P1_{k}(34+67+23)];

end
%% Generate the controller
% Solve with gurobi, time limit = 30s
opts = sdpsettings('solver','gurobi','gurobi.TimeLimit',30);  
Ctrl.Vehicle = CTRL; 
% Create exported optimization model object
Ctrl.Vehicle.Controller = optimizer(cons,objs,opts,{[x01_;x02_],x1_{1},x2_{1},xt1_{:},xt2_{:},Pin1_{:},Pin2_{:},u01_,u02_,Caps_},[x1_,x2_,Mtanks2_,s11_,s12_,P1_,P2_]);