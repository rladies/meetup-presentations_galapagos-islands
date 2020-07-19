#Taller: Aprende a programar en R - Parte 1: Tipos de datos
#Autor: Denisse Fierro Arcos, R-Ladies Galapagos
#Fecha: 2020-07-19
#Detalles: En este script veremos los diferentes tipos de datos que podemos manipular en R, así
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
