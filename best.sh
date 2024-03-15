#!/bin/bash

for dlg_file in *.dlg; do
    num=$(echo $dlg_file | grep -o -E '[0-9]+')
    pdbqt_file="adgpu${num}.pdbqt"

    if [ ! -f "$pdbqt_file" ]; then
        continue
    fi

    # RMSD değerini al ve üç haneli formatla
    rmsd_value=$(grep -A9 'RMSD TABLE' "$dlg_file" | tail -1 | awk '{print $3}')
    rmsd_value_formatted=$(printf "%03d" $rmsd_value)

    vina_split --input "$pdbqt_file"

    # vina_split'in bitmesini bekle
    expected_count=100
    while [ $(ls adgpu${num}_ligand_*.pdbqt 2> /dev/null | wc -l) -lt $expected_count ]; do
        sleep 1
    done

    # İlgili dosyayı tut ve diğerlerini sil
    for split_file in adgpu${num}_ligand_*.pdbqt; do
        if [[ $split_file != adgpu${num}_ligand_${rmsd_value_formatted}.pdbqt ]]; then
            rm "$split_file"
        fi
    done
done

