%% parameters
datadir=['/Volumes/WD_D/gufei/monkey_data/description/'];
% sub info
[num,~,raw]=xlsread([datadir 'subs.xlsx']);
subs=raw(2:end,1);
sub_num=size(subs,1);
% descriptors
des_num=68;
[~,~,desname]=xlsread([datadir 'Descriptors.xlsx']);
desname=desname(1:des_num);
% odor_names={'indole', 'iso_l', 'iso_h', 'peach', 'banana'};
odor_names={'ind', 'isol', 'isoh', 'pea', 'ban'};
odor_num=length(odor_names);
% rating results
ratings=zeros(odor_num,odor_num,sub_num);
des=zeros(odor_num,des_num,sub_num);
%% load data
for subi = 1:sub_num
    % load data
    matname=dir([datadir subs{subi} '*.mat']);
    load([datadir matname.name])
    % get ratings and descriptions
    ratings(:,:,subi)=data.results_vif(:,:);
    des(:,:,subi)=data.results(:,:);
end
%% mean ratings
means_vi = mean(ratings,3)';
sems_vi = std(ratings,0,3)'./sqrt(sub_num);
dimensions={'fear','hostility','sadness','joviality','selfassurance','attentiveness','shyness','fatigue','serenity','surprise'};
dimidx=cell(1,length(dimensions));
dimidx{1}=[9,14,21,30,37,53,61];
dimidx{2}=[4,5,29,31,39,42,44,57];
dimidx{3}=[2,11,18,19,32,40,52,58,62,65];
dimidx{4}=[1,3,7,10,24,25,41,43,50,59,60,63,64,67,68];
dimidx{5}=[20,27,33,46,48,51];
dimidx{6}=[8,26,36,38,47,54];
dimidx{7}=[12,15,28,45,55];
dimidx{8}=[13,16,22,56];
dimidx{9}=[6,35,49,66];
dimidx{10}=[17,23,34];
% average subs
mdes=mean(des,3);
desdim=zeros(odor_num,length(dimensions));
desdimall=zeros(odor_num,length(dimensions),sub_num);
for di=1:length(dimensions)
    desdim(:,di)=mean(mdes(:,dimidx{di}),2);
    desdimall(:,di,:)=mean(des(:,dimidx{di},:),2);
end
%% plot
figure;
hold on
alpha = 0.2;
colors = { '#7E2F8E', '#0072BD', '#D95319', '#EDB120','#000000'};
rnames = {'valence','intensity','familarity','edibility','arousal'};
for i=1:5
    stdshade(means_vi(i,:),sems_vi(i,:),alpha,hex2rgb(colors{i}));    
end
set(gca,'xtick',1:odor_num,'XTickLabel',odor_names,'FontSize',12)
legend(rnames,'Location','eastoutside')
% save figure
saveas(gcf, [datadir 'rating_5dim' '.svg'], 'svg')
saveas(gcf, [datadir 'rating_5dim' '.png'], 'png')
%% ttest
% self-assurance
[h,p,ci,stats]=ttest(squeeze(desdimall(4,5,:)),squeeze(desdimall(5,5,:)));
for dim=dimidx{5}%[1:68]
    [h,p,ci,stats]=ttest(squeeze(des(4,dim,:)),squeeze(des(5,dim,:)));    
    disp(desname{dim})
    disp([dim stats.tstat p])
