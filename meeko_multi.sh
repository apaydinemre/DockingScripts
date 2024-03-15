#!/bin/bash

# Klasördeki her bir .sdf dosyası için döngü
for sdf_file in *.sdf; do
    # Dosya adının .sdf uzantısını çıkarmak
    base_name="${sdf_file%.*}"
    
    # mk_prepare_ligand.py scriptini çalıştırarak .pdbqt formatında çıktı almak
    mk_prepare_ligand.py -i "$sdf_file" -o "${base_name}.pdbqt" --rigid_macrocycles
done
