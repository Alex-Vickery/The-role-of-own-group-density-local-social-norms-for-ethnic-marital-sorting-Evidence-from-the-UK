%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION C: TABLES AND FIGURES 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% Distribution of Social Norms -> FIGURE 7 -> FIG7.m
% Want to show the locality of norms - a plot of Z against regions

% load in the data 
clearvars;
load('spec3.mat');
load('data.mat');

% add in the normalised region effect term
Spec3.FE_est = [0;Spec3.FE_est];
 
% need to create a Z for each ij - 36 x 11 matrix
clear Z z FE snm snf; 

% marriage surplus
z = reshape(Spec3.Z_est,[36,1]); 
z = repmat(z,1,11);

% region effects 
fe = reshape(Spec3.FE_est, [1,11]);
fe = repmat(fe,36,1);

% social norms males
snm = Spec3.PE_est(1,1)*log(pred3.Mm);
snm = reshape(snm,[36,1,11]);
snm = reshape(snm,[36,11]);

% social norms females
snf = Spec3.PE_est(2,1)*log(pred3.Mf);
snf = reshape(snf,[36,1,11]);
snf = reshape(snf,[36,11]);

% combine together
Z = z + fe + snm + snf;
Z = Z';
z = z';
fe = fe';
snm = snm';
snf=snf';
sn = snm + snf;
det = z;

% mean of the terms
m = mean(sn);
reg = ones(11,1);

X = [1 3 5 7];
% marker size 
sz = 100;

% use 3x3 grid  
figure('Name','Show Norms');
set(gcf,'color','w','Position', get(0, 'Screensize'));
[ha, pos] = tight_subplot(3,3,[.04 .04],[.1 .08],[.12 .01]); 
% ww
%subplot(3,3,1);
axes(ha(1));
%boxplot(Z(:,[1:2,7:8]),'orientation','horizontal','Widths',1,'Symbol','ok','Whisker',10,'positions', X) 
scatter(det(:,1),reg,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
hold on
scatter(sn(:,1),reg,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,1) m(1,1)],[0.7 1.3],'Color','k','LineStyle','-')

scatter(det(:,2),reg+1,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,2),reg+1,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,2) m(1,2)],[1.7 2.3],'Color','k','LineStyle','-')

scatter(det(:,7),reg+2,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,7),reg+2,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,7) m(1,7)],[2.7 3.3],'Color','k','LineStyle','-')

scatter(det(:,8),reg+3,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,8),reg+3,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,8) m(1,8)],[3.7 4.3],'Color','k','LineStyle','-')
set(findobj(gca,'type','line'),'linew',0.9)
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.1);
 end
%lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
%set(lines, 'Color', 'r');
Fontsize = 18;
yl = get(gca,'YLabel');
ylFontSize = get(yl,'FontSize');
yAX = get(gca,'YAxis');
set(yAX,'FontSize', Fontsize)
set(yl, 'FontSize', ylFontSize)
title('White','Interpreter','latex','FontSize',30);
ylabel('White','Interpreter','latex','FontSize',30);
line([0 0],[0 5],'Color','black','LineStyle','-')
set(get(gca,'ylabel'),'Units', 'Normalized', 'Position', [-0.2, 0.5, 0])
yticklabels({'','L,L','H,L','L,H','H,H'})
set(gca,'TickLabelInterpreter','latex','fontsize',20)
[lgd,icons,plots,txt] = legend({'Principal Utility','Social Norms'},'Interpreter','latex');
temp = [lgd; lgd.ItemText];
set(temp, 'FontSize', 25);
pos = get(lgd,'Position');
posx = 0.01;
posy = 0.93;
set(lgd,'Position',[posx posy 0.18 0.05]);
for k = 3:4
    icons(k).Children.MarkerSize = 8;
end
box on
axis([-8 2.5 0.5 4.5])
% wb
%subplot(3,3,2);
axes(ha(2));
%boxplot(Z(:,[13:14,19:20]),'orientation','horizontal','Widths',1,'Symbol','ok','Whisker',10,'positions', X)
scatter(det(:,13),reg,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
hold on
scatter(sn(:,13),reg,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,13) m(1,13)],[0.7 1.3],'Color','k','LineStyle','-')

scatter(det(:,14),reg+1,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,14),reg+1,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,14) m(1,14)],[1.7 2.3],'Color','k','LineStyle','-')

scatter(det(:,19),reg+2,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,19),reg+2,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,19) m(1,19)],[2.7 3.3],'Color','k','LineStyle','-')

scatter(det(:,20),reg+3,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,20),reg+3,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,20) m(1,20)],[3.7 4.3],'Color','k','LineStyle','-')
set(gca,'yticklabel',[])
set(findobj(gca,'type','line'),'linew',0.9)
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.1);
 end
