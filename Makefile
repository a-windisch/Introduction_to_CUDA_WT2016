#======================================
#=     Makefile for GPU Lecture 2016  =
#= A. Windisch, Washington University =
#=        in ST. Louis, USA           =
#= host: helium.wustl.edu             =
#======================================

# define compiler
CC		= gcc
CPP		= g++
FC		= gfortran
CGPU		= nvcc
FGPU		= pgfortran
MPICPP		= mpic++
MPIFGPU		= /opt/pgi/linux86-64/2016/mpi/openmpi/bin/mpif90

# define flags
CCFLAGS		= -O3
CPPFLAGS	= -O3
FCFLAGS		= -O3 -cpp
CGPUFLAGS	= -arch=sm_35 -O3 
FGPUFLAGS	= -Mpreprocess -Mcuda -ta=tesla:cc35 -O3

#define libs
CCL3LIBS	= -L/usr/lib64/atlas -ltatlas
CGPUL3LIBS	= -lcublas
FGPUL3LIBS	= /lib64/libstdc++.so.6 /lib64/libgcc_s.so.1 
CGPUL4LIBS	= /usr/local/cuda-7.5/lib64/libcudart.so.7.5

# define directories
L1dirC		= Lecture_i/C_code
L1dirCGPU	= Lecture_i/CUDA_C_code
L1dirFGPU	= Lecture_i/CUDA_FORTRAN_code
L2dirC		= Lecture_ii/C_code
L2dirCGPU	= Lecture_ii/CUDA_C_code
L2dirFGPU	= Lecture_ii/CUDA_FORTRAN_code
L3dirC		= Lecture_iii/C_code
L3dirCGPU	= Lecture_iii/CUDA_C_code
L3dirFGPU	= Lecture_iii/CUDA_FORTRAN_code
L4dirC		= Lecture_iv/C_code
L4dirCGPU	= Lecture_iv/CUDA_C_code
L4dirFGPU	= Lecture_iv/CUDA_FORTRAN_code

# define object directories
L3dirFGPUOBJECTS= $(L3dirFGPU)


default:	all

all:		lecture_i lecture_ii lecture_iii lecture_iv

lecture_i:
	$(CC) $(CCFLAGS) $(L1dirC)/saxpy.c -o $(L1dirC)/saxpy.run
	$(CC) $(CCFLAGS) $(L1dirC)/saxpy_multiple.c -o $(L1dirC)/saxpy_multiple.run
	$(CGPU) $(CGPUFLAGS) $(L1dirCGPU)/getPROPERTIES.cu -o $(L1dirCGPU)/getPROPERTIES.run
	$(CGPU) $(CGPUFLAGS) $(L1dirCGPU)/saxpy.cu -o $(L1dirCGPU)/saxpy.run
	$(CGPU) $(CGPUFLAGS) $(L1dirCGPU)/saxpy_multiple.cu -o $(L1dirCGPU)/saxpy_multiple.run
	$(FGPU) $(FGPUFLAGS) $(L1dirFGPU)/getPROPERTIES.cuf -module $(L1dirFGPU) -o $(L1dirFGPU)/getPROPERTIES.run
	$(FGPU) $(FGPUFLAGS) $(L1dirFGPU)/saxpy.cuf -module $(L1dirFGPU) -o $(L1dirFGPU)/saxpy.run
	$(FGPU) $(FGPUFLAGS) $(L1dirFGPU)/saxpy_multiple.cuf -module $(L1dirFGPU) -o $(L1dirFGPU)/saxpy_multiple.run

lecture_ii:
	$(CPP) $(CCFLAGS) $(L2dirC)/julia_set.cpp -o $(L2dirC)/julia_set.run
	$(CGPU) $(CGPUFLAGS) $(L2dirCGPU)/julia_set.cu -o $(L2dirCGPU)/julia_set.run
	$(FGPU) $(FGPUFLAGS) $(L2dirFGPU)/julia_set.cuf -module $(L2dirFGPU) -o $(L2dirFGPU)/julia_set.run

