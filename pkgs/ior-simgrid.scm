(define-module (ior-simgrid)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (inria simgrid)
  #:use-module (gnu packages perl)
  #:use-module (ior)
  #:use-module (guix build-system gnu)
  #:use-module (guix git-download))

(define-public ior-simgrid
  (package
    (inherit ior)
    (name "ior-simgrid")
    (propagated-inputs (list simgrid perl))
    (arguments
     '(
       #:configure-flags '(#~(string-append "MPICC=" #$simgrid "/bin/smpicc")
                           #~(string-append "CC=" #$simgrid "/bin/smpicc"))
       #:phases
       (modify-phases %standard-phases
		      (add-after 'unpack bootstrap
				 (lambda _
				   (invoke "./bootstrap"))))
                           ))))

    ; configurePhase = ''
    ;   ./bootstrap && SMPI_PRETEND_CC=1 ./configure --prefix=$out MPICC=${pkgs.simgrid}/bin/smpicc CC=${pkgs.simgrid}/bin/smpicc
    ; '';