title('Black','Interpreter','latex','FontSize',30);
line([0 0],[0 5],'Color','black','LineStyle','-')
set(gca,'TickLabelInterpreter','latex','fontsize',20)
box on
axis([-8 2.5 0 5])

%wa
axes(ha(3));
%boxplot(Z(:,[25:26,31:32]),'orientation','horizontal','Widths',1,'Symbol','ok','Whisker',10,'positions', X)
scatter(det(:,25),reg,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
hold on
scatter(sn(:,25),reg,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,25) m(1,25)],[0.7 1.3],'Color','k','LineStyle','-')

scatter(det(:,26),reg+1,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,26),reg+1,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,26) m(1,26)],[1.7 2.3],'Color','k','LineStyle','-')

scatter(det(:,31),reg+2,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,31),reg+2,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,31) m(1,31)],[2.7 3.3],'Color','k','LineStyle','-')

scatter(det(:,32),reg+3,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,32),reg+3,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,32) m(1,32)],[3.7 4.3],'Color','k','LineStyle','-')
set(gca,'yticklabel',[])
set(findobj(gca,'type','line'),'linew',0.9)
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.1);
 end
title('Asian','Interpreter','latex','FontSize',30);
line([0 0],[0 5],'Color','black','LineStyle','-')
set(gca,'TickLabelInterpreter','latex','fontsize',20)
box on
axis([-8 2.5 0 5])

% bw
axes(ha(4));
%boxplot(Z(:,[3:4,9:10]),'orientation','horizontal','Widths',1,'Symbol','ok','Whisker',10,'positions', X)
scatter(det(:,3),reg,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
hold on
scatter(sn(:,3),reg,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,3) m(1,3)],[0.7 1.3],'Color','k','LineStyle','-')

scatter(det(:,4),reg+1,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,4),reg+1,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,4) m(1,4)],[1.7 2.3],'Color','k','LineStyle','-')

scatter(det(:,9),reg+2,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,9),reg+2,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,9) m(1,9)],[2.7 3.3],'Color','k','LineStyle','-')

scatter(det(:,10),reg+3,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,10),reg+3,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,10) m(1,10)],[3.7 4.3],'Color','k','LineStyle','-')
set(findobj(gca,'type','line'),'linew',0.9)
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.1);
 end
Fontsize = 18;
yl = get(gca,'YLabel');
ylFontSize = get(yl,'FontSize');
yAX = get(gca,'YAxis');
set(yAX,'FontSize', Fontsize)
set(yl, 'FontSize', ylFontSize)
ylabel('Black','Interpreter','latex','FontSize',30);
line([0 0],[0 5],'Color','black','LineStyle','-')
set(get(gca,'ylabel'),'Units', 'Normalized', 'Position', [-0.2, 0.5, 0])
yticklabels({'','L,L','H,L','L,H','H,H'})
set(gca,'TickLabelInterpreter','latex','fontsize',20)
box on
axis([-8 2.5 0 5])

% bb
axes(ha(5));
%boxplot(Z(:,[15:16,21:22]),'orientation','horizontal','Widths',1,'Symbol','ok','Whisker',10,'positions', X)
scatter(det(:,15),reg,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
hold on
scatter(sn(:,15),reg,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,15) m(1,15)],[0.7 1.3],'Color','k','LineStyle','-')

scatter(det(:,16),reg+1,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,16),reg+1,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,16) m(1,16)],[1.7 2.3],'Color','k','LineStyle','-')

scatter(det(:,21),reg+2,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,21),reg+2,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,21) m(1,21)],[2.7 3.3],'Color','k','LineStyle','-')

scatter(det(:,22),reg+3,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,22),reg+3,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,22) m(1,22)],[3.7 4.3],'Color','k','LineStyle','-')
set(gca,'yticklabel',[])
set(findobj(gca,'type','line'),'linew',0.9)
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.1);
 end
line([0 0],[0 5],'Color','black','LineStyle','-')
set(gca,'TickLabelInterpreter','latex','fontsize',20)
box on
axis([-8 2.5 0 5])

%ba
axes(ha(6));
%boxplot(Z(:,[27:28,33:34]),'orientation','horizontal','Widths',1,'Symbol','ok','Whisker',10,'positions', X)
scatter(det(:,27),reg,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
hold on
scatter(sn(:,27),reg,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,27) m(1,27)],[0.7 1.3],'Color','k','LineStyle','-')

scatter(det(:,28),reg+1,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,28),reg+1,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,28) m(1,28)],[1.7 2.3],'Color','k','LineStyle','-')

