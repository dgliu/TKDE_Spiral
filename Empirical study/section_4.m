%% Experimental code of Section 4
%% Table 6
fileAddress = 'F:\Matlab_workspace\TKDE_Spiral\Empirical study\';
load([fileAddress,'dataset\Yahoo_user.mat']);
load([fileAddress,'dataset\Yahoo_random.mat']);
[itemSet,itemP] = numunique(train(:,2));
itemMean = arrayfun(@(x) mean(train(itemP{x},3)),1:length(itemSet));
[trainUserSet,trainP] = numunique(train(:,1));
[testUserSet,testP] = numunique(test(:,1));
tab = zeros(3,5);
for h = 0.4:0.1:0.8
    trainScore = zeros(length(trainUserSet),1);
    testScore = zeros(length(testUserSet),1);
    for i = 1:length(trainUserSet)
        tmp = train(trainP{i},3)'-itemMean(train(trainP{i},2));
        trainScore(i) = length(find(abs(tmp)>1.7))/length(trainP{i});
    end
    for i = 1:length(testUserSet)
        tmp = test(testP{i},3)'-itemMean(test(testP{i},2));
        testScore(i) = length(find(abs(tmp)>1.7))/length(testP{i});
    end
    if h == 0.4
        trainHardcore = find(trainScore<0.5);
        trainHardcore(trainHardcore>5400) = [];
        testHardcore = find(testScore>=0.5);
    else
        trainHardcore = find(trainScore>=h);
        trainHardcore(trainHardcore>5400) = [];
        testHardcore = find(testScore>=h);
    end
    tab(1,int8((h-0.3)*10)) = length(intersect(trainHardcore,testHardcore))/...
        length(union(trainHardcore,testHardcore));
    hardcoreProb = length(trainHardcore)/5400;
    sampleResult = zeros(10000,1);
    for i = 1:10000
        sampleHardcore = find(rand(5400,1)<=hardcoreProb);
        sampleResult(i) = length(intersect(sampleHardcore,testHardcore))/...
            length(union(sampleHardcore,testHardcore));
    end
    tab(2,int8((h-0.3)*10)) = mean(sampleResult);
    tab(3,int8((h-0.3)*10)) = ranksum(tab(1,int8((h-0.3)*10)),sampleResult,'tail','right');
