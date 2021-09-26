% set seed
rng(666);
% hrf function
hrf = [0 0 1 5 8 9.2 9 7 4 2 0 -1 -1 -0.8 -0.7 -0.5 -0.3 -0.1 0];
hrf = hrf / max(hrf);
oneblock=390;
% seconds and odor time points
odornum = 5;
seconds = oneblock*odornum;
points = 7:13:seconds;
odorspoints = reshape(randperm(length(points)),odornum,[]);
odorspoints = points(odorspoints);
% set response
real = [37 61 37 29 53];
val = [4.5 4.8 4.8 3.9 3.8];
% val = [4.5 4.8 4.8 3.7 3.8];%high acc
red = 1:5;
red2 = randperm(5);
% val = [1 3 1 1.1 1.1];
int = [2.2 1.8 3.4 3.6 2.2];
% real = [5 5 5 5 5];
% int = ones(1,5);
% set time points with odor to 1
odors = zeros(odornum, seconds);
key = odors;
key1=key;
for i=1:odornum
    odors(i,odorspoints(i,:))=1;
    key(i,min(odorspoints(i,:)+3+round(normrnd(0,0.3,[1,size(odorspoints,2)])),...
        seconds*ones(1,size(odorspoints,2))))=1;
end
% divide into 2 keys
firstkey=randperm(seconds,seconds/2);
key1(:,firstkey)=key(:,firstkey);
key2=key;
key2(:,firstkey)=0;
% generate voxels
n=100;
voxel=zeros(n,seconds);
vires=zeros(n,2);% 1-valence 2-intensity
originalodors=odors;
% block and time noise for odor response
noise_time=normrnd(0,0.5,[1,seconds]);
noise_block=normrnd(0,0.3,[1,odornum]);
noise_block=reshape(repmat(noise_block,[oneblock 1]),1,[]);
odors=originalodors.*(noise_time+noise_block)+originalodors;
% block and time noise for odor intensity response
noise_time=normrnd(0,0.8,[1,seconds]);
noise_block=normrnd(0,0.5,[1,odornum]);
noise_block=reshape(repmat(noise_block,[oneblock 1]),1,[]);
odorsint=originalodors.*(noise_time+noise_block)+originalodors;
% block and time noise for odor valence response
noise_time=normrnd(0,0.5,[1,seconds]);
noise_block=normrnd(0,0.3,[1,odornum]);
noise_block=reshape(repmat(noise_block,[oneblock 1]),1,[]);
odorsval=originalodors.*(noise_time+noise_block)+originalodors;

for i=1:n
    % oddvoxel:3 5 4 2 4 even:2-3
%     realres = mod(i,n)/n*real+normrnd(0,0.05,1,odornum)+mod(i,n)/n;
%     realres = (1+i/10)*real;
%     odorhrf=conv(realres*odors,hrf);
%     odorhrf=odorhrf(1:seconds);
    shift=unifrnd(0,1)>0.3;
    if shift
    realres = unifrnd(0,1,[1,odornum])*100;
%     same=randperm(5,2);
%     realres(same(1))=realres(same(2));
    else
    realres = unifrnd(0,1,[1,odornum])*100;
    realres(5)=realres(4);
%     realres(3)=realres(4);
    end
    
%     noise_time=normrnd(0,0.005,[1,seconds]);
%     noise_block=normrnd(0,0.0003,[1,odornum]);
%     noise_block=reshape(repmat(noise_block,[oneblock 1]),1,[]);
%     odors=odors.*(noise_time+noise_block)+odors;
    
    odorhrf=[];
    permu=unifrnd(0,1)>=0;
    for i_block=1:odornum
        if shift && permu
            realres = realres(randperm(5));
%             realres(1:3) = realres(randperm(3));
%             realres = unifrnd(0,1,[1,odornum])*100;
        elseif shift
            realres = unifrnd(0,1,[1,odornum])*100;
        end
        temp=conv(realres*odors(:,(i_block-1)*oneblock+1:i_block*oneblock),hrf);
        odorhrf=[odorhrf temp(1:oneblock)];
    end
    % 30% chance response to valence
    valres = val;%+normrnd(0,0.02,1,odornum);
    if unifrnd(0,1)>0.7
        vires(i,1) = 1;
        valhrf=conv(valres*odorsval,hrf);
    else
        valhrf=conv((ones(1,odornum))*odorsval,hrf);
    end
    valhrf=valhrf(1:seconds);
    % 80% chance response to intensity
    intres = int;%+normrnd(0,0.05,1,odornum);
    if unifrnd(0,1)>0.2
        vires(i,2) = 1;
        inthrf=conv(intres*odorsint,hrf);
    else
        inthrf=conv((ones(1,odornum))*odorsint,hrf);
    end
    inthrf=inthrf(1:seconds);
    % add noise
    noise1=conv(normrnd(0,10,[1,seconds]),hrf);
    noise1=noise1(1:seconds);
    noise2=normrnd(0,10,[1,seconds]);
    voxel(i,:)=odorhrf+inthrf+valhrf+noise1+noise2;
