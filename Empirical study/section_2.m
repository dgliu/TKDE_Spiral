%% Experimental code of Section 2
%% Figure 2
spiral_example
%% Figure 3
dataName = {'Books','Clothes','Electronics','Movies','Epinion','Ciao','Eachmovie','Movielens20m'};
fileAddress = 'F:\Matlab_workspace\TKDE_Spiral\Empirical study\';
tic
for i = 1:length(dataName)
    % Load data and calculate cache variables
    load([fileAddress,'dataset\',dataName{i},'.mat']);
    [userSet,userP] = numunique(dataMat(:,1));
    userRatingNum = arrayfun(@(x) length(userP{x}),1:length(userSet));
    activeTime = arrayfun(@(x) max(dataMat(userP{x},4))-min(dataMat(userP{x},4)),1:length(userSet));
    regularUserIdx = zeros(length(userSet),1);
    startIdx = 1;
    for j = 1:length(userSet)
        if length(userP{j})>=10
            if i < 4
                edges = min(dataMat(userP{j},4)):(2*2592000):max(dataMat(userP{j},4));
            else
                edges = min(dataMat(userP{j},4)):2592000:max(dataMat(userP{j},4));
            end
            judgeIdx = arrayfun(@(x) ~isempty(find(dataMat(userP{j},4)>edges(x)&dataMat(userP{j},4)<=edges(x+1),1)),1:(length(edges)-1));
            if sum(judgeIdx)==(length(edges)-1)
                regularUserIdx(startIdx) = j;
                startIdx = startIdx+1;
            end
        end
    end
    fprintf('Regular User Num: %d\n',startIdx);
    regularUserIdx = regularUserIdx(1:(startIdx-1));
    [itemSet,itemP] = numunique(dataMat(:,2));
    itemMean = arrayfun(@(x) mean(dataMat(itemP{x},3)),1:length(itemSet));
    itemRatingNum = arrayfun(@(x) length(itemP{x}),1:length(itemSet));
    toc
    
    % Current
    temp = cell(length(itemP),1);
    for j = 1:length(itemP)
        if length(itemP{j})>=50
            temp{j} = itemP{j}(2:end)';
        end
    end
    temp = cell2mat(temp);
    currentMeanDivergence = dataMat(temp,3)-dataMat(temp,5);
    fprintf('dataset/Method: %s/Current completed\n',dataName{i});
    clearvars -except i dataName fileAddress dataMat userSet userP userRatingNum activeTime regularUserIdx itemSet itemP itemMean currentMeanDivergence
    toc
    
    % Final
    finalRatingDivergence = cell(length(itemP),1);
    for j = 1:length(itemP)
        if length(itemP{j})>=50
            finalRatingDivergence{j} = dataMat(itemP{j},3)-itemMean(j);
        end
    end
    finalRatingDivergence = cell2mat(finalRatingDivergence);
    fprintf('dataset/Method: %s/Final completed\n',dataName{i});
    clearvars -except i dataName fileAddress dataMat userSet userP userRatingNum activeTime regularUserIdx itemSet itemP itemMean currentMeanDivergence finalRatingDivergence
    toc
    
    % Timely
    mostTimelyDivergence = cell(length(itemP),1);
    for j = 1:length(itemP)
        if length(itemP{j})>=50
            temp = round(0.05*length(itemP{j}));
            mostTimelyDivergence{j} = dataMat(itemP{j}(temp+1:end),3)-mean(dataMat(itemP{j}(1:temp),3));
        end
    end
    mostTimelyDivergence = cell2mat(mostTimelyDivergence);
    fprintf('dataset/Method: %s/Timely completed\n',dataName{i})
    clearvars -except i dataName fileAddress dataMat userSet userP userRatingNum activeTime regularUserIdx itemSet itemP itemMean currentMeanDivergence finalRatingDivergence mostTimelyDivergence
    toc
    
    % Active
    mostActiveDivergence = cell(length(itemP),1);
    [~,idx] = sort(userRatingNum,'descend');
    mostActiveUser = idx(1:round(0.05*length(idx)));
    for j = 1:length(itemP)
        if length(itemP{j})>=50
            idx = ismember(dataMat(itemP{j},1),mostActiveUser);
            idx = find(idx==1);
            if ~isempty(idx)
                if idx(end)==length(itemP{j})
                    idx(end) = [];
                end
                if length(idx)==1
                    mostActiveDivergence{j} = dataMat(itemP{j}(idx+1:end),3)-dataMat(itemP{j}(idx),3);
                end
                if length(idx)>1
                    temp = zeros(length(itemP{j}),1);
                    startIdx = 1;
                    for k = 1:length(idx)-1
                        temp(startIdx:(startIdx+idx(k+1)-idx(k)-2)) = dataMat(itemP{j}(idx(k)+1:idx(k+1)-1),3)-dataMat(itemP{j}(idx(k)),3);
                        startIdx = startIdx+idx(k+1)-idx(k)-1;
                    end
                    temp(startIdx:(startIdx+length(itemP{j})-idx(k+1)-1)) = dataMat(itemP{j}(idx(k+1)+1:end),3)-dataMat(itemP{j}(idx(k+1)),3);
                    startIdx = startIdx+length(itemP{j})-idx(k+1);
                    mostActiveDivergence{j} = temp(1:startIdx-1);
                end
            end
        end
    end
    mostActiveDivergence = cell2mat(mostActiveDivergence);
    fprintf('dataset/Method: %s/Active completed\n',dataName{i});
    clearvars -except i dataName fileAddress dataMat userSet userP userRatingNum activeTime regularUserIdx itemSet itemP itemMean currentMeanDivergence finalRatingDivergence mostTimelyDivergence mostActiveDivergence
    toc
    
    % Long
    mostLongDivergence = cell(length(itemP),1);
    [~,idx] = sort(activeTime,'descend');
    mostLongUser = userSet(idx(1:round(0.05*length(idx))));
    for j = 1:length(itemP)
        if length(itemP{j})>=50
            idx = ismember(dataMat(itemP{j},1),mostLongUser);
            idx = find(idx==1);
            if ~isempty(idx)
                if idx(end)==length(itemP{j})
                    idx(end) = [];
                end
                if length(idx)==1
                    mostLongDivergence{j} = dataMat(itemP{j}(idx+1:end),3)-dataMat(itemP{j}(idx),3);
                end
                if length(idx)>1
                    temp = zeros(length(itemP{j}),1);
                    startIdx = 1;
                    for k = 1:length(idx)-1
                        temp(startIdx:(startIdx+idx(k+1)-idx(k)-2)) = dataMat(itemP{j}(idx(k)+1:idx(k+1)-1),3)-dataMat(itemP{j}(idx(k)),3);
                        startIdx = startIdx+idx(k+1)-idx(k)-1;
                    end
                    temp(startIdx:(startIdx+length(itemP{j})-idx(k+1)-1)) = dataMat(itemP{j}(idx(k+1)+1:end),3)-dataMat(itemP{j}(idx(k+1)),3);
                    startIdx = startIdx+length(itemP{j})-idx(k+1);
                    mostLongDivergence{j} = temp(1:startIdx-1);
                end
            end
        end
    end
    mostLongDivergence = cell2mat(mostLongDivergence);
    fprintf('dataset/Method: %s/Old completed\n',dataName{i});
    clearvars -except i dataName fileAddress dataMat userSet userP userRatingNum activeTime regularUserIdx itemSet itemP itemMean currentMeanDivergence finalRatingDivergence mostTimelyDivergence mostActiveDivergence mostLongDivergence
    toc
    
    % Regular
    mostRegularDivergence = cell(length(itemP),1);
    for j = 1:length(itemP)
        if length(itemP{j})>=50
            idx = ismember(dataMat(itemP{j},1),regularUserIdx);
            idx = find(idx==1);
            if ~isempty(idx)
                if idx(end)==length(itemP{j})
                    idx(end) = [];
                end
                if length(idx)==1
                    mostRegularDivergence{j} = dataMat(itemP{j}(idx+1:end),3)-dataMat(itemP{j}(idx),3);
                end
                if length(idx)>1
                    temp = zeros(length(itemP{j}),1);
                    startIdx = 1;
                    for k = 1:length(idx)-1
                        temp(startIdx:(startIdx+idx(k+1)-idx(k)-2)) = dataMat(itemP{j}(idx(k)+1:idx(k+1)-1),3)-dataMat(itemP{j}(idx(k)),3);
                        startIdx = startIdx+idx(k+1)-idx(k)-1;
                    end
                    temp(startIdx:(startIdx+length(itemP{j})-idx(k+1)-1)) = dataMat(itemP{j}(idx(k+1)+1:end),3)-dataMat(itemP{j}(idx(k+1)),3);
                    startIdx = startIdx+length(itemP{j})-idx(k+1);
                    mostRegularDivergence{j} = temp(1:startIdx-1);
                end
            end
        end
    end
    mostRegularDivergence = cell2mat(mostRegularDivergence);
    fprintf('dataset/Method: %s/Regular completed\n',dataName{i});
    clearvars -except i dataName fileAddress dataMat userSet userP userRatingNum activeTime regularUserIdx itemSet itemP itemMean currentMeanDivergence finalRatingDivergence mostTimelyDivergence mostActiveDivergence mostLongDivergence mostRegularDivergence
    toc
    
    % Figure
    divergence = [currentMeanDivergence;finalRatingDivergence;mostActiveDivergence;mostTimelyDivergence;mostLongDivergence;mostRegularDivergence];
    groupIdx = [zeros(length(currentMeanDivergence),1);ones(length(finalRatingDivergence),1);2*ones(length(mostActiveDivergence),1);3*ones(length(mostTimelyDivergence),1);4*ones(length(mostLongDivergence),1);...
        5*ones(length(mostRegularDivergence),1)];
    bh = boxplot(divergence,groupIdx,'symbol','');
    set(bh,'linewidth',3);
    set(gca,'XTickLabel',{'current','final','active','timely','long','regular'});
    ylabel('rating divergence');
    set(gca,'box','off');
    set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
    axis tight 
    saveas(gcf,[fileAddress,dataName{i},'_opinion'],'epsc');
end

%% Table 3
dataName = {'Books','Clothes','Electronics','Movies','Epinion','Ciao','Eachmovie','Movielens20m'};
fileAddress = 'F:\Matlab_workspace\TKDE_Spiral\Empirical study\';
pLevel = [0.01,0.05,0.1];
numericalOut = zeros(8,6);
numericalIdx = cell(8,3);
numericalHis = cell(8,1);
for i = 1:length(dataName)
    for j = 1:length(pLevel)
        load([fileAddress,'dataset\',dataName{i},'.mat']);
        [~,~,majorityRate,pluralityRate,majorityRiseIdx,itemTrendHis] = spiralContinuousProcess(dataMat,i,pLevel(j));
        numericalIdx{i,j} = majorityRiseIdx;
        numericalHis{i} = itemTrendHis;
        numericalOut(i,2*j-1:2*j) = [majorityRate,pluralityRate];
        fprintf('dataset/p value: %s/%s completed\n',dataName{i},num2str(pLevel(j)));
    end
end