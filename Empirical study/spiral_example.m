fileAddress = 'F:\Matlab_workspace\TKDE_Spiral\Empirical study\';
load([fileAddress,'dataset\Books.mat']);
[~,P] = numunique(dataMat(:,2));
rating = dataMat(P{3363},:); % "asin": "000725394X"
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
clf;
plot(positiveProb,'LineWidth',3);
hold on
plot(negativeProb,'LineWidth',3);
xlabel('snapshots');
ylabel('fraction');
set(gca,'box','off');
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
bh = legend('positive','negative');
set(bh,...
    'Position',[0.187023805232275 0.769603171333434 0.271071432862963 0.147857146126883]);
set(bh,'Box','off')
axis tight
saveas(gcf,'example1','epsc');

clf;
plot(categoryHis(:,2),'LineWidth',3);
hold on
plot(categoryHis(:,1),'LineWidth',3);
xlabel('snapshots');
ylabel('number');
set(gca,'box','off');
set(gca,'FontName','Arial Rounded MT Bold','FontSize',20,'linewidth',3);
bh = legend('positive','negative');
set(bh,...
    'Position',[0.187023805232275 0.769603171333434 0.271071432862963 0.147857146126883]);
set(bh,'Box','off')
axis tight
saveas(gcf,'example2','epsc');