% script for plotting Netflix emmy data from tidytuesday 

%% import data {{{

nominees = readtable('nominees.csv', 'ReadVariableNames', 1);

%%}}}

%% extract netflix data {{{

nominees.distributor = string(nominees.distributor);
%list all unique distributor names, just to have a look
unique_distributor = unique(nominees.distributor);
ind = find(nominees.distributor == 'Netflix');
distributed_netflix = nominees(ind,:);
%%}}}


%% add up number of nominations and wins for each year {{{
years = linspace(2013, 2021, (2021-2013)+1);
nominated = zeros((2021-2013)+1,1)
won = zeros((2021-2013)+1,1)
for i = 1:length(years)
	ind = find(string(distributed_netflix.type) == 'Nominee' & distributed_netflix.year == years(i));
	nominated(i) = length(ind);
	ind = find(string(distributed_netflix.type) == 'Winner' & distributed_netflix.year == years(i))
	won(i) = length(ind);
end

%calculate number of wins as a percentage for each year
percentage_won = won./(won+nominated)*100;
%}}}

%% plot {{{
%nominations and wins as a stacked bar plot
x = years';
y = [nominated won];
f1 = figure('Position', [200 200 800 600])
ax1 = gca;
b1 = bar(x,y, 'stacked');
hold on
ylabel('number of emmy nominations/wins', 'FontSize', 18)
axis([2012 2022 0 650])

%additonal y-axis for percentage wins as a dashed line
yyaxis right 
ax2 = gca;
ylabel('Percentage of nominations leading to a win', 'FontSize', 18)
dark_red = [0.6314 0.0196 0.0588];
ax2.YColor = dark_red;
axis([2012 2022 0 50]);
plot(years, percentage_won, '-.', 'color', dark_red, 'LineWidth', 3);

% set colors to match Netflix logo, make bars narrower
b1(1).FaceColor = [0.8 0.2 0];
b1(2).FaceColor = [1 0.2 0];
b1(1).BarWidth = 0.35;
b1(2).BarWidth = 0.35;

% insert legend, remove background, change text colour, add axis labels
l1 = legend('nominated', 'won');
set(l1, 'Color', 'none')
set(l1, 'TextColor', 'white')
set(l1, 'FontSize', 18)
set(l1, 'FontWeight', 'bold')
set(gca,'Color','k');
title('Netflix-distributed Emmy nominations vs. wins', 'FontSize', 18)
xlabel('year', 'FontSize', 18)

% insert logos at specified positions 
logo_n = imread('netflix_logo_2.png');
logo_name = imread('netflix_logo.jpeg');

ax3 = axes('Position', [.2 .6 .25 .25])
box on;
imshow(logo_n);

ax4 = axes('Position', [.2 .4 .25 .25])
box on;
imshow(logo_name);

% save figure (requires export_fig.m from the MATLAB File Exchange)
export_fig '~/Documents/MATLAB/tidy_tuesday/emmy_nominations' -png

%}}}


