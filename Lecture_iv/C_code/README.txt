To execute the mpi code, just type the follwoing command:

$ mpirun -np 10 mpi_matrix_manipulation.run

Dont include the '$' symbol, it just serves as a placeholder for your shell prompt. The number of processes is determined by the number provided after the switch '-np' in the command above. The code has been written such that in only allows for divisors of the matrix dimension N. It also has to be smaller or equal to 20.
