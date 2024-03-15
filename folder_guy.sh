#!/bin/bash

# Bulunduğumuz dizindeki tüm .pdbqt dosyaları için döngü
for file in *.pdbqt; do
  # Dosya adından .pdbqt uzantısını çıkar
  base_name="${file%.pdbqt}"

  # Eğer dosya adıyla aynı adı taşıyan bir klasör yoksa oluştur
  if [ ! -d "$base_name" ]; then
    mkdir "$base_name"
  fi

  # Dosyayı ilgili klasöre taşı
  mv "$file" "$base_name"
done
