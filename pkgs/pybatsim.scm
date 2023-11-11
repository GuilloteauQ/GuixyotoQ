(define-module (pybatsim)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (gnu packages python-xyz)
  #:use-module (python-procset)
  #:use-module (guix licenses))

(define my-pyzmq
(package
 (inherit python-pyzmq)
 (version "23.0.0")
 (source
  (origin
   (method url-fetch)
   (uri (pypi-uri "pyzmq" version))
   (sha256
    (base32
       "0gqdfqqccxm63jyh1a351xpnfr34cky3g4a6zlp9vh6p8ijmpsb1"))))))

(define-public pybatsim
  (package
    (name "pybatsim")
    (version "4.0.0a0")
    (home-page "https://gitlab.inria.fr/batsim/pybatsim")
    (source 
       (origin
	(method git-fetch)
	(uri (git-reference
		(url home-page)
		(commit (string-append "v" version))))
	(file-name (git-file-name name version))
	(sha256
	    (base32
		"0gqdfqqccxm63jyh1a351xpnfr34cky3g4a6zlp9vh6p8ijmpsb1"))))
    (build-system pyproject-build-system)
    (arguments
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
		      (add-after 'unpack 'chdir-to-src
				 (lambda _ (chdir "pybatsim-core") #t)))))
    (inputs (list poetry))
    (propagated-inputs (list python-docopt my-pyzmq python-sortedcontainers python-importlib-metadata python-procset))
    (synopsis "Python API and schedulers for Batsim")
    (description "Python API and schedulers for Batsim")
    (license gpl3)))

