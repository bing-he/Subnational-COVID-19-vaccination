clear;close all;
set(0,'defaultAxesFontSize',18)
addpath /Users/Icey/Dropbox/WE/Real_ocean_pressure/Cascadia
%% read data
T = readtable('vaccinations.txt');
location = unique(string(T{:,1}));
location_code = unique(string(T{:,4}));
camp = colormap('hsv');
%% plot subnational vaccination in each country.
s_time = datetime('2021-01-20','InputFormat','yyyy-MM-dd');
e_time = datetime('2021-02-11','InputFormat','yyyy-MM-dd');
location_code(4) = []; location(4) = [];
location_code(16) = []; location(16) = [];
location_code(17) = []; location(17) = [];
total_slope = nan(length(location),1);
max_loc = zeros(length(location),1);
figure('position',[10,10,4250,2000],'visible','off')
% figure('position',[10,10,4000,1000])
num = 1;
for is = 1:length(location)
%for is = 1:10
    subplot(4,5,num)
    ii1 = find(string(T{:,4}) == location_code{is});
    T1 = T(ii1,:);
    ii2 = find(T1{:,3}>s_time & T1{:,3}<e_time);
    T1 = T1(ii2,:);
    region_code = unique(string(T1{:,5}));
    slope = zeros(length(region_code),1);
    max_per = zeros(length(region_code),1);
    for is_rc = 1:length(region_code)
        ii2 = find(string(T1{:,5}) == region_code{is_rc});
        T2 = T1(ii2,:);
%         semilogy(T2{ii3,3},T2{ii3,6},'.-','LineWidth',1.5)
        plot(T2{:,3},T2{:,9},'.-','LineWidth',1.5)
        ymd = zeros(size(T2,1),6);
        ymd(:,1) = year(T2{:,3});
        ymd(:,2) = month(T2{:,3});
        ymd(:,3) = day(T2{:,3});
        dd = date2dd(ymd,2021);
        hold on
        pp1 = polyfit(dd,T2{:,9},1);
        slope(is_rc) = pp1(1);
        max_per(is_rc) = T2{end,9};
    end
    grid on
    xlim([s_time e_time])
    xticks(s_time:4:e_time)
%     ylim([0 max(T1{:,9})])
    total_slope(is) = nanmean(slope);
    max_loc(is) = nanmean(max_per);
    text(s_time+1,max(T1{:,9})-0.5,['Average rate: ' num2str(nanmean(slope))],'FontSize',17)
    
    lgd = legend(region_code,'location','bestoutside');
    lgd.FontSize = 10;lgd.FontAngle = 'italic';
    if is==20 || is==14
        lgd.NumColumns = 2;
    end
    title(location{is})
    num = num+1;
end

%% save the figure
% fig = gcf;
% fig.PaperPositionMode = 'auto';
% fig_pos = fig.PaperPosition;
% fig.PaperSize = [fig_pos(3) fig_pos(4)+0.2];
% print(fig,'Vanccination','-dpdf','-bestfit')


%% plot bar graph
set(0,'defaultAxesFontSize',22)
figure('position',[10 10 2000 600])
subplot(121)
bar(total_slope,0.5)
text(1,0.6,['Average = ' num2str(mean(total_slope),'%.2f')],'FontSize',20)
for is = 1:length(location)
    text(is-0.3,total_slope(is)+0.01,num2str(total_slope(is),'%.2f'),'FontSize',14)
    text(is-0.3,total_slope(is)+0.04,[num2str(round(max_loc(is))) '%'],...
        'Color','r','FontSize',14)
end
text(0.5,0.77,'**% represents the percentage of people who get vaccinated until 02/10/2021',...
    'color','r','FontSize',16)
text(0.5,0.73,'0.** represents the rate of people who get vaccinated 01/21/2021 - 02/10/2021',...
    'color','k','FontSize',16)
ylim([0 0.8])
grid on
xticks(1:1:20)
xticklabels(location)
xtickangle(45)
title('Average rate for national total vaccinations per 100 inhabitants')
subplot(122)
Days = (80-max_loc)./total_slope;
bar(Days,0.5)
for is = 1:length(location)
    text(is-0.5,Days(is)+35,num2str(round(Days(is))),'FontSize',14)
end
grid on
xticks(1:1:length(location))
xticklabels(location)
xtickangle(45)
ylabel('Days')
% ylim([50 260])
title('Days to reach 80% of people vaccinated')