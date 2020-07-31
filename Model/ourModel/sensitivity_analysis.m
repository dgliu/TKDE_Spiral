%% Parameter F
% Coat Shopping
load('coat_user.mat')
load('coat_random.mat');
out1 = ourModel(train,test,'m',290,'n',300,'maxIter',400);
out2 = ourModel(train,test,'m',290,'n',300,'maxIter',400,'F',10);
out3 = ourModel(train,test,'m',290,'n',300,'maxIter',400,'F',20);
out4 = ourModel(train,test,'m',290,'n',300,'maxIter',400,'F',50);
hold on
out = [out1(end),out2(end),out3(end),out4(end)];
bh = plot(out,'-o');
set(bh,'linewidth',3);
xlabel('K');
ylabel('NDCG@10');
set(gca,'box','off');
set(gca,'XTickLabel',{'5','10','20','50'});
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
saveas(gcf,'sensitivity_F_coat','epsc');

% Yahoo!
load('yahoo_user.mat')
load('yahoo_random.mat');
out5 = ourModel(train,test,'maxIter',100);
out6 = ourModel(train,test,'maxIter',100,'F',10);
out7 = ourModel(train,test,'maxIter',120,'F',20);
out8 = ourModel(train,test,'maxIter',120,'F',50);
hold on
out = [out5(end),out6(end),out7(end),out8(end)];
clf
bh = plot(out,'-o');
set(bh,'linewidth',3);
xlabel('K');
ylabel('NDCG@10');
set(gca,'box','off');
set(gca,'XTickLabel',{'5','10','20','50'});
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
saveas(gcf,'sensitivity_F_yahoo','epsc');
%% Parameter sigU/sigV/sigB
% Coat Shopping
load('coat_user.mat')
load('coat_random.mat');
out9 = ourModel(train,test,'m',290,'n',300,'maxIter',200,'sigU',0.05,'sigV',0.05,'sigB',0.05);
out10 = ourModel(train,test,'m',290,'n',300,'maxIter',250,'sigU',0.1,'sigV',0.1,'sigB',0.1);
out11 = ourModel(train,test,'m',290,'n',300,'maxIter',400,'sigU',0.5,'sigV',0.5,'sigB',0.5);
out12 = ourModel(train,test,'m',290,'n',300,'maxIter',400,'sigU',1,'sigV',1,'sigB',1);
hold on
out = [out9(end),out10(end),out11(end),out12(end)];
clf
bh = plot(out,'-o');
set(bh,'linewidth',3);
xlabel('\sigma');
ylabel('NDCG@10');
set(gca,'box','off');
set(gca,'XTickLabel',{'0.05','0.1','0.5','1'});
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
saveas(gcf,'sensitivity_sig_coat','epsc');

% Yahoo!
load('yahoo_user.mat')
load('yahoo_random.mat');
out13 = ourModel(train,test,'maxIter',100,'sigU',0.05,'sigV',0.05,'sigB',0.05);
out14 = ourModel(train,test,'maxIter',120,'sigU',0.1,'sigV',0.1,'sigB',0.1);
out15 = ourModel(train,test,'maxIter',140,'sigU',0.5,'sigV',0.5,'sigB',0.5);
out16 = ourModel(train,test,'maxIter',140,'sigU',1,'sigV',1,'sigB',1);
hold on
out = [out13(end),out14(end),out15(end),out16(end)];
clf
bh = plot(out,'-o');
set(bh,'linewidth',3);
xlabel('\sigma');
ylabel('NDCG@10');
set(gca,'box','off');
set(gca,'XTickLabel',{'0.05','0.1','0.5','1'});
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
saveas(gcf,'sensitivity_sig_yahoo','epsc');
%% Parameter sigR
% Coat Shopping
load('coat_user.mat')
load('coat_random.mat');
out17 = ourModel(train,test,'m',290,'n',300,'maxIter',200,'sigR',0.05);
out18 = ourModel(train,test,'m',290,'n',300,'maxIter',200,'sigR',0.1);
out19= ourModel(train,test,'m',290,'n',300,'maxIter',300,'sigR',0.5);
out20 = ourModel(train,test,'m',290,'n',300,'maxIter',400,'sigR',1);
hold on
out = [out17(end),out18(end),out19(end),out20(end)];
clf
bh = plot(out,'-o');
set(bh,'linewidth',3);
xlabel('\sigma_r');
ylabel('NDCG@10');
set(gca,'box','off');
set(gca,'XTickLabel',{'0.05','0.1','0.5','1'});
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
saveas(gcf,'sensitivity_sigR_coat','epsc');

% Yahoo!
load('yahoo_user.mat')
load('yahoo_random.mat');
out21 = ourModel(train,test,'maxIter',100,'sigR',0.05);
out22 = ourModel(train,test,'maxIter',100,'sigR',0.1);
out23 = ourModel(train,test,'maxIter',150,'sigR',0.5);
out24 = ourModel(train,test,'maxIter',200,'sigR',1);
hold on
out = [out21(end),out22(end),out23(end),out24(end)];
clf
bh = plot(out,'-o');
set(bh,'linewidth',3);
xlabel('\sigma_r');
ylabel('NDCG@10');
set(gca,'box','off');
set(gca,'XTickLabel',{'0.05','0.1','0.5','1'});
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
saveas(gcf,'sensitivity_sigR_yahoo','epsc');