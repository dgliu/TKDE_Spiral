% fileAddress = 'F:\Matlab_workspace\TKDE19_Spiral\Empirical study\';
% load([fileAddress,'dataset\Books.mat']);
% [~,P] = numunique(dataMat(:,2));
% rating = dataMat(P{3363},:);
% categoryHis = zeros(size(rating,1),3);
% for i = 1:size(rating,1)
%     if i ~= 1
%         categoryHis(i,:) = categoryHis(i-1,:);
%     end
%     if rating(i,3) > 3
%         categoryHis(i,3) = categoryHis(i,3)+1;
%     end
%     if rating(i,3) == 3
%         categoryHis(i,2) = categoryHis(i,2)+1;
%     end
%     if rating(i,3) < 3
%         categoryHis(i,1) = categoryHis(i,1)+1;
%     end
% end
% positiveProb = categoryHis(:,3)./sum(categoryHis,2);
% neutralProb = categoryHis(:,2)./sum(categoryHis,2);
% negativeProb = categoryHis(:,1)./sum(categoryHis,2);
% plot(positiveProb,'LineWidth',3);
% hold on
% plot(neutralProb,'LineWidth',3);
% plot(negativeProb,'LineWidth',3);
% xlabel('snapshots');
% ylabel('ratio');
% set(gca,'box','off');
% set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
% bh = legend('positive','neutral','negative');
% set(bh,'Box','off')
% axis tight
fileAddress = 'F:\Matlab_workspace\TKDE19_Spiral\Empirical study\';
load([fileAddress,'dataset\Books.mat']);
[~,P] = numunique(dataMat(:,2));
rating = dataMat(P{3363},:);
categoryHis = zeros(size(rating,1),2);
for i = 1:size(rating,1)
    if i ~= 1
        categoryHis(i,:) = categoryHis(i-1,:);
    end
    if rating(i,3) > 3
        categoryHis(i,2) = categoryHis(i,2)+1;
    else
        categoryHis(i,1) = categoryHis(i,1)+1;
    end
end
positiveProb = categoryHis(:,2)./sum(categoryHis,2);
negativeProb = categoryHis(:,1)./sum(categoryHis,2);
plot(positiveProb,'LineWidth',3);
hold on
plot(negativeProb,'LineWidth',3);
xlabel('snapshots');
ylabel('fraction');
set(gca,'box','off');
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
bh = legend('positive','negative');
set(bh,'Box','off')
axis tight