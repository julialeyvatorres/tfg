%%SEGMENTACIÓ SPM - generem màscara i calculem Dice
clear all
close all
clc

% Definim els paths que utilitzarem
path = 'C:\Users\Julia\Documents\TFG\IMATGES\MICCAI-2012-Multi-Atlas-Challenge-Data\TEST\'; %Base de dades 1
%path = "C:\Users\Julia\Documents\TFG\IMATGES\NI_data\"; %Base de dades 2

%Directori carpeta TEST
d = dir([path]);

% Inicialització dels vectors
GM=[];
WM=[];
CSF=[];
  
%Iterem totes les imatges de TEST
for i=3:length(d)
    d2 = dir([path d(i).name '\*.nii']); %Directori carpeta cas actual
    nom_imatge = d2(1).name; %Extraiem  nom de la imatge per identificar-la

    GT = niftiread([path d(i).name '\' d2(2).name]); %Ground Truth

    d3 = dir([path d(i).name '\SPM\*.nii']);
    C1=niftiread([path d(i).name '\SPM\' d3(1).name]); %Segmentació GM
    C2=niftiread([path d(i).name '\SPM\' d3(2).name]); %Segmentació WM
    C3=niftiread([path d(i).name '\SPM\' d3(3).name]); %Segmentació CSF
    
    %% Calculem la probabilitat maxima de cada vòxel
    [m,Pm]=max([C1(:),C2(:),C3(:)],[],2);
    % Creem una nova imatge amb l'array Pm amb el mateix volum que C1
    E=reshape(Pm,size(C1));
    E = E.*((C1+C2+C3)>1);
 
    %Guardem la segmentació obtinguda
    niftiwrite(E, (path + "\" + d(i).name + "\" + "mask_spm2_" + nom_imatge));
    
    %% Calculem el dice per cada classe
    GM=[GM; dice(E==1,GT==3)];
    WM=[WM; dice(E==2,GT==2)];
    CSF=[CSF; dice(E==3,GT==1)];
     
end
 
%% RESULTATS
%Construim una taula per veure els resultats i calculem mitjana i std total
taula_spm = table(WM,GM,CSF);
WMmean = mean(WM);
GMmean = mean(GM);
CSFmean = mean(CSF);

WMstd = std(WM);
GMstd = std(GM);
CSFstd = std(CSF);

total = table(WMmean,GMmean,CSFmean,WMstd,GMstd,CSFstd);

 