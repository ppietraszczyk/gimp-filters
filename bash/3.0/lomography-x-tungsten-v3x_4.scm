
(define (shadows val)
  (/ (* 0.96 val) 2.55))

(define (midtones val)
  (/ val 2.55))

(define (highlights val)
  (min (/ (* 1.108 val) 2.55) 100.0))

(define (rval col) (car col))
(define (gval col) (cadr col))
(define (bval col) (caddr col))

(define (balance layer2)
  (let (
        (c1 '(20 0 25))
        (c2 '(10 0 12))
        (c3 '(5 0 8))
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
                                 (highlights (bval c3)))))

(define (lomography-x-tungsten-v3x ask-fileglob)
  (let* (
        (baseout (car ask-fileglob))
        (savename (cadr ask-fileglob))
        (image (car (gimp-file-load RUN-NONINTERACTIVE baseout)))
        ;(active-layer (car (gimp-image-get-active-layer image)))
        ;(n (gimp-image-get-layers image))
        ;(n-layers (car n))
        ;(vector-n (cadr n))
        ;(layer1 (vector-ref vector-n 0))


        (if (null? layer-info)
        (gimp-message "layer-info jest puste!")
        (gimp-message "layer-info nie jest puste, ale nie można go bezpośrednio wypisać jako ciąg znaków"))

        (layer-info (gimp-image-get-layers image))
        (num-layers (car layer-info))
        (layer-vector (cadr layer-info))
        (first-layer (vector-ref layer-vector 0))

        ;(gimp_image_set_selected_layers (vector first-layer))
        (gimp-image-set-selected-layers image 1 (vector first-layer))


        ;(selected-layer (car (gimp-image-get-selected-layers image)))

        ;;;(selected-info (gimp-image-get-selected-layers image))


        ;;(num-selected (car selected-info))
        ;;(selected-vector (cadr selected-info))
        ;;(active-layer (vector-ref selected-vector 0)) ; lub inny indeks

        (active-layer first-layer)


        ;(num-layers (vector-length selected-layers))
        ;(active-layer 0)
       )

    ;(set! active-layer (vector-ref selected-layer (- num-layers 1)))

    (gimp-image-undo-group-start image)
    (gimp-drawable-brightness-contrast active-layer 0.05 0.10)
    (balance active-layer)
    (file-tiff-save RUN-NONINTERACTIVE image active-layer savename savename 1)
    (gimp-image-undo-group-end image)
    (gimp-image-delete image)))
