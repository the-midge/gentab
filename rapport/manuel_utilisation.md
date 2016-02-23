# Installation du logiciel GenTab

Nous avons tenté de créer un installateur mais nous n'avons pas eu le temps de le paramètrer de façon correcte.
L'installation du logiciel est donc encore manuelle.
Pour Windows uniquement:

1. Créer dans le dossier de votre choix un raccourci de l'exécutable: 

`Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\GenTab.exe`

2. Créer un dossier C:\Program Files\GenTab, y copier les dossiers et fichiers suivants:

	* `AnalyseHarmonique\`
	* `AnalyseRythmique\`
	* `GenerationMidi\`
	* `Onset_Detection\`
	* `projetTampon_data`
	* `Segmentation\`
	* `Utils\`
	* `gentab_stand_alone.m`
	* `projetTampon.aup`
	
3. Le logiciel dépend des partie tierces attendues aux emplacements suivants:

	* Audacity:	`C:/Program Files (x86)/Audacity/audacity.exe`
	* Guitar Pro 5:	`C:/Program Files (x86)/Guitar Pro 5/GP5.exe`
	* Matlab :	`C:/Program Files/MATLAB/R20XX/bin/matlab.exe`

	---
	
# Utilisation du logiciel GenTab

Le logiciel s'utilise typiquement en 4 étapes délimitées dans l'interface:

1. Création d'un projet Audacity: cliquez qur `New` ou `Explore` et sélectionner un projet audacity existant.
Enregistrez votre morceaux via Audacity, éditez le comme bon vous semble. 
Enfin, exportez le morceaux en wave en faisant `Fichier` -> `Export Audio`, sélectionner le format WAV.

2. Sélectionnez, via `Load`, le fichier audio WAV nouvellement créé. Vous pouvez jouer le morceau en utilisant `Play`.

3. Sélectionnez le format MIDI (GP4 indisponible). Imposez un tempo si vous le souhaitez en le saisissant dans le champ `Imposed Tempo` et cochez la case adjacente pour activer la fonction.
Après génération, que vous ayez imposé le tempo ou non, le tempo réel du morceau sera affiché dans le champ `Found Tempo`

4. Donnez un nom à votre fichier midi (sans l'extension). Vous pouvez choisir également sa localisation avec `...`. Cliquez sur Save pour lancer la transcription.
Une barre d'avancement s'affiche en bas une fois que l'instance de Matlab est lancée. Attendre le message de confirmation de la fin de la transcription.
Le Logiciel Guitar Pro se lance automatiquement en mode importation: Cliquez sur `Importer !` en haut à droite de la fenêtre modale de Guitar Pro. Changez le tempo par celui affiché dans `Found Tempo`.
