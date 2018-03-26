function [fig]=figure_ctrl(fig_name,W,L)

fig=figure('Name',fig_name);
set(0,'Units','pixels') ;
scnsize = get(0,'ScreenSize');
position = get(fig,'Position');
outerpos = get(fig,'OuterPosition');
borders = outerpos - position;
edge = -borders(1)/2;
pos1 = [10, 10, W , L];
set(fig,'OuterPosition',pos1) ;
fig.PaperPositionMode='auto';
fig.PaperUnits='inches';