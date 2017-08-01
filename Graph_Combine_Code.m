function GRAPH = Graph_Combine_Code(varargin)

% Graph.A.Nv       = 2;             % Number of vertices 
% Graph.A.Ne       = 4;             % Number of edges (Power flows)
% Graph.A.Ns       = 2 ;             % Number of sources
% Graph.A.Nt       = 3 ;             % Number of sinks
% 
% Graph.B.Nv       = 2;             % Number of vertices 
% Graph.B.Ne       = 3;             % Number of edges (Power flows)
% Graph.B.Ns       = 2 ;             % Number of sources
% Graph.B.Nt       = 2 ;             % Number of sinks
% 
% % for i = 1:Graph.A.Nv
% %     Graph.A.Verts(
% 
% % Edge matrix 
% Graph.A.E = [1 2;
%              2 3;
%              2 4;
%              1 5];
%          
% Graph.B.E = [1 2;
%              2 3;
%              2 4];
%          
% % Source matrix
% Graph.A.D = zeros(Graph.A.Nv,Graph.A.Ns);
% Graph.A.D(1,1) = 1;
% Graph.A.D(1,2) = 1;
% 
% Graph.B.D = zeros(Graph.B.Nv,Graph.B.Ns);
% Graph.B.D(1,1) = 1;
% Graph.B.D(2,2) = 1;
% 
% % Sink/Source relations  (Sink number is row, Graph power is flowing to is first column,
% % Corresponding vertex in the graph power is flowing to)
% Graph.A.SinkSource = cell(Graph.A.Ns,2);
% Graph.A.SinkSource{1,1} = 'Ex';     % Ex = global sink
% Graph.A.SinkSource{2,1} = 'B'; Graph.A.SinkSource{2,2} = 2;     % to graph B -- in graph B, sink is vertex 2
% Graph.A.SinkSource{3,1} = 'B'; Graph.A.SinkSource{3,2} = 1;     % to graph B -- in graph B, sink is vertex 1
% 
% Graph.B.SinkSource = cell(Graph.B.Ns,2);
% Graph.B.SinkSource{1,1} = 'Ex';
% Graph.B.SinkSource{2,1} = 'A'; Graph.B.SinkSource{2,2} = 1;
% 
% % External Sources -- "global sources"
% Graph.A.Sources = cell(Graph.A.Ns,2);
% % global index for source = 1
% % source is going into Graph A vertex 1
% Graph.A.Sources{1,1} = 'Ex';  Graph.A.Sources{1,2} = 1;
% 
% Graph.B.Sources = cell(Graph.B.Ns,1);
% % Graph.B.Sources{1,1} = 'Ex';  Graph.B.Sources{1,2} = 1; % going into global 3 if it existed
% % Graph.B.Sources{2,1} = 'Ex';  Graph.B.Sources{2,2} = 2; % going into global 4
% 

for i = 1:nargin
    GRAPH.subgraphs(i) = varargin{i};
    GRAPH.subgraph_names{i} = char(64+i);
end

%% dummy variables -- placeholders
GRAPH.Name = 'New Graph';
GRAPH.DT   = 0;
GRAPH.Pin0 = 0;
%% Combined graph
% GRAPH.subgraphs(1) = Graph.A;
% GRAPH.subgraphs(2) = Graph.B;
% GRAPH.subgraph_names = {'A','B'};

%% END USER INPUT
GRAPH.Nv = 0;
GRAPH.Ne = 0;
GRAPH.Ns = 0;
GRAPH.Ns_aux = 0;
GRAPH.Nt = 0;
GRAPH.Nt_aux = 0;
Ns_internal = zeros(length(GRAPH.subgraphs),1);
for i = 1:length(GRAPH.subgraphs)
    GRAPH.Nv = GRAPH.Nv + GRAPH.subgraphs(i).Nv;
    GRAPH.Ne = GRAPH.Ne + GRAPH.subgraphs(i).Ne;
end

z = 0;
GRAPH.Verts = cell(GRAPH.Nv,2);
for i = 1:length(GRAPH.subgraphs)
    GRAPH.Verts(z+1:z+GRAPH.subgraphs(i).Nv,1) = GRAPH.subgraph_names(i);
    GRAPH.Verts(z+1:z+GRAPH.subgraphs(i).Nv,2) = mat2cell([1:GRAPH.subgraphs(i).Nv]',ones(GRAPH.subgraphs(i).Nv,1));
    z = z+ GRAPH.subgraphs(i).Nv;
end

z = 0;
GRAPH.Edges = cell(GRAPH.Ne,2);
for i = 1:length(GRAPH.subgraphs)
    GRAPH.Edges(z+1:z+GRAPH.subgraphs(i).Ne,1) = GRAPH.subgraph_names(i);
    GRAPH.Edges(z+1:z+GRAPH.subgraphs(i).Ne,2) = mat2cell([1:GRAPH.subgraphs(i).Ne]',ones(GRAPH.subgraphs(i).Ne,1));
    z = z+ GRAPH.subgraphs(i).Ne;
end

z = 0;
sink = 0; %GRAPH.Nv+1;
sink2 = 0; Sink_Number = 0;
GRAPH.E = [];
for i = 1:length(GRAPH.subgraphs)
    sink = 0;
    for j = 1:GRAPH.subgraphs(i).Ne
        if GRAPH.subgraphs(i).E(j,2) > GRAPH.subgraphs(i).Nv
%             Sink_Number = GRAPH.subgraphs(i).E(j,2)-GRAPH.subgraphs(i).Nv;
%             Sink_Number = Sink_Number + 1;
            icnt = GRAPH.subgraphs(i).E(j,2)-GRAPH.subgraphs(i).Nv;
            if GRAPH.subgraphs(i).SinkSource{icnt,1} == 'Ex'
                Sink_Number = Sink_Number + 1;
                GRAPH.subgraphs(i).E(j,:) = [GRAPH.subgraphs(i).E(j,1) Sink_Number+GRAPH.Nv+sink2];
                
            else
                y1 = find(ismember(GRAPH.Verts(:,1),GRAPH.subgraphs(i).SinkSource{icnt,1}));
                y2 = find(cell2mat(GRAPH.Verts(y1,2))==GRAPH.subgraphs(i).SinkSource{icnt,2});
                Sink_Vert = y1(y2);
                GRAPH.subgraphs(i).E(j,:) = [GRAPH.subgraphs(i).E(j,1) Sink_Vert];
                sink = sink + 1;
            end
            
            GRAPH.subgraphs(i).E(j,1) = GRAPH.subgraphs(i).E(j,1) + z;
        else
            GRAPH.subgraphs(i).E(j,:) = GRAPH.subgraphs(i).E(j,:) + z;
        end
        GRAPH.E = [GRAPH.E;GRAPH.subgraphs(i).E(j,:)];

    end
    
    z = GRAPH.subgraphs(i).Nv + z;
    sink2 = Sink_Number + sink2; 
    icnt = 0; Sink_Number = 0;
    
end

GRAPH.Nt = sink2;

z = 0;
source = 1;
GRAPH.D = zeros(GRAPH.Nv,0);
for i = 1:length(GRAPH.subgraphs)
    for j = 1:(GRAPH.subgraphs(i).Ns+GRAPH.subgraphs(i).Ns_aux)
        if ~isempty(GRAPH.subgraphs(i).Sources{j,1})
            GRAPH.D(GRAPH.subgraphs(i).Sources{j,2}+z,source) = 1;
            source = source + 1;
        end
    end
    z = z+ GRAPH.subgraphs(i).Nv;
end

GRAPH.Ns = size(GRAPH.D,2);
%% Defining the vertex capacitances by stacking them
GRAPH.Caps = zeros(GRAPH.Nv,1);
z = 0;
for i = 1:length(GRAPH.subgraphs)
    GRAPH.Caps(z+1:z+GRAPH.subgraphs(i).Nv,1) = GRAPH.subgraphs(i).Caps;
    z = z + GRAPH.subgraphs(i).Nv;
    
end

%% defining the Edge coefficients by stacking them
GRAPH.E_coeff = zeros(GRAPH.Ne,4);
z = 0;
for i = 1:length(GRAPH.subgraphs)
    GRAPH.E_coeff(z+1:z+GRAPH.subgraphs(i).Ne,:) = GRAPH.subgraphs(i).E_coeff;
    z = z + GRAPH.subgraphs(i).Ne;
    
end



%% defining values for number of inputs and max/min constraints
GRAPH.NuC = 0;
GRAPH.NuB = 0;
GRAPH.u_min = [];
GRAPH.u_max = [];
GRAPH.x0 = [];
GRAPH.x_min = [];
GRAPH.x_max = [];
% GRAPH.uC0 = [];
% GRAPH.uB0 = [];

i_W = 0;
for i = 1:length(GRAPH.subgraphs)
    GRAPH.NuC = GRAPH.NuC + GRAPH.subgraphs(i).NuC;
    GRAPH.NuB = GRAPH.NuB + GRAPH.subgraphs(i).NuB;
    GRAPH.u_min = [GRAPH.u_min; GRAPH.subgraphs(i).u_min];
    GRAPH.u_max = [GRAPH.u_max; GRAPH.subgraphs(i).u_max];
    GRAPH.x0    = [GRAPH.x0; GRAPH.subgraphs(i).x0];
    GRAPH.x_min = [GRAPH.x_min; GRAPH.subgraphs(i).x_min];
    GRAPH.x_max = [GRAPH.x_max; GRAPH.subgraphs(i).x_max];
%     GRAPH.uC0   = [GRAPH.uC0; GRAPH.subgraphs(i).uC0];
%     GRAPH.uB0   = [GRAPH.uB0; GRAPH.subgraphs(i).uB0];
    
    i_W = i_W + size(GRAPH.subgraphs(i).W,1);
end

%% defining the B matrix by stacking 
GRAPH.B = zeros(GRAPH.Ne,GRAPH.NuC);
z = 0; y = 0;
for i = 1:length(GRAPH.subgraphs)
    GRAPH.B(z+1:z+GRAPH.subgraphs(i).Ne,y+1:y+GRAPH.subgraphs(i).NuC) = GRAPH.subgraphs(i).B;
    z = z + GRAPH.subgraphs(i).Ne;
    y = y + GRAPH.subgraphs(i).NuC;
end

%% defining the W matrix
GRAPH.W = zeros(i_W,GRAPH.Ne);
i_ROW = 0; i_COL = 0;
for i = 1:length(GRAPH.subgraphs)
    GRAPH.W(i_ROW+1:i_ROW+size(GRAPH.subgraphs(i).W,1), ...
            i_COL+1:i_COL+size(GRAPH.subgraphs(i).W,2)) = GRAPH.subgraphs(i).W;
    i_ROW = size(GRAPH.subgraphs(i).W,1) + i_ROW;
    i_COL = size(GRAPH.subgraphs(i).W,2) + i_COL;
end         

%% incidence matrix
GRAPH.M = zeros(GRAPH.Nv+GRAPH.Nt,GRAPH.Ne);
for i = 1:GRAPH.Ne;
    GRAPH.M(GRAPH.E(i,1),i) = 1;
    GRAPH.M(GRAPH.E(i,2),i) = -1;
end
clear i
GRAPH.M_upper = GRAPH.M(1:GRAPH.Nv,:);
GRAPH.M_lower = GRAPH.M(1+GRAPH.Nv:end,:);
GRAPH.Tail    = (GRAPH.M'== 1);
GRAPH.Head    = (GRAPH.M'==-1);