end
% general time noise for all voxels
% noise_time=conv(normrnd(0,0.01,[1,seconds]),hrf);
% noise_time=noise_time(1:seconds);
% noise_block=normrnd(0,0.1,[1,odornum]);
% noise_block=reshape(repmat(noise_block,[oneblock 1]),1,[]);
% voxel=voxel+voxel.*(noise_time+noise_block);
% figure
% plot(voxel')
%% regressors
resodor = zeros(size(odors));
for i=1:odornum
    temp=conv(odors(i,:)+normrnd(0,0.01,1,seconds),hrf);
    temp=temp(1:seconds);
    resodor(i,:)=temp;
end
reskey=conv(sum(key),hrf);
reskey1=conv(sum(key1),hrf);
reskey2=conv(sum(key2),hrf);
resval=conv(val*odors,hrf);
resint=conv(int*odors,hrf);
resred=conv(red*odors,hrf);
resred2=conv(red2*odors,hrf);
% resint=conv([1.8 2.2 2 1.9 2.1]*odors,hrf);
% resval;resint;resred;
designmat=[resval;resint;reskey1;reskey2];
designmat=designmat(:,1:seconds);
% ones regressor (redundant)
% designmat=[ones(1,seconds);designmat];
% 5 odor regressor
% designmat=[resodor;designmat];
% 1 odor regressor
resone = conv(sum(odors),hrf);
resone=resone(1:seconds);
designmat=[resone;designmat];
% plot regressors
% figure
% nplots = size(designmat,1);
% for i=1:nplots
%     subplot(2,round(nplots/2),i)
%     plot(designmat(i,:)')
% end
%% glm fit
voxelfit=zeros(n,seconds);
% the constant term is the first element of b
b=zeros(size(designmat,1)+1,n);
wholemat=[ones(seconds,1) designmat'];
% wholemat=[ones(seconds,1) designmat([6 7 8],:)'];
fits=zeros(size(voxel));
for i=1:n
    b(:,i)=glmfit(designmat',voxel(i,:));
    % glmfit is equal to this one b=pinv(x)*y=inv(x'*x)*x'*y
%     x=[ones(seconds,1) designmat'];
%     b(:,i)=pinv(x)*voxel(1,:)';
%     b(:,i)=inv(x'*x)*x'*voxel(1,:)';
    val=wholemat*b(:,i);
%     val=wholemat*b([1 7:9],i);
    fits(i,:)=val';    
end
errors=voxel-fits;
% figure
% plot(fits')
% figure
% plot(errors')
% get 6s response
maxrespoints = sort(odorspoints,2)+6;
maxres = zeros(odornum,size(odorspoints,2),n);
maxfit = maxres;
for i=1:n
    i_errors = errors(i,:);
    maxres(:,:,i) = i_errors(maxrespoints);
    i_fits = fits(i,:);
    maxfit(:,:,i) = i_fits(maxrespoints);
end
mean_res=squeeze(mean(maxres,2));
mean_fit=squeeze(mean(maxfit,2));
%% RSA
maxres_re=reshape(permute(maxres,[2,1,3]),length(points),n);
rho=corr(maxres_re');
figure('position',[20,450,500,400]);
imagesc((1-rho)./max(max(1-rho)));
colormap jet
colorbar
figure('position',[530,450,500,400]);
scatter(maxres_re(1,:),maxres_re(2,:))
xlabel('trial1');ylabel('trial2')
%% MVPA
passed_data.data=maxres_re;
[results,decfg]=decoding_roi_5odors_glm(passed_data,odornum);
disp(results.confusion_matrix.output{1});
% show correlation between 2 voxels
color='rgbyp';
color=color(1:odornum);
color=reshape(repmat(color,[length(points)/odornum 1]),[],1);
cmap = containers.Map({'y','m','c','r','g','b','w','p'},...
    {[1 0.6 0],[1 0 1],[0 1 1],[1 0 0],[0 0.8 0],[0 0 0.8],[1 1 1],[0.67 0 1]});
C=cell2mat(values(cmap,cellstr(color)));
figure('position',[20,0,1000,400]);
subplot(1,2,1)
scatter(maxres_re(:,1),maxres_re(:,2),50,cell2mat(values(cmap,cellstr(color))),'filled')
xlabel('voxel1');ylabel('voxel2')
subplot(1,2,2)
scatter3(maxres_re(:,3),maxres_re(:,4),maxres_re(:,5),50,C,'filled')
% scatter3(maxres_re(:,1),maxres_re(:,2),maxres_re(:,3),50,C,'filled')
xlabel('voxel3');ylabel('voxel4');zlabel('voxel5')

figure('position',[20,1000,1000,400]);
plot(voxel(1,1:oneblock)')
hold on ;plot(errors(1,1:oneblock)')