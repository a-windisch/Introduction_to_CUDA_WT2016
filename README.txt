#======================================
#=        GPU Lecture 2016            =
#= A. Windisch, Washington University =
#=        in ST. Louis, USA           =
#= host: helium.wustl.edu             =
#======================================

This is the source code I prepared for a lecture series 
I held at Washington University in St. Louis in 2016.
To build the executables, just type 'make' (you may have
to modify the Makefile to match your configuration).
In order to compile the CUDA Fortran example, you 
need the pgfortran compiler provided by The Portland Group
(PGI). Feel free to use the code as you please. If you have
any questions you can contact me using
andreas.windisch@yahoo.com.

The lecture is split into four parts.
In the following, I provide a very short description of the
contents of this package.

===========================================================
Here is the current directory structure:
.
├── Lecture_i
│   ├── C_code
│   │   ├── saxpy.c
│   │   └── saxpy_multiple.c
│   ├── CUDA_C_code
│   │   ├── getPROPERTIES.cu
│   │   ├── saxpy.cu
│   │   └── saxpy_multiple.cu
│   └── CUDA_FORTRAN_code
│       ├── getPROPERTIES.cuf
│       ├── saxpy.cuf
│       └── saxpy_multiple.cuf
├── Lecture_ii
│   ├── C_code
│   │   ├── create_movie.sh
│   │   ├── julia_set.cpp
│   │   ├── loop_monochrome_image.gnu
│   │   └── README.txt
│   ├── CUDA_C_code
│   │   ├── create_movie.sh
│   │   ├── julia_set.cu
│   │   ├── loop_monochrome_image.gnu
│   │   └── README.txt
│   └── CUDA_FORTRAN_code
│       ├── create_movie.sh
│       ├── julia_set.cuf
│       ├── loop_monochrome_image.gnu
│       └── README.txt
├── Lecture_iii
│   ├── C_code
│   │   ├── 5000_random_numbers.dat
│   │   ├── BLAS_matrix_multiplication.cpp
│   │   ├── sort.cpp
│   │   └── sort_large.cpp
│   ├── CUDA_C_code
│   │   ├── 5000_random_numbers.dat
│   │   ├── cuBLAS_matrix_multiplication.cu
│   │   ├── THRUST_sort.cu
│   │   └── THRUST_sort_large.cu
│   └── CUDA_FORTRAN_code
│       ├── 5000_random_numbers.dat
│       ├── csort.cu
│       ├── cuBLAS_matrix_multiplication_1.cuf
│       ├── cuBLAS_matrix_multiplication_2.cuf
│       ├── THRUST_mod.cuf
│       ├── THRUST_sort.cuf
│       └── THRUST_sort_large.cuf
├── Lecture_iv
│   ├── C_code
│   │   ├── mpi_matrix_manipulation.cpp
│   │   ├── README.txt
│   │   ├── setpaths.sh
│   │   └── single_core_matrix_manipulation.cpp
│   ├── CUDA_C_code
│   │   ├── blackbox.cuh
│   │   ├── blackbox.o
│   │   ├── CUDA_function.h
│   │   ├── matrix_manipulation.cu
│   │   ├── matrix_manipulation.o
│   │   ├── mpi_launcher.cpp
│   │   ├── mpi_launcher.o
│   │   └── README.txt
│   └── CUDA_FORTRAN_code
│       ├── blackbox.mod
│       ├── blackbox.o
│       ├── matrix_manipulation.cuf
│       ├── mpi_launcher.f90
│       └── README.txt
├── Makefile
└── README.txt

===========================================================
Lecture i
===========================================================
The folder C_code contains a 'saxpy' example which takes
two vectors x and y, and produces x = a*x + y for each
entry. The same problem is solved in CUDA_C and CUDA_FORTRAN
and can be found in the corresponding folders. The example
'saxpy_multiple' is similar to 'saxpy', but it contains a 
loop wrapped around the actual saxpy execution to provide 
more computational intensity, such that the effect of 
dominant transfer times is suppressed.
In the folders for CUDA_C and CUDA_FORTRAN I also included
the programs getPROPERTIES.cu (C) and getPROPERTIES.cuf 
(Fortran), that allow for performing device queries
on a CUDA enabled machine. This programs might be used
to probe for the presence/functionality of a given CUDA
programming environment.
===========================================================
Lecture ii
===========================================================
In this example, we compute a Julia set using the escape
algorithm. The problem is solved in C, CUDA_C and 
CUDA_FORTRAN, the executables can be found in the
corresponding sub-folders. There is also a README file in 
each subdirectory that explains how the data can be 
processed to obtain an mp4 movie using the gnuplot scripts
provided in the respective folders.
===========================================================
Lecture iii
===========================================================
This part is dedicated to the use of libraries, such as
cuBLAS, cuRAND, cuFFT, MAGAM, CULA, etc. In our example,
we discuss cuBLAS, which provides some level 3 BLAS 
operations. We also discuss the use of the Thrust library,
which allows for parallelized sorting, scanning, transform
and reduction operations. As before, all examples will be 
discussed in single core (C), as well as CUDA_C and 
CUDA_FORTRAN.
===========================================================
Lecture iv
===========================================================
Lecture four is dedicated to multi-GPU programming,
using both, MPI with CUDA C and FORTRAN. We start
with a simple C-code that computes entries of a matrix
which is represented as a one-dimensional array (think
of it as being a spatial lattice of some system you want
to investigate). The program single_core_matrix_manipulation
loops through this matrix (lattice) and performs operations
depending on its position. After that, the trace is computed,
which serves as a value for comparison. I also implemented
a MPI program that solves the same problem, where I 
restricted the maximal number of cores to 20. Then, the 
same problem is solved using CUDA-C and CUDA Fortran. The
maximal allowed number of threads there is 4, as we only
have 4 GPUs available. The lattice is split among the 
available GPUs (using MPI), and the entries of the 
partition are then computed using CUDA. The results
are sent to the master thread, which then assembles the
final matrix and computes the trace.
Lecture iv also contains a very simple self-test example
that allows you to check whether you can apply your 
knowledge to write a very simple CUDA C/FORTRAN program.
I added a pre-compiled version of a device function 
that can be called to provide you with the result of the test.
Just follow the instructions provided in the README.txt in
the CUDA-C/FORTRAN folder of Lecture iv.
In each folder you also find a README file that contains instructions
on how to run the program. 


