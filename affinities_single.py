import subprocess
import glob
import pandas as pd
import os

# Mevcut çalışma dizinini al
folder_path = os.getcwd()

# .dlg dosyalarını bulma
dlg_files = glob.glob(f'{folder_path}/*.dlg')

# Sonuçları saklamak için boş bir DataFrame oluşturma
results_df = pd.DataFrame(columns=['File Name', 'Affinity', 'Run'])

# Her bir .dlg dosyası için affinity ve run bilgisini çekme
for dlg_file in dlg_files:
    # RMSD TABLE'den sonra gelen 9 satırın son satırını al, affinity ve run bilgisini çek
    command_affinity_run = f"grep -A9 'RMSD TABLE' {dlg_file} | tail -1 | awk '{{print $4, $3}}'"
    try:
        output = subprocess.check_output(command_affinity_run, shell=True, text=True)
        affinity, run = output.strip().split()
        # Dosya adı, affinity ve run'ı DataFrame'e ekle
        results_df = pd.concat([results_df, pd.DataFrame([{'File Name': os.path.basename(dlg_file), 'Affinity': affinity, 'Run': run}])], ignore_index=True)
    except subprocess.CalledProcessError as e:
        print(f"Error processing file {dlg_file}: {e}")

# Sonuçları ekrana yazdır
print(results_df)

# İsteğe bağlı olarak sonuçları CSV dosyasına kaydet
results_df.to_csv(f'{folder_path}/affinity_run_results.csv', index=False)
