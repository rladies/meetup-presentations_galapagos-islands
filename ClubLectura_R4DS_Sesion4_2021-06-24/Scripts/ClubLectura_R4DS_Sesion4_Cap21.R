###########################################################################
#Club de Lectura:
#R para Ciencia de Datos (Wickham y Grolemund)
#R-Ladies Barranquilla, Galapagos, Guayaquil y Milagro
#
#Sesion 4: Capitulos 21 (Iteracion)
#Script por: Denisse Fierro Arcos (R-Ladies Galapagos)
###########################################################################

# Llamando bibliotecas ----------------------------------------------------
library(tidyverse)
library(palmerpenguins)


# Bucles for --------------------------------------------------------------
#Carguemos la base de datos de Palmer penguins
ping <- penguins
#Revisemos como se ve esta base de datos
glimpse(ping)

#Usemos un bucle para calcular el promedio de las medidas de picos, aletas y
#peso
#Primero creamos un vector vacio para guardar los resultados
promedios <- vector()

#Creamos nuestro bucle que estara basado en los nombres de las columnas de
#nuestro interes
for(i in names(ping[3:6])){
  #Guardamos los resultados en el vector vacio creado
  promedios <- append(promedios, mean(ping[[i]], na.rm = T))
}
#Veamos los resultados
promedios

#Otras funciones relevantes para bucles for
for(i in 1:ncol(ping)){
  print(i)
}

#Esta opcion da mucha flexibilidad al bucle porque las iteraciones
#dependeran del tamano del input
for(i in seq_along(ping)){
  print(i)
}

for(i in names(ping)){
  print(i)
}

#Utilizando bucles for para cambiar datos en variables existentes
#Asumamos que queremos estandarizar los datos morfometricos de los pinguinos
for(i in names(ping[3:6])){
  ping[i,] <- scale(ping[[i]])
}
ping

#Calculemos los promedios usando el bucle que creamos anteriormente
promedios <- vector()
for(i in names(ping[3:6])){
  #Guardamos los resultados en el vector vacio creado
  promedios <- append(promedios, mean(ping[[i]], na.rm = T))
}
#Veamos los resultados
promedios
#Los valores son mucho mas cercanos a cero. Nuestro bucle funciono.

#Es importante recalcar que podemos utilizar una lista para guardar
#resultados
medidas <- ping %>% 
  select(bill_length_mm:body_mass_g)

lista_promedios <- list()
for(i in seq_along(medidas)){
  #Guardamos los resultados en el vector vacio creado
  lista_promedios[[i]] <- mean(medidas[[i]], na.rm = T)
}
#Veamos los resultados
lista_promedios
#Podemos crear un vector
promedios1 <- unlist(lista_promedios)
#Comparemos con los resultados anteriores
promedios; promedios1


# Bucle while -------------------------------------------------------------
#El bucle while se evalua cuando una condicion se cumple
i <- 10
while(i > 5){
  i <- i-1
  print(i)
}

#Podemos mezclar varios bucles
for(i in 1:10){
  if(i %% 2 == 0){
    print(sprintf("%1.0f es un numero par", i))
    }else(print(sprintf("%1.0f es un numero impar", i)))}

#Equivalente
i <- 1
while(i <= 10){
  if(i %% 2 == 0){
    print(sprintf("%1.0f es un numero par", i))
  }else(print(sprintf("%1.0f es un numero impar", i)))
  i <- i+1
}


# Programacion funcional --------------------------------------------------
#Funciones Apply
#Accedamos a la base de datos de pinguinos
ping <- penguins
glimpse(ping)

#Calculemos el promedio de las columnas con medidas morfometricas con apply
prom <- apply(ping[,3:6], 2, mean, na.rm = T)
prom

#lapply nos ofrece una opcion equivalente, pero en vez de un vector, produce
#una lista
prom1 <- lapply(ping[,3:6], mean, na.rm = T)
prom1

#sapply es otra opcion, pero nos da como resultado un vector
prom2 <- sapply(ping[,3:6], mean, na.rm = T)

#Comparemos todos los resultados
prom2; unlist(prom1); prom


# Funciones map -----------------------------------------------------------
#Parte del paquete purrr que esta dentro del tidyverse
#Si queremos calcular los mismos promedios anteriores podemos utilizar las
#opciones de map
prom3 <- map_dbl(ping[,3:6], mean, na.rm = T)

#Tan podemos unirlo con otros paquetes del tidyverse
ping %>% 
  select(bill_length_mm:body_mass_g) %>% 
  map_dbl(mean, na.rm = T)

#Comparamos con los resultados anteriores
prom3; prom2; unlist(prom1); prom

#Que pasa si uso map_dbl con un vector no numerico?
map_dbl(ping, mean, na.rm = T)
#Simplemente no obtenemos resultados para columnas no numericas y una advertencia



