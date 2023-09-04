%FEM LA PREDICCIÓ DE LA MÀSCARA, GENEREM VOLUM I CALCULEM DICE(TEST)

clear all
close all

%Definim directori imatges TEST
path_test = '/home/alumne2/julia/TEST/';

%Directori on emmagatzarem volum de la predicció
labelPredict = '/home/alumne2/julia/label_predict/';

%Carreguem el model
network = load(['home/alumne2/julia/net.mat']);
network = network.net;

%Inicialitzem vectors
CSF = [];
WM = [];
GM = [];
BG = [];

%Iterem els 20 casos de TEST
for k=1:20
  
    k = sprintf('%d%d',mod(floor(k/10),10),mod(k,10));
    d = dir([path_test num2str(k) '/*.nii']); %Directori cas actual
    d2 = dir([path_test num2str(k) '/T1/*.png']); %Directori slices T1
    d3 = dir([path_test num2str(k) '/mask/*.png']); %Directori slices GT
    
    seg = []; %Inicialitzem volum de la predicció
    
    %Màscara original(EDITADA)
    path = [path_test num2str(k) '/' d(3).name]; 
    GT = niftiread(path);
    GT = round(GT,2);
    maskInfo = niftiinfo(path); %Obtenim informació del GT
    
    %Iterem totes les llesques del cas actual
    for m=1:length(d2)
        A = imread([path_test num2str(k) '/T1/' d2(m).name]); %Imatge TEST
        Aseg = imread([path_test num2str(k) '/mask/' d3(m).name]); %GT TEST

        %Generem la segmentació de la llesca actual
        B = semanticseg(A,network,'OutputType','uint8','Classes',["background", "CSF", "WM", "GM"]);
        
        %Afegim slice al volum de la predicció
        seg(:,:,m) = B; 
        
    end
    
    %%Guardem el volum de la segmentació generada
    nomnou = [labelPredict 'predict_' d(1).name]; %Nom imatge predicció
    % Editem info predicció
    maskInfo.Filename = nomnou;
    maskInfo.Datatype = 'double';
    maskInfo.ImageSize = size(seg);
    niftiwrite(seg,nomnou,maskInfo);
    
    %Calculem el dice per cada classe
    BG = [BG; dice(seg==1, GT==0)]; 
    CSF =[CSF; dice(seg==2, GT==0.33)];
    WM = [WM; dice(seg==3, GT==0.67)];
    GM = [GM; dice(seg==4, GT==1)];

end

%%RESULTATS
%Construim una taula per veure els resultats i calculem mitjana i std total
taula_resultats = table(WM, GM, CSF);
WMmean = mean(WM);
GMmean = mean(GM);
CSFmean = mean(CSF);
WMstd = std(WM);
GMstd = std(GM);
CSFstd = std(CSF);

total = table(WMmean, GMmean, CSFmean, WMstd, GMstd, CSFstd);
