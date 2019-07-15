function Korrespondenzen = punkt_korrespondenzen(I1,I2,Mpt1,Mpt2,varargin)
%% Input parser, vielleich benötigt für einstellbare parametern??
Im1=double(I1);
Im2=double(I2);
checkwinlen=@(x) isnumeric(x) && (x>1) && mod(x,2)==1;
checkmincorr=@(x) isnumeric(x) && (x<=1) && (x>=0);
p=inputParser;
p.addParameter('window_length',25,checkwinlen)
p.addParameter('min_corr',0.95,checkmincorr)
p.parse(varargin{:,:});
res=p.Results;
window_length=res.window_length;
min_corr=res.min_corr;
%% End of Input Parser
%% Entfernung von Merkmale zu nähe am Rand und geben den restlichen Merkmalspunkte + Anzahl davon zurück
a1=size(I1);    
a2=size(I2); %a2(1)=rows/y a2(2)=columns/x
b=length(Mpt1);
c=length(Mpt2);
window_length2=floor(window_length/2);
for i=1:b %
    if ((Mpt1(1,i)-window_length2)<1 || (Mpt1(1,i)+window_length2)>a1(2))
        Mpt1(:,i)=0;
    elseif ((Mpt1(2,i)-window_length2)<1 || (Mpt1(2,i)+window_length2)>a1(1))
        Mpt1(:,i)=0;
    end
end
for j=1:c
    if ((Mpt2(1,j)-window_length2)<1 || (Mpt2(1,j)+window_length2)>a2(2))
        Mpt2(:,j)=0;
    elseif ((Mpt2(2,j)-window_length2)<1 || (Mpt2(2,j)+window_length2)>a2(1))
        Mpt2(:,j)=0;
    end
end
temp1=Mpt1(1,:);
temp2=Mpt1(2,:);
temp3=Mpt2(1,:);
temp4=Mpt2(2,:);
temp1=temp1(temp1~=0);
temp2=temp2(temp2~=0);
temp3=temp3(temp3~=0);
temp4=temp4(temp4~=0);
Mpt1=[temp1;temp2];
Mpt2=[temp3;temp4];
%% Jedes Merkmal wird mit seinem fenster von Bild extrahiert, normiert und in gestacktes spaltenmatrix gespeichert
b1=length(Mpt1);
b2=length(Mpt2);
N=window_length^2;
Mat_feat_1=zeros(N,b1); %für geschwindigkeit -->preallocate
Mat_feat_2=zeros(N,b2);
for i=1:b1
    mm=Mpt1(:,i);
    v=double(I1(mm(2)-window_length2:1:mm(2)+window_length2,mm(1)-window_length2:1:mm(1)+window_length2));
    mu=(1/N)*sum(sum(v));
    vdash=v;
    vdash(:)=mu;
    vminusmu=v-mu;
    vminusmuq=vminusmu.^2;
    sigmav=sqrt((1/(N-1))*sum(sum(vminusmuq)));
    Wn=(1/sigmav)*(vminusmu);
    Mat_feat_1(:,i)=Wn(:);
end
for j=1:b2
    mm2=Mpt2(:,j);
    v2=double(I2(mm2(2)-window_length2:1:mm2(2)+window_length2,mm2(1)-window_length2:1:mm2(1)+window_length2));
    mu2=(1/N)*sum(sum(v2));
    vdash2=v2;
    vdash2(:)=mu2;
    vminusmu2=v2-mu2;
    vminusmuq2=vminusmu2.^2;
    sigmav2=sqrt((1/(N-1))*sum(sum(vminusmuq2)));
    Wn2=(1/sigmav2)*(vminusmu2);
    Mat_feat_2(:,j)=Wn2(:);
end
%% NCC Brechnung
aTb=(transpose(Mat_feat_2)*Mat_feat_1);
NCC_matrix=1/(N-1)*aTb;
NCC_matrix(NCC_matrix<min_corr)=0;
[temp, sorted_index]=sort(NCC_matrix(:),'descend');
len=temp(temp~=0);
sorted_index=sorted_index(1:length(len));
%% Sortiert die Korrespondenzpunktpaare zusammen in einer Matrix
len=length(sorted_index);
Korrespondenzen=zeros(4,len);
for i=1:len
    if NCC_matrix(sorted_index(i))>0
        [Y,X]=ind2sub(size(NCC_matrix),sorted_index(i));
        Korrespondenzen(:,i)=[Mpt1(1,X);Mpt1(2,X);Mpt2(1,Y);Mpt2(2,Y)];
        NCC_matrix(:,X)=0;
    end
end

Korrespondenzen(:,~any(Korrespondenzen))=[];
end