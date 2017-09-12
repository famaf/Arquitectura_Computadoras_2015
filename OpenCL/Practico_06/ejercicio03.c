// This program implements a vector addition using OpenCL

// g++ -o lec02_vectoradd lec02_vectoradd.c -lOpenCL

// System includes
#include <stdio.h>
#include <stdlib.h>

// OpenCL includes
#include <CL/cl.h>

// OpenCL kernel to perform an element-wise addition 
const char* programSource =
"__kernel                                             \n"
"void simpleMultiply(__global int *A,                 \n"
"                    __global int *B,                 \n"
"                    __global int *C,                 \n"
"                    __private int N)                 \n"
"{                                                    \n"
"                                                     \n"
"    // Get global position in Y direction            \n"
"    // Get global position in X direction            \n"
"    // Calculate result of one element               \n"
"    int idx = get_global_id(0);                      \n"
"    int idy = get_global_id(1);                      \n"
"    C[idx*N + idy] = A[idx*N + idy] + B[idx*N +idy]; \n"
"}                                                    \n"
;


int main() {
    // This code executes on the OpenCL host

    // Host data
    int *A = NULL;  // Input array
    int *B = NULL;  // Input array
    int *C = NULL;  // Output array

    // Elements in each array
    const int N = 3;

    // Compute the size of the data 
    size_t datasize = sizeof(int)*N*N;

    // Allocate space for input/output data
    A = (int*)malloc(datasize);
    B = (int*)malloc(datasize);
    C = (int*)malloc(datasize);

    // Initialize the input data
    int i, j;
    printf("Matriz A\n");
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            A[i*N + j] = i;
            printf("%d  ", A[i*N + j]);
        }
        printf("\n");
    }
    printf("\n");

    printf("Matriz B\n");
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            B[i*N + j] = j;
            printf("%d  ", B[i*N + j]);
        }
        printf("\n");
    }


    // Use this to check the output of each API call
    cl_int status;
     
    // Retrieve the number of platforms
    cl_uint numPlatforms = 0;
    status = clGetPlatformIDs(0, NULL, &numPlatforms);

    // Allocate enough (suficiente) space for each platform
    cl_platform_id *platforms = NULL;
    platforms = (cl_platform_id*)malloc(numPlatforms*sizeof(cl_platform_id));
 
    // Fill in the platforms
    status = clGetPlatformIDs(numPlatforms, platforms, NULL);

    // Retrieve the number of devices
    cl_uint numDevices = 0;
    status = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, 0, NULL, &numDevices);

    // Allocate enough space for each device
    cl_device_id *devices;
    devices = (cl_device_id*)malloc(numDevices*sizeof(cl_device_id));

    // Fill in the devices
    status = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, numDevices, devices, NULL); //--> Elijo para trabajar con la plataforma 1

    // Create a context and associate it with the devices
    cl_context context;
    context = clCreateContext(NULL, numDevices, devices, NULL, NULL, &status);

    // Create a command queue and associate it with the device 
    cl_command_queue cmdQueue;
    cmdQueue = clCreateCommandQueue(context, devices[0], 0, &status);

    // Create a buffer object that will contain the data 
    // from the host array A
    cl_mem bufA;
    bufA = clCreateBuffer(context, CL_MEM_READ_ONLY, datasize, NULL, &status);

    // Create a buffer object that will contain the data 
    // from the host array B
    cl_mem bufB;
    bufB = clCreateBuffer(context, CL_MEM_READ_ONLY, datasize, NULL, &status);

    // Create a buffer object that will hold the output data
    cl_mem bufC;
    bufC = clCreateBuffer(context, CL_MEM_WRITE_ONLY, datasize, NULL, &status); 
    
    // Write input array A to the device buffer bufferA
    status = clEnqueueWriteBuffer(cmdQueue, bufA, CL_FALSE, 0, datasize, A, 0, NULL, NULL);
    
    // Write input array B to the device buffer bufferB
    status = clEnqueueWriteBuffer(cmdQueue, bufB, CL_FALSE, 0, datasize, B, 0, NULL, NULL);

    // Create a program with source code
    cl_program program = clCreateProgramWithSource(context, 1, (const char**)&programSource, NULL, &status);

    // Build (compile) the program for the device
    status = clBuildProgram(program, numDevices, devices, NULL, NULL, NULL);

    // Create the vector addition kernel
    cl_kernel kernel;
    kernel = clCreateKernel(program, "simpleMultiply", &status);

    // Associate the input and output buffers with the kernel 
    status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &bufA);
    status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &bufB);
    status = clSetKernelArg(kernel, 2, sizeof(cl_mem), &bufC);
    status = clSetKernelArg(kernel, 3, sizeof(int), &N);

    // Define an index space (global work size) of work 
    // items for execution. A workgroup size (local work size) 
    // is not required, but can be used.
    size_t globalWorkSize[2];

    // There are 'elements' work-items 
    globalWorkSize[0] = N;
    globalWorkSize[1] = N;

    // Execute the kernel for execution
    status = clEnqueueNDRangeKernel(cmdQueue, kernel, 2, NULL, globalWorkSize, NULL, 0, NULL, NULL);

    // Read the device output buffer to the host output array
    clEnqueueReadBuffer(cmdQueue, bufC, CL_TRUE, 0, datasize, C, 0, NULL, NULL);

    printf("\n");

    printf("Matriz C\n");
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            printf("%d  ", C[i*N + j]);
        }
        printf("\n");
    }
    printf("\n");

    // Verify the output
/*
    int result = 1;
    for (i = 0; i < elements; i++) {
        printf("i=%4d : %4d + %4d = %4d\n", i, A[i], B[i], C[i]);

        if (C[i] != i+i) {
            result = 0;
            break;
        }
    }

    if (result) {
        printf("Output is correct\n");
    }
    else {
        printf("Output is incorrect\n");
    }
*/
    // Free OpenCL resources
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(cmdQueue);
    clReleaseMemObject(bufA);
    clReleaseMemObject(bufB);
    clReleaseMemObject(bufC);
    clReleaseContext(context);

    // Free host resources
    free(A);
    free(B);
    free(C);
    free(platforms);
    free(devices);

    return 0;
}
