#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

# define N 10

int main(int argc, char **argv) {
    int comm_sz;
    int rank;
    int *A;
    int *B;
    int *C;
    int *va;
    int *vb;
    int *vc;
    int i;

    MPI_Init(&argc, &argv);

    MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        A = malloc(N * sizeof(int));
        B = malloc(N * sizeof(int));
        C = malloc(N * sizeof(int));

        for (i = 0; i < N; i++) {
            A[i] = i;
            B[i] = i;
        }
    }

    va = malloc((N/comm_sz) * sizeof(int));
    vb = malloc((N/comm_sz) * sizeof(int));
    vc = malloc((N/comm_sz) * sizeof(int));

    MPI_Scatter(A, (N/comm_sz), MPI_INT, va, (N/comm_sz), MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Scatter(B, (N/comm_sz), MPI_INT, vb, (N/comm_sz), MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Scatter(C, (N/comm_sz), MPI_INT, vc, (N/comm_sz), MPI_INT, 0, MPI_COMM_WORLD);

    for (i = 0; i < N/comm_sz; i++) {
        vc[i] = va[i] * vb[i];
    }

    MPI_Gather(vc, (N/comm_sz), MPI_INT, C, (N/comm_sz), MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("A = [ ");
        for (i = 0; i < N; i++) {
            printf("%d ", A[i]);
        }
        printf("]\n");

        printf("B = [ ");
        for (i = 0; i < N; i++) {
            printf("%d ", B[i]);
        }
        printf("]\n");

        printf("C = [ ");
        for (i = 0; i < N; i++) {
            printf("%d ", C[i]);
        }
        printf("]\n");
    }

    MPI_Finalize();

    return 0;
}
