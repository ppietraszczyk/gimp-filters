#!/usr/bin/sh
# Filtr symulujący Lomography X Tungsten 64 (Cross-Processed)
# Przemysław R. Pietraszczyk
# Poprawiona struktura nawiasów i wywołania

files=$(ls *.ARW)

for file in $files; do
    if [ "$file" = "DSC01621.ARW" ]; then
        base_name=${file%.ARW}  # wycina rozszerzenie
        loadtiff=$base_name.tiff
        baseout=$base_name.siec.tiff
        savename=$base_name.save.tiff

        dcraw -v -w -H 0 -b 1.0 -o 1 -q 3 -T "$file"

        while [ ! -e "$base_name.tiff" ]; do
            echo "czekam"
            sleep 1
        done

        convert "$loadtiff" -bordercolor white -border 30 -compress lzw "$baseout"

        #echo "baseout=[$baseout]"
        #echo "savename=[$savename]"



      gimp -i -f --batch-interpreter=plug-in-script-fu-eval \
      -b '(load "/home/przem/.config/GIMP/3.2/scripts/przem-lomography-x-tungsten-noninteractive-v3x.scm")' \
      -b "(przem-lomography-x-tungsten-noninteractive-v3x ('$baseout' '$savename'))" \
      -b '(gimp-quit 0)'
    fi
done


