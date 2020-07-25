#Taller: Aprende a programar en R - Parte 1: Tipos de datos
#Autor: Denisse Fierro Arcos, R-Ladies Galapagos
#Fecha: 2020-07-19
#Detalles: En este script veremos los diferentes tipos de datos que podemos manipular
#en R, asi
#como practicar crear variables


# Caracteres --------------------------------------------------------------
"Bobby"
"Lisa"

# Asignando caracter a una variable ---------------------------------------
H <- "Bobby"
H
class(H)
M <- "Lisa"
M
A <- "Lisa y Bobby"
A
class(A)

#Otra manera de asignar una variable
assign("Nombre", "Lisa")
Nombre
class(Nombre)

#Borrar variables
rm(H, M, A, Nombre)

# Datos numéricos ---------------------------------------------------------
#Incluye enteros y decimales
2
#Revisemos qué tipo de dato es
class(2)
#¿Cómo podemos decirle a R que lo reconozca como un número entero?
2L
#Revisemos el tipo de dato
class(2L)
#¿Qué pasa si fuerzo a R a que reconozca un número decimal como entero?
class(2.5L)


# Cálculos con datos numéricos --------------------------------------------
#Podemos realizar operaciones numéricas como una calculadora
2+5
2*5
2/5
sqrt(5)
sqrt(5)+2


# Creando variables -------------------------------------------------------
x <- -2
x
class(x)

y <- 6.8
y
class(y)

z <- 10L
z
class(z)

# Cálculos utilizando variables -------------------------------------------
x+y
class(x+y)

x*z
class(x*z)

z*z
z^2
class(z*z)
class(z^2)

(x+y)*(-z)
x+y*(-z)

# Asignando resultados de cálculos a variables ----------------------------
#A una nueva variable
m <- y*z
m

#Actualizando el valor de una variable existente
x
x <- x^3
x

y
y <- y/-x
y

rm(m, x, y, z)

# Números complejos -------------------------------------------------------
#Los números complejos están representados por un número real y un número imaginario
30+2i
class(30+2i)

sqrt(-1)
sqrt(-1+0i)
class(sqrt(-1+0i))

x <- 30+2i
x

y <- sqrt(-1+0i)
y

#Es posible también hacer cálculos con números complejos
x+y
y*2


# Valores numéricos especiales --------------------------------------------
#Inf - Infinito
x <- 15/0
x
class(x)

#NaN - No es un número
y <- 0/0
y
class(y)


# Lógicos -----------------------------------------------------------------
x <- TRUE
x
class(x)
#Podemos hacer operaciones aritméticas
x+2

y <- FALSE
y
class(y)
y*5

#Ejemplo de uso de booleanos
x <- -5
y <- 20
#Preguntamos si una condición es cierta o falsa
x < y
y <= 15
#Podemos guardar el resultado de esa pregunta en una variable
z <- x == 10
x
z

# Vectores ----------------------------------------------------------------
x <- 20
x
length(x)
y <- 5+(5*3)
y
length(y)

#Vector vacío
x <- vector()
x
length(x)

#Vectores con más de un elemento
x <- c(5, -10, 15)
x
length(x)
class(x)

#Creando un vector a partir de una secuencia
x <- (1:10)
x
class(x)
y <- c(-10:-1)
y
z <- c(5.5:26) 
z
class(z)
#Secuencias con incrementos distintos a uno
x <- c(5, 10, 15)
x
x1 <- seq(from = 5, to = 15, by = 5)
x1
x2 <- seq(from = 5, length.out = 3, by = 5)
x2
#Comparando resultados (booleanos)
x == x1
x == x2
z <- x == c(5:7)
z
class(z)
z*5

rm(x, y, z, x1, x2)

#Creando un vector repitiendo un número o variable
x <- rep(10, times = 4)
x
y <- rep(1:3, times = 4)
y
#Repitiendo cada elemento N número de veces
z <- rep(seq(1, 3, by = 1), each = 4)
z
#¿Son x & z iguales?
y == z

#Creando un vector basado en otros vectores
x; y; z
nuevo <- c(x, y, z)
nuevo
length(nuevo)

nuevo2 <- c(x, rep(y, 3))
nuevo2

nuevo3 <- c(y, rep(10:14, each = 3))
nuevo3

#Uso de booleanos
nuevo3 > 10
nuevo3 < 10
nuevo3 != 10

rm(nuevo, nuevo2, nuevo3)

#Operaciones con vectores
x <- seq(from = 5, to = 15, by = 5)
x
x*5
(10*x)^2
x*pi
sqrt(x)
x * c(1:3)
x * c(1:2)

rm(x, y, z)

# Vectores con caracteres -------------------------------------------------
nombres <- c("Laura", "Pedro", "Cecilia", "Ximena")
length(nombres)

#Accediendo elementos específicos de un vector
nombres[4]
nombres[1:2]
nombres[c(1,3)]
nombres[c(1,3:4)]
nombres[-2]

#Cambiando un elemento
nombres[4] <- "Jorge"
nombres
#Aumentando un elemento
nombres[5] <- "Marina"
nombres
nombres[6:7] <- c("Isabel", "Estela")
nombres
nombres[9] <- "Julio"
nombres
#NA significa que ese elemento no tiene un valor asignado
rm(nombres)

#Podemos hacer lo mismo con vectores numéricos
x <- seq(from = 5, to = 15, by = 5)
x
x[1] <- 30
x


