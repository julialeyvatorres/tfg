# SEGMENTACIÓ DE MATÈRIES CEREBRALS PER A L’OBTENCIÓ DE MARCADORS DE VOLUMETRIES I ATRÒFIA EN MALALTIES NEURODEGENERATIVES
Treball Final de Grau - Grau en Enginyeria Biomèdica (UdG)
Autora: Júlia Leyva

# PROPÒSIT
L'objectiu d'aquest projecte és el processament d'imatges de ressonància magnètica (RM) cerebral i la segmentació automàtica de les tres matèries principals del cervell: matèria blanca (WM), matèria gris (GM) i líquid cefalorraquidi (CSF), permetent l’obtenció de volumetries objectives. Aquestes mesures són molt útils tant per a la quantificació de l’atròfia com pel seguiment de la pèrdua de volum cerebral i la seva correlació amb la malaltia. D'aquesta manera, ajudar als clínics amb la detecció precoç i l'evolució de les malalties neurodegeneratives.

S'ha utilitzat una tècnica tradicional, Statistical Parametric Mapping (SPM), i una tècnica innovadora basada en l'entrenament de xarxes neuronals (Deep Learning) per fer un posterior anàlisi i avaluar-les per comparar-les entre elles.

# REQUERIMENTS D'INSTAL·LACIÓ
Els requeriments per poder executar el projecte són MATLAB R2023a i la toolbox Deep Learning i SPM12.

# MANUAL D'USUARI
A continuació, detallem els passsos necessaris per a l'execució del projecte.

1. Descarreguem el conjunt de dades de la font desitjada. Concretament, en el projecte s'ha usat la base de dades d'un dels reptes MICCAI de l'any 2012: Grand Challenge and Workshop on Multi-Atlas Labeling. LINK

2. El següent pas serà aplicar la primera tècnica: SPM. Mitjançant Matlab, executarem el software SPM12 i escollirem els volums a segmentar. Com a resultat, s'obtenen per a cada volum 5 fitxers .nii amb les màscares següents: c1: Màscara GM, c2: Màscara WM, c3: Màscara CSF, c4: Màscara crani i c5: Màscara teixit tou i aire/fons. Seguidament s'executarà el fitxer SPM.m per a generar el volum de la màscara predita i calcular el dice.

3. Passem a la tècnica mitjançant Deep Learning. Primer executarem el fitxer preprocessament_imatges3D per a fer el preprocessament de les imatges.
4. El següent serà entrenar el model executant el fitxer entrenament.
5. Per acabar, executem l'últim fitxer prediccio_test, per testejar el model entrenat, generar el volum predit i calcular el dice.
