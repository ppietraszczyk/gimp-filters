; przem-add-background-under-text-v3x - Script-fu dodający podpis z tłem
; author: PRP
; licencja: Public Domain
; Gdańsk - 06-02-2025
; ver. 2.260116-1~beta for Gimp 3.0

(define (przem-add-background-under-text-v32 image drawable text font font-size fg-color bg-color background-transparency opacity)

  (let* (
        (type-layer (vector-ref drawable 0))
        (type (car (gimp-drawable-type type-layer)))
        (image-width (car (gimp-image-get-width image)))
        (image-height (car (gimp-image-get-height image)))
        (text-extents (gimp-text-get-extents-font text font-size font))
        (text-width (car text-extents))
        (text-height (cadr text-extents))
        (pos-x (- (- image-width text-width) 40))
        (pos-y (- image-height text-height))
        (bg-x-left (- pos-x 10))
        (bg-x-right (+ text-width 10))
        (text-layer 0)
        (bg-layer 0)
        )
        
	(gimp-context-push)
	(gimp-image-undo-group-start image)

	(if (> (car (gimp-drawable-type type-layer)) 1)
        (gimp-image-convert-rgb image)
        )

	; Ustawienie koloru tła
    (gimp-context-set-background bg-color)
    (gimp-context-set-foreground fg-color)

    (set! bg-layer (car (gimp-layer-new image "Background" bg-x-right text-height RGB-IMAGE  100 LAYER-MODE-NORMAL)))

    (gimp-drawable-fill bg-layer FILL-BACKGROUND)
    (gimp-layer-set-opacity bg-layer opacity)
     
    ; Dodanie warstwy tła pod tekstem
    (gimp-image-insert-layer image bg-layer 0 -1)

    ;(gimp-layer-translate bg-layer bg-x-left pos-y)
    ;(gimp-selection-translate image bg-layer bg-x-left pos-y)
    (gimp-layer-set-offsets bg-layer bg-x-left pos-y)
    (if (= background-transparency TRUE)
	    (begin
            (gimp-drawable-fill bg-layer FILL-TRANSPARENT)
        )
        (begin  ; else
        )
    )
    (set! text-layer (car(gimp-text-font image -1 0 0 text 0 TRUE font-size font)))

	; Ustawienie pozycji tekstu
    (gimp-layer-set-offsets text-layer pos-x pos-y)

    ; Przesuń warstwę tekstową na górę stosu warstw
	(gimp-image-raise-item-to-top image text-layer)

    ; Scalanie warstw
    (gimp-image-merge-down image text-layer CLIP-TO-IMAGE)

    (gimp-image-undo-group-end image) ; Zakończ grupę operacji undo

    ; Aktualizacja widoku
    (gimp-displays-flush)
	(gimp-context-pop)

  )
)

(script-fu-register-filter "przem-add-background-under-text-v32"
  _"Add Background Under Text"
  _"Dodaje kolorowe tło pod tekstem z możliwością wyboru czcionki i rozmiaru."
  "Przemysław R. Pietraszczyk"
  "Public Domain"
  "2025-02-06"
  "RGB* GRAY*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-STRING "Text" "Doda Elektroda"
  SF-FONT "Font" "Monospace"
  SF-ADJUSTMENT "Font Size" (list 50 1 1000 1 10 0 1)
  SF-COLOR "Foreground Color" (list 100 100 100)
  SF-COLOR "Background Color" (list 255 215 0)
  SF-TOGGLE "Background Transparency" FALSE
  SF-ADJUSTMENT "Transparency Value" (list 100 1 100 1 10 0 1)
)

(script-fu-menu-register "przem-add-background-under-text-v32"
                         "<Image>/Filters/PIETRASZCZYK/")
