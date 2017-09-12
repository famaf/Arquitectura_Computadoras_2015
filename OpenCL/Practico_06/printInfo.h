/*
 * auxFunc.h
 *
 *  Created on: Sep 2, 2012
 *      Author: notroot
 */

#ifndef AUXFUNC_H_
#define AUXFUNC_H_

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <iostream>
#include <math.h>
#include <CL/cl.h>

#include <string.h>
#include <stdarg.h>

void PrintPlatformInformation(cl_platform_id platform_id)
{

	char platformProfile[1000];
	char platformValueVersion[1000];
	char platformValueName[1000];
	char platformValueVendor[1000];
	char platformValueExt[1000];

	printf("\nPLATFORM INFORMATION:\n");

	/*PLATFORM INFORMATION

	 cl_int clGetPlatformInfo (cl_platform_id platform,		platform refers to the platform ID returned by clGetPlatformIDs or can be NULL.
	 cl_platform_info param_name,  param_name is an enumeration constant that identifies the platform information being queried. It can be one of the following values as specified in table 4.1. (Page 30 OpenCL Spec)
	 size_t param_value_size,		param_value_size specifies the size in bytes of memory pointed to by param_value. This size in bytes must be >= size of return type specified in table 4.1.
	 void *param_value,			param_value is a pointer to memory location where appropriate values for a given param_name as specified in table 4.1 will be returned. If param_value is NULL, it is ignored.
	 size_t *param_value_size_ret) param_value_size_ret returns the actual size in bytes of data being queried by param_value. Ifparam_value_size_ret is NULL, it is ignored.
	 clGetPlatformInfo returns CL_SUCCESS if the function is executed successfully. 	*/

	//Get Platform Profile
	if (clGetPlatformInfo(platform_id, CL_PLATFORM_PROFILE, 1000,
			&platformProfile, NULL) != CL_SUCCESS)
	{
		printf("Unable to get platformInfo\n");
	}
	printf("Platform Profile:       ");
	printf("%s", platformProfile);
	printf("\n");

	//Get Platform Version
	if (clGetPlatformInfo(platform_id, CL_PLATFORM_VERSION, 1000,
			&platformValueVersion, NULL) != CL_SUCCESS)
	{
		printf("Unable to get platformInfo\n");
	}
	printf("Platform Version:       ");
	printf("%s", platformValueVersion);
	printf("\n");

	//Get Platform Name
	if (clGetPlatformInfo(platform_id, CL_PLATFORM_NAME, 1000,
			&platformValueName, NULL) != CL_SUCCESS)
	{
		printf("Unableto get platformInfo\n");
	}
	printf("Platform Name:          ");
	printf("%s", platformValueName);
	printf("\n");

	//Get Platform Vendor
	if (clGetPlatformInfo(platform_id, CL_PLATFORM_VENDOR, 1000,
			&platformValueVendor, NULL) != CL_SUCCESS)
	{
		printf("Unable to get platformInfo\n");
	}
	printf("Platform Vendor:        ");
	printf("%s", platformValueVendor);
	printf("\n");

	//Get Platform Extensions
	if (clGetPlatformInfo(platform_id, CL_PLATFORM_EXTENSIONS, 1000,
			&platformValueExt, NULL) != CL_SUCCESS)
	{
		printf("Unable to get platformInfo\n");
	}
	printf("Platform Extensions:     ");
	printf("%s", platformValueExt);
	printf("\n\n");

}

