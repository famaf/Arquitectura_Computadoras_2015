// Este programa implementa una suma de vectores usando OpenCL

// g++ -o ejercicio1 ejercicio1.c -lOpenCL

// System includes
#include <stdio.h>
#include <stdlib.h>

// OpenCL includes
#include <CL/cl.h>

// Kernel OpenCL para realizar una adición de elementos sabio
const char* programSource =
"__kernel                                            \n"
"void vecadd(__global int *A,                        \n"
"            __global int *B,                        \n"
"            __global int *C)                        \n"
"{                                                   \n"
"                                                    \n"
"   // Get the work-item’s unique ID                 \n"
"   int idx = get_global_id(0);                      \n"
"                                                    \n"
"   // Add the corresponding locations of            \n"
"   // 'A' and 'B', and store the result in 'C'.     \n"
"   C[idx] = A[idx] + B[idx];                        \n"
"}                                                   \n"
;

int main() {
    // Este código se ejecuta en el host OpenCL

    // Host data
    int *A = NULL;  // Input array
    int *B = NULL;  // Input array
    int *C = NULL;  // Output array

    // Elementos en cada array
    const int elements = 2048;

    // Calcular en tamaño de los datos
    size_t datasize = sizeof(int)*elements;

    // Asignamos espacio para la entrada/salida de datos
    A = (int*)malloc(datasize);
    B = (int*)malloc(datasize);
    C = (int*)malloc(datasize);

    // Inicializar los datos de entrada
    int i;
    for (i = 0; i < elements; i++) {
        A[i] = i;
        B[i] = i;
    }

    // Utilice esta opción para comprobar la salida de cada llamada a la API
    cl_int status;

    // Recuperar el número de plataformas
    cl_uint numPlatforms = 0;
    status = clGetPlatformIDs(0, NULL, &numPlatforms);

    // Asignamos suficiente espacio para cada plataforma
    cl_platform_id *platforms = NULL;
    platforms = (cl_platform_id*)malloc(numPlatforms*sizeof(cl_platform_id));

    // Rellena las plataformas
    status = clGetPlatformIDs(numPlatforms, platforms, NULL);

    // Recuperamos el numero de dispositivos
    cl_uint numDevices = 0;
    status = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, 0, NULL, &numDevices);

    // Asignar suficiente espacio para cada dispositivo
    cl_device_id *devices;
    devices = (cl_device_id*)malloc(numDevices*sizeof(cl_device_id));

    // Rellena los dispositivos
    status = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, numDevices, devices, NULL);

    // Crear un contexto y asociarlo con los dispositivos
    cl_context context;
    context = clCreateContext(NULL, numDevices, devices, NULL, NULL, &status);

    // Crear una cola de comandos y asociarlo con el dispositivo
    cl_command_queue cmdQueue;
    cmdQueue = clCreateCommandQueue(context, devices[0], 0, &status);

    // Creeamos un objeto de búfer que contendrá los datos del host arreglo A
    cl_mem bufA;
    bufA = clCreateBuffer(context, CL_MEM_READ_ONLY, datasize, NULL, &status);

    // Creeamos un objeto de búfer que contendrá los datos del host arreglo B
    cl_mem bufB;
    bufB = clCreateBuffer(context, CL_MEM_READ_ONLY, datasize, NULL, &status);

    // Cree un objeto de búfer que contendrá los datos de salida
    cl_mem bufC;
    bufC = clCreateBuffer(context, CL_MEM_WRITE_ONLY, datasize, NULL, &status); 
    
    // Escribe la entrada del arreglo A en el dispositivo buffer "bufA"
    status = clEnqueueWriteBuffer(cmdQueue, bufA, CL_FALSE, 0, datasize, A, 0, NULL, NULL);
    
    // Escribe la entrada del arreglo A en el dispositivo buffer "bufB"
    status = clEnqueueWriteBuffer(cmdQueue, bufB, CL_FALSE, 0, datasize, B, 0, NULL, NULL);

    // Crear un programa con código fuente
    cl_program program = clCreateProgramWithSource(context, 1, (const char**)&programSource, NULL, &status);

    // Construir (compilar) el programa para el dispositivo
    status = clBuildProgram(program, numDevices, devices, NULL, NULL, NULL);

    // Crea la suma de vectores en Kernel
    cl_kernel kernel;
    kernel = clCreateKernel(program, "vecadd", &status);

    // Asocia los buffers de entrada y salida con el Kernel
    status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &bufA);
    status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &bufB);
    status = clSetKernelArg(kernel, 2, sizeof(cl_mem), &bufC);

    // Defina un espacio de índice (tamaño de trabajo global) de los elementos de trabajo para la ejecución.
    // Un tamaño de grupo de trabajo (el tamaño de obra local) no es necesario, pero puede ser utilizado.
    size_t globalWorkSize[1];
 
    // Hay "elementos" work-items
    globalWorkSize[0] = elements;

    // Ejecutar el kernel para su ejecución
    status = clEnqueueNDRangeKernel(cmdQueue, kernel, 1, NULL, globalWorkSize, NULL, 0, NULL, NULL);

    // Lee el buffer de salida del dispositivo del arreglo de salida del host
    clEnqueueReadBuffer(cmdQueue, bufC, CL_TRUE, 0, datasize, C, 0, NULL, NULL);

    // Verificamos la salida
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

    // Liberamos los recursos de OpenCL
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(cmdQueue);
    clReleaseMemObject(bufA);
    clReleaseMemObject(bufB);
    clReleaseMemObject(bufC);
    clReleaseContext(context);

    // Liberamos los recursos del Host
    free(A);
    free(B);
    free(C);
    free(platforms);
    free(devices);

    return 0;
}
