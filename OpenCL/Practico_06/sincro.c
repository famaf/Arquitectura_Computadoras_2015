
// g++ -o lec02_sincro lec02_sincro.c -lOpenCL

// System includes
#include <stdio.h>
#include <stdlib.h>

// OpenCL includes
#include <CL/cl.h>

// OpenCL kernel to perform an element-wise addition 
const char* programSource =
"__kernel                                                         \n"
"void sincro(__global int *A,                                     \n"
"            __global int *B)                                     \n"
"{                                                                \n"
"   __local int C[2];                                             \n"
"                                                                 \n"
"   C[get_local_id(0)] = A[get_global_id(0)];                     \n"
"                                                                 \n"
"   barrier(CLK_LOCAL_MEM_FENCE);                                 \n"
"                                                                 \n"
"   int other_local_id = (get_local_id(0)+1)%get_local_size(0);   \n"
"   B[get_global_id(0)] = C[get_local_id(0)] + C[other_local_id]; \n"
"}                                                                \n"
;

int main() {
    // Host data
    int *A = NULL;  // Input array
    int *B = NULL;  // Output array

    // N*N Elements in array
    const int N = 10;

    // Compute the size of the data 
    size_t datasize = sizeof(int)*N;

    // Allocate space for input/output data
    A = (int*)malloc(datasize);
    B = (int*)malloc(datasize);

    // Initialize and print the input data
    printf("Array A:\n");
    for (int i = 0; i < N; i++) {
        A[i] = i;
        printf(" %3d ", A[i]);
    }
    printf("\n");

    // Use this to check the output of each API call
    cl_int status;

    // Retrieve the number of platforms
    cl_uint numPlatforms = 0;
    status = clGetPlatformIDs(0, NULL, &numPlatforms);

    // Allocate enough space for each platform
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
    status = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, numDevices, devices, NULL);

    // Create a context and associate it with the devices
    cl_context context;
    context = clCreateContext(NULL, numDevices, devices, NULL, NULL, &status);

    // Create a command queue and associate it with the device 
    cl_command_queue cmdQueue;
    cmdQueue = clCreateCommandQueue(context, devices[0], 0, &status);

    // Create a buffer object that will contain the data from the host array A
    cl_mem bufA;
    bufA = clCreateBuffer(context, CL_MEM_READ_WRITE, datasize, NULL, &status);

    // Create a buffer object that will contain the data from the host array B
    cl_mem bufB;
    bufB = clCreateBuffer(context, CL_MEM_READ_WRITE, datasize, NULL, &status);

    // Write input array A to the device buffer bufferA
    status = clEnqueueWriteBuffer(cmdQueue, bufA, CL_FALSE, 0, datasize, A, 0, NULL, NULL);

    // Create a program with source code
    cl_program program = clCreateProgramWithSource(context, 1, (const char**)&programSource, NULL, &status);

    // Build (compile) the program for the device
    status = clBuildProgram(program, numDevices, devices, NULL, NULL, NULL);

    // Create the vector addition kernel
    cl_kernel kernel;
    kernel = clCreateKernel(program, "sincro", &status);

    // Associate the input and output buffers with the kernel
    status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &bufA);
    status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &bufB);

    // Define an index space
    size_t globalWorkSize[1];
    globalWorkSize[0] = N;
    size_t localWorkSize[1];
    localWorkSize[0] = 2;

    // Execute the kernel for execution
    status = clEnqueueNDRangeKernel(cmdQueue, kernel, 1, NULL, globalWorkSize, localWorkSize, 0, NULL, NULL);

    // Read the device output buffer to the host output array
    clEnqueueReadBuffer(cmdQueue, bufB, CL_TRUE, 0, datasize, B, 0, NULL, NULL);

    // Verify and print the output
    printf("Array intermedio:\n");
    for (int i = 0; i < N; i++) {
        printf(" %3d ", B[i]);
    }
    printf("\n");

    // Switch buffers (arguments)
    status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &bufB);
    status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &bufA);

    // Execute the kernel for execution
    status = clEnqueueNDRangeKernel(cmdQueue, kernel, 1, NULL, globalWorkSize, localWorkSize, 0, NULL, NULL);

    // Read the device output buffer to the host output array
    clEnqueueReadBuffer(cmdQueue, bufA, CL_TRUE, 0, datasize, A, 0, NULL, NULL);

    // Verify and print the output
    printf("Array A:\n");
    for (int i = 0; i < N; i++) {
        printf(" %3d ", A[i]);
    }
    printf("\n");

    // Free OpenCL resources
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(cmdQueue);
    clReleaseMemObject(bufA);
    clReleaseMemObject(bufB);
    clReleaseContext(context);

    // Free host resources
    free(A);
    free(B);
    free(platforms);
    free(devices);

    return 0;
}
