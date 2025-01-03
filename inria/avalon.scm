(define-module (inria avalon)
  #:use-module (guix)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages python-web)
  #:use-module (srfi srfi-1))

(define-public python-concerto
  (package
    (name "python-concerto")
    (version "0.1.3")
    (source (origin
        (method git-fetch)
        (uri (git-reference
          (url "https://gitlab.inria.fr/VeRDi-project/concerto")
          (commit "dca88d662e1c27f426657bdffdb57e7c8b09b30b")))
        (sha256
          (base32
            "09qa2za72gx9y3k3m9x4rpanfnw6yb7c9pmrb6x7yn4r4cwmlp9k"))))
    (build-system python-build-system)
    (home-page "https://gitlab.inria.fr/VeRDi-project/concerto")
    (synopsis "Preliminary implementation in Python 3 of the Concerto reconfiguration model.")
    (description "Preliminary implementation in Python 3 of the Concerto reconfiguration model.")
    (license license:gpl3)))

(define-public python-execo
    (package
      (name "python-execo")
      (version "2.8.1")
      (source (origin
          (method git-fetch)
          (uri (git-reference
            (url "https://gitlab.inria.fr/mimbert/execo")
            (commit (string-append "v" version))))
          (sha256
            (base32
              "1hqb1x8v7qrrznhzwr8rnf4s6jkz7yk5l1f46bqn3bfmy6jf1yjx"))))
      (build-system python-build-system)
      (inputs (list python-requests))
      (home-page "https://gitlab.inria.fr/mimbert/execo")
      (synopsis
       "Python API for asynchronous control of local or remote, standalone or parallel, unix processes.")
      (description
       "Python API for asynchronous control of local or remote, standalone or parallel,
    unix processes.")
      (license license:gpl3)))
