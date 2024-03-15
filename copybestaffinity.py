import os
import pandas as pd
import shutil

def read_txt_to_dataframe(file_path):
    table_name = os.path.basename(file_path).split("_")[0]
    with open(file_path, 'r') as file:
        data = [line.strip().split('\t') for line in file.readlines() if "ligand" in line or line.startswith('Result Name')]
    df = pd.DataFrame(data[1:], columns=data[0])
    df['Table Name'] = table_name
    return df

def copy_files_with_different_extensions(df, source_dir, target_dir, extensions, top_n=10):
    sorted_df = df.sort_values(by='RMSD', ascending=True).head(top_n)
    for file_name in sorted_df['Result Name']:
        base_file_name = file_name.split('_ligand_')[0]
        for ext in extensions:
            modified_file_name = base_file_name + ext
            source_file = os.path.join(source_dir, modified_file_name)
            target_file = os.path.join(target_dir, modified_file_name)
            shutil.copy(source_file, target_file)

def process_directory_and_copy_files(directory, source_base_dir, target_base_dir, extensions):
    for file in os.listdir(directory):
        if file.endswith("_Results.txt"):
            df = read_txt_to_dataframe(os.path.join(directory, file))
            table_name = df['Table Name'].iloc[0]

            source_dir = os.path.join(source_base_dir, table_name)
            target_dir = os.path.join(target_base_dir, table_name)

            os.makedirs(target_dir, exist_ok=True)
            copy_files_with_different_extensions(df, source_dir, target_dir, extensions)

current_directory = os.getcwd()
source_base_dir = '/home/aslihan/Desktop/OXA/Runs/GRID-2-500'
target_base_dir = '/home/aslihan/Desktop/OXA/Runs/GRID-2-BEST'
extensions = ['.xml', '.dlg']

process_directory_and_copy_files(current_directory, source_base_dir, target_base_dir, extensions)
