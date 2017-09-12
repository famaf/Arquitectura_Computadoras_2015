#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

//devuelve uno si es fuente de calor si no 0
int esFuente(int x, int y, int j, int* HP) {
    int t;
    for (t = 0; t < j; t++) {
        if ((HP[(t+1)*2-2] == x)&&(HP[(t+1)*2-1] == y)) return 1;
    }
    return 0;
}


void imprimirMatriz(double *matricita, int n, int size) {
    for (int m = 0; m < n/size; m++) {
        printf("\n");
        for (int g = 0; g < n ; g++) {
            printf("%.2f ", matricita[m*n+g]);
        }
    }
    printf("\n");
}



int main(int argc, char ** argv) {
    MPI_Init(&argc, &argv);
    int n = -1, k = 0, j = 0;
    double sum = 0, count = 0;
    int *HotPoint = NULL;
    double *matriz=NULL;

    int size, rank;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        int temperature = 0, x = 0, y = 0;
        while (n <= 0 || (n % size != 0)) {
            printf("Ingrese el tamaño de la matriz que sea divisible por el numero de procesos: ");
            fflush( stdout );
            scanf("%d", &n);
        }
        printf("Ingrese la cantidad de iteraciones: ");
        fflush( stdout );
        scanf("%d", &k);
        printf("Ingrese la cantidad de fuentes de calor: ");
        fflush( stdout );
        scanf("%d", &j);

        matriz = malloc(n*n*sizeof(double));
        for (int h = 0; h < n*n; h++) {
            matriz[h] = 0;
        }

        HotPoint = malloc(j*2*sizeof(int));

        for (int h = 0; h < j; h++) {
            printf("Ingrese fuente de calor %d con formato x y temperatura: ", h);
            fflush( stdout );
            scanf("%d %d %d", &x, &y, &temperature);
            matriz[y*n+x] = temperature;
            HotPoint[(h+1)*2-2] = x;
            HotPoint[(h+1)*2-1] = y;
        }
        printf("\n");

        printf("--------- MATRIZ ORIGINAL --------- \n");
        imprimirMatriz(matriz, n, 1);
    }

    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&k, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&j, 1, MPI_INT, 0, MPI_COMM_WORLD);
    if (rank != 0) HotPoint = malloc(j*2*sizeof(int));
    MPI_Bcast(HotPoint, j*2, MPI_INT, 0, MPI_COMM_WORLD);

    double *matricita = NULL;
    double *matricita_auxiliar = NULL;
    matricita          = malloc(n/size*n*sizeof(double));
    matricita_auxiliar = malloc(n/size*n*sizeof(double));

    double *filaArriba = malloc(n*sizeof(double));
    double *filaAbajo = malloc(n*sizeof(double));

    //hay q ver lo q sobra
    MPI_Scatter(matriz, n*n/size, MPI_DOUBLE, 
                matricita, n*n/size, MPI_DOUBLE,
                0, MPI_COMM_WORLD);

    //k iteraciones
    for (int u = 0; u<k; u++) {
        if (rank == 0) {
            MPI_Send(&(matricita[n*n/size-n]), n, MPI_DOUBLE, rank+1, u, MPI_COMM_WORLD);
            MPI_Recv(filaAbajo, n, MPI_DOUBLE, rank+1 , u, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        else if (rank == size-1) {
            MPI_Send(matricita, n, MPI_DOUBLE, rank-1, u, MPI_COMM_WORLD);
            MPI_Recv(filaArriba, n, MPI_DOUBLE, rank-1 , u, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        else {
            //tambien mando las filas superiores e inferiores a los procesos rank-1 y rank+1
            MPI_Send(matricita, n, MPI_DOUBLE, rank-1, u, MPI_COMM_WORLD);
            MPI_Send(&(matricita[n*n/size-n]), n, MPI_DOUBLE, rank+1, u, MPI_COMM_WORLD);
            //recivo las 2 filas que me hacen falta
            MPI_Recv(filaArriba, n, MPI_DOUBLE, rank-1 , u, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            MPI_Recv(filaAbajo, n, MPI_DOUBLE, rank+1 , u, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        //cada celda de las iteraciones que le corresponden a este proceso
        for (int y = 0; y < n/size; y++) {
            for (int x = 0; x < n; x++) {
                sum = 0;
                count = 0;
                if (esFuente(x, y+(rank*n/size), j, HotPoint)) {//(rank*n/size) me da cuantas filas en y avanze antes
                    matricita_auxiliar[y*n+x] = matricita[y*n+x];
                }
                else {
                    if (x>0) {
                        sum += matricita[y*n+x-1];
                        count++;
                    }
                    if (x<n-1) {
                        sum += matricita[y*n+x+1];
                        count++;
                    }
                    if (y > 0) {
                        sum += matricita[(y-1)*n+x];
                        count++;
                    }
                    else if (rank != 0) {
                        sum += filaArriba[x];
                        count++;
                    }
                    if (y < n/size-1) {
                        sum += matricita[(y+1)*n+x];
                        count++;
                    }
                    else if (rank != size-1) {
                        sum += filaAbajo[x];
                        count++;
                    }
                    sum += matricita[y*n+x];
                    matricita_auxiliar[y*n+x] = sum/count;
                }
            }
        }

        double *tempptr = matricita;
        matricita = matricita_auxiliar;
        matricita_auxiliar = tempptr;

        for (int p = 0; p < n/size*n;p++) {
            matricita_auxiliar[p] = 0;
        }

        MPI_Gather(matricita, n*n/size, MPI_DOUBLE,
               &(matriz[rank*n*n/size]), n*n/size, MPI_DOUBLE,
               0, MPI_COMM_WORLD);

        if (rank == 0) {
           printf("----------- Iteracion %d -----------\n", u+1);
           imprimirMatriz(matriz, n, 1);
        }
    }

    MPI_Finalize();

    return 0;
}
