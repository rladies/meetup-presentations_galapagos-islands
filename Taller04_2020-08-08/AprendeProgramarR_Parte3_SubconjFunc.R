#Taller: Aprende a programar en R - Parte 3: Subconjuntos y funciones
#Autor: Denisse Fierro Arcos, R-Ladies Galapagos
#Fecha: 2020-08-07
#Detalles: En este script veremos como acceder a subconjuntos de datos y continuamos
#con las funciones

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
ID
Nombres
Edades
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
df1$Edad[3] <- 0
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
df[[3]]
#También podemos utilizar el nombre de la columna para acceder elementos del data frame
df$edad
df["edad"]
#Fila 1, columna 2 (nombre)
df[1, 2]
df$nombre[1]
df[1, "nombre"]

#Podemos crear una nueva columna facilmente
df1$NuevaColumna1 <- c("M", "M", "H", "H", NA)
df1
#Podemos anidar funciones
df1$NuevaColumna2 <- c(rep(c("M", "H"), each = 2),  "M")
df1
#Podemos incluir un solo valor para toda la columna
df1$NuevaColumna3 <- 100
df1

#Podemos hacer operaciones matematicas
df1$Identificacion*10
df1$ID <- df1$Identificacion*10
df1
df1$Identificacion/df1$ID
df1$resultado <- df1$Identificacion/df1$ID
df1

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

#Los factores pueden ser ordenados de acuerdo a un criterio que nosotros definamos
#Sin ordenar
mesNacimiento <- factor(c("abril", "enero", "septiembre", "enero", "julio"))
mesNacimiento
unclass(mesNacimiento)
levels(mesNacimiento)
#Ahora ordenados
mesNacimiento <- factor(c("abril", "enero", "septiembre", "enero", "julio"), 
                        levels = c("enero", "abril", "julio", "septiembre"), 
                        ordered = T)
mesNacimiento
levels(mesNacimiento)

#Ahora agregamos esta nueva columna a nuestra base de datos y creemos una tabla
df <- cbind(df, mesNacimiento)
df
table(df$mesNacimiento)

#Un factor puede contener mas niveles que los actualmente presentes
mesNacimiento <- factor(c("abril", "enero", "septiembre", "enero", "julio"), 
                        levels = c("enero", "febrero", "marzo", "abril", "mayo", "junio", 
                                   "julio", "agosto", "septiembre", "octubre", "noviembre",
                                   "diciembre"), ordered = T)
mesNacimiento

#Si reemplazamos al columna de nacimientos y producimos una tabla
df$mesNacimiento <- mesNacimiento
df
table(df$mesNacimiento)

#Podemos acceder y cambiar a un elemento de un factor como hemos visto anteriormente
levels(mesNacimiento)[10]
levels(mesNacimiento)[10] <- "Octubre"
levels(mesNacimiento)[10]

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


# Funciones ---------------------------------------------------------------
#Creando una funcion - Calculando el area de un rectangulo (Area = base*altura)
areaRectangulo <- function(base, altura){
  return(base*altura)}
class(areaRectangulo)

#Aplicando una funcion
areaRectangulo(15, 10)
AR <- areaRectangulo(15, 10)
AR

#Utilizando variables en vez de numeros
b <- 15
altura <- 10
areaRectangulo(b, altura)

base <- 15*20
areaRectangulo(base, altura)

#Creando una funcion con argumentos predefinidos 
#Area del circulo (Area = pi*radio^2)
areaCirculo2 <- function(r){
  pi*r^2
}
areaCirculo2(20, 3.14)