void PrintDeviceInformation(cl_device_id device_id)
{

	cl_uint workItemDim;
	size_t workItemSize[3];
	size_t workGroupSize = 0;
	cl_uint deviceClock;
	cl_uint deviceAddrBits;
	cl_bool imageSupport;
	size_t deviceMaxParamSize;
	cl_device_mem_cache_type cacheType;
	cl_uint cacheLineSize;
	cl_ulong cacheMemSize;
	cl_ulong globalMemSize;
	cl_ulong constantBufferSize;
	cl_uint deviceMaxConstArgs;
	cl_ulong deviceLocalMemSize;
	size_t deviceTimeResolution;
	cl_bool deviceAvailable;
	cl_bool deviceCompilerAvailable;
	cl_device_exec_capabilities deviceCapabilities;
	char deviceName[200];
	char deviceVendor[200];
	char driverVersion[200];
	char deviceProfile[200];
	char deviceVersion[200];
	char deviceExtensions[500];
	cl_device_type deviceType;
	cl_uint computeUnits;

	/*
	 cl_int clGetDeviceInfo (cl_device_id device,			device is a device returned by clGetDeviceIDs.
	 cl_device_info param_name,		param_name is an enumeration constant that identifies the device information being queried. It can be one of the following values as specified in table 4.3.
	 size_t param_value_size,		param_value_size specifies the size in bytes of memory pointed to by param_value.
	 void *param_value,				param_value is a pointer to memory location where appropriate values for a given param_name as specified in table 4.3 will be returned.
	 size_t *param_value_size_ret)	param_value_size_ret returns the actual size in bytes of data being queried by param_value. If param_value_size_ret is NULL, it is ignored.
	 */

	printf("\nDEVICE INFORMATION:\n");

	//Get Device Name
	if (clGetDeviceInfo(device_id, CL_DEVICE_NAME, 200 * sizeof(char),
			&deviceName, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Vendor:   ");
	printf("%s", deviceName);
	printf("\n");

	//Get Device Vendor
	if (clGetDeviceInfo(device_id, CL_DEVICE_VENDOR, 200 * sizeof(char),
			&deviceVendor, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Name:            ");
	printf("%s", deviceVendor);
	printf("\n");

	//Get Device Driver Version
	if (clGetDeviceInfo(device_id, CL_DRIVER_VERSION, 200 * sizeof(char),
			&driverVersion, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Driver Version:  ");
	printf("%s", driverVersion);
	printf("\n");

	//Get Device Profile
	if (clGetDeviceInfo(device_id, CL_DEVICE_PROFILE, 200 * sizeof(char),
			&deviceProfile, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Profile:         ");
	printf("%s", deviceProfile);
	printf("\n");

	//Get Device Version
	if (clGetDeviceInfo(device_id, CL_DEVICE_VERSION, 200 * sizeof(char),
			&deviceVersion, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Version:         ");
	printf("%s", deviceVersion);
	printf("\n");

	//Get Device Type
	if (clGetDeviceInfo(device_id, CL_DEVICE_TYPE, sizeof(cl_device_type),
			&deviceType, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Type:            ");
	switch (deviceType)
	{
	case CL_DEVICE_TYPE_CPU:
		printf("CL_DEVICE_TYPE_CPU");
		break;
	case CL_DEVICE_TYPE_GPU:
		printf("CL_DEVICE_TYPE_GPU");
		break;
	case CL_DEVICE_TYPE_ACCELERATOR:
		printf("CL_DEVICE_TYPE_ACCELERATOR");
		break;
	case CL_DEVICE_TYPE_DEFAULT:
		printf("CL_DEVICE_TYPE_DEFAULT");
		break;
	default:
		printf("default");
		break;
	}
	printf("\n");

	//Get Device Max Compute Unit
	if (clGetDeviceInfo(device_id, CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(cl_uint),
			&computeUnits, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Max Compute Units:      ");
	printf("%u", computeUnits);
	printf("\n");

	//Get Device Max Work Item Dimensions
	if (clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS,
			sizeof(cl_uint), &workItemDim, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Max Work Item Dimension:");
	printf("%u", workItemDim);
	printf("\n");

	//Get Device Max Work Item in a Dimension
	if (clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_ITEM_SIZES,
			(sizeof(size_t)) * 3, &workItemSize, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Max Work Item in a Dim: ");
	printf("%u,%u,%u", (int) workItemSize[0], (int) workItemSize[1], (int) workItemSize[2]);
	printf("\n");

	//Get Device Max Work Group Size
	if (clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_GROUP_SIZE,
			sizeof(size_t), &workGroupSize, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Max Work Group Size:    ");
	printf("%u", (int) workGroupSize);
	printf("\n");

	//Get Device Max Clock Freq
	if (clGetDeviceInfo(device_id, CL_DEVICE_MAX_CLOCK_FREQUENCY,
			sizeof(cl_uint), &deviceClock, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Max Device Clock Freq:  ");
	printf("%u", deviceClock);
	printf(" MHz\n");

	//Get Device Address Bits
	if (clGetDeviceInfo(device_id, CL_DEVICE_ADDRESS_BITS, sizeof(cl_uint),
			&deviceAddrBits, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Address Bits:    ");
	printf("%u", deviceAddrBits);
	printf(" Bits\n");

	//Get Device Image Support
	if (clGetDeviceInfo(device_id, CL_DEVICE_IMAGE_SUPPORT, sizeof(cl_bool),
			&imageSupport, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Image Support:   ");
	if (imageSupport)
	{
		printf("Image Supported\n");
	}
	else
	{
		printf("Image Not Supported\n");
	}

	//Get Device Max Param Size
	if (clGetDeviceInfo(device_id, CL_DEVICE_MAX_PARAMETER_SIZE, sizeof(size_t),
			&deviceMaxParamSize, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Max Kernel Param Size:  ");
	printf("%u", (int) deviceMaxParamSize);
	printf(" Bytes\n");

	//Get Device Cache Type
	if (clGetDeviceInfo(device_id, CL_DEVICE_GLOBAL_MEM_CACHE_TYPE,
			sizeof(cl_device_mem_cache_type), &cacheType, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Global Mem support:     ");
	if (cacheType == CL_NONE)
	{
		printf("None\n");
	}
	else
	{
		if (cacheType == CL_READ_ONLY_CACHE)
		{
			printf("Read Only\n");
		}
		else
		{
			if (cacheType == CL_READ_WRITE_CACHE)
			{
				printf("Read and Write\n");
			}
		}
	}

	//Get Device Cache Line Size
	if (clGetDeviceInfo(device_id, CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE,
			sizeof(cl_uint), &cacheLineSize, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Cache Line Size: ");
	printf("%u", cacheLineSize);
	printf(" Bytes\n");

	//Get Device Cache Mem Size
	if (clGetDeviceInfo(device_id, CL_DEVICE_GLOBAL_MEM_CACHE_SIZE,
			sizeof(cl_ulong), &cacheMemSize, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Cache Mem Size:  ");
	printf("%.0f", (float) cacheMemSize);
	printf(" Bytes\n");

	//Get Device Global Mem Size
	if (clGetDeviceInfo(device_id, CL_DEVICE_GLOBAL_MEM_SIZE, sizeof(cl_ulong),
			&globalMemSize, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Global Mem Size: ");
	printf("%.0f", (float) globalMemSize);
	printf(" Bytes\n");

	//Get Device Constant Mem Size
	if (clGetDeviceInfo(device_id, CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE,
			sizeof(cl_ulong), &constantBufferSize, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Max Constanst Mem Size: ");
	printf("%.0f", (float) constantBufferSize);
	printf(" Bytes\n");

	//Get Device Max Constants Argument
	if (clGetDeviceInfo(device_id, CL_DEVICE_MAX_CONSTANT_ARGS, sizeof(cl_uint),
			&deviceMaxConstArgs, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Max Const Args in Ker:  ");
	printf("%u", deviceMaxConstArgs);
	printf(" Arguments\n");

	//Get Device Local Mem Size
	if (clGetDeviceInfo(device_id, CL_DEVICE_LOCAL_MEM_SIZE, sizeof(cl_ulong),
			&deviceLocalMemSize, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Local Mem Size:  ");
	printf("%.0f", (float) deviceLocalMemSize);
	printf(" Bytes\n");

	//Get Device Timer Resolution
	if (clGetDeviceInfo(device_id, CL_DEVICE_PROFILING_TIMER_RESOLUTION,
			sizeof(size_t), &deviceTimeResolution, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Timer Res:       ");
	printf("%u", (int) deviceTimeResolution);
	printf(" nanoseconds\n");

	//Get Device Available
	if (clGetDeviceInfo(device_id, CL_DEVICE_AVAILABLE, sizeof(cl_bool),
			&deviceAvailable, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Available:       ");
	if (deviceAvailable == CL_TRUE)
	{
		printf("Yes\n");
	}
	else
	{
		if (deviceAvailable == CL_FALSE)
		{
			printf("No\n");
		}
	}

	//Get Compiler Available
	if (clGetDeviceInfo(device_id, CL_DEVICE_COMPILER_AVAILABLE,
			sizeof(cl_bool), &deviceCompilerAvailable, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Compiler Avail:  ");
	if (deviceCompilerAvailable == CL_TRUE)
	{
		printf("Yes\n");
	}
	else
	{
		if (deviceCompilerAvailable == CL_FALSE)
		{
			printf("No\n");
		}
	}

	//Get Device Capabilites
	if (clGetDeviceInfo(device_id, CL_DEVICE_EXECUTION_CAPABILITIES,
			sizeof(cl_device_exec_capabilities), &deviceCapabilities,
			NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Exe Capabl:      ");
	if (deviceCapabilities == CL_EXEC_KERNEL)
	{
		printf("OpenCL Kernels\n");
	}
	if (deviceCapabilities == CL_EXEC_NATIVE_KERNEL)
	{
		printf("Native Kernels\n");
	}

	//Get Device Extensions
	if (clGetDeviceInfo(device_id, CL_DEVICE_EXTENSIONS, 500 * sizeof(char),
			&deviceExtensions, NULL) != CL_SUCCESS)
	{
		printf("Unableto get deviceInfo\n");
	}
	printf("Device Extensions:      ");
	printf("%s", deviceExtensions);
	printf("\n\n");

}

#endif /* AUXFUNC_H_ */
