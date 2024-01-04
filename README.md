# DockingScripts
You can find the scripts I use for docking, Ligand preparation and virtual screening.

# rdkit_2d.py

This script adds hydrogens to the 2D ligand files with sdf extension in the ligands folder, converts them to 3D using the ETKDGv3 module, calculates the Gasteiger charge and finally performs UFF energy minimization. After these processes are completed, it saves them back to the new_ligands folder with sdf extension.

Usage

1- Create a folder named ligands and new_ligands in your current folder and upload the script to the main folder. 
2- In the "ligands" folder, upload your 2D ligand files with .sdf extension that you downloaded from your libraries and run the script.
3- They will be saved in the "new_ligands" folder ready to be converted to pdbqt. 
4- After that you can convert your sdf files to pdbqt using Meeko (https://github.com/forlilab/Meeko) or OpenBabel (https://github.com/openbabel/openbabel).
