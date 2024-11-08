#!/bin/bash

# DLG dosyalarını PDBQT formatına dönüştür ve en iyi modeli çıkar
for dlg_file in *.dlg; do
    base_name=$(basename "$dlg_file" .dlg)
    echo "İşleniyor: $dlg_file"

    # DLG dosyasını PDBQT formatına dönüştür
    grep "^DOCKED:" "$dlg_file" | cut -c9- > "${base_name}.pdbqt"

    # En iyi modelin sırasını bul
    rank=$(grep -A9 'RMSD TABLE' "$dlg_file" | tail -1 | awk '{print $3}')
    best_model=$(printf "%d" "$rank")
    echo "En iyi model: MODEL $best_model"

    # En iyi modeli PDBQT dosyasından çıkar ve yeni bir dosyaya kaydet
    awk -v best_model="$best_model" '
    /^MODEL/ {model_num=$2; in_model=(model_num == best_model); next}
    /^ENDMDL/ {in_model=0; next}
    in_model {print}
    ' "${base_name}.pdbqt" > "${base_name}_best.pdbqt"

    echo "En iyi model kaydedildi: ${base_name}_best.pdbqt"
done

