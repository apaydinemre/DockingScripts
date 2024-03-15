#!/bin/bash

# Mevcut çalışma dizinini al
BASE_FOLDER=$(pwd)

# Hedef klasör yolu
DESTINATION_FOLDER="${BASE_FOLDER}/RMSD Results"

# Hedef klasörü oluştur
mkdir -p "${DESTINATION_FOLDER}"

# Ana klasördeki her alt klasör için döngü yap
for SUBFOLDER in "${BASE_FOLDER}"/*; do
    if [ -d "${SUBFOLDER}" ]; then
        # Alt klasör adını al
        FOLDER_NAME=$(basename "${SUBFOLDER}")
        
        # rmsd_results.txt dosyasının varlığını kontrol et
        RMSD_FILE="${SUBFOLDER}/rmsd_results.txt"
        if [ -f "${RMSD_FILE}" ]; then
            # Dosyayı yeni adıyla hedef klasöre taşı
            mv "${RMSD_FILE}" "${DESTINATION_FOLDER}/${FOLDER_NAME}.txt"
        fi
    fi
done
