import os
import csv
import subprocess
from natsort import natsorted

# Çıktı dosyası
output_file = "affinity_run_table.csv"

# CSV başlıklarını yaz
headers = ["Folder Name", "Energy 1", "Energy 2", "Energy 3", "Energy 4", "Energy 5", "Run 1", "Run 2", "Run 3", "Run 4", "Run 5"]

# CSV dosyasını başlat
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(headers)

    # Tüm klasörleri dolaş
    for root, dirs, files in os.walk("."):
        energies = []
        runs = []
        dlg_files = [f for f in files if f.endswith('.dlg')]

        # Dosyaları sayısal değerlerine göre doğru sırala
        for dlg_file in natsorted(dlg_files):
            file_path = os.path.join(root, dlg_file)
            
            # Affinity değerini çıkar
            grep_affinity_cmd = f"grep -A9 'RMSD TABLE' {file_path} | tail -1 | awk '{{print $4}}'"
            affinity_result = subprocess.run(grep_affinity_cmd, shell=True, text=True, capture_output=True)
            affinity = affinity_result.stdout.strip()

            # Run değerini çıkar
            grep_run_cmd = f"grep -A9 'RMSD TABLE' {file_path} | tail -1 | awk '{{print $3}}'"
            run_result = subprocess.run(grep_run_cmd, shell=True, text=True, capture_output=True)
            run = run_result.stdout.strip()

            energies.append(affinity)
            runs.append(run)

        # Sütun sayısına göre NA doldur
        while len(energies) < 5:
            energies.append("NA")
        while len(runs) < 5:
            runs.append("NA")

        # Klasör adı ve değerleri CSV'ye yaz
        folder_name = os.path.basename(root)
        if dlg_files:  # Eğer klasör içinde dlg dosyaları varsa
            writer.writerow([folder_name] + energies + runs)