end
%% Figure 6
dataName = {'Books','Clothes','Electronics','Movies','Epinion','Ciao','Eachmovie','Movielens20m'};
fileAddress = 'F:\Matlab_workspace\TKDE_Spiral\Empirical study\';
for i = 1:length(dataName)
    load([fileAddress,'dataset\',dataName{i},'.mat']);
    tmp = dataMat(:,3)-dataMat(:,5);
    [itemSet,itemP] = numunique(dataMat(:,2));
    itemMean=zeros(1,max(dataMat(:,2)));
    for j=1:length(itemSet)
        itemMean(itemSet(j))=mean(dataMat(itemP{j},3));
    end
    [userSet,userP] = numunique(dataMat(:,1));
    userRate = nan(length(userSet),2);
    for j = 1:length(userSet)
        badIdx=find(itemMean(dataMat(userP{j},2))<3);
        bestIdx=find(itemMean(dataMat(userP{j},2))>=3);
        if ~isempty(badIdx)&&~isempty(bestIdx)
            userRate(j,1) = length(find(tmp(userP{j}(badIdx))>1.7))/length(badIdx);
            userRate(j,2) = length(find(tmp(userP{j}(bestIdx))<-1.7))/length(bestIdx);
        end
    end
    bh = boxplot([userRate(:,2),userRate(:,1)],'symbol','','Labels',{'CP','PN'});
    set(bh,'linewidth',3);
    set(gca,'box','off');
    set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
    axis tight
    ylim([0 0.5])
    yyaxis left
    ylabel('h^{CP}_i');
    yyaxis right
    ylim([0 0.5])
    ylabel('h^{PN}_i');
    saveas(gcf,[fileAddress,dataName{i},'_moral'],'epsc');
    clf;
    fprintf([dataName{i},' process completed\n']);
end
%--------------------------------------------------------------------------
% Yahoo_user
load([fileAddress,'dataset\Yahoo_user.mat']);
[itemSet,itemP] = numunique(train(:,2));
itemMean = arrayfun(@(x) mean(train(itemP{x},3)),1:length(itemSet));
tmp = train(:,3)'-itemMean(train(:,2));
[userSet,userP] = numunique(train(:,1));
userRate = nan(length(userSet),2);
for i = 1:length(userSet)
    badIdx = find(itemMean(train(userP{i},2))<3);
    bestIdx = find(itemMean(train(userP{i},2))>=3);
    if ~isempty(badIdx)&&~isempty(bestIdx)
        userRate(i,1) = length(find(tmp(userP{i}(badIdx))>1.7))/length(badIdx);
        userRate(i,2) = length(find(tmp(userP{i}(bestIdx))<-1.7))/length(bestIdx);
    end
end
bh = boxplot([userRate(:,2),userRate(:,1)],'symbol','','Labels',{'CP','PN'});
set(bh,'linewidth',3);
set(gca,'box','off');
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
axis tight
yyaxis left
ylabel('h^{CP}_i');
yyaxis right
ylabel('h^{PN}_i');
saveas(gcf,[fileAddress,'Yahoo_user_moral'],'epsc');
clf;
fprintf('Yahoo_user process completed\n');
%--------------------------------------------------------------------------
% Yahoo_random
load([fileAddress,'dataset\Yahoo_random.mat']);
tmp = test(:,3)'-itemMean(test(:,2));
[userSet,userP] = numunique(test(:,1));
userRate = nan(length(userSet),2);
for i = 1:length(userSet)
    badIdx = find(itemMean(test(userP{i},2))<3);
    bestIdx = find(itemMean(test(userP{i},2))>=3);
    if ~isempty(badIdx)&&~isempty(bestIdx)
        userRate(i,1) = length(find(tmp(userP{i}(badIdx))>1.7))/length(badIdx);
        userRate(i,2) = length(find(tmp(userP{i}(bestIdx))<-1.7))/length(bestIdx);
    end
end
bh = boxplot([userRate(:,2),userRate(:,1)],'symbol','','Labels',{'CP','PN'});
set(bh,'linewidth',3);
set(gca,'box','off');
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
axis tight
yyaxis left
ylabel('h^{CP}_i');
yyaxis right
ylabel('h^{PN}_i');
saveas(gcf,[fileAddress,'Yahoo_random_moral'],'epsc');
clf;
fprintf('Yahoo_random process completed\n');
%% Figure 7
dataName = {'Books','Clothes','Electronics','Movies','Epinion','Ciao','Eachmovie','Movielens20m'};
fileAddress = 'F:\Matlab_workspace\TKDE_Spiral\Empirical study\';
bound = [30,20,20,30,80,110,100,320];
for i = 1:length(dataName)
    load([fileAddress,'dataset\',dataName{i},'.mat']);
    tmp = dataMat(:,3)-dataMat(:,5);
    [itemSet,itemP] = numunique(dataMat(:,2));
    itemMean=zeros(1,max(dataMat(:,2)));
    for j=1:length(itemSet)
        itemMean(itemSet(j))=mean(dataMat(itemP{j},3));
    end
    [userSet,userP] = numunique(dataMat(:,1));
    num = nan(length(userSet),4);
    for j = 1:length(userSet)
        badIdx=find(itemMean(dataMat(userP{j},2))<3);
        bestIdx=find(itemMean(dataMat(userP{j},2))>=3);
        if ~isempty(badIdx)&&~isempty(bestIdx)
            num(j,3) = length(badIdx);
            num(j,4) = length(find(tmp(userP{j}(badIdx))>1.7));
            num(j,1) = length(bestIdx);
            num(j,2) = length(find(tmp(userP{j}(bestIdx))<-1.7));
        end
    end
    bh = boxplot(num,'symbol','','Labels',{'$$\mathbf{N^{P}_i}$$','$$\mathbf{N^{CP,h}_i}$$','$$\mathbf{N^{N}_i}$$','$$\mathbf{N^{PN,h}_i}$$'});
    set(bh,'linewidth',3);
    set(gca,'box','off');
    set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
    bp = gca;
    bp.XAxis.TickLabelInterpreter = 'latex';
    axis tight
    ylim([0 bound(i)])
    saveas(gcf,[fileAddress,dataName{i},'_num'],'epsc');
    clf;
    fprintf([dataName{i},' process completed\n']);
end
%--------------------------------------------------------------------------
% Yahoo_user
load([fileAddress,'dataset\Yahoo_user.mat']);
[itemSet,itemP] = numunique(train(:,2));
itemMean = arrayfun(@(x) mean(train(itemP{x},3)),1:length(itemSet));
tmp = train(:,3)'-itemMean(train(:,2));
[userSet,userP] = numunique(train(:,1));
num = nan(length(userSet),4);
for i = 1:length(userSet)
    badIdx = find(itemMean(train(userP{i},2))<3);
    bestIdx = find(itemMean(train(userP{i},2))>=3);
    if ~isempty(badIdx)&&~isempty(bestIdx)
        num(i,3) = length(badIdx);
        num(i,4) = length(find(tmp(userP{i}(badIdx))>1.7));
        num(i,1) = length(bestIdx);
        num(i,2) = length(find(tmp(userP{i}(bestIdx))<-1.7));
    end
end
bh = boxplot(num,'symbol','','Labels',{'$$\mathbf{N^{P}_i}$$','$$\mathbf{N^{CP,h}_i}$$','$$\mathbf{N^{N}_i}$$','$$\mathbf{N^{PN,h}_i}$$'});
bp = gca;
bp.XAxis.TickLabelInterpreter = 'latex';
set(bh,'linewidth',3);
set(gca,'box','off');
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
axis tight
ylim([0 30])
saveas(gcf,[fileAddress,'Yahoo_user_num'],'epsc');
clf;
fprintf('Yahoo_user process completed\n');
%--------------------------------------------------------------------------
% Yahoo_random
load([fileAddress,'dataset\Yahoo_random.mat']);
tmp = test(:,3)'-itemMean(test(:,2));
[userSet,userP] = numunique(test(:,1));
num = nan(length(userSet),4);
for i = 1:length(userSet)
    badIdx = find(itemMean(test(userP{i},2))<3);
    bestIdx = find(itemMean(test(userP{i},2))>=3);
    if ~isempty(badIdx)&&~isempty(bestIdx)
        num(i,3) = length(badIdx);
        num(i,4) = length(find(tmp(userP{i}(badIdx))>1.7));
        num(i,1) = length(bestIdx);
        num(i,2) = length(find(tmp(userP{i}(bestIdx))<-1.7));
    end
end
bh = boxplot(num,'symbol','','Labels',{'$$\mathbf{N^{P}_i}$$','$$\mathbf{N^{CP,h}_i}$$','$$\mathbf{N^{N}_i}$$','$$\mathbf{N^{PN,h}_i}$$'});
bp = gca;
bp.XAxis.TickLabelInterpreter = 'latex';
set(bh,'linewidth',3);
set(gca,'box','off');
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
axis tight
saveas(gcf,[fileAddress,'Yahoo_random_num'],'epsc');
clf;
fprintf('Yahoo_random process completed\n');