# Matrices ----------------------------------------------------------------
#Creando una matriz basada en una sequencia
#Podemos definit el numero de filas
x <- matrix(1:30, nrow = 5)
x
length(x)
dim(x)
class(x)
#O el numero de columnas
y <- matrix(seq(2,100, by = 5), ncol = 10)
y
dim(y)
#O ambos
z <- matrix(rep(10, 20), ncol = 5, nrow = 4)
z
#Podemos definir si la matriz es llenada por columnas o filas
matrix(1:30, nrow = 5, byrow = FALSE) #por columna
matrix(1:30, nrow = 5, byrow = T) #por file

#Podemos crear matrices basadas en vectores existentes
x <- seq(1:50)
x
xMat <- matrix(x, nrow = 10) #ordenadas por columna
xMat
xMatFila <- matrix(x, nrow = 10, byrow = T) #ordenadas por fila
xMatFila

#Podemos combinar matrices para crear matrices mas grandes
#Una sobre otra con rbind()
xFila <- rbind(xMat, xMatFila)
xFila
#Una al lado de la otra con cbind()
xCol <- cbind(xMat, xMatFila)
xCol


# Cambiando el nombre de columnas y filas ---------------------------------
xCol
colnames(xCol)
colnames(xCol) <- c("Uno", "Dos", "Tres", "Cuatro", "Cinco", "Seis",  "Siete",
                    "Ocho", "Nueve", "Diez")
colnames(xCol)
xCol

rownames(xCol)
rownames(xCol) <- c("uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", 
                    "ocho", "nueve", "diez")
rownames(xCol)
xCol


# Accediendo elementos de la matriz ---------------------------------------
#Por filas
xFila
xFila[1,]
xFila[1:3,]
xFila[c(1, 5),]
xCol["uno",]

#Por columna
xFila[,1]
xFila[,3:5]
xFila[,c(2, 4)]
xCol[,"Uno"]

#Por elemento
xFila[1,5]
xFila[15,3]
xCol["cuatro", "Tres"]

#Podemos reemplazar los valores de elementos específicos
xCol
xCol[1,] <- 3
xCol
xCol[,1] <- rep(1:5, 2)
xCol
xCol[6,10] <- 100
xCol
xCol["cuatro", "Tres"] <- 350
xCol

#Podemos también cambiar el nombre de una columna o fila específica
colnames(xCol)[5]
colnames(xCol)[5] <- "CINCO"
colnames(xCol)
rm(xCol, xFila, xMat, xMatFila, x, y, z)

# Data frames -------------------------------------------------------------
#Creando un data frame vacio
df <- data.frame()

#Creando un data frame con varias columnas
df <- data.frame(ID = c(1:5), 
                 Nombres = c("Elena", "Isabela", "Juan", "Pedro", "Lola"),
                 Edades = c(rep(30, 3), 15, 18))
df
dim(df)
class(df)

#Creando data frame basado en otros vectores
ID <- c(1:5)
Nombres <- c("Elena", "Isabela", "Juan", "Pedro", "Lola")
Edades <- c(rep(30, 3), 15, 18)
ID; Nombres; Edades
#Uniendo todos los vectores
df1 <- data.frame(ID, Nombres, Edades)
df1

#Comprobando si los dos data frames son iguales
df == df1

#Podemos cambiar los nombres de las columnas al crear el data frame con vectores
colnames(df1)
df1 <- data.frame(Identificacion = ID, Nombre = Nombres, Edad = Edades)
df1
#Reemplazando contenido de un elemento
df1$Edad[3] <- NA
df1

#Tambien podemos cambiar los nombres despues de crear el data frame
colnames(df)
colnames(df) <- c("id", "nombre", "edad")
colnames(df)

#Accedemos elementos de la misma manera que con las matrices
#Fila 1
df[1,]
#Columna 3 (edad)
df[,3]
#También podemos utilizar el nombre de la columna para acceder elementos del data frame
df$edad
df["edad"]
#Fila 1, columna 2 (nombre)
df[1, 2]
df$nombre[1]
df[1, "nombre"]


# Factores ----------------------------------------------------------------
#Nos permite agregar información de manera fácil
Ciudad <- c(rep("Santa Cruz", 3), "Guayaquil", "Quito")
Ciudad
class(Ciudad)
Ciudad <- factor(Ciudad)
Ciudad
class(Ciudad)
levels(Ciudad)

#Podemos agregar una columna adicional como lo hicimos con las matrices
df <- cbind(df, Ciudad)
df
class(df)
str(df)

#Alternativamente podemos crear una columna adicional
df$Ciudad2 <- Ciudad
df

#Agregando/resumiendo información basado en la columna de factores (ciudad)
table(df$Ciudad)
table(df['Ciudad'])
table(df[,4])


# Listas ------------------------------------------------------------------
Encuesta <- list(ID = ID,
                 Nombres = Nombres,
                 Participantes = 5,
                 Casado = c(T, F, F, T, NA),
                 Ciudad = Ciudad,
                 Encuestador = c("Lisa", "Jorge"))
Encuesta
class(Encuesta)
#Número de elementos incluidos en una lista
length(Encuesta)

#Acceder a elementos de una lista
Encuesta$Participantes
Encuesta[['Participantes']]
Encuesta[3]

#Acceder a un subelemento en una lista - Tercer elemento en Ciudad
Encuesta$Ciudad[3]
Encuesta[['Ciudad']][3]

#Número de elementos dentro de un elemento de la lista
length(Encuesta$Encuestador)
length(Encuesta$Nombres)

#Cambiar contenido de un elemento de la lista
Encuesta$ID <- seq(1, 16, by = 3)
Encuesta

#Agregando un nuevo elemento a la lista
Encuesta$ID <- ID

#Cambiar contenido de un sub-elemento de la lista
Encuesta$Encuestador[2] <- "Pedro"
Encuesta

#Accediendo nombres de los elementos de la lista y cambiandolos
names(Encuesta)
names(Encuesta)[1] <- "Identificación"
names(Encuesta)

