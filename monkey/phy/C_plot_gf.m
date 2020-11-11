clear;
clc;
%% load .mat res data
% [filenames, pathname] = uigetfile( ...
%     {'*.bhv2;*.h5;*.mat;','All Data Files'},...
%     '请选择数据文件','MultiSelect', 'on');   
files=dir('200529*.mat');
matfile=files(1).name;
plxfile=strrep(matfile,'mat','plx');
res_data = load(matfile);
% sample rate of biopac resp
biopac_freq=500;

%% find out valid res points
odor_num = 5;
points = findpoints(res_data.data);
markers(:,1) = find(res_data.data(:,2)>0);
markers(:,2) = res_data.data(markers(:,1),2);

% marker_info | odor | start | end(air start)
marker_info(:,1) = markers(markers(:,2) ~=6,2);
marker_info(:,2) = markers(markers(:,2) ~=6,1);
marker_info(:,3) = markers(markers(:,2) == 6,1);

p = 1; % mark the index of current loc 
valid_res = cell(5,1);
%test = cell(5,1);
for i = 1:length(marker_info)
    odor = marker_info(i,1);
    odor_start = marker_info(i,2);
    odor_end = marker_info(i,3);
    for ii = p:length(points)
        
        % define respiration length as start to peak
        res_start = points(ii,1)-250;
        res_end = points(ii,2)-250;
        
        % for each respiration, check if it is in the odor presention
        if res_start>=odor_start && res_end<=odor_end
            valid_res{odor,1} = [valid_res{odor,1};[res_start,res_end]];
            %test{odor}{end+1} = res_data.data(res_start:res_end)';
        elseif res_end > odor_end
            p = ii;
            break
        else 
            continue
        end
        
    end
end

%% 
[raw_freq, raw_n, ~, raw_fn, raw_ad] = plx_ad(plxfile,'AI08'); % raw res data
raw_ts=(1:raw_fn)/raw_freq;
%read spike time
post = 3;
[nspk, tspk] = plx_ts(plxfile, 'SPK63',0); % spike data
valid_spk = cell(odor_num,1);
plot_res = cell(odor_num,1);
figure('position',[20,0,800,1000]);

%% plot raster
win = 0.05; % 50ms/win
max_y = 30;
for i = 1:odor_num
    cat_spk = [];
    subplot(3,2,i);
    for ii = 1:length(valid_res{i,1})
      
        ref = valid_res{i,1}(ii,1)/biopac_freq;
        valid_spk{i,1}{end+1,1} = tspk(tspk>=ref & tspk<=ref+post)-ref;
        cat_spk = cat(1,cat_spk,valid_spk{i}{ii});
        scatter(valid_spk{i}{ii},zeros(length(valid_spk{i}{ii}),1)+ii*5,7,'k','filled'); 
        hold on
%         axis off
        box off
        
    end
    trans_spk = floor(cat_spk/win)*win + win/2;
    freq = hist(trans_spk,unique(trans_spk))/(win*length(valid_res{i,1}));
%    max_y = max([max_y;smoothcur]);
    smoothfreq=smooth(freq);
%     smoothfreq=freq;
    plot(unique(trans_spk), smoothfreq,'LineWidth',1.5,'color','[0.4940 0.1840 0.5560]');
    
    % plot respiration
    for ii = 1:length(valid_res{i,1})
        
        ref = valid_res{i,1}(ii,1)/biopac_freq;
        y=raw_ad(raw_ts>=ref & raw_ts<=ref+post);
        y=(y-min(y))/(max(y)-min(y))*100+20;
        plot(raw_ts(raw_ts>=ref & raw_ts<=ref+post)-ref,y,'LineWidth',1.5,'color','b')        
        
    end
    
    %set(gca,'Position',[0.05+(i-1)*0.2,0.1,0.15,0.35])
    set(gca,'ylim',[0,120]);    
    xlabel('Time(s)');
    ylabel('Firing Rate (spk/s)');
    title(['odor ',int2str(i)])
end
% set(gcf,'Paperposition',[0.25 0.25 21 28])
% saveas(gcf,'rm035ana_0529_test01_64baseline2','pdf')