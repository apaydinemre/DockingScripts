import os
import shutil

def copy_specific_files(source_dir, target_dir, subdir):
    subdir_path = os.path.join(source_dir, subdir)
    target_subdir_path = os.path.join(target_dir, subdir)
    if not os.path.exists(target_subdir_path):
        os.makedirs(target_subdir_path)

    files_to_copy = ['ligand.pdb', 'protein.pdb']
    files_to_copy += [f for f in os.listdir(subdir_path) if f.startswith(subdir[:4]) and f.endswith('.pdb')]

    for file_name in files_to_copy:
        source_file = os.path.join(subdir_path, file_name)
        target_file = os.path.join(target_subdir_path, file_name)
        if os.path.exists(source_file):
            shutil.copy(source_file, target_file)

def process_directories(source_base_dir, target_base_dir):
    for subdir in os.listdir(source_base_dir):
        subdir_path = os.path.join(source_base_dir, subdir)
        if os.path.isdir(subdir_path):
            copy_specific_files(source_base_dir, target_base_dir, subdir)

source_base_dir = '/home/aslihan/Desktop/OXA/Runs/GRID-2-500'
target_base_dir = '/home/aslihan/Desktop/OXA/Runs/GRID-2-BEST'

process_directories(source_base_dir, target_base_dir)
