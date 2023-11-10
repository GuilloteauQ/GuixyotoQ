(define-module (ior)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages perl)
  #:use-module (guix build-system gnu)
  #:use-module (guix git-download))

(define-public ior
  (package
    (name "ior")
    (version "3.3.0")
    (home-page "https://github.com/hpc/ior")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url home-page)
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1qw8flyjr5h9m2im8wgasc5hri7lliycidbpl69mcgp26ysfja55"))))
    (build-system gnu-build-system)
    (arguments
     '(#:phases (modify-phases %standard-phases
                  (delete 'check))))
    (native-inputs (list autoconf automake))
    (propagated-inputs (list openmpi perl))
    (synopsis "Parallel file system I/O performance test")
    (description
     "IOR is a parallel IO benchmark that can be used to test the performance of parallel storage systems using various interfaces and access patterns. The IOR repository also includes the mdtest benchmark which specifically tests the peak metadata rates of storage systems under different directory structures. Both benchmarks use a common parallel I/O abstraction backend and rely on MPI for synchronization.")
    (license gpl2)))
