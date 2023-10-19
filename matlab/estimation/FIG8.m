%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION C: TABLES AND FIGURES 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% C.6 - Predicted Shares of Intra-Ethnic Marriages - FIGURE 8 -> FIG8.m
% load in the data 
clearvars;

% load in data 
load('spec3.mat'); % predicted
load('data.mat'); % data

% wm
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
wm1 = zeros(fxdpar.k,1);
wm2 = zeros(fxdpar.k,1);
propw = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*dat.M_pre(:,:,r);
    numijm2(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*pred3.Mm(:,:,r);
    wm1(r,1) = (numijm1(1,1,r) + numijm1(1,2,r)+ numijm1(2,1,r) + numijm1(2,2,r))/(sum(numijm1(:,1,r)) + sum(numijm1(:,2,r)));
    wm2(r,1) = (numijm2(1,1,r) + numijm2(1,2,r)+ numijm2(2,1,r) + numijm2(2,2,r))/(sum(numijm2(:,1,r)) + sum(numijm2(:,2,r)));
    propw(r,1) = (dat.cnt_m(1,1,r) + dat.cnt_m(2,1,r) + dat.cnt_f(1,1,r) + dat.cnt_f(2,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
wm = table(propw, wm1, wm2);
clear numijm1 numijm2 propw; 

% wf
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
wf1 = zeros(fxdpar.k,1);
wf2 = zeros(fxdpar.k,1);
propw = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*dat.F_pre(:,:,r);
    numijm2(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*pred3.Mf(:,:,r);
    wf1(r,1) = (numijm1(1,1,r) + numijm1(1,2,r)+ numijm1(2,1,r) + numijm1(2,2,r))./(sum(numijm1(1,:,r)) + sum(numijm1(2,:,r)));
    wf2(r,1) = (numijm2(1,1,r) + numijm2(1,2,r)+ numijm2(2,1,r) + numijm2(2,2,r))./(sum(numijm2(1,:,r)) + sum(numijm2(2,:,r)));
    propw(r,1) = (dat.cnt_m(1,1,r) + dat.cnt_m(2,1,r) + dat.cnt_f(1,1,r) + dat.cnt_f(2,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
wf = table(propw, wf1, wf2);
clear numijm1 numijm2 propw;

% bm
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
bm1 = zeros(fxdpar.k,1);
bm2 = zeros(fxdpar.k,1);
propb = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*dat.M_pre(:,:,r);
    numijm2(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*pred3.Mm(:,:,r);
    bm1(r,1) = (numijm1(3,3,r) + numijm1(3,4,r)+ numijm1(4,3,r) + numijm1(4,4,r))./(sum(numijm1(:,3,r)) + sum(numijm1(:,4,r)));
    bm2(r,1) = (numijm2(3,3,r) + numijm2(3,4,r)+ numijm2(4,3,r) + numijm2(4,4,r))./(sum(numijm2(:,3,r)) + sum(numijm2(:,4,r)));
    propb(r,1) = (dat.cnt_m(3,1,r) + dat.cnt_m(4,1,r) + dat.cnt_f(3,1,r) + dat.cnt_f(4,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
bm = table(propb, bm1, bm2);
clear numijm1 propb; 

% bf
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
bf1 = zeros(fxdpar.k,1);
bf2 = zeros(fxdpar.k,1);
propb = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*dat.F_pre(:,:,r);
    numijm2(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*pred3.Mf(:,:,r);
    bf1(r,1) = (numijm1(3,3,r) + numijm1(3,4,r)+ numijm1(4,3,r) + numijm1(4,4,r))./(sum(numijm1(3,:,r)) + sum(numijm1(4,:,r)));
    bf2(r,1) = (numijm2(3,3,r) + numijm2(3,4,r)+ numijm2(4,3,r) + numijm2(4,4,r))./(sum(numijm2(3,:,r)) + sum(numijm2(4,:,r)));
    propb(r,1) = (dat.cnt_m(3,1,r) + dat.cnt_m(4,1,r) + dat.cnt_f(3,1,r) + dat.cnt_f(4,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
bf = table(propb, bf1, bf2);
clear numijm1 propb; 

% am
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
am1 = zeros(fxdpar.k,1);
am2 = zeros(fxdpar.k,1);
propa = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*dat.M_pre(:,:,r);
    numijm2(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*pred3.Mm(:,:,r);
    am1(r,1) = (numijm1(5,5,r) + numijm1(5,6,r)+ numijm1(6,5,r) + numijm1(6,6,r))./(sum(numijm1(:,5,r)) + sum(numijm1(:,6,r)));
    am2(r,1) = (numijm2(5,5,r) + numijm2(5,6,r)+ numijm2(6,5,r) + numijm2(6,6,r))./(sum(numijm2(:,5,r)) + sum(numijm2(:,6,r)));
    propa(r,1) = (dat.cnt_m(5,1,r) + dat.cnt_m(6,1,r) + dat.cnt_f(5,1,r) + dat.cnt_f(6,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
am = table(propa, am1, am2);
clear numijm1 propa;

% af
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
af1 = zeros(fxdpar.k,1);
af2 = zeros(fxdpar.k,1);
propa = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*dat.F_pre(:,:,r);
    numijm2(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*pred3.Mf(:,:,r);
    af1(r,1) = (numijm1(5,5,r) + numijm1(5,6,r)+ numijm1(6,5,r) + numijm1(6,6,r))./(sum(numijm1(5,:,r)) + sum(numijm1(6,:,r)));
    af2(r,1) = (numijm2(5,5,r) + numijm2(5,6,r)+ numijm2(6,5,r) + numijm2(6,6,r))./(sum(numijm2(5,:,r)) + sum(numijm2(6,:,r)));
    propa(r,1) = (dat.cnt_m(5,1,r) + dat.cnt_m(6,1,r) + dat.cnt_f(5,1,r) + dat.cnt_f(6,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
af = table(propa, af1, af2);
clear numijm1 propa; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load in the counterfactual data 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the below data is created by the counterfactuals.m script

load('wmcount.mat');
load('bmcount.mat');
load('amcount.mat');
load('wfcount.mat');
load('bfcount.mat');
load('afcount.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FIGURE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = table2array(af(1:11,1:3)); % set to asian women - change for other ethnic groups
sz=700;

figure('Name','figure8-wm')
set(gcf,'color','w','Position', get(0, 'Screensize'));
scatter(x(:,1),x(:,3),sz,[123/255,204/255,196/255],'filled','s')
hold on 
grid on
box on
scatter(propa,afcount1,sz,[186/255,228/255,188/255],'filled','d') % change here for other ethnic groups
scatter(propa,afcount2,sz,[8/255,104/255,172/255],'filled','^') % change here for other ethnic groups
a = get(gca,'XTickLabel'); 
set(gca,'XTickLabel',a,'TickLabelInterpreter', 'latex','fontsize',30)

% these axes are for whites
% xticks([0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1])
% lab = {0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1};
% xticklabels(lab);
% yticks([ 0.92 0.925 0.93 0.935 0.94 0.945 0.95 0.955 0.96 0.965 0.97 0.975 0.98 0.985 0.99 0.995 1])
% labs = {[], [], 0.93, [], 0.94, [], 0.95, [], 0.96, [], 0.97, [], 0.98, [], 0.99, [], 1};
% yticklabels(labs);

xlabel('Prop. of Asians','Interpreter','latex','FontSize',30)
label_h = ylabel('Prop. of intra-ethnic marriages','Interpreter','latex','FontSize',30);

% these values are for whites
%label_h.Position(1) = 0.56;
%label_h.Position(2) = 0.96;

% these values are for black and Asian
label_h.Position(1) = -0.02;
label_h.Position(2) = 0.5;

% these values are for black and Asian
xticks([0 0.02 0.04 0.06 0.08 0.1 0.12 0.14 0.16 0.18 0.2])
lab = {0, [], 0.04, [], 0.08, [], 0.12, [], 0.16, [], 0.2};
xticklabels(lab);
yticks([0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1])
labs = {0, [], 0.2, [], 0.4, [], 0.6, [], 0.8, [], 1};
yticklabels(labs);

a = get(gca,'YTickLabel'); 
set(gca,'YTickLabel',a,'TickLabelInterpreter', 'latex','fontsize',50)


% legend 
%[h, hobj, hout, mout] = legend({'Predicted: Recent Cohorts, Model w/o Social Preferences{   }','Predicted: Recent Cohorts, Contemporaneous Norms{   }', 'Predicted: Recent Cohorts, Lagged Norms'},'Interpreter','latex');
[h, hobj, hout, mout] = legend({'Predicted: Estimating Cohorts{   }','Predicted: Recent Cohorts, Contemporaneous Norms{   }', 'Predicted: Recent Cohorts, Lagged Norms'},'Interpreter','latex');
h.FontSize = 30;
h.Orientation = 'horizontal';
set(h,'units','normalized');
%set(h,'position',[0.605,0.15,0,0.2])
set(h,'position',[0.795,0.15,0,0.2])
%set(h,'position',[0.81,0.15,0,0.2])
h.NumColumns = 1;
M = findobj(hobj,'type','patch');
set(M,'MarkerSize',30);
[HLeg,HLegBack,HAxBack] = resizeLegend('Scale',0.99);
%HAxBack.YLim = [0.92,1]; % reset grid 
HAxBack.YLim = [0,1]; % reset grid 
HAxBack.XLim = [0,0.2]; % reset grid 

% annotation('arrow',[0.26, 0.185],[0.66,0.64],'LineWidth',1) % wm
% annotation('arrow',[0.26, 0.185],[0.66,0.42],'LineWidth',1)
% annotation('arrow',[0.315, 0.56],[0.69,0.76],'LineWidth',1)
% dim = [.21 .66 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

% annotation('arrow',[0.26, 0.185],[0.66,0.64],'LineWidth',1) % wm
% annotation('arrow',[0.26, 0.185],[0.66,0.42],'LineWidth',1)
% annotation('arrow',[0.26, 0.185],[0.66,0.62],'LineWidth',1)
% dim = [.21 .66 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

% annotation('arrow',[0.21, 0.185],[0.675,0.68],'LineWidth',1) % wf
% annotation('arrow',[0.26, 0.185],[0.66,0.495],'LineWidth',1)
% annotation('arrow',[0.315, 0.56],[0.69,0.78],'LineWidth',1)
% dim = [.21 .66 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

% annotation('arrow',[0.21, 0.185],[0.68,0.685],'LineWidth',1) % wf
% annotation('arrow',[0.21, 0.18],[0.68,0.49],'LineWidth',1)
% annotation('arrow',[0.21, 0.185],[0.68,0.675],'LineWidth',1)
% dim = [.21 .66 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

% annotation('arrow',[0.725, 0.84],[0.68,0.855],'LineWidth',1) % bm
% annotation('arrow',[0.725, 0.84],[0.68,0.81],'LineWidth',1)
% annotation('arrow',[0.62, 0.46],[0.68,0.725],'LineWidth',1)
% dim = [.62 .65 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

% annotation('arrow',[0.725, 0.84],[0.68,0.855],'LineWidth',1) % bm
% annotation('arrow',[0.725, 0.84],[0.68,0.82],'LineWidth',1)
% annotation('arrow',[0.725, 0.84],[0.68,0.79],'LineWidth',1)
% dim = [.62 .65 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);


% annotation('arrow',[0.725, 0.84],[0.68,0.80],'LineWidth',1) % bf
% annotation('arrow',[0.725, 0.84],[0.68,0.725],'LineWidth',1)
% annotation('arrow',[0.62, 0.46],[0.68,0.62],'LineWidth',1)
% dim = [.62 .65 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

% annotation('arrow',[0.725, 0.84],[0.68,0.80],'LineWidth',1) % bf
% annotation('arrow',[0.725, 0.84],[0.68,0.73],'LineWidth',1)
% annotation('arrow',[0.725, 0.84],[0.68,0.71],'LineWidth',1)
% dim = [.62 .65 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

% annotation('arrow',[0.725, 0.85],[0.68,0.835],'LineWidth',1) % am
% annotation('arrow',[0.725, 0.85],[0.68,0.80],'LineWidth',1)
% annotation('arrow',[0.62, 0.49],[0.68,0.76],'LineWidth',1)
% dim = [.62 .65 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

% annotation('arrow',[0.725, 0.85],[0.68,0.835],'LineWidth',1) % am
% annotation('arrow',[0.725, 0.85],[0.68,0.80],'LineWidth',1)
% annotation('arrow',[0.725, 0.85],[0.68,0.81],'LineWidth',1)
% dim = [.62 .65 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

annotation('arrow',[0.725, 0.85],[0.68,0.87],'LineWidth',1) % af
annotation('arrow',[0.725, 0.85],[0.68,0.835],'LineWidth',1)
annotation('arrow',[0.62, 0.49],[0.68,0.81],'LineWidth',1)
dim = [.62 .65 .105 .06];
str = 'London';
annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

% annotation('arrow',[0.725, 0.85],[0.68,0.87],'LineWidth',1) % af
% annotation('arrow',[0.725, 0.85],[0.68,0.835],'LineWidth',1)
% annotation('arrow',[0.725, 0.85],[0.68,0.845],'LineWidth',1)
% dim = [.62 .65 .105 .06];
% str = 'London';
% annotation('textbox',dim,'String',str,'interpreter','latex','FontSize',50,'LineWidth',1);

axis([0 0.2 0 1])
%axis([0.6 1 0.92 1])





