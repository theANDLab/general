%% John Maule - University of Sussex - 2018 
% run this cell and enter the measruements manually - 
fname = 'Brown_eizokm_20180923';

rgb = [0,4,8,16,24,32,64,96,128,140,150,160,170,180,190,200,210,220,230,240,250,255]';

red = [];
green = [];
blue = [];
grey = [];
xyY=[];

% measurements = load ('measurements1.txt');
% red = measurements(:,1)';
% green = measurements(:,2)';
% blue = measurements(:,3)';
% grey = measurements(:,3)';
% xyY = load('primaries1.txt');
  

%%
save(fname);
%% Average all the measurements and plot the gamma curves
red = red';
green = green';
blue = blue';
grey = grey'; % don't have grey measurements, but that doesn't matter

sumguns=red+green+blue;

figure;
plot(rgb,sumguns,'r','linewidth',4)
hold on
plot(rgb,grey,'black','linewidth',4)
hold off
%% Generate lookup table and gamut file and save out

calFile=fname;

SETTINGS.lutfilename    = [pwd, '\', calFile]; % if not direct control via dialoguebox
SETTINGS.measureinterval = [1, 1];
SETTINGS.agg_mode       = 'mean';
SETTINGS.fit            = 1;
SETTINGS.rgb            = (rgb(:,1))';
SETTINGS.plot           = 1;
SETTINGS.ldt            = 1;

%ANSWERS = [R(:,1), G(:,1), B(:,1), L(:,1)];
ANSWERS = [red', green', blue', grey'];

conversion = mod_lookuptabler(ANSWERS, SETTINGS);


dlmwrite([pwd, '\', calFile, '.xyY'], xyY, 'delimiter', '\t', 'newline', 'pc');

return