scatter(det(:,33),reg+2,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,33),reg+2,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,33) m(1,33)],[2.7 3.3],'Color','k','LineStyle','-')

scatter(det(:,34),reg+3,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,34),reg+3,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,34) m(1,34)],[3.7 4.3],'Color','k','LineStyle','-')
set(gca,'yticklabel',[])
set(findobj(gca,'type','line'),'linew',0.9)
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.1);
 end
line([0 0],[0 5],'Color','black','LineStyle','-')
set(gca,'TickLabelInterpreter','latex','fontsize',20)
box on 
axis([-8 2.5 0 5])

% aw
axes(ha(7));
%boxplot(Z(:,[5:6,11:12]),'orientation','horizontal','Widths',1,'Symbol','ok','Whisker',10,'positions', X)
scatter(det(:,5),reg,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
hold on
scatter(sn(:,5),reg,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,5) m(1,5)],[0.7 1.3],'Color','k','LineStyle','-')

scatter(det(:,6),reg+1,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,6),reg+1,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,6) m(1,6)],[1.7 2.3],'Color','k','LineStyle','-')

scatter(det(:,11),reg+2,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,11),reg+2,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,11) m(1,11)],[2.7 3.3],'Color','k','LineStyle','-')

scatter(det(:,12),reg+3,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,12),reg+3,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,12) m(1,12)],[3.7 4.3],'Color','k','LineStyle','-')
set(findobj(gca,'type','line'),'linew',0.9)
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.1);
 end
Fontsize = 18;
yl = get(gca,'YLabel');
ylFontSize = get(yl,'FontSize');
yAX = get(gca,'YAxis');
set(yAX,'FontSize', Fontsize)
set(yl, 'FontSize', ylFontSize)
ylabel('Asian','Interpreter','latex','FontSize',30);
line([0 0],[0 5],'Color','black','LineStyle','-')
set(get(gca,'ylabel'),'Units', 'Normalized', 'Position', [-0.2, 0.5, 0])
yticklabels({'','L,L','H,L','L,H','H,H'})
set(gca,'TickLabelInterpreter','latex','fontsize',20)
box on
axis([-8 2.5 0 5])

% ab
axes(ha(8));
%boxplot(Z(:,[17:18,23:24]),'orientation','horizontal','Widths',1,'Symbol','ok','Whisker',10,'positions', X)
scatter(det(:,17),reg,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
hold on
scatter(sn(:,17),reg,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,17) m(1,17)],[0.7 1.3],'Color','k','LineStyle','-')

scatter(det(:,18),reg+1,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,18),reg+1,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,18) m(1,18)],[1.7 2.3],'Color','k','LineStyle','-')

scatter(det(:,23),reg+2,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,23),reg+2,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,23) m(1,23)],[2.7 3.3],'Color','k','LineStyle','-')

scatter(det(:,24),reg+3,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,24),reg+3,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,24) m(1,24)],[3.7 4.3],'Color','k','LineStyle','-')
set(gca,'yticklabel',[])
set(findobj(gca,'type','line'),'linew',0.9)
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.1);
 end
line([0 0],[0 5],'Color','black','LineStyle','-')
set(gca,'TickLabelInterpreter','latex','fontsize',20)
box on
axis([-8 2.5 0 5])

%aa
axes(ha(9));
%boxplot(Z(:,[29:30,35:36]),'orientation','horizontal','Widths',1,'Symbol','ok','Whisker',10,'positions', X)
scatter(det(:,29),reg,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
hold on
scatter(sn(:,29),reg,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,29) m(1,29)],[0.7 1.3],'Color','k','LineStyle','-')

scatter(det(:,30),reg+1,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,30),reg+1,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,30) m(1,30)],[1.7 2.3],'Color','k','LineStyle','-')

scatter(det(:,35),reg+2,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,35),reg+2,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,35) m(1,35)],[2.7 3.3],'Color','k','LineStyle','-')

scatter(det(:,36),reg+3,sz,'s','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
scatter(sn(:,36),reg+3,sz,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
line([m(1,36) m(1,36)],[3.7 4.3],'Color','k','LineStyle','-')
set(gca,'yticklabel',[])
set(findobj(gca,'type','line'),'linew',0.9)
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.1);
 end
line([0 0],[0 5],'Color','black','LineStyle','-')
set(gca,'TickLabelInterpreter','latex','fontsize',20)
box on
axis([-8 2.5 0 5])
text(-16.9,17.9,'Female Ethnicity','Interpreter','latex','FontSize',30)
text(-36,6.2,'Male Ethnicity','Rotation',90,'Interpreter','latex','FontSize',30)
saveas(gcf,'z3x3','epsc')