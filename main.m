clc;
clear ;
close all;
Device = 0;
fun_InputParameterSetting;
DataLength = 8; 
datainfo = dir(['\','*.dat']);
txtinfo = dir(['./','*.txt']);
t = length(datainfo);
for i = 1:t 
    datapath = strcat(datainfo(i).folder,'\',datainfo(i).name) ;
    txtpath = strcat(txtinfo.folder,'\',txtinfo.name);
    Ghyd = load(txtpath);
    DataValue = fun_Record2Value( datapath, Vref, Gain, SampleRate );
    TimeLength = length(DataValue)/SampleRate;
    TotalSoundLevelLine = zeros(1,TimeLength); 
    TimeFreq = zeros(TimeFreqRange+1,TimeLength);
    for ii = 1:TimeLength 
        temp = DataValue( (ii-1)*SampleRate+1:ii*SampleRate );
        temp = temp-mean(temp);
        hpsd = psd(Hs,temp,'NFFT',nfft,'Fs',SampleRate);
        SoundPresureLevel = hpsd.Data;
        SoundPresureLevel = 10*log10(SoundPresureLevel);
        Freq = hpsd.Frequencies;
        GhydFullFreq = interp1(Ghyd(:,1),Ghyd(:,2),Freq,'PCHIP'); 
        SoundPresureLevel = SoundPresureLevel - GhydFullFreq;
        TimeFreq(1:TimeFreqRange+1,ii) = SoundPresureLevel(1:TimeFreqRange+1);
        SSP(ii,:) = 10.^(0.1*SoundPresureLevel);
        TotalSoundLevelLine(ii) = 10*log10(sum(SSP(ii,TotalSoundLevelLineFreqStart+1:TotalSoundLevelLineFreqStop+1))); 
    end
    for jj = 1:5*4
        start_num=(jj-1)*15+1;
        end_num=jj*15;
        mean_temp(jj,1:(size(SSP,2)))=[mean(10*log10(SSP(start_num:end_num,:)))];
    end
    for jj = 1:5*4
        start_num=(jj-1)*15+1;
        end_num=jj*15;
        mean_temp_shipin(jj,1:(size(TimeFreq',2)))=[mean(TimeFreq(:,start_num:end_num),2)];
    end
    out1((i-1)*5*4+1:(i)*5*4,1:size(TimeFreq,1))=[mean_temp_shipin];
    out2((i-1)*5*4+1:(i)*5*4,1:size(SSP,2))=[mean_temp];
end
