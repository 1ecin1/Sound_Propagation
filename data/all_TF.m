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
