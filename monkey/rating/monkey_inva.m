function monkey_inva(offcenter_x, offcenter_y)
% rate monkey odors
% times
waittime=1;
cuetime=1.5;
odortime=2;
offset=1;
blanktime=0.5;
iti=2;

% fixation
fix_size=18;
fix_thick=3;
fixcolor_back=[0 0 0];
fixcolor_cue=[246 123 0]; %[211 82 48];
fixcolor_inhale=[0 154 70];  %[0 0 240];

% port
port='COM3';%COM3
% keys
KbName('UnifyKeyNames');
Key1 = KbName('1!');
Key2 = KbName('2@');
escapeKey = KbName('ESCAPE');
triggerKey = KbName('s');

% rating instruction
air=0;

% input
prompt={'Enter subject number:'};
name='Experimental Information';
numlines=1;
defaultanswer={'s999'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
subject=answer{1};
id=str2double(subject(end-1:end));
% skip sync test
Screen('Preference', 'SkipSyncTests', 1);
if nargin < 2
    offcenter_x=0; offcenter_y=0;
end
% odor seq
seq = gen_seq('vi', id);

% record
result=zeros(length(seq),7);
result(:,1)=seq;

AssertOpenGL;
whichscreen=max(Screen('Screens'));

% ettport
delete(instrfindall('Type','serial'));
% ettport=ett('init',port);

% colors
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)*4/5);
backcolor=gray;

% data file
datafile=sprintf('Data%s%s_inva%s.mat',filesep,subject,datestr(now,30));
% open screen
[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('TextFont', windowPtr, 'Kaiti');
% get screen size
[width, height] = Screen('WindowSize',windowPtr);

fixationp1=OffsetRect(CenterRect([0 0 fix_thick fix_size],rect),offcenter_x,offcenter_y);
fixationp2=OffsetRect(CenterRect([0 0 fix_size fix_thick],rect),offcenter_x,offcenter_y);

fps=round(FrameRate(windowPtr));%Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
oldPriority=Priority(MaxPriority(windowPtr));

HideCursor;
ListenChar(2);      % turn off keyboard

% air
% ett('set',ettport,air); 

% start screen
msg=sprintf('Press [s] key to start...');
Screen('FillRect',windowPtr,backcolor);
Screen('DrawText',windowPtr,msg,20,20,black);
Screen('Flip',windowPtr);
% wait for key to start
[touch, ~, keyCode] = KbCheck;
while ~(touch && (keyCode(triggerKey) || keyCode(escapeKey)))
    [touch, ~, keyCode] = KbCheck;
end

tic;
zerotime=GetSecs;

% start
Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
Screen('Flip',windowPtr);

% wait time
WaitSecs(waittime);

cyc = 1;
while cyc~=size(seq, 1)+1
    
    odor=seq(cyc,1);
    
    % hint
    Screen('FillRect',windowPtr,fixcolor_cue,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_cue,fixationp2);
    vbl=Screen('Flip',windowPtr);
    starttime=GetSecs;
    result(cyc,2)=starttime-zerotime;
    
    % open
    WaitSecs(cuetime-offset);
%     ett('set',ettport,odor);
    
    % inhale
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp2);
    vbl=Screen('Flip', windowPtr, vbl + (fps*cuetime-0.1)*ifi);
    trialtime=GetSecs;
    result(cyc,3)=trialtime-zerotime;
    
    % close 
    WaitSecs(odortime-offset);
%     ett('set',ettport,air);    

    % offset
    WaitSecs(offset);
    
    % blank screen
    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    Screen('Flip', windowPtr);
    WaitSecs(blanktime);
    
    % rating  
    results(cyc,4:end) = gen_rating(exp,windowPtr);
     
    % if not the last trial
    if cyc~=length(seq)
    % count down iti
    timer=iti;
    Screen('TextSize', windowPtr, 32);
    [norm,~]=Screen('TextBounds', windowPtr, num2str(timer));
    count=OffsetRect(CenterRect(norm,rect),offcenter_x,offcenter_y);
    Screen('DrawText', windowPtr, num2str(timer),count(1),count(2),0);
    vbl = Screen('Flip', windowPtr);

    while GetSecs-vbl<iti
        % flip every 1 second
        if floor(GetSecs-vbl)>iti-timer+0.9
            timer=timer-1;
            Screen('TextSize', windowPtr, 32);
            [norm,~]=Screen('TextBounds', windowPtr, num2str(timer));
            count=OffsetRect(CenterRect(norm,rect),offcenter_x,offcenter_y);
            Screen('DrawText', windowPtr, num2str(timer),count(1),count(2),0);
            Screen('Flip', windowPtr);
        end
        [touch, ~, keyCode] = KbCheck;
        if touch && keyCode(escapeKey)
            ListenChar(0);      % open keyboard
            Screen('CloseAll');
            save(datafile,'result','response');
            return
        end
    end
    
    % wait time 2s
    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    Screen('Flip',windowPtr);
    WaitSecs(waittime);    
    end
    
    cyc = cyc + 1;
end

toc;
% restore
Priority(oldPriority);
ShowCursor;
ListenChar(0);      %restore keyboard
Screen('CloseAll');
%save
save(datafile,'result');

return