files=$(ls *.jpg)

for file in $files; do
	if [ $file = "DSC08621.jpg" ]; then
        base_name=${file%.jpg}  # wycina rozszerzenie
        save_name=$base_name.suffix.jpg
        flatpak run org.gimp.GIMP  -i -b '(przem-soft-focus-noninteractive' $file $save_name ' 100 100)' -b '(gimp-quit 0)'
		mv $save_name SAVE
    fi
done
