%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION C: TABLES AND FIGURES 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% Figure 4: Proportion Intra-Ethnic Marriages by Region and Gender ->
% FIG4.m

% load in the data 
clearvars;
load('data.mat')

% create the x data
datm = zeros(3,fxdpar.k);
datf = zeros(3,fxdpar.k);
for r = 1:fxdpar.k
a = repmat(dat.cnt_m(:,:,r),1,6).*dat.M_pre(:,:,r);
b = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*dat.F_pre(:,:,r);
    for x = 1:3
    datm(x,r) = (a(2*x-1,2*x-1)+a(2*x-1,2*x)+a(2*x,2*x-1)+a(2*x,2*x))/(sum(a(:,2*x-1)) + sum(a(:,2*x))); 
    datf(x,r) = (b(2*x-1,2*x-1)+b(2*x-1,2*x)+b(2*x,2*x-1)+b(2*x,2*x))/(sum(b(2*x-1,:)) + sum(b(2*x,:))); 
    end

end 

male = [1,datm(:,9)';2,datm(:,7)';3,datm(:,6)';4,datm(:,5)';5,datm(:,4)';6,datm(:,10)';7,datm(:,8)';8,datm(:,3)';9,datm(:,11)';10,datm(:,2)';11,datm(:,1)'];
female = [1,datf(:,9)';2,datf(:,7)';3,datf(:,6)';4,datf(:,5)';5,datf(:,4)';6,datf(:,10)';7,datf(:,8)';8,datf(:,3)';9,datf(:,11)';10,datf(:,2)';11,datf(:,1)'];

comb = [male(1,:);female(1,:);
        male(2,:);female(2,:);
        male(3,:);female(3,:);
        male(4,:);female(4,:);
        male(5,:);female(5,:);
        male(6,:);female(6,:);
        male(7,:);female(7,:);
        male(8,:);female(8,:);
        male(9,:);female(9,:);
        male(10,:);female(10,:);
        male(11,:);female(11,:)];

regions = [1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32];

figure('Name','figure8-males')
set(gcf,'color','w','Position', get(0, 'Screensize'));
bar(regions,comb(:,2:4),'BarWidth',0.9);
pos=get(gca,'position');
pos(4)=0.87;        % try reducing width 10%
set(gca,'position',pos);
grid on
xticks([1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32])
xticklabels({'m','f','m','f','m','f','m','f','m','f','m','f','m','f','m','f','m','f','m','f','m','f'})
%ylabel('\% of total','Interpreter','latex','FontSize',20)
%set(get(gca,'ylabel'),'Units', 'Normalized', 'Position', [-0.05, 0.5, 0])
a = get(gca,'XTickLabel'); 
set(gca,'XTickLabel',a,'TickLabelInterpreter', 'latex','fontsize',20)
h = legend({'White','Black','Asian'},'Interpreter','latex');
 h.FontSize = 20;
 hline = refline(0,0);
 hline.Color = 'k';
 hline.LineWidth = 2;
 hline.HandleVisibility = 'off';
 h.Orientation = 'horizontal';
%set(h,'Location','southoutside')
set(h,'units','normalized');
set(h,'position',[0.47,0.007,0.1,0.02])
%[HLeg,HLegBack,HAxBack] = resizeLegend('Scale',0.99);
%HAxBack.YLim = [0,1]; % reset grid 
%HAxBack.XLim = [0,32.5]; % reset grid 

 axis([0 32.5 0 1]) 
 text(1.5,-0.065,'London','Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(4.5,-0.065,{'West';'Midlands'},'Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(7.5,-0.065,{'East';'Midlands'},'Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(10.5,-0.065,'Yorkshire','Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(13.5,-0.065,{'North';'West'},'Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(16.5,-0.065,{'South';'East'},'Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(19.5,-0.065,'Eastern','Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(22.5,-0.065,{'North';'East'},'Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(25.5,-0.065,{'South';'West'},'Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(28.5,-0.065,'Scotland','Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 text(31.5,-0.065,'Wales','Interpreter','latex','fontsize',20,'HorizontalAlignment', 'center')
 

















