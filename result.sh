#!/bin/bash

# Ana klasörün yolu (bu scriptin çalıştırıldığı klasör olacak)
main_directory=$(pwd)

# Analyse klasörünün yolu
analyse_directory="$main_directory/analyse"

# Analyse klasörünü oluştur
mkdir -p "$analyse_directory"

# Ana klasördeki tüm alt klasörler için döngü
for dir in $(ls -d */)
do
    # Klasör adını temizle
    dir=${dir%/}

    # dlg klasörüne git
    cd "$main_directory/$dir"

    # Çıktıyı kaydedeceğiniz dosya
    output_file="${dir}_results.csv"

    # CSV başlıklarını yaz (Enerji ve Run için 5'er sütun)
    echo "Folder Name, Energy 1, Energy 2, Energy 3, Energy 4, Energy 5, Run 1, Run 2, Run 3, Run 4, Run 5" > "$output_file"

    # Enerji ve Run değerlerini tutacak diziler
    energies=()
    runs=()

    # Dlg dosyaları için döngü (1'den 5'e)
    for i in {1..5}
    do
        dlg_file="${dir}_${i}.dlg"

        # Enerji ve run bilgilerini çıkar
        if [ -f "$dlg_file" ]; then
            energy=$(grep -A9 'RMSD TABLE' "$dlg_file" | tail -1 | awk '{print $4}')
            run=$(grep -A9 'RMSD TABLE' "$dlg_file" | tail -1 | awk '{print $3}')

            # Dizilere ekle
            energies+=($energy)
            runs+=($run)
        else
            # Dosya yoksa boş değer ekle
            energies+=("NA")
            runs+=("NA")
        fi
    done

    # Sonuçları CSV formatında kaydet
    echo "$dir, ${energies[0]}, ${energies[1]}, ${energies[2]}, ${energies[3]}, ${energies[4]}, ${runs[0]}, ${runs[1]}, ${runs[2]}, ${runs[3]}, ${runs[4]}" >> "$output_file"

    echo "İşlem tamamlandı. Sonuçlar $output_file dosyasında."

    # Eski CSV dosyasını analyse klasörüne taşı
    mv "$output_file" "$analyse_directory/"

    # Ana klasöre geri dön
    cd "$main_directory"
done

echo "Tüm işlemler tamamlandı. Dosyalar $analyse_directory içine taşındı."
