import os
import pandas as pd

def combine_csv_files(directory):
    # Klasördeki tüm CSV dosyalarını bul
    csv_files = [file for file in os.listdir(directory) if file.endswith('.csv')]

    # Tüm CSV dosyalarını birleştirmek için boş bir DataFrame oluştur
    combined_csv = pd.DataFrame()

    # Her bir CSV dosyasını oku ve birleştir
    for file in csv_files:
        current_csv = pd.read_csv(os.path.join(directory, file))
        combined_csv = pd.concat([combined_csv, current_csv], ignore_index=True)

    # Birleştirilmiş veriyi yeni bir CSV dosyasına kaydet
    combined_csv.to_csv(os.path.join(directory, 'combined_results.csv'), index=False)

    print("Tüm CSV dosyaları birleştirildi ve 'combined_results.csv' olarak kaydedildi.")

# Çalıştırılacak klasör yolu
directory_path = '.'  # Bu scriptin bulunduğu klasör için '.'
combine_csv_files(directory_path)
