// System includes
#include <stdio.h>
#include <stdlib.h>

// OpenCL includes
#include <CL/cl.h>

// Kernel para el modo Express
const char* programSourceExpress =
"__kernel                                                                   \n"
"void express(__global double *A,                                           \n"
"             __global double *B,                                           \n"
"             __global double *C,                                           \n"
"             __private int N,                                              \n"
"             __private int k)                                              \n"
"{                                                                          \n"
"    // Get the work-item’s unique ID                                       \n"
"    int idx = get_global_id(0);                                            \n"
"    int idy = get_global_id(1);                                            \n"
"                                                                           \n"
"    int cant_vecinos;                                                      \n"
"    double sumador;                                                        \n"
"    int iterador;                                                          \n"
"                                                                           \n"
"    for(iterador = 0; iterador < k; iterador++) {                          \n"
"        cant_vecinos = 1;                                                  \n"
"        sumador = 0;                                                       \n"
"                                                                           \n"
"        // Es un punto caliente                                            \n"
"        if (A[idx + idy*N] != 0) {                                         \n"
"            B[idy*N + idx] = A[idy*N + idx];                               \n"
"            C[idy*N + idx] = A[idy*N + idx];                               \n"
"        }                                                                  \n"
"        else {                                                             \n"
"            sumador = B[idy*N + idx];                                      \n"
"                                                                           \n"
"            if (idx > 0) {                                                 \n"
"                sumador = sumador + B[idy*N + (idx - 1)];                  \n"
"                cant_vecinos++;                                            \n"
"            }                                                              \n"
"            if (idx < N-1) {                                               \n"
"                sumador = sumador + B[idy*N + (idx + 1)];                  \n"
"                cant_vecinos++;                                            \n"
"            }                                                              \n"
"            if (idy > 0) {                                                 \n"
"                sumador = sumador + B[(idy - 1)*N + idx];                  \n"
"                cant_vecinos++;                                            \n"
"            }                                                              \n"
"            if (idy < N-1) {                                               \n"
"                sumador = sumador + B[(idy + 1)*N + idx];                  \n"
"                cant_vecinos++;                                            \n"
"            }                                                              \n"
"                                                                           \n"
"            C[idy*N + idx] = (double)sumador/cant_vecinos;                 \n"
"        }                                                                  \n"
"        barrier(CLK_GLOBAL_MEM_FENCE);                                     \n"
"        B[idy*N + idx] = C[idy*N + idx];                                   \n"
"        C[idy*N + idx] = 0;                                                \n"
"    }                                                                      \n"
"    C[idy*N + idx] = B[idy*N + idx];                                       \n"
"}                                                                          \n"
;

// Kernel para el modo RealTime
const char* programSourceRealTime =
"__kernel                                                                   \n"
"void realtime(__global double *A,                                          \n"
"              __global double *B,                                          \n"
"              __global double *C,                                          \n"
"              __private int N)                                             \n"
"{                                                                          \n"
"    // Get the work-item’s unique ID                                       \n"
"    int idx = get_global_id(0);                                            \n"
"    int idy = get_global_id(1);                                            \n"
"                                                                           \n"
"    int cant_vecinos = 1;                                                  \n"
"    double sumador = 0;                                                    \n"
"                                                                           \n"
"    // Es un punto caliente                                                \n"
"    if (A[idx + idy*N] != 0) {                                             \n"
"        B[idy*N + idx] = A[idy*N + idx];                                   \n"
"        C[idy*N + idx] = A[idy*N + idx];                                   \n"
"    }                                                                      \n"
"    else {                                                                 \n"
"            sumador = B[idy*N + idx];                                      \n"
"                                                                           \n"
"            if (idx > 0) {                                                 \n"
"                sumador = sumador + B[idy*N + (idx - 1)];                  \n"
"                cant_vecinos++;                                            \n"
"            }                                                              \n"
"            if (idx < N-1) {                                               \n"
"                sumador = sumador + B[idy*N + (idx + 1)];                  \n"
"                cant_vecinos++;                                            \n"
"            }                                                              \n"
"            if (idy > 0) {                                                 \n"
"                sumador = sumador + B[(idy - 1)*N + idx];                  \n"
"                cant_vecinos++;                                            \n"
"            }                                                              \n"
"            if (idy < N-1) {                                               \n"
"                sumador = sumador + B[(idy + 1)*N + idx];                  \n"
"                cant_vecinos++;                                            \n"
"            }                                                              \n"
"                                                                           \n"
"            C[idy*N + idx] = (double)sumador/cant_vecinos;                 \n"
"    }                                                                      \n"
"}                                                                          \n"
;

