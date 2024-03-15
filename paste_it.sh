#!/bin/bash

# Kopyalanacak dosyalar
files_to_copy=("prepare_gpf.py" "protein.pdbqt")

# Bulunduğumuz dizindeki tüm klasörler için döngü
for dir in */ ; do
  # Eğer hedef bir dizinse, dosyaları kopyala
  if [ -d "$dir" ]; then
    for file in "${files_to_copy[@]}"; do
      # Dosya mevcutsa kopyala
      if [ -f "$file" ]; then
        cp "$file" "$dir"
      else
        echo "Dosya bulunamadı: $file"
      fi
    done
  fi
done
