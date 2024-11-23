function [ DataValue ] = fun_Record2Value( DirFileName, Vref, Gain, SampleRate )
% 从ZCG或标定系统记录文件中读取数据并按照“三个字节表示一个数值”的规则来计算具体数值大小。
% 输入参数分别是ZCG或标定系统记录文件的路径与文件名、测量时设置的满量程电压值、信号调理模块增益、信号记录模块的采样率。

% 从ZCG或标定系统记录文件中读取数据
FileID = fopen(DirFileName,'r');
if (FileID==-1)
    warndlg('未打开数据文件！', '俊男の警告');
    DataValue = 0;
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fseek(FileID, 0, 'eof');
    %{
    'bof' 或 -1文件的开头
    'cof' 或 0文件中的当前位置
    'eof' 或 1文件的结尾
    %}
DataLength = ftell(FileID);
    %返回指定文件中的当前位置

if(DataLength<=0)
    DataValue = 0;
    return;
end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TimeLength = floor(DataLength/(SampleRate*3));
    % y = floor(x) 函数将x中元素取整，值y为不大于本身的最小整数。对于复数，分别对实部和虚部取整

fseek(FileID, 0, 'bof');

DataOrigin = fread(FileID,TimeLength*SampleRate*3,'uchar');
    %{
    FileID:文件句柄；
    TimeLength*SampleRate*3:每次读取长度；
    uchar:以uchar类型读取(unsigned char)
    %}

DataTemp = DataOrigin(1:3:end)*256*256 + DataOrigin(2:3:end)*256 + DataOrigin(3:3:end);   % 三个字节表示一个数值
    %{
    DataOrigin(1:3:end):从第一个位置开始读取，每隔3个字节读取一个，直到最后一个
    %}

DataTemp(DataTemp>8388608) = DataTemp(DataTemp>8388608)-16777215;    
    % 由于数据文件采用二进制补码方式，当数据大于2^23=8388608时，实际测量值为负电压,应减去2^24-1=16777215
%DataValue = DataTemp * Vref / (Gain*(8388608-1)) * 2.15/2;   % 2.15/2为采集存储模块内部衰减系数
DataValue = DataTemp * Vref / (Gain*(8388608-1)) ;   % 2.15/2为采集存储模块内部衰减系数

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fclose(FileID);



