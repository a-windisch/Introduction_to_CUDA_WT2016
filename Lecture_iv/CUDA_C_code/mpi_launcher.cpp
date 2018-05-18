#include <iostream>
#include <vector>
#include <mpi.h>
#include "CUDA_function.h"
#define N 16384
#define N_work 100
#define ARRAYTAG  1

using namespace std;

extern vector<double> launch_CUDA_C_code( int num_procs, int proc_id, int dim, int work, vector<double> M_MPI_part);

int main( int argc, char *argv[]) 
{

 int num_procs;
 int proc_id;

 MPI_Status status;
 MPI_Init(&argc, &argv);
 MPI_Comm_size(MPI_COMM_WORLD, &num_procs); 
 MPI_Comm_rank(MPI_COMM_WORLD, &proc_id);

 if( proc_id == 0 )
 {
  cout << "CUDA-C-code, multi GPU version\n";
  cout << "using openmpi. Number of cores in use: "<< num_procs << " \n";
 }

 if ( num_procs > 4 || N%num_procs != 0)
 {
  if ( proc_id == 0 ) 
  {
   cout << "\n";
   cout << "Unappropriate number of processes. There are only four\n";
   cout << "GPUs available. Each MPI process claims one GPU, therefore\n";
   cout << "the number of MPI processes must not be greater than 4.\n";
   cout << "Also, the size of the matrix should be a multiple of the \n";
   cout << "GPUs in use.\n";
  }
  return 1;
 }

 int const i_part_size = N/num_procs;
 vector<double> M_part(N*i_part_size);
 vector<double> M_return(N*i_part_size);


 if( proc_id == 0 )
 {
  cout << "Preparing host matrix M (thread 0).\n";
  vector<double> M(N*N);
  for ( int k=0; k<N*N; k++ )
  {
   M[k] = 0.0;
  }
  cout << "Distributing matrix slices to available GPUs (thread 0).\n";
  for ( int num=0; num<num_procs;num++ )
  {
   int i_start = num*i_part_size;
   int i_stop  = num*i_part_size + i_part_size;
   cout << "Preparing array for process number " << num+1 << "/" << num_procs << ".\n"; 
   cout << "In array M: start index: " << i_start  << ", stop index: " << i_stop-1  << ".\n"; 
   int l = 0;
   for( int i=i_start; i<i_stop; i++)
   {
    for( int j=0; j<N; j++)
    {
     int pos = i*N + j;
     M_part[l] = M[pos];
     l++;
    }
   }
   if( num > 0 ) 
   {
    MPI_Ssend(&M_part[0], i_part_size*N, MPI_DOUBLE, num, ARRAYTAG, MPI_COMM_WORLD);
   }
  }
  cout << "Data distribution complete.\n"; 
 }

 if( proc_id != 0 )
 {
  M_part.resize(i_part_size*N);
  MPI_Recv(&M_part[0], i_part_size*N, MPI_DOUBLE, 0, ARRAYTAG, MPI_COMM_WORLD, &status);
  cout << "Process number " << proc_id << " received partition.\n";
 }


 if( proc_id == 0 )
 {
  cout << "Switching to CUDA (all processes).\n";
 }

 M_return = launch_CUDA_C_code( num_procs, proc_id, N, N_work,  M_part );
 MPI_Barrier( MPI_COMM_WORLD);
 cout << "Process number " << proc_id << " received its CUDA results.\n";

 if ( proc_id != 0 )
 {
  cout << "Process number " << proc_id << " sends result.\n";
  MPI_Ssend(&M_return[0], N*i_part_size, MPI_DOUBLE, 0, ARRAYTAG, MPI_COMM_WORLD);
 }
 if( proc_id == 0 ) 
 {
  cout << "Constructing first matrix partition (thread 0).\n";
  vector<double> M(N*N);
  for( int i=0; i<i_part_size; i++)
  {
   for( int j=0; j<N; j++)
   {
    int pos = i*N + j;
    M[pos] = M_return[pos]; 
   }
  }
  cout << "Done.\n";
  cout << "Ready to receive data from other threads (thread 0).\n";
  for (int num=1; num<num_procs; num++)
  {
   MPI_Recv(&M_return[0], N*i_part_size, MPI_DOUBLE, num, ARRAYTAG, MPI_COMM_WORLD, &status);
   int l=0;
   for( int i=num*i_part_size; i<(num+1)*i_part_size; i++)
   {
    for( int j=0; j<N; j++)
    {
     int pos = N*i + j;
     M[pos] = M_return[l];
     l++; 
    }
   }
  }
  cout << "Matrix M constructed (thread 0).\n";
  cout << "Computing trace.\n";
  double trace=0.0;
  for( int i=0; i<N; i++ )
  {
   trace += M[i*N + i];
  }
  cout << "Done (thread 0).\n";
  cout << "Trace: " << trace << "\n";
 }

 MPI_Finalize();
 return 0;
}
