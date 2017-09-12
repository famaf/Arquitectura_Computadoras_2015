// Ejericicio numero 5 con input de usuario

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

void Get_input(int rank, int comm_sz, float *a_p, float *b_p, int *n_p) {
    int i;

    if (rank == 0) {
        printf("Ingrese el tamaño de los vectores: ");
        scanf("%d", n_p);

        size_t length = sizeof(int)*n_p;
        a_p = (float*)malloc(length);
        b_p = (float*)malloc(length);

        for (i = 0; i < length; i++) {
            printf("\nIngrese el elemento %d del vector A: ", i);
            scanf("%f", &a_p[i]);
        }

        for (i = 0; i < length; i++) {
            printf("\nIngrese el elemento %d del vector B: ", i);
            scanf("%f", &b_p[i]);
        }
    }

    MPI_Bcast(a_p, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);
    MPI_Bcast(b_p, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);
    MPI_Bcast(n_p, 1, MPI_INT, 0, MPI_COMM_WORLD);
}


int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);

    int *N;
    float *a = NULL;
    float *b = NULL;
    float *la;
    float *lb;
    float result;

    int rank, size; // rank es el numero de proceso, y size la cantidad de procesos

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    Get_input(rank, size, &a, &b, &N);

    la = malloc((N/size) * sizeof(float));
    lb = malloc((N/size) * sizeof(float));

    MPI_Scatter(a, (N/size), MPI_FLOAT, la, (N/size), MPI_FLOAT, 0, MPI_COMM_WORLD);
    MPI_Scatter(b, (N/size), MPI_FLOAT, lb, (N/size), MPI_FLOAT, 0, MPI_COMM_WORLD);

    // OPCION 1
    float parcial = 0.0f;
    for (int i = 0; i < N/size; i++) {
        parcial = parcial + la[i] * lb[i];
    }

    MPI_Reduce(&parcial, &result, 1, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("%f\n", result);
    }

    MPI_Finalize();

    return 0;
}
