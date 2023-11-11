(define-module (pybatsim)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages check)
  #:use-module (python-procset)
  #:use-module (guix licenses))


(define python-pyzmq-22.0.3
  (package
    (name "python-pyzmq")
    (version "22.0.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pyzmq" version))
       (sha256
        (base32 "0bgrn65cxfz1c1sjrgyq5dy1mkhppxxbizd5wvrl03cq4zhkrxpp"))
       (snippet
        #~(begin
            (use-modules (guix build utils))
            ;; The bundled zeromq source code.
            (delete-file-recursively "bundled")
            ;; Delete cythonized files.
            (for-each delete-file
                      (list "zmq/backend/cython/context.c"
                            "zmq/backend/cython/_device.c"
                            "zmq/backend/cython/error.c"
                            "zmq/backend/cython/message.c"
                            "zmq/backend/cython/_poll.c"
                            "zmq/backend/cython/_proxy_steerable.c"
                            "zmq/backend/cython/socket.c"
                            "zmq/backend/cython/utils.c"
                            "zmq/backend/cython/_version.c"
                            "zmq/devices/monitoredqueue.c"))))))
    (build-system python-build-system)
    (arguments
     `(#:configure-flags
       (list (string-append "--zmq=" (assoc-ref %build-inputs "zeromq")))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'disable-problematic-tests
           (lambda _
             ;; FIXME: The test_draft.TestDraftSockets test fails with:
             ;;   zmq.error.Again: Resource temporarily unavailable
             (delete-file "zmq/tests/test_draft.py")))
         (add-before 'check 'build-extensions
           (lambda _
             ;; Cython extensions have to be built before running the tests.
             (invoke "python" "setup.py" "build_ext" "--inplace")))
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (invoke "pytest" "-vv")))))))
    (inputs (list zeromq))
    (native-inputs
     (list pkg-config
           python-cython
           python-pytest
           python-pytest-asyncio
           python-tornado))
    (home-page "https://github.com/zeromq/pyzmq")
    (synopsis "Python bindings for 0MQ")
    (description
     "PyZMQ is the official Python binding for the ZeroMQ messaging library.")
    (license bsd-4)))


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
    (propagated-inputs (list python-docopt python-pyzmq-22.0.3 python-sortedcontainers python-importlib-metadata python-procset))
    (synopsis "Python API and schedulers for Batsim")
    (description "Python API and schedulers for Batsim")
    (license gpl3)))

