#include <iostream>
#include "cublas.h"

int  main ( void ) {

 using namespace std;


 int N = 7000;

 cout << "CUDA-C (cuBLAS) version\n";
 cout << "Initializing cuBLAS.\n";

 cublasStatus status;
 cublasInit();

 cout << "Done.\n";
 cout << "Allocating " << N << "x" << N << "-matrices MA, MB and MC on host.\n";
 double *MA_h = (double*)malloc(N*N*sizeof(double));
 double *MB_h = (double*)malloc(N*N*sizeof(double));
 double *MC_h = (double*)malloc(N*N*sizeof(double));
 double *MA_d; 
 double *MB_d; 
 double *MC_d;

 cout << "Done.\n";
 cout << "Filling matrices on host.\n";

 for (int i=0;i<N;i++)
 {
  for (int j=0;j<N;j++)
  {
    int pos = j*N + i;
    MA_h[pos] = (double) ( i%10 + j%10 + 1);   
    MB_h[pos] = (double) ( i%8  + j%11 + 1); 
    MC_h[pos] = 0.0;
  }
 }

 cout << "Done.\n";
 cout << "Allocating " << N << "x" << N << "-matrices MA, MB and MC on device.\n";
 cout << "(in fact, they are N*N 1dim vectors here...)\n";


 //This can be done in a secure way, by monitoring the process
 //using the status variable defined above. In case anything goes
 //wrong, an error message will be produced.
 status = cublasAlloc(N*N, sizeof(*MA_d), (void**)&MA_d);
 if (status != CUBLAS_STATUS_SUCCESS) {
     cout <<  "!!!! device memory allocation error (MA_d)\n";
     return EXIT_FAILURE;
 }

 //If you want to spice up your life by adding excitement
 //by NOT monitoring the status, that is perfectly fine as well.
 //Let us live on the edge for the rest of the code.
 cublasAlloc(N*N,sizeof(*MB_d),(void**) &MB_d);
 cublasAlloc(N*N,sizeof(*MC_d),(void**) &MC_d);

 cout << "Done.\n";
 cout << "Copy data from host to device.\n";

 cublasSetVector(N*N,sizeof(double),MA_h,1,MA_d,1);
 cublasSetVector(N*N,sizeof(double),MB_h,1,MB_d,1);

 cout << "Done.\n";
 cout << "Perform multiplication MC = MA.MB on device.\n";
 cublasDgemm('N','N',N,N,N,1.0,MA_d,N,MB_d,N,0.0,MC_d,N);
 cout << "Done.\n";
 cout << "Copy data from device to host.\n";

 cublasGetVector(N*N,sizeof(double),MC_d,1,MC_h,1);


 cout << "Done.\n";
 cout << "Control element MC(123,456):\n";
 cout << MC_h[122+455*N]<<"\n";

 free(MA_h);  
 free(MB_h);  
 free(MC_h);
 cublasFree(MA_d);
 cublasFree(MB_d);
 cublasFree(MC_d);

 cublasShutdown();

}

