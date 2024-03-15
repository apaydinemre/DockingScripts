#!/bin/bash

# Bulunduğumuz dizindeki tüm klasörler için döngü
for dir in */ ; do
  # Klasör adından sonraki '/' karakterini kaldır
  dir_name=${dir%/}

  # Eğer hedef bir dizinse
  if [ -d "$dir" ]; then
    # Klasör içine gir
    cd "$dir"

    # prepare_gpf.py scriptini ilgili parametrelerle çalıştır
    if [ -f "./prepare_gpf.py" ] && [ -f "protein.pdbqt" ]; then
      ./prepare_gpf.py -l "${dir_name}.pdbqt" -r protein.pdbqt -p npts='50,45,55' -p gridcenter='-14.152,15.494,-41.641'
    else
      echo "Gerekli dosyalar bulunamadı: $dir_name"
    fi

    # Üst klasöre çık
    cd ..
  fi
done
