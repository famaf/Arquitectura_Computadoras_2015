#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

// Se encarga de imprimir la matriz ingresada
void ImprimirMatriz(double *matriz, int tamanio) {
    int i, j;

    for (i = 0; i < tamanio; i++) {
        for (j = 0; j < tamanio;j++) {
            printf("%.2lf ",matriz[i*tamanio + j]);
        }
        printf("\n");
    }
    printf("\n");
}


int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);

    double *A = NULL; // Matriz Inicial y Final
    double *local_matrix = NULL; // Pedazo de matriz A correspondiente a cada proceso
    double *local_matrix_aux = NULL; // Matriz intermedia para guardar los valores

    int N = 0; // Tamaño de la matriz (N*N)
    int k = 0; // Cantidad iteraciones a realizar
    int j = 0; // Cantidad de fuentes de calor

    int *x = NULL; // Posicion x de puntos de calor (Columnas)
    int *y = NULL; // Posicion y de puntos de calor (Filas)
    double *t = NULL; // Valores de temperatura en puntos de calor

    int i = 0; // Indice para recorrer la cantidad de fuentes de calor
    int eje_x, eje_y; // Indices para recorrer la matriz

    int comm_sz, rank;

    MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // Master (Proceso 0)
    if (rank == 0) {
        // Input del usuario
        printf("Ingrese el tamaño de la matriz: ");
        fflush(stdout);
        scanf("%d", &N);
        printf("Ingrese la cantidad de iteraciones: ");
        fflush(stdout);
        scanf("%d", &k);
        printf("Ingrese la cantidad de fuentes de calor: ");
        fflush(stdout);
        scanf("%d", &j);

        // Pedimos memoria para guardar la matriz A
        // y los puntos de calor (x,y,t)
        A = malloc(N*N * sizeof(double));
        x = malloc(j * sizeof(int));
        y = malloc(j * sizeof(int));
        t = malloc(j * sizeof(double));

        // Inicializamos la matriz A con todos valores en 0
        for (int i = 0; i < N*N; i++) {
            A[i] = 0;
        }

        // Tomamos las fuentes de calor (posiciones y valores)
        // y lo ponemos en la matriz A
        for (i = 0; i < j; i++) {
            printf("Ingrese la fuente de calor %d : ", i);
            fflush(stdout);
            scanf("%d %d %lf", &x[i], &y[i], &t[i]);
            A[y[i]*N + x[i]] = t[i];
        }

        // Imprimimos como comienza la matriz A inicial
        printf("\nMatriz inicial\n");
        ImprimirMatriz(A, N);
    }

    MPI_Bcast(&N, 1, MPI_INT, 0, MPI_COMM_WORLD); // Pasamos N a todos los procesos
    MPI_Bcast(&k, 1, MPI_INT, 0, MPI_COMM_WORLD); // Pasamos k a todos los procesos
    MPI_Bcast(&j, 1, MPI_INT, 0, MPI_COMM_WORLD); // Pasamos j a todos los procesos

    // Los demás procesos (que no son el master) piden memoria
    // para que el resto de los procesos guarde los puntos de calor
    if (rank != 0) {
        x = malloc(j * sizeof(int));
        y = malloc(j * sizeof(int));
        t = malloc(j * sizeof(double));
    }

    // Broadcast de los puntos de calor
    MPI_Bcast(x, j, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(y, j, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(t, j, MPI_INT, 0, MPI_COMM_WORLD);

    int cant_filas = N/comm_sz; // cantidad de filas que calculara cada proceso
    int mini_matrix_size = N*cant_filas; // tamaño de la matriz que manejará cada proceso

    local_matrix = malloc(mini_matrix_size * sizeof(double)); // pedimos memoria para la matrix de cada proceso
    local_matrix_aux = malloc(mini_matrix_size * sizeof(double)); // pedimos memoria para la matriz intermedia

    // Partimos la matriz A en pedazos (local_matrix) para cada proceso
    MPI_Scatter(A, N*cant_filas, MPI_DOUBLE, local_matrix, N*cant_filas, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    // Inicializamos las matrices locales
    for (eje_x = 0; eje_x < N; eje_x++) {
        for (eje_y = 0; eje_y < N/comm_sz; eje_y++) {
            local_matrix[eje_y*N + eje_x] = 0;

            // Inicializa con puntos de calor
            for (int q=0;q<j;q++) {
                if (x[q]==eje_x && y[q]== rank*N/comm_sz + eje_y) {
                    local_matrix[eje_y*N + eje_x] = t[q];
                }
            }
        }
    }

    double *fila_arriba = malloc(N*sizeof(double)); // Fila superior que se intercambiara con una inferior
    double *fila_abajo = malloc(N*sizeof(double)); // Fila inferior que se intercambiara con una superior

    int iterador; // Para bucle for que realiza iteraciones (también usado como 'tag' en MPI_Sendrecv)
    int cantidad_vecinos; // Me indica los vecinos que la celda alrededor incluyendome
    double sumador; // Calcula la suma del valor de la temperatura de los vecinos
    double promedio; // Contiene el valor del promedio de suma de las celdas

    // Iteramos k veces sobre la matriz local al proceso (local_matrix)
    for (iterador = 0; iterador < k; iterador++) {
        // Procesos que envian y reciben sus datos

        // Estoy en la primera parte de la matriz (no tengo fila de arriba para enviar)
        if (rank==0) {
            // Mando la ultima fila para abajo y recibo la primera fila de local_matrix de abajo
            MPI_Sendrecv(&(local_matrix[N*cant_filas - N]), N, MPI_DOUBLE, rank+1, iterador,
                         fila_abajo, N, MPI_DOUBLE, rank+1, iterador, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        // Estoy en la ultima local_matrix (no tengo fila de abajo para enviar)
        else if (rank == comm_sz - 1) {
            // Mando la fila mia para arriba y recibo la fila de arriba
            MPI_Sendrecv(local_matrix, N, MPI_DOUBLE, rank-1, iterador,
                         fila_arriba, N, MPI_DOUBLE, rank-1, iterador, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        // Estoy entre medio, ie, tengo fila de arriba y de abajo para enviar y recibo filas de arriba y abajo
        else {
            // Mando la fila mia para arriba y recibo la fila de arriba
            MPI_Sendrecv(local_matrix, N, MPI_DOUBLE, rank-1, iterador,
                         fila_arriba, N, MPI_DOUBLE, rank-1, iterador, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            // Mando la ultima fila para abajo y recibo la primera fila de local_matrix de abajo
            MPI_Sendrecv(&(local_matrix[N*cant_filas - N]), N, MPI_DOUBLE, rank+1, iterador,
                         fila_abajo, N, MPI_DOUBLE, rank+1, iterador, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }

        // Ejecutamos el algoritmo de calculo de temperaturas para cada celda
        for (int fila = 0; fila < cant_filas; fila++) {
            for (int columna = 0; columna < N; columna++) {
                sumador = 0; // Donde vamos a guardar la suma de temperaturas
                cantidad_vecinos = 1; // Tenemos en cuenta el punto donde estoy parado
                sumador = sumador + local_matrix[fila*N + columna]; // Sumamos el valor de la celda en que estoy parado

                // Es una fuente de calor
                if (local_matrix[fila*N + columna] != 0) {
                    local_matrix_aux[fila*N + columna] = local_matrix[fila*N + columna];
                }
                // No tiene temperatura
                else {
                    // Es la primera fila (fila de arriba), pero no es la fila vacia del proceso master
                    if (fila == 0 && rank!=0) {
                        sumador = sumador + fila_arriba[columna];
                        cantidad_vecinos++;
                    }
                    // Es la ultima fila (fila de abajo), pero no es la fila vacia del ultimo proceso
                    if(fila == cant_filas-1 && rank!=comm_sz-1) {
                        sumador = sumador + fila_abajo[columna];
                        cantidad_vecinos++;
                    }
                    // Tengo un vecino arriba (Sumo la celda de arriba)
                    if(fila > 0) {
                        sumador = sumador + local_matrix[(fila - 1)*N + columna];
                        cantidad_vecinos++;
                    }
                    // Tengo un vecino abajo (Sumo la celda de abajo)
                    if(fila < cant_filas - 1) {
                        sumador = sumador + local_matrix[(fila + 1)*N + columna];
                        cantidad_vecinos++;
                    }
                    // Tengo un vecino a la derecha (Sumo la celda de la derecha)
                    if(columna > 0) {
                        sumador = sumador + local_matrix[fila*N + (columna - 1)];
                        cantidad_vecinos++;
                    }
                    // Tengo un vecino a la izquierda (Sumo la celda de la izquierda)
                    if(columna < N - 1) {
                        sumador = sumador + local_matrix[fila*N + (columna + 1)];
                        cantidad_vecinos++;
                    }

                    promedio = (double)sumador/cantidad_vecinos; // Calculamos el promedio de temperaturas
                    local_matrix_aux[fila*N + columna] = promedio; // Guardo el promedio en local_matrix auxiliar
                }
            }
        }
        // Hacemos el swap de punteros
        double *r = local_matrix;
        local_matrix = local_matrix_aux;
        local_matrix_aux = r;

        // Hacemos un Gather sobre A para poder unir los local_matrixs de nuevo (dentro del for para imprimir iteraciones)
        // En A queda el resultado de la union de las matrices locales a cada proceso (local_matrix)
        MPI_Gather(local_matrix, mini_matrix_size, MPI_DOUBLE, A, mini_matrix_size, MPI_DOUBLE, 0, MPI_COMM_WORLD);

        // Si estamos en el Master (Proceso 0)
        // imprimimos el resultado de la iteración actual 
        if (rank == 0) {
            printf("Matriz de iteración %i\n", iterador+1);
            ImprimirMatriz(A, N);
        }
    }

    MPI_Finalize();

    return 0;
}
