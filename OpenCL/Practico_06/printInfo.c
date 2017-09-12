//
// Compile Command:
// $ g++ -o lec02_printInfo lec02_printInfo.c -lOpenCL
//
// Si el ejecutable no encuentra la librería (pasa en algunas computadoras del Lab) ejecutarlo con el siguiente comando:
//
// $ LD_LIBRARY_PATH=/usr/lib64 ./OpenCL


#include "lec02_printInfo.h"

int main()
{
	/*****************************************/
	/* Initialize OpenCL */
	/*****************************************/

	cl_platform_id platform_id[2];
	cl_uint num_of_platforms;

	if (clGetPlatformIDs(0, NULL, &num_of_platforms) != CL_SUCCESS)
	{
		printf("\nUnable to get Platform Id\n");
		return 1;

	}
	else
	{
		printf("\nNumber of Platforms Available: %u\n", num_of_platforms);
	}

	if (clGetPlatformIDs(1, platform_id, &num_of_platforms) != CL_SUCCESS)
	{
		printf("\nUnable to get Platform Id\n");
		return 1;
	}
	else
	{
		PrintPlatformInformation(platform_id[0]);
		PrintPlatformInformation(platform_id[1]);
	}

	cl_device_id device_id;
	cl_uint num_of_gpu_devices = 0;
	cl_uint num_of_cpu_devices = 0;

	//Check for how many GPUs are available in Platform:
	if (clGetDeviceIDs(platform_id[0], CL_DEVICE_TYPE_GPU, 0, NULL,
			&num_of_gpu_devices) != CL_SUCCESS)
	{
		printf("Number of GPU Devices Available: 0\n");
	}
	else
	{
		printf("Number of GPU Devices Available: %u\n", num_of_gpu_devices);
	}

	//Check for how many CPUs are available in Platform:
	if (clGetDeviceIDs(platform_id[0], CL_DEVICE_TYPE_CPU, 0, NULL,
			&num_of_cpu_devices) != CL_SUCCESS)
	{
		printf("Number of CPU Devices Available: 0\n");
	}
	else
	{
		printf("Number of CPU Devices Available: %u\n", num_of_cpu_devices);
	}

	//Get device to use

	if(num_of_gpu_devices>=1){
		cl_device_id device_id[2];
		if (clGetDeviceIDs(platform_id[0], CL_DEVICE_TYPE_GPU, 2, device_id,
				&num_of_gpu_devices) != CL_SUCCESS)
		{
			printf("Unable to get GPU device_id\n");
			return 1;
		}
		else
		{
			PrintDeviceInformation(device_id[0]);
			PrintDeviceInformation(device_id[1]);
		}
	}

	if(num_of_cpu_devices>=1){
		if (clGetDeviceIDs(platform_id[0], CL_DEVICE_TYPE_CPU, 1, &device_id,
					&num_of_cpu_devices) != CL_SUCCESS)
			{
				printf("Unable to get device_id\n");
				return 1;
			}
			else
			{
				PrintDeviceInformation(device_id);
			}
	}

	return 0;
}
