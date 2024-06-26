%% set path
monkeys = {'RM035','RM033'};
% monkeys = {'RM033'};
if length(monkeys)>1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/respiration_odor/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
%% load data
trl=[];
resp_monkey=cell(1,length(monkeys));
for monkey_i = 1:length(monkeys)
    monkey = monkeys{monkey_i};
    file_dir = ['/Volumes/WD_D/gufei/monkey_data/yuanliu/' ...
                lower(monkey) '_ane/mat/'];
    label = [file_dir monkey '_datpos_label.mat'];
    load(label);
    data_resp = cell(length(filenames),1);
    for i_date = 1:length(filenames)
    file = filenames{i_date};
    data = load([file_dir file]);
    %% cut to trials
    resp=cell(1,length(data.lfp));
    trl_date=[];
    for i=1:length(data.lfp)
    cfg=[];
    cfg.trl=data.trl(i).odorresp;
    resp{i} = ft_redefinetrial(cfg, data.bioresp{i});
    % reshale resp points
    respoint=reshape(data.trl(i).resp(:,1),[],3);
    % add 2&3 column of resppoint to odorresp if the first column is same
    for resp_i = 1:size(data.trl(i).odorresp, 1)
        idx=find(respoint(:,1)==data.trl(i).odorresp(resp_i,1));
        if ~isempty(idx)
            data.trl(i).odorresp(resp_i,2:3)=respoint(idx,2:3);
        end
    end
    respoint = data.trl(i).odorresp;
    respoint(:,2:3)=respoint(:,2:3)-respoint(:,1);
    trl_date=[trl_date;respoint]; 
    end
    %% append data
    cfg=[];
    cfg.keepsampleinfo='no';
    resp = ft_appenddata(cfg,resp{:});
    % remove trials containing nan values
    idx=~(cellfun(@(x) any(any(isnan(x),2)),resp.trial));
    trl=[trl;trl_date(idx,:)]; 
    cfg.trials=idx;
    data_resp{i_date}=ft_selectdata(cfg,resp);
    end
    % for checking trial length
    resp_monkey{monkey_i} = ft_appenddata(cfg,data_resp{:});   
    % length(trl)
    % length(resp_monkey{monkey_i}.trial)
    % length(resp_monkey{1}.trial)+length(resp_monkey{2}.trial)
end
% add monkey id
if length(monkeys)>1
    trl(1:length(resp_monkey{1}.trial),5)=str2num(monkeys{1}(4:5));
    trl(length(resp_monkey{1}.trial)+1:end,5)=str2num(monkeys{2}(4:5));
end
save([pic_dir 'respoints.mat'],'trl')
%% analyze trl
load([data_dir 'pic/respiration_odor/' '2monkey' '/' 'respoints.mat'])
% bins=0:0.5:6;
bins=20;
% trl(:,1:3)=trl(:,1:3)/1000;
for time_i=2:3    
    figure('position',[20,450,800,1000])
    subplot(4, 2, 1)
    hist(trl(trl(:,4)~=6,time_i),bins)
    title('odor')
    subplot(4, 2, 2)
    hist(trl(trl(:,4)==6,time_i),bins)
    title('air')
    subplot(4, 2, 3)
    hist(trl(trl(:,5)==35,time_i),bins)
    title('RM035')
    subplot(4, 2, 4)
    hist(trl(trl(:,5)==33,time_i),bins)
    title('RM033')
    subplot(4, 2, 5)
    hist(trl(trl(:,5)==35&trl(:,4)==6,time_i),bins)
    title('RM035air')
    subplot(4, 2, 6)
    hist(trl(trl(:,5)==33&trl(:,4)==6,time_i),bins)
    title('RM033air')
    subplot(4, 2, 7)
    hist(trl(trl(:,5)==35&trl(:,4)~=6,time_i),bins)
    title('RM035odor')
    subplot(4, 2, 8)
    hist(trl(trl(:,5)==33&trl(:,4)~=6,time_i),bins) 
    title('RM033odor')
    % percentage of trials less than 3s
    disp(sum(trl(:,time_i)<3000)/length(trl(:,time_i)));
    disp(sum(trl(trl(:,4)~=6,time_i)<3000)/length(trl(trl(:,4)~=6,time_i)));
end