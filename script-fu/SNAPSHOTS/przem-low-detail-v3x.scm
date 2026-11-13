; przem-low-detail-v3x - Zmniejsza szczegółowość zdjęcia (pixelize + blur + posterize
; Przmeysław R. Pietraszczyk
; 2026-07-22
; ver 2.260722-2
; editor: KWrite

(define (przem-low-detail-v3x image drawable px-size blur-radius posterize-levels)
    (let* ((base-layer (vector-ref drawable 0)))

    (gimp-image-undo-group-start image)
    (gimp-drawable-merge-new-filter base-layer "gegl:pixelize" "PIXELIZE" LAYER-MODE-REPLACE 1.0 "size-x" px-size "size-y" px-size)
    (gimp-drawable-merge-new-filter base-layer "gegl:gaussian-blur" "GAUSSIAN-BLUR" LAYER-MODE-REPLACE 1.0 "std-dev-x" blur-radius "std-dev-y" blur-radius "filter" "IIR")
    (gimp-drawable-posterize base-layer posterize-levels)
    )
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
)

(script-fu-register-filter "przem-low-detail-v3x"
 "Low Detail"
 "Zmniejsza szczegółowość zdjęcia (pixelize + blur + posterize)"
 "PRP"
 "Public Domain"
 "2026-07-22"
 "RGB* GRAY*"
 SF-ONE-OR-MORE-DRAWABLE
 SF-ADJUSTMENT "Pixel size" '(8 1 16 1 10 0 0)
 SF-ADJUSTMENT "Blur radius" '(3 1 100 1 10 0 0)
 SF-ADJUSTMENT "Posterize levels" '(6 2 64 1 10 0 0)
)

(script-fu-menu-register "przem-low-detail-v3x"
                         "<Image>/Filters/PIETRASZCZYK/")
