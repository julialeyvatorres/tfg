%%SEPARAR SLICES + PREPROCESSAMENT DE LES IMATGES:

clear all
close all
clc

%Definim directori imatges TRAIN/TEST
path_images = '/home/alumne2/julia/TEST/';
d = dir([path_images]);

%%PROCESSEM LES IMATGES PER LLESQUES
%Iterem cada cas per a separar per llesques la imatge T1 i la màscara
for i=3:length(d)
    
    d2 = dir([path_images d(i).name '/*.nii']); %Directori carpeta actual
    nom_imatge = extractBefore(d2(1).name,".nii"); %Nom imatge per identificar-la
    
    imatge = niftiread([path_images d(i).name '/' d2(1).name]); %Imatge T1
    imatge = imatge/max(imatge(:)); %Normalitzem la imatge a partir del valor màxim

    mask = niftiread([path_images d(i).name '/' d2(2).name]); %Màscara
    mask = rescale(mask); %Rescale per normalitzar valors a escala de grisos
    
    mida = size(imatge);
    %Creem les carpetes on guardarem les llesques
    mkdir(d2(1).folder, 'T1');
    mkdir(d2(1).folder, 'mask');
    
    index = 1; %Index nombre de llesques
    
    %Inicialitzem matrius pels nous volums
    volum = [];
    volumMask = [];
    
    for j=1:(mida(3)) %Iterem per cada llesca
        
        mk = mask(:,:,j); %Obtenim slice j en el pla axial de la màscara
        if any(mk(:) ~= 0) %Continuem si conté pixels diferents a zero 
            
            im = imatge(:,:,j); %Obtenim slice j en el pla axial de la T1
            im(mk==0)=0; %Skull stripping
           
            %Retallem per tenir imatges de NxN (256x256)
            im = imcrop(im,[0,0,256,256]);
            mk = imcrop(mk,[0,0,256,256]);
        
            num = sprintf('%d%d%d',floor(j/100),mod(floor(j/10),10),mod(j,10));
            
            %Guardem la slice actual
            imwrite(im,"/home/alumne2/julia/TEST/" + d(i).name + "/T1_skull/" + nom_imatge + "_slice" + num +".png"); %guardem cada llesca
            imwrite(mk,"/home/alumne2/julia/TEST/" + d(i).name + "/mask_skull/" + nom_imatge + "_slice" + num +".png"); %guardem cada llesca
            
            %Generem els volums nous afegint les llesques
            volum(:,:,index) = im;
            volumMask(:,:,index) = mk;
            index = index+1; %Augmentem index
            
        end
    end
    
     %%
     %GUARDEM ELS NOUS VOLUMS PROCESSATS
     mkdir(d2(1).folder, 'volumsEdited'); %Creem carpeta per guardar nous volums
     
     %Obtenim la informació del volums originals
     imInfo = niftiinfo([path_images d(i).name '/' d2(1).name]); %Info imatge T1
     maskInfo = niftiinfo([path_images d(i).name '/' d2(2).name]); %Info màscara
        
     %Noms dels nous volums
     nomNouIm = ['/home/alumne2/julia/volumsTestEdit/' nom_imatge '_new.nii'];
     nomNouMask = ['/home/alumne2/julia/volumsTestEdit/' nom_imatge '_3C_new.nii'];
     
     %Fem una copia de la informació i l'editem
     imInfo_copia=imInfo;
     maskInfo_copia=maskInfo;
     
     imInfo_copia.Filename = nomNouIm;
     maskInfo_copia.Filename = nomNouMask;
     
     imInfo_copia.Datatype = 'double';
     maskInfo_copia.Datatype = 'double';
    
     imInfo_copia.ImageSize = size(volum);
     maskInfo_copia.ImageSize = size(volumMask);
     imInfo_copia.Filesize = numel(volum);
     maskInfo_copia.Filesize = numel(volumMask);
     
     %Guardem els nous volums generats
     niftiwrite(volum, nomNouIm, imInfo_copia);
     niftiwrite(volumMask, nomNouMask, maskInfo_copia);
end