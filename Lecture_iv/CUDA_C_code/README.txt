=======================================================================
For the MPI example:
=======================================================================

To execute the mpi code, just type the follwoing command:

$ mpirun -np 4 mpi_and_cuda_matrix_manipulation.run

Dont include the '$' symbol, it just serves as a placeholder for your shell prompt. The number of processes is determined by the number provided after the switch '-np' in the command above. The code has been written such that in only allows for 4 threads (one for each GPU). A further restriction is, that the number of threads in use must be a divisor of the size of the matrix.

=======================================================================
For self test:
=======================================================================

Copy the saxpy.cu example from Lecture_i/CUDA_C_code into this folder (Lecture_iv/CUDA_C_code) and rename it to my_cuda_program.cu.
Then, modify the program as follows.

=======================================================================
Include the header file: 
=======================================================================
#include "blackbox.cuh"

=======================================================================
In the main function:
=======================================================================
Define an integer N=73.
Define a character array of that size on the host and on the device (using cudaMalloc for the latter).
Initialize the host array to white spaces, carr[i] = ' ';
Transfer the character array to the device.
Call the kernel, passing the device array and the integer N.
Copy the result back to host.
Write a loop that runs through the character array on the host and 'cout' the result.
Add one line break after the loop:
cout << "\n";


=======================================================================
In the kernel function:
=======================================================================
Change the kernel such that it takes a character array arr and an integer N as argument, while returning nothing.
Then, in the kernel, calculate the thread id and call the function that is provided by the blackbox:

 fill_array( arr, i);

=======================================================================
Finally, compile your program with:
=======================================================================

$ nvcc -arch=sm_20 -rdc=true blackbox.o my_cuda_program.cu

=======================================================================
Execute:
=======================================================================
$ ./a.out