int main() {
    // This code executes on the OpenCL host

    char modo; // Char de entrada que me indica el modo usado

    int N = 0; // Tamaño de la matriz cuadrada
    int k = 0; // Cantidad de iteraciones a realizar
    int j = 0; // cantidad de fuentes de calor

    int *x = NULL; // Vector con los valores de x (columnas de la matriz)
    int *y = NULL; // Vector con los valores de y (filas de la matriz)
    double *t = NULL; // Vector con los valores de t (temperatura)

    double *A = NULL; // Matriz Inicial (con las fuentes de calor solamente)
    double *B = NULL; // Matriz Intermedia
    double *C = NULL; // Matriz de Salida

    // Varibles de Profiling para medir el tiempo
    cl_ulong time_start, time_end;
    double total_time;

    // Input de usuario
    printf("\nModos de operacion disponibles:\n");
    printf("\te/E - Modo Express\n");
    printf("\tr/R - Modo Real-Time\n");
    printf("\nIngrese el modo de operacion: ");
    scanf("%c", &modo);
    printf("Ingrese el tamaño de la matriz: ");
    scanf("%d", &N);
    printf("Ingrese la cantidad de iteraciones: ");
    scanf("%d", &k);
    printf("Ingrese la cantidad de fuentes de calor: ");
    scanf("%d", &j);

    k = k + 1;

    // Elements in matrix
    const int dimension = N*N;

    // Compute the size of the data
    size_t matrixsize = sizeof(double)*dimension;

    // Allocate space for input/output data
    A = (double*)malloc(matrixsize);
    B = (double*)malloc(matrixsize);
    C = (double*)malloc(matrixsize);

    // Tamaño de los vectores (x, y, t)
    size_t vectorsize = sizeof(int)*j;
    size_t vectorsize_float = sizeof(double)*j;

    // Alocamos memoria para los vectores
    x = (int*)malloc(vectorsize);
    y = (int*)malloc(vectorsize);
    t = (double*)malloc(vectorsize_float);

    // Bucle para cargar las fuentes de calor (ubicacion y valores)
    int i;
    for (i = 0; i < j; i++) {
        printf("Ingrese la fuente de calor %d: ", i);
        scanf("%d ", &x[i]);
        scanf("%d ", &y[i]);
        scanf("%lf", &t[i]);
    }

    // Inicializamos la matriz con todos 0's
    int eje_x, eje_y;
    for (eje_y = 0; eje_y < N; eje_y++) {
        for (eje_x = 0; eje_x < N; eje_x++) {
            A[eje_y*N + eje_x] = 0;
        }
    }

    // Cargamos los puntos de calor en la matriz
    for (i = 0; i < j; i++) {
        A[y[i]*N + x[i]] = t[i];
    }

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
    cmdQueue = clCreateCommandQueue(context, devices[0], CL_QUEUE_PROFILING_ENABLE, &status); // Profiling

    // Ensure to have execute all enqueued task
    clFinish(cmdQueue); // Profiling

    // Create a buffer object that will contain the data from the host matrix A
    cl_mem bufA;
    bufA = clCreateBuffer(context, CL_MEM_READ_WRITE, matrixsize, NULL, &status);

    // Create a buffer object that will contain the data from the host matrix B
    cl_mem bufB;
    bufB = clCreateBuffer(context, CL_MEM_READ_WRITE, matrixsize, NULL, &status);

    // Create a buffer object that will contain the data from the host matrix C
    cl_mem bufC;
    bufC = clCreateBuffer(context, CL_MEM_READ_WRITE, matrixsize, NULL, &status);

    // Write input matrix A to the device buffer bufA
    status = clEnqueueWriteBuffer(cmdQueue, bufA, CL_TRUE, 0, matrixsize, A, 0, NULL, NULL);

    // Write input matrix T to the device buffer bufB
    status = clEnqueueWriteBuffer(cmdQueue, bufB, CL_FALSE, 0, matrixsize, B, 0, NULL, NULL);

    // Write input matrix C to the device buffer bufC
    status = clEnqueueWriteBuffer(cmdQueue, bufC, CL_FALSE, 0, matrixsize, C, 0, NULL, NULL);

    cl_program program;

    if (modo == 'e' || modo == 'E') {
        // Create a program with source code Express
        program = clCreateProgramWithSource(context, 1, (const char**)&programSourceExpress, NULL, &status);
    }
    else {
        // Create a program with source code RealTime
        program = clCreateProgramWithSource(context, 1, (const char**)&programSourceRealTime, NULL, &status);
    }

    // Build (compile) the program for the device
    status = clBuildProgram(program, numDevices, devices, NULL, NULL, NULL);

    cl_kernel kernel;

    if (modo == 'e' || modo == 'E') {
        // Create the vector addition kernel Express
        kernel = clCreateKernel(program, "express", &status);
    }
    else {
        // Create the vector addition kernel RealTime
        kernel = clCreateKernel(program, "realtime", &status);
    }

    // Define an index space (global work size) of work 
    // items for execution. A workgroup size (local work size) 
    // is not required, but can be used.
    size_t globalWorkSize[2];

    // There are 'elements' work-items 
    globalWorkSize[0] = N;
    globalWorkSize[1] = N;

    cl_event event; // Profiling

    if (modo == 'e' || modo == 'E') {
        // Associate the input and output buffers with the kernel 
        status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &bufA);
        status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &bufB);
        status = clSetKernelArg(kernel, 2, sizeof(cl_mem), &bufC);
        status = clSetKernelArg(kernel, 3, sizeof(int), &N);
        status = clSetKernelArg(kernel, 4, sizeof(int), &k);

        // Execute the kernel for execution
        status = clEnqueueNDRangeKernel(cmdQueue, kernel, 2, NULL, globalWorkSize, NULL, 0, NULL, &event); // Profiling

        clWaitForEvents(1, &event); // Profiling

        // Read the device output buffer to the host output matrix
        clEnqueueReadBuffer(cmdQueue, bufC, CL_TRUE, 0, matrixsize, C, 0, NULL, NULL);

        clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_START, sizeof(time_start), &time_start, NULL); // Profiling
        clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_END, sizeof(time_end), &time_end, NULL); // Profiling

        // Imprimo la matriz
        printf("*** Matriz Final ***\n");
        for (eje_y = 0; eje_y < N; eje_y++) {
            for (eje_x = 0; eje_x < N; eje_x++) {
                printf("%.2lf\t", C[eje_y*N + eje_x]);
            }
            printf("\n");
        }

        total_time = time_end - time_start; // Profiling
        printf("\nTiempo de ejecucion en milisegundos = %0.5f ms\n", (total_time / 1000000.0)); // Profiling
    }
    else {
        // Associate the input and output buffers with the kernel 
        status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &bufA);
        status = clSetKernelArg(kernel, 3, sizeof(int), &N);
        for (i = 0 ; i < k ; i++) {
            status = clSetKernelArg(kernel, (i%2==0?1:2), sizeof(cl_mem), &bufB);
            status = clSetKernelArg(kernel, (i%2==0?2:1), sizeof(cl_mem), &bufC);

            // Execute the kernel for execution
            status = clEnqueueNDRangeKernel(cmdQueue, kernel, 2, NULL, globalWorkSize, NULL, 0, NULL, &event); // Profiling

            clWaitForEvents(1, &event); // Profiling

            // Read the device output buffer to the host output matrix
            clEnqueueReadBuffer(cmdQueue, (i%2==0?bufC:bufB), CL_TRUE, 0, matrixsize, (i%2==0?C:B), 0, NULL, NULL);

            clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_START, sizeof(time_start), &time_start, NULL); // Profiling
            clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_END, sizeof(time_end), &time_end, NULL); // Profiling

            if (i != 0) {
                printf("\n*** Iteracion N° %d ***\n", i);
                // Imprimo la matriz
                for (eje_y = 0; eje_y < N; eje_y++) {
                    for (eje_x = 0; eje_x < N; eje_x++) {
                        printf("%.2lf\t", (i%2==0?C[eje_y*N + eje_x]:B[eje_y*N + eje_x]));
                    }
                    printf("\n");
                }
            }
        }

        total_time = time_end - time_start; // Profiling
        printf("\nTiempo de ejecucion en milisegundos = %0.5f ms\n", (float)(total_time / 1000000.0)); // Profiling
    }

    printf("\nGracias por usar este programa =)\n\n");

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
