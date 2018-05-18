#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include "CUDA_function.h"
#include <vector>
#include <thrust/device_vector.h>

using namespace std;

__global__ void manipulate_matrix( int proc_id, int i_part_size, int dim, int work, double *devdata)
{

 int i = blockIdx.x*blockDim.x + threadIdx.x; //determine thread id i
 int j = blockIdx.y*blockDim.y + threadIdx.y; //determine thread id j

 int ip = proc_id*i_part_size + i; 
 int jp = j; 
 int pos = i*dim + j;
 for(int k=0; k<work; k++)
 {
  devdata[pos] += atan((double)((ip+k+1)%10)*acos(-1.0) + double((jp+k+1)%5)*acos(-1.0)*acos(-1.0));
 }
}


extern "C" vector<double> launch_CUDA_C_code( int num_procs, int proc_id, int dim, int work, vector<double> M_MPI_part) 
{

 cudaSetDevice(proc_id);
 cout << "Process number " << proc_id << " claimed GPU number " <<  proc_id << ".\n";

 int i_part_size =dim/num_procs;
 vector<double> M_part(dim*i_part_size);
 thrust::host_vector<double> hostdata(dim*i_part_size);
 thrust::device_vector<double> devdata(dim*i_part_size);
 double * ptr = thrust::raw_pointer_cast(&devdata[0]);
 dim3 threadsPerBlock(16,16);         //number of threads per block and grid size
 int i_extent = i_part_size/threadsPerBlock.x;
 int j_extent = dim/threadsPerBlock.x;
 dim3 numBlocks(i_extent,j_extent);

 for( int i=0; i<dim*i_part_size; i++)
 {
  hostdata[i] = M_MPI_part[i];
 }
 
 thrust::copy(hostdata.begin(),hostdata.end(),devdata.begin());
 
 cout << "Process number " << proc_id << " calls the kernel. \n";

 manipulate_matrix<<<numBlocks,threadsPerBlock>>> ( proc_id, i_part_size, dim, work, ptr);
 cudaDeviceSynchronize();
 cout << "Process number " << proc_id << " kernel call finished. \n";
 
 thrust::copy(devdata.begin(),devdata.end(),hostdata.begin());
 cout << "Process number " << proc_id << " data transfer to host complete. \n";
 
 for( int i=0; i<dim*i_part_size; i++)
 {
  M_part[i] = hostdata[i];
 }

 return M_part; 
}
