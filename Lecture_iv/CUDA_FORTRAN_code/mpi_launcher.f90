#define N 16384
#define N_work 100

PROGRAM mpi_launch

 USE mpi
 USE matrix
 USE cudafor

 IMPLICIT NONE

 INTEGER(KIND=4) :: ierr, errc
 INTEGER(KIND=4) :: proc_id, num_procs
 INTEGER :: istat, i


! Initialize MPI.
 CALL MPI_Init ( ierr )

! Get the number of processes.
 CALL MPI_COMM_RANK (MPI_COMM_WORLD, proc_id, ierr)
 CALL MPI_COMM_SIZE (MPI_COMM_WORLD, num_procs, ierr)

 IF( proc_id .EQ. 0 ) THEN
  PRINT *
  PRINT *, "CUDA-FORTRAN-code, multi GPU version"
  WRITE (*,'(A39 x I3)'), " using openmpi. Number of cores in use:", num_procs
 END IF


 IF( num_procs .GT. 4 .OR. MOD(N,num_procs) .NE. 0) THEN
  IF( proc_id .EQ. 0 ) THEN
   PRINT *,  "Unappropriate number of processes. There are only four"
   PRINT *,  "GPUs available. Each MPI process claims one GPU, therefore"
   PRINT *,  "the number of MPI processes must not be greater than 4."
   PRINT *,  "Also, the size of the matrix should be a multiple of the"
   PRINT *,  "GPUs in use.";
  END IF
  CALL MPI_Abort(MPI_COMM_WORLD, errc, ierr)
 END IF

 istat = cudaSetDevice(proc_id)
 WRITE(*,'(A16 x I3 x A18 x I3 x A1)') " Process number ", proc_id, "claimed GPU dev # ", proc_id, "." 
 CALL main_program(proc_id, num_procs, N, N_work)

!  Shut down MPI.
 CALL MPI_Finalize ( ierr )

END PROGRAM mpi_launch

