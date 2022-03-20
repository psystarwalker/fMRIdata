data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm033_ane/';
out_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm033_ane/mat/';
sample_rate=500;
% dates={'191212','191227','191231'};
% dates={'200107','200114','200119','200312'};
% dates={'200227','200305'};
% dates={'200319','200326','200403','200410','200416','200114'};
% dates={'200319','200326','200410','200416','200403'};
dates={'200423'};
channel=33:64;
bad_channel=[46 50 56];
channel(ismember(channel,bad_channel))=[];
% channel=num2str(48);
resp_channel='AI08';

for d=1:length(dates)
    for elec_i=1:2  
    %data filename
    cur_date=dates{d};
    pattern=[data_dir cur_date '_testo*_rm033_' num2str(elec_i) '*plx'];
%     pattern=[data_dir cur_date '_testo' '*' '_rm033.plx'];
    plxname=dir(pattern);
    % blank data
    lfp=cell(1,length(plxname));
    trlodorresp=cell(1,length(plxname));
    trlodor=cell(1,length(plxname));
    trlresp=cell(1,length(plxname));
    resp=lfp;
    bioresp=lfp;
    
    % check number of files
    if length(plxname)>0
    for i=1:length(plxname)    
    try
    disp(['Processing... ' plxname(i).name]);
    % test=1;
    fl=[data_dir filesep plxname(i).name];
    front=strrep(fl,'.plx','');
    %按照每导读取数据，频率信息存在raw_freq中，数据信息存在raw_ad中
%     [res_freq, res_n, res_ts, res_fn, raw_res] = plx_ad_v(fl,resp_channel); % raw res data
    % [n, ts, sv] = plx_event_ts(fl, 'Strobed');
    %fieldtrip的格式组织数据
    lfp{i}=struct('label',{{}},'trial',{{[]}},'time',{{[]}});
%     resp{i}=lfp{i};
    %resp
%     ad_time=(1:res_n)/res_freq;
%     resp{i}.label{end+1}=resp_channel;
%     resp{i}.trial{1}=[resp{i}.trial{1};raw_res'];
%     resp{i}.time{1}(end+1,:)=ad_time';
%     resp{i}.fsample=res_freq;
    for i_channel=1:length(channel)
        CON_chan=strcat('WB',num2str(channel(i_channel)));
        [raw_freq, raw_n, raw_ts, raw_fn, raw_ad] = plx_ad_v(fl,CON_chan);
        %lfp
        if i_channel==1
            % lfp.dimord='chan_time';
            lfp{i}.fsample=raw_freq;
            ad_time=(1:raw_n)/raw_freq;
            lfp{i}.time{1}=ad_time';
            lfp{i}.trial{1}=[];
        end        
%         disp(size(raw_ad));
        % deal with size difference
        size_diff = size(raw_ad,1)-length(ad_time);
        if size_diff<0
            raw_ad=[raw_ad;zeros(abs(size_diff),1)];
        elseif size_diff>0
            raw_ad=raw_ad(1:length(ad_time));
        end
        if size_diff~=0
        cat=[plxname(i).name ' ' CON_chan ' diff: ' num2str(size_diff)];
        unix(['echo ' cat ' >> ' out_dir 'diff.txt']);
        end
        lfp{i}.label{i_channel,1}=CON_chan;
        lfp{i}.trial{1}=[lfp{i}.trial{1};raw_ad'];
    end
    % resample
    cfg=[];
    cfg.resamplefs  = 1000;
    lfp{i} = ft_resampledata(cfg,lfp{i});
    % filt data
    cfg=[];
    cfg.bpfilter = 'yes';
    cfg.bpfilttype = 'fir';
    cfg.bpfreq = [0.1 300];
    cfg.bsfilter    = 'yes';
    cfg.bsfilttype = 'fir';
    cfg.bsfreq      = [49 51];
    lfp{i} = ft_preprocessing(cfg,lfp{i});
    %得到plx时间下的呼吸时间点
    [res_plx,resp_points,odor_time,bioresp{i}]=find_resp_time(front);
    %取0点前3.5s,后9.5s
    offset = -3.5;
    after  = 9.5;
    %呈现气味的呼吸
    trl=[];    
    for label_i=1:length(res_plx)
        trl=[trl;[res_plx{label_i}(:,1:2) zeros(size(res_plx{label_i},1),1) repmat(label_i,size(res_plx{label_i},1),1)]];
    end
    trl(:,1:2)=round(trl(:,1:2)*lfp{i}.fsample);
    trl(:,2)=trl(:,1)+lfp{i}.fsample*after;
    trl(:,1)=trl(:,1)+lfp{i}.fsample*offset;
    trl(:,3)=lfp{i}.fsample*offset;
    trlodorresp{i}=trl;
    %气味条件
    trl=[];
    for label_i=1:length(odor_time)
        trl=[trl;[odor_time{label_i} zeros(size(odor_time{label_i},1),1) repmat(label_i,size(odor_time{label_i},1),1)]];
    end
    trl(:,1:2)=round(trl(:,1:2)*lfp{i}.fsample);
    trl(:,2)=trl(:,1)+lfp{i}.fsample*after;
    trl(:,1)=trl(:,1)+lfp{i}.fsample*offset;
    trl(:,3)=lfp{i}.fsample*offset;
    trlodor{i}=trl;
    %呼吸条件
    label=repmat([1 2 3],[size(resp_points,1) 1]);
    label=reshape(label,[],1);
    resp_points=reshape(resp_points,[],1);
    trl=zeros(length(resp_points),4);
    trl(:,1)=resp_points;
    trl(:,4)=label;
    trl(:,1:2)=round(trl(:,1:2)*lfp{i}.fsample);
    trl(:,2)=trl(:,1)+lfp{i}.fsample*after;
    trl(:,1)=trl(:,1)+lfp{i}.fsample*offset;
    trl(:,3)=lfp{i}.fsample*offset;
    trlresp{i}=trl;
    % echo broken files
    catch
        unix(['echo ' plxname(i).name ' >> ' out_dir 'broken.txt']);
    end    
    end
    trl=struct('resp',trlresp,'odor',trlodor,'odorresp',trlodorresp);
    save([out_dir cur_date '_rm033_' num2str(elec_i) '_ane.mat'],'plxname','lfp','bioresp','trl');    
    end    
    end
end

% unix(['cat ' out_dir 'diff_old.txt|awk ''{print $1}''|uniq |wc -l']);