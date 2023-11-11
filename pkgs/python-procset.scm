(define-module (python-procset)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages check)
  #:use-module (guix licenses))

(define-public python-procset
(package
  (name "python-procset")
  (version "1.0")
    (home-page "https://gitlab.inria.fr/bleuse/procset.py")
    (source (origin
	    (method git-fetch)
	    (uri (git-reference
		    (url home-page)
		    (commit (string-append "v" version))))
	    (file-name (git-file-name name version))
	    (sha256
	    (base32
	     "1cnmbw4sgl9156lgvakdkpjr7mgd2wasqz1zml9qzk29p705420z"))))
  (build-system python-build-system)
  ; (native-inputs (list python-coverage python-interval-set python-pytest
  ;                      python-pytest-cov))
  (synopsis "Toolkit to manage sets of closed intervals.")
  (description "Toolkit to manage sets of closed intervals.")
  (license gpl3)))
