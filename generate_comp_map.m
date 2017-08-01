function MAP = generate_comp_map(PR_MAX,MF_MAX,N_MAX,eta_MAX,eta_MIN,SKEW_X,SKEW_Y,plot_flg)
% % user inputs
% PR_MAX = 5;
% MF_MAX = 2;
% N_MAX  = 75000;
% eta_MAX = 80;
% eta_MIN = 35;
% SKEW_X  = 1;
% SKEW_Y  = 2;
% plot_flg = 1;

% variable definition
raw_data;
Data001(:,1) = Data001(:,1)*MF_MAX;
Data001(:,2) = (Data001(:,2)-1)*(PR_MAX-1)+1;
DATA.r10  = Data001(1:4,:);
DATA.r20  = Data001(5:10,:);
DATA.r30  = Data001(11:18,:);
DATA.r40  = Data001(19:26,:);
DATA.r50  = Data001(27:34,:);
DATA.r60  = Data001(35:42,:);
DATA.r70  = Data001(43:50,:);
DATA.r80  = Data001(51:58,:);
DATA.r90  = Data001(59:66,:);
DATA.r100 = Data001(67:74,:);
fn = fieldnames(DATA);

% efficiency curve parameters
u = 0:0.04:1.96;
v = 0:0.01:2*pi;
[U,V] = meshgrid(u,v);

x   =  SKEW_X*U.*cos(V-0.7)+ 0.55*MF_MAX;
y   =  SKEW_Y*U.*sin(V)    + (.45*(PR_MAX-1)+1);
eta = -U.^2;
eta = (eta - min(min(eta)));
eta = eta./max(max(eta))*(eta_MAX-eta_MIN)/100+eta_MIN/100;
clear u v
% figure; surf(x,y,eta)
% shading interp
% view(gca,[0 90]); colorbar
x(x<0) = 0; 

%% pull the surgeline data points from the DATA structure
surgeline = [];
for i = 1:numel(fieldnames(DATA))
    eval(['surgeline = [surgeline; DATA.',fn{i},'(1,:)];']);
end
surgeline(1,1) = 0;

%% make tables

% lookup vectors
PR_VEC  = linspace(1,PR_MAX,25);
MDOT_VEC = linspace(0,MF_MAX,20);
N_VEC    = linspace(.1*N_MAX,N_MAX,10);

% EFFICIENCY DATA
ETA_DATA = zeros(20,25)+eta_MIN/100;

% round values to nearest in lookup table
roundTargets = MDOT_VEC;
v = x;
mdot_rounded = interp1(roundTargets,roundTargets,v,'nearest');
roundTargets = PR_VEC;
v = y;
pr_rounded   = interp1(roundTargets,roundTargets,v,'nearest');

for i = 1:size(eta,2)
    for j = 1:size(eta,1)
        i_mdot = find(mdot_rounded(j,i)== MDOT_VEC);
        i_PR   = find(pr_rounded(j,i)  == PR_VEC);
        ETA_DATA(i_mdot,i_PR) = eta(j,i);
    end
end

MAP.PR_VEC = PR_VEC;
MAP.MDOT_VEC = MDOT_VEC;
MAP.ETA = ETA_DATA;
MAP.N_VEC = N_VEC;
% FLOW RATE DATA
MDOT_DATA = zeros(10,25);

x1 = []; y1 = []; z1 = []; 
for i = 1:size(fn,1);
    x1 = [x1; N_VEC(i)*ones(size(eval(['DATA.',fn{i},'(:,2)'])))];
    y1 = [y1; eval(['DATA.',fn{i},'(:,2)'])];
    z1 = [z1; eval(['DATA.',fn{i},'(:,1)'])];
end

[xData, yData, zData] = prepareSurfaceData( x1, y1, z1 );

% Set up fittype and options.
ft = fittype( 'poly22' );

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft );

for i = 1:max(size(N_VEC))
    for j = 1:numel(PR_VEC)
        MDOT_DATA(i,j) = fitresult.p00 + fitresult.p10*N_VEC(i) + fitresult.p01*PR_VEC(j) + ...
            fitresult.p20*N_VEC(i)^2 + fitresult.p11*N_VEC(i)*PR_VEC(j) + fitresult.p02*PR_VEC(j)^2;
    end
end
MDOT_DATA(MDOT_DATA<0) = 0; 

MAP.MDOT = MDOT_DATA;

%% PLOT THE MAP
if plot_flg
%     set(0,'defaultLineLineWidth',2)
    set(0,'defaultAxesFontName', 'Times')
    set(0,'defaultTextFontName', 'Times')
    set(0,'defaultAxesFontSize', 11)
    set(0,'defaultTextFontSize', 11)
