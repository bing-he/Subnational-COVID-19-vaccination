clear;close all;
set(0,'defaultAxesFontSize',17)
addpath /Users/Icey/Dropbox/WE/Real_ocean_pressure/Cascadia
%% read data
T = readtable('vaccinations.txt');
location = unique(string(T{:,1}));
location_code = unique(string(T{:,4}));
% camp = colormap('hsv');
%% plot US subnational data
s_time = datetime('2021-01-20','InputFormat','yyyy-MM-dd');
e_time = datetime('2021-02-11','InputFormat','yyyy-MM-dd');
location_code(4) = []; location(4) = [];
location_code(16) = []; location(16) = [];
location_code(17) = []; location(17) = [];

% figure('position',[10,10,5500,3000],'visible','off')
figure('position',[10,10,1500,1000])
subplot(211)
is = 20;
ii1 = find(string(T{:,4}) == location_code{is});
T1 = T(ii1,:);
ii2 = find(T1{:,3}>s_time & T1{:,3}<e_time);
T1 = T1(ii2,:);
region_code = unique(string(T1{:,5}));
region = unique(string(T1{:,2}));
slope = zeros(length(region_code),1);
Max_per = zeros(length(region_code),1);
for is_rc = 1:length(region_code)
    ii2 = find(string(T1{:,5}) == region_code{is_rc});
    T2 = T1(ii2,:);
    %      semilogy(T2{ii3,3},T2{ii3,6},'.-','LineWidth',1.5)
    plot(T2{:,3},T2{:,9},'.-','LineWidth',1.5)
    ymd = zeros(size(T2,1),6);
    ymd(:,1) = year(T2{:,3});
    ymd(:,2) = month(T2{:,3});
    ymd(:,3) = day(T2{:,3});
    dd = date2dd(ymd,2021);
    hold on
    pp1 = polyfit(dd,T2{:,9},1);
    slope(is_rc) = pp1(1);
    Max_per(is_rc) = T2{end,9};
end
grid on
xlim([s_time e_time])
xticks(s_time:4:e_time)
%     ylim([0 max(T1{:,9})])
text(s_time+1,max(T1{:,9})-0.5,['Average rate: ' num2str(nanmean(slope))],'FontSize',20)
lgd = legend(region_code,'location','bestoutside');
lgd.Units = 'centimeters';lgd.FontAngle = 'italic'; lgd.FontSize = 12;
lgd.NumColumns = 3;
title([location{is} ' subnational total vaccinations per 100 inhabitants'])

%%% plot bar graph
subplot(212)
bar(slope,0.5)
grid on
for is = 1:length(region_code)
    text(is-0.5,slope(is)+0.01,num2str(slope(is),'%.2f'),'FontSize',12)
    text(is-0.5,slope(is)+0.04,[num2str(round(Max_per(is))) '%'],...
        'Color','r','FontSize',12)
end
text(30,0.67,'**% represents the percentage of people who get vaccinated until 02/10/2021',...
    'color','r','FontSize',13)
text(30,0.64,'0.** represents the rate of people who get vaccinated 01/21/2021 - 02/10/2021',...
    'color','k','FontSize',13)
xticks(1:1:length(region_code))
xticklabels(region)
xtickangle(45)
ylim([0.25 0.7])
title('Average rate for US subnational total vaccinations per 100 inhabitants')
return


%% plot data for each country
figure('position',[10,10,1500,1000])
s_time = datetime('2021-01-13','InputFormat','yyyy-MM-dd');
e_time = datetime('2021-02-13','InputFormat','yyyy-MM-dd');
for is1 = 1:length(location_code)
% for is1 = 1
    ii1 = find(string(T{:,4}) == location_code{is1});
    T1 = T(ii1,:);
    % region_code = unique(string(T1{:,5}));
    min_time = min(T1{:,3});
    max_time = max(T1{:,3});
    time = min_time:1:max_time;
    n_days = length(time);
    tot_all = nan(n_days,1);
    num = 1;
    for is_time = min_time:1:max_time
        ii2 = find(T1{:,3} == is_time);
        tot_all(num) = sum(T1{ii2,6});
        num = num+1;
    end
    time1 = time;
    time1(tot_all == 0) = [];
    tot_all(tot_all == 0) = [];
    if is1 <= 11
        subplot(211)
        semilogy(time1,tot_all,'.-','color',camp(is1*20,:),'LineWidth',1.5)
        hold on
    else
        subplot(212)
        semilogy(time1,tot_all,'.-','color',camp((is1-11)*20,:),'LineWidth',1.5)
        hold on
    end
end
subplot(211)
grid on
legend(location(1:11),'location','northeastoutside')
xlim([s_time e_time])
% subplot(212)
% grid on
% legend(location(12:end),'location','northeastoutside')
% xlim([s_time e_time])