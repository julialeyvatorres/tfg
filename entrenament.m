%%ENTRENAMENT D'UNA XARXA NEURONAL

clear all
close all
clc

% Definim els paths que utilitzarem
path_train = '/home/alumne2/julia/slicesTRAIN/train_slices';
path_train_labels = '/home/alumne2/julia/slicesTRAIN/train_slices_seg';
path_val = '/home/alumne2/julia/slicesTRAIN/val_slices';
path_val_labels = '/home/alumne2/julia/slicesTRAIN/val_slices_seg';

% path_train = '/home/alumne2/julia/slices_sense_fons/train_slices';
% path_train_labels = '/home/alumne2/julia/slices_sense_fons/train_slices_seg';
% path_val = '/home/alumne2/julia/slices_sense_fons/val_slices';
% path_val_labels = '/home/alumne2/julia/slices_sense_fons/val_slices_seg';

%Creem un objecte per emmagatzemar les imatges
imds = imageDatastore(path_train);
valds = imageDatastore(path_val);

%Definim el nom de les classes i les etiquetes associades
classNames = ["background", "CSF", "WM", "GM"];
labelIDs   = [0 85 170 255];

%Creem un objecte per emmagatzemar el GT
pxds = pixelLabelDatastore(path_train_labels,classNames,labelIDs);
pxval = pixelLabelDatastore(path_val_labels,classNames,labelIDs);

%Creem la xarxa U-Net
imageSize = [256 256];
numClasses = 4;
lgraph = unetLayers(imageSize, numClasses);

%Data Augmentation
augmenter = imageDataAugmenter( ...
    'RandRotation',[-10 10],...
    'RandXTranslation',[-5 5],...
    'RandYTranslation',[-5 5], ...
    'RandXReflection',1,...
    'RandXShear',[-5,5], ...
    'RandYShear',[-5 5]);

%Creem un objecte per entrenar la xarxa
%ds = pixelLabelImageDatastore(imds,pxds, 'DataAugmentation',augmenter);
ds = pixelLabelImageDatastore(imds,pxds);
val = pixelLabelImageDatastore(valds,pxval);

%Establim les opcions d'entrenament
options = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',200, ...
    'MiniBatchSize',8 , ...
    'Plots','training-progress', ...
    'VerboseFrequency',10, ...
    'ValidationData',val,...
    'ValidationPatience',10,...
    'OutputNetwork','best-validation-loss');

%Entrenem la xarxa neuronal
net = trainNetwork(ds,lgraph,options)

outputDir = "/home/alumne2/julia";

%Guardem el model
outputFile = fullfile(outputDir, "net.mat");
save(outputFile, "net");