lecture_iii:
	$(CPP) $(CCFLAGS) $(CCL3LIBS) $(L3dirC)/BLAS_matrix_multiplication.cpp -o $(L3dirC)/BLAS_matrix_multiplication.run
	$(CPP) $(CCFLAGS) $(L3dirC)/sort.cpp -o $(L3dirC)/sort.run
	$(CPP) $(CCFLAGS) $(L3dirC)/sort_large.cpp -o $(L3dirC)/sort_large.run
	$(CGPU) $(CGPUFLAGS) $(CGPUL3LIBS) $(L3dirCGPU)/cuBLAS_matrix_multiplication.cu -o $(L3dirCGPU)/cuBLAS_matrix_multiplication.run
	$(CGPU) $(CGPUFLAGS) $(CGPUL3LIBS) $(L3dirCGPU)/THRUST_sort.cu -o $(L3dirCGPU)/THRUST_sort.run
	$(CGPU) $(CGPUFLAGS) $(CGPUL3LIBS) $(L3dirCGPU)/THRUST_sort_large.cu -o $(L3dirCGPU)/THRUST_sort_large.run
	$(FGPU) $(FGPUFLAGS) $(L3dirFGPU)/cuBLAS_matrix_multiplication_1.cuf -module $(L3dirFGPU) -o $(L3dirFGPU)/cuBLAS_matrix_multiplication_1.run
	$(FGPU) $(FGPUFLAGS) $(L3dirFGPU)/cuBLAS_matrix_multiplication_2.cuf -module $(L3dirFGPU) -o $(L3dirFGPU)/cuBLAS_matrix_multiplication_2.run
	$(CGPU) $(CGPUFLAGS) -c $(L3dirFGPU)/csort.cu -o $(L3dirFGPU)/csort.o
	$(FGPU) $(FGPUFLAGS) -module $(L3dirFGPU) -c $(L3dirFGPU)/THRUST_mod.cuf -o $(L3dirFGPU)/THRUST_mod.o
	$(FGPU) $(FGPUFLAGS) -module $(L3dirFGPU) -c $(L3dirFGPU)/THRUST_sort.cuf -o $(L3dirFGPU)/THRUST_sort.o
	$(FGPU) $(FGPUFLAGS) $(FGPUL3LIBS) -module $(L3dirFGPU) $(L3dirFGPU)/THRUST_sort.o $(L3dirFGPU)/THRUST_mod.o $(L3dirFGPU)/csort.o -o $(L3dirFGPU)/THRUST_sort.run
	$(FGPU) $(FGPUFLAGS) -module $(L3dirFGPU) -c $(L3dirFGPU)/THRUST_sort_large.cuf -o $(L3dirFGPU)/THRUST_sort_large.o
	$(FGPU) $(FGPUFLAGS) $(FGPUL3LIBS) -module $(L3dirFGPU) $(L3dirFGPU)/THRUST_sort_large.o $(L3dirFGPU)/THRUST_mod.o $(L3dirFGPU)/csort.o -o $(L3dirFGPU)/THRUST_sort_large.run

lecture_iv:
	$(CPP) $(CCFLAGS) $(L4dirC)/single_core_matrix_manipulation.cpp -o $(L4dirC)/single_core_matrix_manipulation.run
	sh $(L4dirC)/setpaths.sh
	$(MPICPP) $(L4dirC)/mpi_matrix_manipulation.cpp -o $(L4dirC)/mpi_matrix_manipulation.run
	$(CGPU) -c $(L4dirCGPU)/matrix_manipulation.cu -o $(L4dirCGPU)/matrix_manipulation.o
	$(MPICPP) -c $(L4dirCGPU)/mpi_launcher.cpp -o $(L4dirCGPU)/mpi_launcher.o
	$(MPICPP) $(L4dirCGPU)/mpi_launcher.o $(L4dirCGPU)/matrix_manipulation.o $(CGPUL4LIBS) -o $(L4dirCGPU)/mpi_and_cuda_matrix_manipulation.run
	$(MPIFGPU) $(FGPUFLAGS) -module $(L4dirFGPU) -c $(L4dirFGPU)/matrix_manipulation.cuf -o $(L4dirFGPU)/matrix_manipulation.o
	$(MPIFGPU) $(FGPUFLAGS) -module $(L4dirFGPU) -c $(L4dirFGPU)/mpi_launcher.f90 -o $(L4dirFGPU)/mpi_launcher.o
	$(MPIFGPU) $(FGPUFLAGS) -module $(L4dirFGPU) $(L4dirFGPU)/mpi_launcher.o $(L4dirFGPU)/matrix_manipulation.o -o $(L4dirFGPU)/mpi_and_cuda_matrix_manipulation.run

clean: clean_i clean_ii clean_iii clean_iv

clean_i:
	rm $(L1dirC)/*.run
	rm $(L1dirCGPU)/*.run
	rm $(L1dirFGPU)/*.run
	rm $(L1dirFGPU)/*.mod

clean_ii:
	rm $(L2dirC)/*.run
	rm $(L2dirCGPU)/*.run
	rm $(L2dirFGPU)/*.run
	rm $(L2dirFGPU)/*.mod

clean_iii:
	rm $(L3dirC)/*.run
	rm $(L3dirCGPU)/*.run
	rm $(L3dirFGPU)/*.run
	rm $(L3dirFGPU)/*.mod
	rm $(L3dirFGPU)/*.o

clean_iv:
	rm $(L4dirC)/*.run
	rm $(L4dirCGPU)/*.run
	rm $(L4dirCGPU)/mpi*.o
	rm $(L4dirCGPU)/matrix*.run
	rm $(L4dirFGPU)/*.run
	rm $(L4dirFGPU)/mpi*.o
	rm $(L4dirFGPU)/matrix*.o

