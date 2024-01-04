from rdkit import Chem
from rdkit.Chem import rdDistGeom
from rdkit.Chem import rdForceFieldHelpers
from rdkit.Chem import rdPartialCharges
import os

ligands_dir = "ligands"
output_dir = "new_ligands"
status_file = "process_status.txt"

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

sdf_files = [f for f in os.listdir(ligands_dir) if f.endswith(".sdf")]

with open(status_file, 'w') as status:
    for sdf_file in sdf_files:
        input_path = os.path.join(ligands_dir, sdf_file)
        output_path = os.path.join(output_dir, sdf_file)
        mol = Chem.MolFromMolFile(input_path)

        # Add hydrogens
        try:
            mol = Chem.AddHs(mol, addCoords=True)
        except:
            status.write(f"{sdf_file} : Chem.AddHs(mol) = Failed\\n")
            continue

        # 3D embedding
        etkdgv3 = rdDistGeom.ETKDGv3()
        embed_status = rdDistGeom.EmbedMolecule(mol, etkdgv3)
        if embed_status == -1:
            status.write(f"{sdf_file} : rdDistGeom.EmbedMolecule(mol, etkdgv3) = Failed\\n")

        # Compute Gasteiger charges
        try:
            rdPartialCharges.ComputeGasteigerCharges(mol)
        except:
            status.write(f"{sdf_file} : rdPartialCharges.ComputeGasteigerCharges(mol) = Failed\\n")

        # UFF energy minimization
        try:
            rdForceFieldHelpers.UFFOptimizeMolecule(mol)
        except:
            status.write(f"{sdf_file} : rdForceFieldHelpers.UFFOptimizeMolecule(mol) = Failed\\n")

        Chem.MolToMolFile(mol, output_path)
