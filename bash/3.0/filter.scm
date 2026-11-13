; filter.scm
(define (shadows val) (/ (* 0.96 val) 2.55))
(define (midtones val) (/ val 2.55))
(define (highlights val) (min (/ (* 1.108 val) 2.55) 100.0))
(define (rval col) (car col))
(define (gval col) (cadr col))
(define (bval col) (caddr col))

(define (balance layer2)
  (let ((c1 '(20 0 25)) (c2 '(10 0 12)) (c3 '(5 0 8)))
    (gimp-drawable-color-balance layer2 TRANSFER-SHADOWS 1
                                 (shadows (rval c1)) (shadows (gval c1)) (shadows (bval c1)))
    (gimp-drawable-color-balance layer2 TRANSFER-MIDTONES 1
                                 (midtones (rval c2)) (midtones (gval c2)) (midtones (bval c2)))
    (gimp-drawable-color-balance layer2 TRANSFER-HIGHLIGHTS 1
                                 (highlights (rval c3)) (highlights (gval c3)) (highlights (bval c3)))))

(define (lomography-x-tungsten-v3x baseout savename)
  (let* ((image (car (gimp-file-load RUN-NONINTERACTIVE baseout)))
         (layer-info (gimp-image-get-layers image))
         (layer-vector (cadr layer-info))
         (active-layer (vector-ref layer-vector 0)))
    (gimp-image-undo-group-start image)
    (gimp-drawable-brightness-contrast active-layer 0.05 0.10)
    (balance active-layer)
    (file-tiff-save RUN-NONINTERACTIVE image active-layer savename savename 1)
    (gimp-image-undo-group-end image)
    (gimp-image-delete image)))
