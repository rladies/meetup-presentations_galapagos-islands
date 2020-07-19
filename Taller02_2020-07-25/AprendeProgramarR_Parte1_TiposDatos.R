#Taller: Aprende a programar en R - Parte 1: Tipos de datos
#Autor: Denisse Fierro Arcos, R-Ladies Galapagos
#Fecha: 2020-07-19



#Datos numéricos enteros
2
#Podemos realizar operaciones numéricas como una calculadora
2+5
2*5

#Asígnalos a una variable
x <- 2
y <- 5
#Mira su contenido llamando la variable
x
y

#Realiza operaciones numéricas
x+y
x*y

#Nota que estas operaciones no afectan el valor de las variables
x
y

#Realiza operaciones numéricas y guarda este resultado
z1 <- x+y
z2 <- x*y

#Nota que en la consola no aparecen los resultados de las operaciones guardadas en las variables
#Si quieres ver su contenido, llama a la variable
z1
z2

#También puedes hacer operaciones entre variables y números
z1-5

#Puedes cambiar el valor de una misma variable, asignandola al mismo nombre
z1
z1 <- z1-5
z1

R nos permite no solo utilizar números enteros, sino que también números decimales y complejos

#Números decimales
x <- 5/2
x
x+10

#Números complejos
y <- 3i+5
y
y*2

z1
class(z1)
x
class(x)
y
class(y)

z1 <- 2L
class(z1)

Valores numéricos especiales

z1/0

0/0