#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

void Get_input(int my_rank, int comm_sz, double *a_p, double *b_p, int *n_p) {
    int dest;
    if (my_rank == 0) {
        printf("Enter a, b, and n\n");
        scanf("%lf %lf %d", a_p, b_p, n_p);

        for (dest = 1; dest < comm sz; dest++) {
            MPI_Send(a_p, 1, MPI_DOUBLE, dest, 0, MPI_COMM_WORLD);
            MPI_Send(b_p, 1, MPI_DOUBLE, dest, 0, MPI_COMM_WORLD);
            MPI_Send(n_p, 1, MPI_INT, dest, 0, MPI_COMM_WORLD);
        }
    }
    /* my rank != 0 */
    else  {
        MPI_Recv(a_p, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Recv(b_p, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Recv(n_p, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
}


int main(int argc, char **argv) {
    int my_rank;
    int comm_sz;
    int *n;
    double *a;
    double *b;
    double *h;
    double local_n;
    double local_a;
    double local_b;
    double local_integral;

    MPI_Init(&argc, &argv);

    Get_input(my_rank, comm_sz, a, b, n);

    h = double(b - a)/n;

    local_n = n/comm_sz;

    MPI_Finalize();

    return 0;
}


// h = (b-a)/n;
// local_n = n/comm_sz;
// local_a = a + my_rank*local_n*h;
// local_b = local_a + local_n*h;
// local_integral = ReglaTrapecio(local_a, local_b, local_n, h);
// if (my_rank != 0)
//     mandar local_integral al proceso 0
// else { /* my_rank == 0 */
//     total_integral = local_integral;
//     for (proc = 1; proc < comm_sz; proc++) {
//         Recibir local_integral desde proc;
//         total_integral += local_integral;
//     }
//     print total_integral;
// }