%% this code generates the efficiency lines
    figure('Units','inches'); hold on; box on; grid on;
    set(gcf,'Position',[8 4 8 4])
    surgeline = [surgeline; surgeline(end,:)];
    DATA.r100 = [DATA.r100; DATA.r100(end,:)];
    for i = 5:5:size(eta,2);
    %         i = 50;
        indx = []; 
        for j = 1:numel(x(:,i))

            xl = surgeline(  max(find(x(j,i) >= surgeline(1:10,1))) ,1);
            xh = surgeline(1+max(find(x(j,i) >= surgeline(1:10,1))) ,1);
            yl = surgeline(  max(find(x(j,i) >= surgeline(1:10,1))) ,2);
            yh = surgeline(1+max(find(x(j,i) >= surgeline(1:10,1))) ,2);

            m = (yh-yl)/(xh-xl); b = yh-m*xh; 

            if y(j,i) > m*x(j,i) + b
                indx = [indx; j];
            end
        end
        if ~isempty(indx); 
            ind2 = size([max(indx):numel(x(:,i)) 1:min(indx)],2);
            x(1:ind2,i) = x([max(indx):numel(x(:,i)) 1:min(indx)],i);
            y(1:ind2,i) = y([max(indx):numel(y(:,i)) 1:min(indx)],i);
            x(ind2+1:end,i) =  x(ind2,i);
            y(ind2+1:end,i) =  y(ind2,i);
        end

        % find data points that are above the max RPM line
        indx = []; 
        for j = 1:numel(x(:,i))

            xl = DATA.r100(max(find(x(j,i)   >= DATA.r100(1:8,1))) ,1);
            xh = DATA.r100(1+max(find(x(j,i) >= DATA.r100(1:8,1))) ,1);
            yl = DATA.r100(max(find(x(j,i)   >= DATA.r100(1:8,1))) ,2);
            yh = DATA.r100(1+max(find(x(j,i) >= DATA.r100(1:8,1))) ,2);

            m = (yh-yl)/(xh-xl); b = yh-m*xh; 
            if isempty(m)
                m = 0; b = PR_MAX;
            end
            if y(j,i) > m*x(j,i) + b
                indx = [indx; j];
            end
        end

        % avoids plotting the data points outside of the DATA
        if ~isempty(indx); 
            clear section
            A = 1:numel(x(:,i)); A(indx) = 0;
            ne0 = find(A~=0);                                   
            ix0 = unique([ne0(1) ne0(diff([0 ne0])>1)]);        
            B = [find(diff([0 ne0])>1)-1 length(ne0)]; B = B(B~=0);
            ix1 = ne0(B);   % Segment End Indices
            for k1 = 1:length(ix0)
                section{k1} = A(ix0(k1):ix1(k1));
            end
            for k = 1:numel(section)
                plot(x(section{k},i),y(section{k},i),'r-','Linewidth',1)
            end
        else
            plot(x(:,i),y(:,i),'r-','Linewidth',1)
        end
    end


    % plot the DATA
    set(gca,'GridLineStyle',':')
    xlim([0 MF_MAX]); ylim([0.95 PR_MAX])
    plot(surgeline(:,1),surgeline(:,2),'-k','Linewidth',2)
    for i = 1:numel(fieldnames(DATA))
        eval(['x1 = DATA.',fn{i},';']);
        plot(x1(:,1),x1(:,2),'-ob','Linewidth',1);
        
    end
    for i = 1:numel(fieldnames(DATA))
        eval(['x1 = DATA.',fn{i},';']);
        try
            if 1
                lbl = str2num(fn{i}(2:end))/100*N_MAX/1000;
                text(x1(5,1)+.03*MF_MAX,x1(5,2),[sprintf('%0.1f',lbl),'k'],...
                    'BackgroundColor',[1 1 1],'EdgeColor',[0 0 0]);
                lbl = str2num(fn{i}(2:end))/100*N_MAX/1000;
                text(x1(5,1)+.03*MF_MAX,x1(5,2),[sprintf('%0.1f',lbl),'k']);
            end
        catch
        end
    end
    tix=get(gca,'xtick')';
    set(gca,'xticklabel',num2str(tix,'%.1f'))
    tix=get(gca,'ytick')';
    set(gca,'yticklabel',num2str(tix,'%.1f'))

    xlabel('Mass flow rate [kg/s]');
    ylabel('$\Pi_C$');
end