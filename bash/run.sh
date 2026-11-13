#!/bin/bash

# Używamy bezpiecznego czytania plików zamiast 'ls' (odporne na spacje w nazwach)
for file in *.jpg; do
    if [ "$file" = "DSC01903.jpg" ]; then
        # GIMP 3 wymaga dokładnego parsowania ciągów znaków
        # Przekazujemy pełną ścieżkę jako tekst do nowego skryptu dwuargumentowego
        gimp -i --batch-interpreter plug-in-script-fu-eval \
             -b "(przem-soft-focus-noninteractive-v3x \"$file\")" \
             -b "(gimp-quit 0)"

        # mv "$save_name" SAVE
    fi
done
