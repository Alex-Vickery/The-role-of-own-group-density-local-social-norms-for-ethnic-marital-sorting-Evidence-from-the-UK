%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION C: TABLES AND FIGURES 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% C.2 - Observed and Predicted Proportion of Intra-Ethnic Marriages -
% FIGURE 6 -> FIG6.m

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
% PLOT FIGURE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% transfer data to array
x = table2array(wm(1:11,1:3)); % change this for different eth, gender combination
% marker size
sz=700;

% plot figure 
figure('Name','figure11-wm')
set(gcf,'color','w','Position', get(0, 'Screensize'));
scatter(x(:,1),x(:,2),sz,[67/255,162/255,202/255],'filled')
grid on
box on
hold on 
scatter(x(:,1),x(:,3),sz,[123/255,204/255,196/255],'filled','s')
xlabel('Prop. of Whites','Interpreter','latex','FontSize',30)
ylabel('Prop. of intra-ethnic marriages','Interpreter','latex','FontSize',30)
set(get(gca,'ylabel'),'Units', 'Normalized', 'Position', [-0.1, 0.5, 0])
a = get(gca,'XTickLabel'); 
set(gca,'XTickLabel',a,'TickLabelInterpreter', 'latex','fontsize',40)
a = get(gca,'YTickLabel'); 
set(gca,'YTickLabel',a,'TickLabelInterpreter', 'latex','fontsize',50)

% the green data below is to create the figure for Blacks and Asians
% yticks([0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1])
% labs = {0, [], 0.2, [], 0.4, [], 0.6, [], 0.8, [], 1};
% yticklabels(labs);
% xticks([0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1])
% lab = {0, [], 0.02, [], 0.04, [], 0.06, [], 0.08, [], 0.1};
% xticklabels(lab);

% this is for whites
xticks([0.8 0.82 0.84 0.86 0.88 0.9 0.92 0.94 0.96 0.98 1])
lab = {0.8, [], 0.84, [], 0.88, [], 0.92, [], 0.96, [], 1};
xticklabels(lab);
yticks([0.96 0.965 0.97 0.975 0.98 0.985 0.99 0.995 1])
labs = {0.96, [], 0.97, [], 0.98, [], 0.99, [], 1};
yticklabels(labs);

[h, hobj, hout, mout] = legend({'Observed{   }','Predicted  '},'Interpreter','latex');
 h.FontSize = 50;
 h.Orientation = 'horizontal';
 set(h,'units','normalized');
set(h,'position',[0.87,0.2,0,0.2])
h.NumColumns = 1;
M = findobj(hobj,'type','patch');
set(M,'MarkerSize',30);
[HLeg,HLegBack,HAxBack] = resizeLegend('Scale',0.99);
HAxBack.YLim = [0.955,1]; % reset grid % whites
%HAxBack.YLim = [0,1]; % reset grid  % use for black and asian
HAxBack.XLim = [0.82,1]; % reset grid % whites
%HAxBack.XLim = [0,0.1]; % reset grid  % use for black and asian

lx = [x(9,1)];
ly = [x(9,3)];
labels = {'London'};
labelpoints(lx, ly, labels,'position','NE','buffer',0.9,'interpreter','latex','FontSize',50)
nx = [x(7,1)];
ny = [x(7,3)];
labels = {'West Midlands'};
labelpoints(nx, ny, labels,'position','NW','buffer',0.9,'interpreter','latex','FontSize',50)
annotation('arrow',[0.26, 0.185],[0.65,0.64],'LineWidth',1) % wm
annotation('arrow',[0.26, 0.185],[0.65,0.52],'LineWidth',1)
annotation('rectangle',[.21 .65 .105 .08],'LineWidth',1)
annotation('rectangle',[.31 .74 .20 .08],'LineWidth',1)
annotation('arrow',[0.51, 0.535],[0.78,0.79],'LineWidth',1)
annotation('arrow',[0.51, 0.535],[0.78,0.72],'LineWidth',1)

% annotation('arrow',[0.26, 0.185],[0.69,0.68],'LineWidth',1) % wf 
% annotation('arrow',[0.26, 0.185],[0.69,0.53],'LineWidth',1)
% annotation('rectangle',[.21 .69 .105 .08],'LineWidth',1)
% annotation('rectangle',[.31 .78 .20 .08],'LineWidth',1)
% annotation('arrow',[0.51, 0.535],[0.8,0.84],'LineWidth',1)
% annotation('arrow',[0.51, 0.535],[0.8,0.77],'LineWidth',1)

% annotation('arrow',[0.84, 0.765],[0.75,0.73],'LineWidth',1) % bm
% annotation('arrow',[0.84, 0.765],[0.75,0.705],'LineWidth',1)
% annotation('rectangle',[.79 .75 .105 .08],'LineWidth',1)
% annotation('rectangle',[.30 .64 .20 .08],'LineWidth',1)
% annotation('arrow',[0.30, 0.28],[0.66,0.63],'LineWidth',1)
% annotation('arrow',[0.30, 0.28],[0.66,0.61],'LineWidth',1)

% annotation('arrow',[0.79, 0.765],[0.68,0.63],'LineWidth',1) % bf
% annotation('arrow',[0.79, 0.765],[0.68,0.605],'LineWidth',1)
% annotation('rectangle',[.79 .64 .105 .08],'LineWidth',1)
% annotation('rectangle',[.3 .49 .20 .08],'LineWidth',1)
% annotation('arrow',[0.30, 0.28],[0.51,0.47],'LineWidth',1)
% annotation('arrow',[0.30, 0.28],[0.51,0.45],'LineWidth',1)

% annotation('arrow',[0.785, 0.81],[0.84,0.775],'LineWidth',1) % am
% annotation('arrow',[0.785, 0.81],[0.84,0.725],'LineWidth',1)
% annotation('rectangle',[.68 .785 .105 .08],'LineWidth',1)
% annotation('rectangle',[.41 .82 .20 .08],'LineWidth',1)
% annotation('arrow',[0.61, 0.63],[0.84,0.865],'LineWidth',1)
% annotation('arrow',[0.61, 0.63],[0.84,0.795],'LineWidth',1)

% annotation('arrow',[0.785, 0.805],[0.84,0.815],'LineWidth',1) % af
% annotation('arrow',[0.785, 0.805],[0.84,0.805],'LineWidth',1)
% annotation('rectangle',[.68 .83 .105 .08],'LineWidth',1)
% annotation('rectangle',[.54 .69 .20 .08],'LineWidth',1)
% annotation('arrow',[0.61, 0.63],[0.77,0.84],'LineWidth',1)
% annotation('arrow',[0.61, 0.63],[0.77,0.80],'LineWidth',1)


axis([0.82 1 0.955 1]) % whites 
%axis([0 0.1 0 1]) % black and asian
