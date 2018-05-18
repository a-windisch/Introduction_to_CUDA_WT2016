#ifndef CUDA_FUNCTION_H
#define CUDA_FUNCTION_H

#include <vector>

 extern "C" std::vector<double> launch_CUDA_C_code( int num_procs, int proc_id, int N, int work, std::vector<double> M_MPI_part);

#endif
