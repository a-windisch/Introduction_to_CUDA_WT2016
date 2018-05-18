#include <iostream>
#include <math.h>
#include <mpi.h>
#include <vector>

#define N 5000 // array size
#define Nwork 100
#define ARRAYTAG 1

int main( int argc, char *argv[]) 
{

 using namespace std;
 
 int num_procs;
 int proc_id;

 MPI_Status status;
 MPI_Init(&argc, &argv);
 MPI_Comm_size(MPI_COMM_WORLD, &num_procs); 
 MPI_Comm_rank(MPI_COMM_WORLD, &proc_id);

 if( proc_id == 0 )
 {
  cout << "C-code, multi core version\n";
  cout << "using openmpi. Number of cores in use: "<< num_procs << " \n";
  cout << "Size of matrix: "<< N << "x" << N << "\n";
 }
 //cout << "Hi, I am process number " << proc_id <<"/"<<num_procs<<".\n"; 

 if ( N%num_procs != 0 || num_procs > 20)
 {
  if ( proc_id == 0 ) 
  {
   cout << "\n";
   cout << "Unappropriate number of processes. Only divisors of\n";
   cout << "matrix size are allowed. The maximal number of processes\n";
   cout << "has been restricted to 20.\n";
  }
  return 1;
 }

 int const i_part_size = N/num_procs;
 int part_pos;
 vector<double> M_part(N*i_part_size);
 

 if( proc_id == 0 )
 {
  cout << "Preparing  matrix (thread 0).\n";
  vector<double> M(N*N);
  for ( int k=0; k<N*N; k++ )
  {
   M[k] = 0.0;
  }
  cout << "Distributing matrix slices to available threads (MPI send, thread 0).\n";
  for ( int num=1; num<num_procs;num++ )
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
   MPI_Send(&M_part[0], i_part_size*N, MPI_DOUBLE, num, ARRAYTAG, MPI_COMM_WORLD);
  }
  cout << "Data distribution complete.\n"; 
 }

 if( proc_id != 0 )
 {
  M_part.resize(i_part_size*N);
  MPI_Recv(&M_part[0], i_part_size*N, MPI_DOUBLE, 0, ARRAYTAG, MPI_COMM_WORLD, &status);
  cout << "Process number " << proc_id << " received parition.\n";
 }

 //The following code is executed by every thread
 for (int i=0;i<i_part_size; i++)
 {
 for ( int j=0;j<N; j++)
  {
   int pos = i*N + j;
   int ip = proc_id*i_part_size + i; 
   int jp = j; 
   for(int k=0; k<Nwork; k++)
   {
    M_part[pos] += atan((double)((ip+k+1)%10)*acos(-1.0) + double((jp+k+1)%5)*acos(-1.0)*acos(-1.0));
   }
  }
 }

 if ( proc_id != 0 )
 {
  cout << "Process number " << proc_id << " sends result.\n";
  MPI_Send(&M_part[0], N*i_part_size, MPI_DOUBLE, 0, ARRAYTAG, MPI_COMM_WORLD);
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
    M[pos] = M_part[pos]; 
   }
  }
  cout << "Done.\n";
  cout << "Ready to receive data from other threads (thread 0).\n";
  for (int num=1; num<num_procs; num++)
  {
 //  MPI_Recv(&M[num*i_part_size], N*(i_part_size+1), MPI_DOUBLE, num, ARRAYTAG, MPI_COMM_WORLD, &status);
   MPI_Recv(&M_part[0], N*i_part_size, MPI_DOUBLE, num, ARRAYTAG, MPI_COMM_WORLD, &status);
   int l=0;
   for( int i=num*i_part_size; i<(num+1)*i_part_size; i++)
   {
    for( int j=0; j<N; j++)
    {
     int pos = N*i + j;
     M[pos] = M_part[l];
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
