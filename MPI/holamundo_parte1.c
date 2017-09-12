#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv) {
    int comm_sz = 0;
    int my_rank = 0;

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

    printf("Hola mundo, soy el proceso %d de %d!\n", my_rank, comm_sz);

    MPI_Finalize();

    return 0;
}
