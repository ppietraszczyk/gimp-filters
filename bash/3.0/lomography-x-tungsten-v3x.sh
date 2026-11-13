#!/usr/bin/sh
# Filtr symulujący Lomography X Tungsten 64 (Cross-Processed)
# Przemysław R. Pietraszczyk
# 07-11-2026
# ver. 2.261107-0
# Ten script-fu wykorzystuje funkcje ze skryptu 'chrome-it.scm'
# Autorstwa Spencer Kimball

files=$(ls *.ARW)

for file in $files; do
	if [ $file = "DSC01621.ARW" ]; then
        base_name=${file%.ARW}  # wycina rozszerzenie
        loadtiff=$base_name.tiff
        baseout=$base_name.siec.tiff
        savename=$base_name.save.tiff
        dcraw -v -w -H 0 -b 1.0 -o 1 -q 3 -T  $file
        #dcraw -v -r 2.726191 1.000000 1.479328 1.064126 -H 0 -b 1.0 -o 1 -q 3 -6 -T  $file
		while [ ! -e $base_name.tiff  ]; do
            	echo "czekam"
        done
        convert  $loadtiff  -bordercolor white -border 30  -compress lzw $baseout

gimp -i -f --batch-interpreter plug-in-script-fu-eval -b "

(define (shadows val)
	(/ (* 0.96 val) 2.55))

(define (midtones val)
	(/ val 2.55))

(define (highlights val)
	(min (/ (* 1.108 val) 2.55) 100.0))

(define (rval col)
	(car col))

(define (gval col)
    (cadr col))

(define (bval col)
    (caddr col))

(define (balance layer2)
	(let* (
        ; Cienie: dodanie blueego i magenty
        (c1 '(20 0 25)); Cyan-Red (ujemny = więcej cyjanu/blueego) ; Yellow-Blue (dodatni = więcej niebieskiego)
        (c2 '(10 0 12)) ; Midtony: delikatny fiolet
        (c3 '(5 0 8)) ; więcej czerwieni, mniej niebieskiego w światłach
		)
		(gimp-drawable-color-balance layer2 TRANSFER-SHADOWS 1
                                  (shadows (rval c1))
                                  (shadows (gval c1))
                                  (shadows (bval c1)))
		(gimp-drawable-color-balance layer2 TRANSFER-MIDTONES 1
                                  (midtones (rval c2))
                                  (midtones (gval c2))
                                  (midtones (bval c2)))
		(gimp-drawable-color-balance layer2 TRANSFER-HIGHLIGHTS 1
                                  (highlights (rval c3))
                                  (highlights (gval c3))
                                  (highlights (bval c3)))
	))


(define (lomography-x-tungsten-v3x ask-fileglob)
  (let* (
        ;(layer (vector-ref drawable 0))
        ;(thefiles (cadr (file-glob ask-fileglob 0)))
		;(baseout (car thefiles))
		;(savename (cadr thefiles))

        (baseout (car ask-fileglob))
        (savename (cadr ask-fileglob))

		(image (car (gimp-file-load RUN-NONINTERACTIVE baseout baseout)))
		;(drawable (car (gimp-image-get-active-layer image)))
        ;(selected-layers-array (car (gimp-image-get-selected-layers image)))

        ;; 1. Pobieramy pełną strukturę (liczba . wektor_warstw)
        ;(selected-data (gimp-image-get-selected-layers image))

        ;; 2. Wyciągamy sam wektor (drugi element struktury)
        ;(layers-vector (cadr selected-data))

        ;; GIMP 3.0 (Zwraca czysty wektor bezpośrednio w car!)
        (let ((layers-vector (car (gimp-image-get-selected-layers image))))
            (vector-ref layers-vector 0)
        )

        ;; 3. Pobieramy pierwszą warstwę z wektora (indeks 0)
        (active-layer (vector-ref layers-vector 0))

        ;(num-selected-layers vector-length selected-layers-array)
        ;(active-layer 0)
        )
    (gimp-image-undo-group-start image)
    ;(set! active-layer (vector-ref selected-layers-array (- num-selected-layers 1)))
    ;(gimp-message (number->string (cadr thefiles)))

    ;(let ((liczba (cadr thefiles)))
    ;(display (string-append 'Wynik operacji to: ' (number->string liczba)))
    ;(newline))

    ; 1. Delikatne rozjaśnienie i podniesienie kontrastu (symulacja slajdu)
    (gimp-drawable-brightness-contrast active-layer 0.05 0.10)
    ;(gimp-drawable-brightness-contrast active-layer 0.0 0)

    ; 2. Kluczowy Balans Kolorów (Color Balance)
    ; Symulacja przesunięcia w stronę fioletu/niebieskiego (Tungsten w świetle dziennym)
    ; Cienie: dodanie niebieskiego i magenty
    (balance active-layer)

    ; 3. Zwiększenie nasycenia (X Tungsten ma żywe kolory)
    ;(gimp-drawable-hue-saturation active-layer HUE-RANGE-ALL 0 0 0)

    (gimp-image-merge-down image active-layer CLIP-TO-IMAGE)
    (file-tiff-save  RUN-NONINTERACTIVE image active-layer savename savename 1) ; 1 - lZW


    ; Zakończenie grupy cofania
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)
lomography-x-tungsten-v3x '(\"$baseout\" \"$savename\")'
" -b "(gimp-quit 0)"
	#rm $base_name.siec.tiff
    #rm $base_name.tiff
	fi
done