end
% valence & intensity
for dim=1:2
    disp(rnames{dim})
    [h,p,ci,stats]=ttest(squeeze(ratings(1,dim,:)),squeeze(ratings(2,dim,:)));
    disp(p)
    [h,p,ci,stats]=ttest(squeeze(ratings(1,dim,:)),squeeze(ratings(3,dim,:)));
    disp(p)
    [h,p,ci,stats]=ttest(squeeze(ratings(1,dim,:)),mean(squeeze(ratings(2:3,dim,:)))');
    disp(p)
    [h,p,ci,stats]=ttest(squeeze(ratings(2,dim,:)),squeeze(ratings(3,dim,:)));
    disp(p)
    [h,p,ci,stats]=ttest(squeeze(ratings(4,dim,:)),squeeze(ratings(5,dim,:)));
    disp(p)
end
% descriptions
% dis = 'euclidean';
% dis = 'cosine';
dis = 'correlation';
dist=[];
for subi = 1:sub_num
    % 10 dimensions
    temp = pdist2(desdimall(:,:,subi),desdimall(:,:,subi),dis);
    % 68 descriptors
%     temp = pdist2(des(:,:,subi),des(:,:,subi),dis);
    % select upper triangle
    dist(:,subi) = 1-temp(triu(true(size(temp)), 1));
end
[h,p,ci,stats]=ttest(dist');
disp(mean(dist'))
disp(p)
%% RDMs
% rating results
rating=struct('valence',zeros(sub_num,odor_num));
rating.intensity=rating.valence;
rating.familarity=rating.valence;
rating.edibility=rating.valence;
rating.arousal=rating.valence;
for odori=1:odor_num
    % caculate mean score
    rating.valence(:,odori) = squeeze(ratings(odori,1,:));
    rating.intensity(:,odori) = squeeze(ratings(odori,2,:));
    rating.familarity(:,odori) = squeeze(ratings(odori,3,:));
    rating.edibility(:,odori) = squeeze(ratings(odori,4,:));
    rating.arousal(:,odori) = squeeze(ratings(odori,5,:));
end
% distances
dis = 'euclidean';
% dis = 'correlation';
rating.valRDM=pdist2(rating.valence',rating.valence',dis);
rating.intRDM=pdist2(rating.intensity',rating.intensity',dis);
rating.famRDM=pdist2(rating.familarity',rating.familarity',dis);
rating.ediRDM=pdist2(rating.edibility',rating.edibility',dis);
rating.aroRDM=pdist2(rating.arousal',rating.arousal',dis);
rating.simRDM=pdist2(mdes,mdes,dis);
% 10 dimension
% rating.simRDM=pdist2(desdim,desdim,dis);
vai=[mean(rating.valence);mean(rating.intensity)]';
rating.vaiRDM=pdist2(vai,vai,dis);
% mean for each subject
% for subi=1:sub_num
% tempsimRDM(:,:,subi)=pdist2(des(:,:,subi),des(:,:,subi),dis);
% % 10 dimension
% tempsimRDM(:,:,subi)=pdist2(desdimall(:,:,subi),desdimall(:,:,subi),dis);
% vai=[rating.valence(subi,:);rating.valence(subi,:)]';
% tempvaiRDM(:,:,subi)=pdist2(vai,vai,dis);
% tempvalRDM(:,:,subi)=pdist2(rating.valence',rating.valence',dis);
% tempintRDM(:,:,subi)=pdist2(rating.intensity',rating.intensity',dis);
% tempfamRDM(:,:,subi)=pdist2(rating.familarity',rating.familarity',dis);
% tempediRDM(:,:,subi)=pdist2(rating.edibility',rating.edibility',dis);
% temparoRDM(:,:,subi)=pdist2(rating.arousal',rating.arousal',dis);
% end
% rating.valRDM=mean(tempvalRDM,3);
% rating.intRDM=mean(tempintRDM,3);
% rating.famRDM=mean(tempfamRDM,3);
% rating.ediRDM=mean(tempediRDM,3);
% rating.aroRDM=mean(temparoRDM,3);
% rating.simRDM=mean(tempsimRDM,3);
% rating.vaiRDM=mean(tempvaiRDM,3);
% add each RDM to x
x=[];
% get field of struct
fname=fieldnames(rating);
for i=1:5    
    x=[x rating.(fname{i+5})(triu(true(size(rating.(fname{i+5}))), 1))];
end
x=rating.vaiRDM(triu(true(size(rating.vaiRDM)), 1));
y=rating.simRDM(triu(true(size(rating.simRDM)), 1));
[b,dev,stats] = glmfit(x(:,[1]),y,'normal');
disp([b stats.p])
% plot fitted line
figure;
hold on
plot(x(:,[1]),y,'o')
% fitted line
yfit = glmval(b,x(:,[1]),'identity');
plot(x(:,[1]),yfit,'-')
% save rating to mat file
save([datadir 'rating_inva.mat'],'rating')
mvi=means_vi';
save([datadir 'mresults.mat'],'desdim','mvi')