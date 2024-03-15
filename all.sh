#!/bin/bash

# Mevcut çalışma dizinini al (Bulunduğu klasör)
BASE_DIR="/home/emre/Desktop/OXA/25"

# Her bir alt klasör için döngü başlat
for dir in */; do
    # Alt klasöre git
    cd "$dir"
    
    # prepare_gpf.py dosyasına çalıştırma izni ver ve çalıştır
    if [ -f "prepare_gpf.py" ]; then
        chmod +x prepare_gpf.py
        ./prepare_gpf.py -l ligand.pdbqt -r protein.pdbqt -p npts='50,45,55' -p gridcenter='-11.97,16.925,-42.381'
    fi

    # autogrid4 komutunu çalıştır
    autogrid4 -p protein.gpf -l protein.glg

    # Belirtilen autodock_gpu komutlarını 5 kez çalıştır
    for i in {1..5}; do
        autodock_gpu_128wi -ffile protein.maps.fld -lfile ligand.pdbqt -nrun 100 -lsmet ad -resnam "adgpu$i"
        grep "DOCKED:" "adgpu$i.dlg" | cut -c9- > "adgpu$i.pdbqt"
    done
    
    # Ana dizine geri dön
    cd ..
done

# Her bir alt klasör için döngü başlat (İkinci Script)
for dir in $BASE_DIR/*/; do
    # Alt klasöre git
    cd "$dir"
    
    # Eğer best.sh dosyası varsa, çalıştırma izni ver ve çalıştır
    if [ -f "best.sh" ]; then
        chmod +x best.sh
        ./best.sh
    fi
    
    # Ana dizine geri dön
    cd $BASE_DIR
done

for dir in $BASE_DIR/*/; do
    # Alt klasöre git
    cd "$dir"
    # PDBQT adlı klasör oluştur
    mkdir -p PDBQT

    # Sadece belirli dosyaları PDBQT klasörüne taşı
    for i in {1..5}; do
        mv "adgpu$i.pdbqt" PDBQT/
    done

    # Ana dizine geri dön
    cd $BASE_DIR
done

# Her bir alt klasör için döngü başlat
for dir in $BASE_DIR/*/; do
    # Alt klasöre git
    cd "$dir"
    
    # "Results" klasörü oluştur
    mkdir -p "Results"

    # "protein.pdbqt" ve "ligand.pdbqt" hariç tüm .pdbqt dosyalarını "Results" klasörüne kopyala
    find . -maxdepth 1 -type f -name "*.pdbqt" ! -name "protein.pdbqt" ! -name "ligand.pdbqt" -exec cp {} "Results/" \;

    # Ayrıca "ligand.pdb" dosyasını da "Results" klasörüne kopyala
    cp ligand.pdb "Results/"

    # Results klasörüne git
    cd "Results"

    for file in *.pdbqt
    do
    pythonsh /home/emre/mgltools/MGLToolsPckgs/AutoDockTools/Utilities24/pdbqt_to_pdb.py -f "$file"
    done
    python /home/emre/Desktop/OXA/Scripts/rmsd_rdkit.py

    # Ana klasöre geri dön
    cd $BASE_DIR
done

# "RMSD Values" klasörü oluştur
mkdir -p "$BASE_DIR/RMSD Values"

# Her bir alt klasördeki "Results" klasörü için döngü başlat
for dir in $BASE_DIR/*/; do
    # Eğer Results klasörü varsa
    if [ -d "${dir}Results" ]; then
        # Results klasörünün adını alt klasörün adıyla değiştir ve RMSD Values klasörüne taşı
        dir_name=$(basename "${dir}")
        mv "${dir}Results" "$BASE_DIR/RMSD Values/${dir_name}_Results"
    fi
done
