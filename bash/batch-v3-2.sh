files=$(ls *.jpg)

for file in $files; do
	if [ $file = "DSC07203.jpg" ]; then
        base_name=${file%.jpg}  # wycina rozszerzenie
        save_name=$base_name.suffix.jpg

		run="gimp -i --batch-interpreter plug-in-script-fu-eval -b '(przem-soft-focus-noninteractive-v3 "$file" "$save_name")' -b '(gimp-quit 0)'"
        eval "$run"
		#mv $save_name SAVE
    fi
done
