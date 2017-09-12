// Ejercicio numero 5 del practico sin input

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define N 10

int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);

    int *a = NULL;
    int *b = NULL;
    int *la;
    int *lb;
    int result;
    int i;

    int rank, size;

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        a = malloc(N * sizeof(int));
        b = malloc(N * sizeof(int));

        // Inicializa los vectores con valores del 1 al 1000
        for (i = 0; i < N; i++) {
            a[i] = i;
            b[i] = i;
        }
    }

    la = malloc((N/size) * sizeof(int));
    lb = malloc((N/size) * sizeof(int));

    MPI_Scatter(a, (N/size), MPI_INT, la, (N/size), MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Scatter(b, (N/size), MPI_INT, lb, (N/size), MPI_INT, 0, MPI_COMM_WORLD);

    // OPCION 1
    int parcial = 0;
    for (i = 0; i < N/size; i++) {
        parcial = parcial + la[i] * lb[i];
    }

    MPI_Reduce(&parcial, &result, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("a = [ ");
        for (i = 0; i < N; i++) {
            printf("%d ", a[i]);
        }
        printf("]\n");

        printf("b = [ ");
        for (i = 0; i < N; i++) {
            printf("%d ", b[i]);
        }
        printf("]\n");

        printf("Resultado: %d\n", result);
    }

    MPI_Finalize();

    return 0;
}


// #define N (12)

// int divceil(int a, int b) {
//     return (a+b-1) / b;
// }


// int main(int argc, char **argv) {
//     MPI_Init(&argc, &argv);

//     int *a = NULL, *b = NULL;
//     int *la, *lb;
//     int result;

//     int  rank, size;

//     int work = divceil(N, size);

//     MPI_Comm_size(MPI_COMM_WORLD, &size);
//     MPI_Comm_rank(MPI_COMM_WORLD, &rank);

//     if (rank == 0) {
//         a = malloc(N * sizeof(int));
//         b = malloc(N * sizeof(int));

//         // Inicializa los vectores con valores del 1 al 1000
//         for (int i = 0; i < N; i++) {
//             a[i] = i;
//             b[i] = i;
//         }
//     }

//     la = malloc(work * sizeof(int));
//     lb = malloc(work * sizeof(int));

//     MPI_Scatter(a, work, MPI_int, la, work, MPI_int, 0, MPI_COMM_WORLD);
//     MPI_Scatter(b, work, MPI_int, lb, work, MPI_int, 0, MPI_COMM_WORLD);

//     // OPCION 1
//     int parcial = 0.0f;
//     for (int i = 0; i < work; i++) {
//         parcial = parcial + la[i] * lb[i];
//     }

//     MPI_Reduce(&parcial, &result, 1, MPI_int, MPI_SUM, 0, MPI_COMM_WORLD);

//     if (rank == 0) {
//         printf("%f\n", result);
//     }

//     MPI_Finalize();

//     return 0;
// }
