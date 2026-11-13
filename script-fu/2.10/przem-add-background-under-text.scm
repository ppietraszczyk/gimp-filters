; przem-add-background-under-text - Script-fu dodający podpis z tłem
; author: PRP
; licencja: Public Domain
; Gdańsk - 06-02-2025
; ver. 1.250209-1

(define (przem-add-background-under-text image drawable text font font-size color background-transparency opacity)

  (gimp-image-undo-group-start image)

  (let* (
        (image-width (car (gimp-image-width image)))
        (image-height (car (gimp-image-height image)))
        (text-extents (gimp-text-get-extents-fontname text font-size 0 font))
        (text-width (car text-extents))
        (text-height (cadr text-extents))
        (pos-x (- (- image-width text-width) 40))
        (pos-y (- image-height text-height))
        (bg-x-left (- pos-x 10))
        (bg-x-right (+ text-width 10))
        (text-layer (car (gimp-text-fontname image -1 0 0 text 0 TRUE font-size 0 font)))
        (bg-layer (car (gimp-layer-new image bg-x-right text-height RGBA-IMAGE "Background" 100 NORMAL-MODE)))
        (is-nocolorful (car (gimp-drawable-is-gray drawable))) ; czy obraz jest w odcieniach szarości
        )

	; Ustawienie koloru tła
    (gimp-context-set-background color)
    (gimp-drawable-fill bg-layer BACKGROUND-FILL)
    (gimp-layer-set-opacity bg-layer opacity)

	; jeśli obraz jest szary to konwertuje go na RGB - tak na sztukę
    (if (= is-nocolorful TRUE)
        (gimp-image-convert-rgb image)
    )

    ; Dodanie warstwy tła pod tekstem
    (gimp-image-insert-layer image bg-layer 0 -1)
    ;(gimp-image-add-layer image new-layer 0)
    (gimp-layer-translate bg-layer bg-x-left pos-y)
    
    (if (= background-transparency TRUE)
	    (begin
            (gimp-drawable-fill bg-layer TRANSPARENT-FILL)
        )
        (begin  ; else
        )
    )
    
	; Ustawienie pozycji tekstu
    (gimp-layer-set-offsets text-layer pos-x pos-y)
    
    ; Przesuń warstwę tekstową na górę stosu warstw
	(gimp-image-raise-item-to-top image text-layer)
    
    ; Scalanie warstw
    (gimp-image-merge-down image text-layer CLIP-TO-IMAGE)

    ; Aktualizacja widoku
    (gimp-displays-flush)
    
    (gimp-image-undo-group-end image) ; Zakończ grupę operacji undo
  )
)

(script-fu-register "przem-add-background-under-text"
  _"Add Background Under Text"
  _"Dodaje kolorowe tło pod tekstem z możliwością wyboru czcionki i rozmiaru."
  "Przemysław R. Pietraszczyk"
  "Public Domain"
  "2025-02-06"
  "RGB* GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-STRING "Text" "Doda Elektroda"
  SF-FONT "Font" "Sans-serif"
  SF-ADJUSTMENT "Font Size" '(50 1 1000 1 10 0 1)
  SF-COLOR "Background Color" '(255 215 0)
  SF-TOGGLE "Background Transparency" FALSE
  SF-ADJUSTMENT "Transparency Value" '(100 1 100 1 10 0 1)
)

(script-fu-menu-register "przem-add-background-under-text"
                         "<Image>/Filters/PIETRASZCZYK/")
