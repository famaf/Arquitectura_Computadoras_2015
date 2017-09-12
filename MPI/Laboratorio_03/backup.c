#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

// Se encarga de inicializar la matriz con todos 0's
void InicializarMatriz(double *matrix, int length) {
    int i, j;

    for (i = 0; i < length; i++) {
        for (j = 0; j < length; j++) {
            matrix[i*length + j] = 0;
        }
    }
}

// Se encarga de imprimir la matriz ingresada
void ImprimirMatriz(double *matrix, int length) {
    int i, j;

    for (i = 0; i < length; i++) {
        for (j = 0; j < length; j++) {
            printf("%.2lf\t",matrix[i*length + j]);
        }
        printf("\n");
    }
    printf("\n");
}

// Se encarga de copiar todos los elementos de una matriz hacia otra
void CopiarMatriz(double *source, double *target, int filas, int columnas) {
    int i, j;

    for (i = 0; i < filas; i++) {
        for (j = 0; j < columnas; j++) {
            target[i*columnas + j] = source[i*columnas + j];
        }
    }
}


int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);

    double *A = NULL; // Matriz Inicial
    double *B = NULL; // Matriz Final

    int N = 0; // Tamaño de la matriz (N*N)
    int iteraciones = 0; // Cantidad iteraciones a realizar
    int cantFuentesCalor = 0; // Cantidad de fuentes de calor

    int x = 0; // Posiciones x (filas de la matriz)
    int y = 0; // Posiciones y (columnas de la matriz)
    double t = 0; // Temperatura t (punto de calor)

    int comm_sz, rank;

    MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // Proceso 0
    if (rank == 0) {
        // Imput del usuario
        printf("Ingrese el tamaño de la matriz: ");
        fflush(stdout);
        scanf("%d", &N);
        printf("Ingrese la cantidad de iteraciones: ");
        fflush(stdout);
        scanf("%d", &iteraciones);
        printf("Ingrese la cantidad de fuentes de calor: ");
        fflush(stdout);
        scanf("%d", &cantFuentesCalor);

        const int dimension = N*N; // Tamaño de la matriz

        // Alocamos memoria para las dos matrices
        A = malloc(dimension * sizeof(double));
        B = malloc(dimension * sizeof(double));

        // Inicializamos las matrices
        InicializarMatriz(A, N);
        InicializarMatriz(B, N);

        // Tomamos el input de las posiciones y valor de las temperaturas
        for (int i = 0; i < cantFuentesCalor; i++) {
            printf("Ingrese la fuente de calor %d : ", i);
            fflush(stdout);
            scanf("%d %d %lf", &x, &y, &t);
            // Cargamos los puntos de calor en la matriz
            A[x*N + y] = t;
        }

        // Imprimimos matriz inicial
        printf("\n*** Matriz Inicial ***\n");
        ImprimirMatriz(A, N);
    }

    // Pasamos a todos los procesos el N
    MPI_Bcast(&N, 1, MPI_INT, 0, MPI_COMM_WORLD);
    // Pasamos a todos los procesos las iteraciones
    MPI_Bcast(&iteraciones, 1, MPI_INT, 0, MPI_COMM_WORLD);

    const int lengthPedazo = N/comm_sz; // Largo de cada pedazo en que se dividira la matriz
    const int pedazo = N*(N/comm_sz); // Tamaño de la pedazo que calculara cada proceso

    double *miniA = NULL; // Pedazo que calculara cada proceso de tamaño igual a pedazo
    double *miniT = NULL; // Pedazo que contiene los puntos de calor
    double *miniA_aux = NULL; // Matriz intermedia para guardar los valores
    double *fila_superior = NULL; // Fila superior que se intercambiara con una inferior
    double *fila_inferior = NULL; // Fila inferior que se intercambiara con una superior

    int cantVecinos; // Me indica los vecinos que la celda alrededor incluyendome
    double sumador; // Calcula la suma del valor de la temperatura de los vecinos
    double promedio; // Contiene el valor del promedio de la suma de las celdas

    // Alocamos memoria para todas las matrices y vectores (filas)
    miniA = malloc(pedazo * sizeof(double));
    miniA_aux = malloc(pedazo * sizeof(double));
    miniT = malloc(pedazo * sizeof(double));
    fila_superior = malloc(N * sizeof(double));
    fila_inferior = malloc(N * sizeof(double));

    // Partimos la matriz A en pedazos para cada proceso
    MPI_Scatter(A, pedazo, MPI_DOUBLE, miniA, pedazo, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    // Partimos la matriz T en pedazos para cada proceso
    MPI_Scatter(A, pedazo, MPI_DOUBLE, miniT, pedazo, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    // Comenzamos a iterar sobre las miniA's
    for (int i = 0; i < iteraciones; i++) {
        // Estoy en la primera fila => tengo fila abajo nomas
        if (rank == 0) {
            MPI_Sendrecv(&miniA[N*(lengthPedazo-1)], N, MPI_DOUBLE, rank+1, 0,
                        fila_inferior, N, MPI_DOUBLE, rank+1, 0,
                        MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        // Estoy en la ultima fila => tengo fila arriba nomas
        else if (rank == comm_sz - 1) {
            MPI_Sendrecv(&miniA[0], N, MPI_DOUBLE, rank-1, 0,
                         fila_superior, N, MPI_DOUBLE, rank-1, 0,
                         MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        // Estoy en el medio => tengo fila arriba y abajo
        else {
            // Mando arriba y recibo abajo
            MPI_Sendrecv(&miniA[0], N, MPI_DOUBLE, rank-1, 0,
                         fila_superior, N, MPI_DOUBLE, rank-1, 0,
                         MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            // Mando abajo y recibo arriba
            MPI_Sendrecv(&miniA[N*(lengthPedazo-1)], N, MPI_DOUBLE, rank+1, 0,
                        fila_inferior, N, MPI_DOUBLE, rank+1, 0,
                        MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        // Itero sobre las miniA's para el calculo de los promedios
        for (int j = 0; j < lengthPedazo; j++) { // Filas
            for (int k = 0; k < N; k++) { // Columnas
                // Nos paramos en una celda de alguna de las miniA's
                cantVecinos = 1;
                sumador = miniA[j*N + k]; // Valor de la celda donde estoy parado

                // Estoy en un punto de calor
                if (miniT[j*N + k] != 0) {
                    miniA_aux[j*N + k] = miniT[j*N + k];
                }
                else {
                    // Tengo un vecino a la izquierda
                    if (k > 0) {
                        sumador += miniA[j*N + (k-1)];
                        cantVecinos++;
                    }
                    // Tengo un vecino a la derecha
                    if (k < N - 1) {
                        sumador += miniA[j*N + (k+1)];
                        cantVecinos++;
                    }
                    // Tengo un vecino arriba
                    if (j > 0) {
                        sumador += miniA[(j-1)*N + k];
                        cantVecinos++;
                    }
                    // Estoy en la primera fila de alguna miniA
                    else {
                        // Si no soy el proceso 0 => sumo el valor de la celda
                        // que esta arriba mio (de alguna miniA), es decir,
                        // el valor de la celda de su ultima fila
                        if (rank != 0) {
                            sumador += fila_superior[k];
                            cantVecinos++;
                        }
                    }
                    // Tengo un vecino abajo
                    if (j < lengthPedazo - 1) {
                        sumador += miniA[(j+1)*N + k];
                        cantVecinos++;
                    }
                    else {
                        // Si no el ultimo proceso => sumo el valor de la celda
                        // que esta abajo mio (de alguna miniA), es decir,
                        // el valor de la celda de su primera fila
                        if (rank != comm_sz - 1)
                        {
                            sumador += fila_inferior[k];
                            cantVecinos++;
                        }
                    }
                    // Calculamos el promedio
                    promedio = (double)sumador/cantVecinos;
                    // Metemos el promedio calculado en miniA_aux
                    miniA_aux[j*N+k] = promedio;
                }
                MPI_Barrier(MPI_COMM_WORLD);
            }
        }
        // Copiamos la matriz miniA_aux a la matriz miniA
        CopiarMatriz(miniA_aux, miniA, lengthPedazo, N);

        // Unimos todos los pedazos y los guardamos en la matriz B
        MPI_Gather(miniA, pedazo, MPI_DOUBLE, B, pedazo, MPI_DOUBLE, 0, MPI_COMM_WORLD);

        // Si estamos en el proceso 0 imprimimos la iteracion i-esima de la
        // matriz B
        if (rank == 0) {
            printf("\n*** Iteracion N° %d ***\n", i+1);
            ImprimirMatriz(B, N);
        }
    }

    MPI_Finalize();

    return 0;
}
