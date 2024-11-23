load('Freq.mat')
%%
f=Freq(1:3000,:);
%%
figure
imagesc(1:size(result_6_5_22,2),f,result_6_5_22)
%%
up_a=result_6_5_22(:,400:430);
up_b=result_6_5_22(:,250:280);
up_c=result_6_5_22(:,50:80);

do_a=result_6_5_29(:,400:430);
do_b=result_6_5_29(:,250:280);
do_c=result_6_5_29(:,50:80);
%%
figure
imagesc(1:size(result_6_7_22,2),f,result_6_7_22)
%%
up_d=result_6_7_22(:,260:290);
up_e=result_6_7_22(:,170:200);
up_f=result_6_7_22(:,50:80);

do_d=result_6_7_29(:,260:290);
do_e=result_6_7_29(:,170:200);
do_f=result_6_7_29(:,50:80);
%%
up_all=[zeros(3000, 2) up_a zeros(3000, 5) up_b zeros(3000, 7) up_d zeros(3000, 10) up_c zeros(3000, 14) up_e zeros(3000, 20) up_f zeros(3000, 2)];
%up_all(up_all==0)=10;
do_all=[zeros(3000, 2) do_a zeros(3000, 5) do_b zeros(3000, 7) do_d zeros(3000, 10) do_c zeros(3000, 14) do_e zeros(3000, 20) do_f zeros(3000, 2)]+10;

%%
figure('name','总体频域5','NumberTitle', 'off','Position',[200 300 700 300])
%imagesc(1:size(up_all,2),f,up_all)
pcolor(1:size(up_all,2),f,up_all)
shading interp
colormap jet
axis xy
%set(gca,'yscale','log')
xticks([17 53 93 134 178 230])		%具体的y轴刻度
xticklabels({'a(50m)','b(200m)','c(500m)','d(1km)','e(4km)','f(8km)'})
ylim([20 500]); %5000轴范围
set(get(gca, 'Xlabel'),'FontWeight','bold','Fontsize',13);
set(get(gca, 'Ylabel'),'FontWeight','bold','Fontsize',13);
set(gca,'FontSize',13);
xlabel('Station','FontName','Times New Roman');
ylabel(['Frequency ' '\it f\rm' ' / Hz'],'FontName','Times New Roman');
set(gca,'FontSize',13,'Fontname', 'Times New Roman');
set(gca, 'TickDir', 'out');%使图像坐标轴的刻度朝外
set(get(colorbar,'Title'),'string','SPL / dB','FontName','Times New Roman');
caxis([40 100])
%%
figure('name','总体频域5','NumberTitle', 'off','Position',[200 300 700 300])
%imagesc(1:size(up_all,2),f,up_all)
pcolor(1:size(do_all,2),f,do_all)
shading interp
colormap jet
axis xy
%set(gca,'yscale','log')
xticks([17 53 93 134 178 230])		%具体的y轴刻度
xticklabels({'a(50m)','b(200m)','c(500m)','d(1km)','e(4km)','f(8km)'})
ylim([20 2000]); %5000轴范围
set(get(gca, 'Xlabel'),'FontWeight','bold','Fontsize',13);
set(get(gca, 'Ylabel'),'FontWeight','bold','Fontsize',13);
set(gca,'FontSize',13);
xlabel('Station','FontName','Times New Roman');
ylabel(['Frequency ' '\it f\rm' ' / Hz'],'FontName','Times New Roman');
set(gca,'FontSize',13,'Fontname', 'Times New Roman');
set(gca, 'TickDir', 'out');%使图像坐标轴的刻度朝外
set(get(colorbar,'Title'),'string','SPL / dB','FontName','Times New Roman');
caxis([40 100])