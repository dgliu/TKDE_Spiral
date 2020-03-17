function [majorityOriRate,pluralityOriRate,majorityNewRate,pluralityNewRate,majorityRiseIdx,itemTrendHis]=spiralContinuousProcess(dataMat,idx, pLevel)
%% Continuous
% Movielens20M is a special case. Because the rating range in Movielens20M
% is 0.5:0.5:5, while the others are 1:1:5
if idx < 8   
    disLength = 5;
    disInterval = 6:10;
else
    disLength = 10;
    disInterval = 6:15;
end
[~,P] = numunique(dataMat(:,2));
itemRatingDis = zeros(length(P),disLength); 
itemTrendHis = cell(length(P),1); 
itemMajorityHis = cell(length(P),1);
itemKurtosis = nan*ones(length(P),1); 
pValue = nan*ones(length(P),1);
for i = 1:length(P)
    if length(P{i}) >= 50 % Remove items with less than 50 ratings
        itemRatingDis(i,:) = dataMat(P{i}(end),disInterval);
        % Smoothing the rating distribution to avoid inaccurate kurtosis results
        correctItemRatingDis = itemRatingDis(i,:);
        correctItemRatingDis(correctItemRatingDis==0) = 1; 
        % As mentioned above, Movielens20M is a special case
        if idx < 8
            tmp = [ones(1,correctItemRatingDis(1)),2*ones(1,correctItemRatingDis(2)),3*ones(1,correctItemRatingDis(3)),4*ones(1,correctItemRatingDis(4)),5*ones(1,correctItemRatingDis(5))];
        else
            tmp = [0.5*ones(1,correctItemRatingDis(1)),1*ones(1,correctItemRatingDis(2)),1.5*ones(1,correctItemRatingDis(3)),2*ones(1,correctItemRatingDis(4)),2.5*ones(1,correctItemRatingDis(5)),...
                3*ones(1,correctItemRatingDis(6)),3.5*ones(1,correctItemRatingDis(7)),4*ones(1,correctItemRatingDis(8)),4.5*ones(1,correctItemRatingDis(9)),5*ones(1,correctItemRatingDis(10))]; 
        end
        itemKurtosis(i) = kurtosis(tmp); % Calculate kurtosis
    end
end
for i = 1:length(P) 
    if length(P{i}) >= 50
        % Time series of majority ratios
        tmp = abs(dataMat(P{i},3)-dataMat(P{i},5));
        series = arrayfun(@(x) length(find(tmp(1:x)<1))/x,11:10:length(P{i}));
        pValue(i) = cumKendallTest(series',(1:length(series))','gt'); % Mann-Kendall trend test
        itemTrendHis{i} = series;
        % Time series of majority opinions
        tmp = dataMat(P{i}(11:10:length(P{i})),5);
        majorityIdx = floor(tmp);
        itemMajorityHis{i} = majorityIdx;
    end
end
% If the kurtosis is less than 3, we don't think this item has a dominant
% majority opinion. Note that we need to remove items whose Mann-Kendall
% trend test has failed
pluralityIdx = setdiff(find(itemKurtosis<3),find(isnan(pValue)==1)); 
% If the kurtosis is greater than 3, we think that the item has a dominant
% majority opinion. Similarly, we need to remove items whose Mann-Kendall 
% trend test have failed
majorityIdx = setdiff(find(itemKurtosis>=3),find(isnan(pValue)==1)); 
%% Original results
majorityOriRate = length(find((pValue(majorityIdx)<=pLevel&pValue(majorityIdx)>=0)==1))/...
    length(majorityIdx);
majorityRiseIdx = majorityIdx((pValue(majorityIdx)<=pLevel&pValue(majorityIdx)>=0)==1);
pluralityOriRate = length(find((pValue(pluralityIdx)<=pLevel&pValue(pluralityIdx)>=0)==1))/...
    length(pluralityIdx);
%% Correction results
tmp = arrayfun(@(x) length(unique(itemMajorityHis{x})),majorityIdx);
% Add items and their majority opinion goes to the dead end
majorityNewRate = length(union(find(tmp==1),find((pValue(majorityIdx)<=pLevel&pValue(majorityIdx)>=0)==1)))/...
    length(majorityIdx); 
tmp = arrayfun(@(x) length(unique(itemMajorityHis{x})),pluralityIdx);
% Remove items with a fluctuating majority opinion
pluralityNewRate = length(setdiff(find((pValue(pluralityIdx)<=pLevel&pValue(pluralityIdx)>=0)==1),find(tmp~=1)))/...
    length(pluralityIdx); 
end