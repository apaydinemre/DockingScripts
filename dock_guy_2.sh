#!/bin/bash

# Bulunduğumuz dizindeki tüm klasörler için döngü
for dir in */ ; do
  # Klasör adından sonraki '/' karakterini kaldır
  folder_name=${dir%/}

  # Eğer hedef bir dizinse
  if [ -d "$dir" ]; then
    echo "Processing directory: $folder_name"
    # Klasör içine gir
    cd "$dir"

    # autogrid4 komutunu çalıştır
    autogrid4 -p protein.gpf -l protein.glg

    # Belirtilen autodock_gpu komutlarını 5 kez çalıştır
    for i in {1..5}; do
        autodock_gpu_128wi -ffile protein.maps.fld -lfile "${folder_name}.pdbqt" -nrun 256 -lsmet ad -D 2 -resnam "${folder_name}_$i"
        grep "DOCKED:" "${folder_name}_$i.dlg" | cut -c9- > "${folder_name}_$i.pdbqt"
    done

    # Üst klasöre çık
    cd ..
  fi
done
