function [ DataValue ] = fun_Record2Value( DirFileName, Vref, Gain, SampleRate )
% ��ZCG��궨ϵͳ��¼�ļ��ж�ȡ���ݲ����ա������ֽڱ�ʾһ����ֵ���Ĺ��������������ֵ��С��
% ��������ֱ���ZCG��궨ϵͳ��¼�ļ���·�����ļ���������ʱ���õ������̵�ѹֵ���źŵ���ģ�����桢�źż�¼ģ��Ĳ����ʡ�

% ��ZCG��궨ϵͳ��¼�ļ��ж�ȡ����
FileID = fopen(DirFileName,'r');
if (FileID==-1)
    warndlg('δ�������ļ���', '���Фξ���');
    DataValue = 0;
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fseek(FileID, 0, 'eof');
    %{
    'bof' �� -1�ļ��Ŀ�ͷ
    'cof' �� 0�ļ��еĵ�ǰλ��
    'eof' �� 1�ļ��Ľ�β
    %}
DataLength = ftell(FileID);
    %����ָ���ļ��еĵ�ǰλ��

if(DataLength<=0)
    DataValue = 0;
    return;
end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TimeLength = floor(DataLength/(SampleRate*3));
    % y = floor(x) ������x��Ԫ��ȡ����ֵyΪ�����ڱ������С���������ڸ������ֱ��ʵ�����鲿ȡ��

fseek(FileID, 0, 'bof');

DataOrigin = fread(FileID,TimeLength*SampleRate*3,'uchar');
    %{
    FileID:�ļ������
    TimeLength*SampleRate*3:ÿ�ζ�ȡ���ȣ�
    uchar:��uchar���Ͷ�ȡ(unsigned char)
    %}

DataTemp = DataOrigin(1:3:end)*256*256 + DataOrigin(2:3:end)*256 + DataOrigin(3:3:end);   % �����ֽڱ�ʾһ����ֵ
    %{
    DataOrigin(1:3:end):�ӵ�һ��λ�ÿ�ʼ��ȡ��ÿ��3���ֽڶ�ȡһ����ֱ�����һ��
    %}

DataTemp(DataTemp>8388608) = DataTemp(DataTemp>8388608)-16777215;    
    % ���������ļ����ö����Ʋ��뷽ʽ�������ݴ���2^23=8388608ʱ��ʵ�ʲ���ֵΪ����ѹ,Ӧ��ȥ2^24-1=16777215
%DataValue = DataTemp * Vref / (Gain*(8388608-1)) * 2.15/2;   % 2.15/2Ϊ�ɼ��洢ģ���ڲ�˥��ϵ��
DataValue = DataTemp * Vref / (Gain*(8388608-1)) ;   % 2.15/2Ϊ�ɼ��洢ģ���ڲ�˥��ϵ��

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fclose(FileID);



