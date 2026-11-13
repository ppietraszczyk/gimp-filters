; przem-soft-focus-noninteractive - Tworzy efekt miękkiego focusa
; author: PRP
; licencja: Public Domain
; Gdańsk - 15-09-2025
; ver. 2.250615-0

(define (przem-soft-focus-noninteractive filename file-name blur-radius opacity)

  (let* (
		(img (car (gimp-file-load RUN-NONINTERACTIVE filename file-name)))
		(drawable (car (gimp-image-get-active-layer img)))
        (soft-layer (car (gimp-layer-copy drawable FALSE)))
        )
	
    (gimp-image-insert-layer img soft-layer 0 -1)
    (gimp-item-set-name soft-layer "Soft Focus")
    
    ; Rozmycie Gaussa
    (plug-in-gauss 1 img soft-layer blur-radius blur-radius 0)

    ; Zmień tryb mieszania na Overlay lub Screen
    (gimp-layer-set-mode soft-layer OVERLAY-MODE)
    
    ; Dostosuj przezroczystość
    (gimp-layer-set-opacity soft-layer opacity)
    ;(gimp-image-merge-down img soft-layer CLIP-TO-IMAGE)
	
	(gimp-file-save RUN-NONINTERACTIVE img drawable file-name filename)
    (gimp-image-delete img)

))

