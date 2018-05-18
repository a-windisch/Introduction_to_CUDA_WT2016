=======================================================================
For the MPI example:
=======================================================================
To execute the mpi code, just type the follwoing command:

$ /opt/pgi/linux86-64/2016/mpi/openmpi/bin/mpiexec -np 4 mpi_and_cuda_matrix_manipulation.run

Dont include the '$' symbol, it just serves as a placeholder for your shell prompt. The number of processes is determined by the number provided after the switch '-np' in the command above. The code has been written such that in only allows for 4 threads (one for each GPU). A further restriction is, that the number of threads in use must be a divisor of the size of the matrix.

=======================================================================
For self test:
=======================================================================

Copy the saxpy.cuf example from Lecture_i/CUDA_FORTRAN_code into this folder (Lecture_iv/CUDA_FORTRAN_code) and rename it to my_cuda_program.cuf.
Then, modify the program as follows.


=======================================================================
In the main function:
=======================================================================
Define an integer N=73.
Define an integer array of that size on the host and on the device.
Initialize the integer host array to zero, iarr= 0;
Transfer the integer array to the device.
Call the kernel, passing the device array and the integer N.
Copy the result back to host.
Print the converted ASCIIs as characters:
 PRINT *, ACHAR(iarr)


=======================================================================
In the kernel function:
=======================================================================
Include the blackbox module:
 
 USE blackbox

Change the kernel such that it takes an integer array iarr and an integer N as argument, while returning nothing.
Then, in the kernel, calculate the thread id and call the function that is provided by the blackbox:

 CALL fill_array( arr, i);

=======================================================================
Finally, compile your program with:
=======================================================================

$ pgfortran -Mcuda blackbox.o my_cuda_program.cuf

=======================================================================
Execute
=======================================================================

$ ./a.out
