#!/bin/bash

# Dosyanın adı
file="protein.gpf"

# Geçici bir dosya oluştur
temp_file=$(mktemp)

# İlk satırı oku ve geçici dosyaya yaz
head -n 1 $file > $temp_file

# Eklemek istediğiniz satırı yaz
echo "parameter_file AD4_parameters_new.dat # force field default parameter file" >> $temp_file

# İlk satırdan sonrasını okuyup geçici dosyaya ekle
tail -n +2 $file >> $temp_file

# Orijinal dosyayı güncelle
mv $temp_file $file

echo "Dosya başarıyla düzenlendi."
