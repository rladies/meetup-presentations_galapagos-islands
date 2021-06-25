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
library(magrittr)


# Bucles for --------------------------------------------------------------
#Carguemos la base de datos de Palmer penguins
ping <- penguins
#Revisemos como se ve esta base de datos
glimpse(ping)

#Usemos un bucle para calcular el promedio de las medidas de picos, aletas y
#peso
#Primero creamos un vector vacio para guardar los resultados
promedios1 <- vector()

#Creamos nuestro bucle que estara basado en los nombres de las columnas de
#nuestro interes
for(i in names(ping[3:6])){
  #Guardamos los resultados en el vector vacio creado
  promedios1 <- append(promedios, mean(ping[[i]], na.rm = T))
}
#Veamos los resultados
promedios1

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
for(i in 3:6){
  print(scale(ping[,i]))
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

#Bucles con mas de una condicion
medidas <- medidas %>% drop_na()
for(i in 1:nrow(medidas)){
  if(medidas$bill_depth_mm[i] > 20 & medidas$body_mass_g[i] >= 3500){
    print(medidas[i,])
    }else(print("No"))
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

#Otra opcion es escoger todas columnas con numeros decimales
ping %>% 
  select_if(is.double) %>% 
  map_dbl(mean, na.rm = T)

#Comparamos con los resultados anteriores
prom3; prom2; unlist(prom1); prom

#Que pasa si uso map_dbl con un vector no numerico?
map_dbl(ping, mean, na.rm = T)
#Simplemente no obtenemos resultados para columnas no numericas y una advertencia


#Asumamos que quisieramos calcular un modelo lineal que nos permita establecer si 
#el largo de la aleta esta relacionada al peso de los pinguinos, pero queremos
#aplicar este modelo a cada especie de pinguino
modelos_especies <- ping %>% 
  #Dividimos nuestros datos de acuerdo a la especie
  split(.$species) %>% 
  #Aplicamos los modelos lineales a cada especie por separado
  map(~lm(flipper_length_mm ~ body_mass_g, data = .x))
#Recuerda que map siempre espera una lista y regresa una lista

#Veamos los resultados - utilizemos un for loop para automatizarlo
for(i in names(modelos_especies)){
  print(i)
  print(summary(modelos_especies[[i]]))
}

#O incluso mejor, utilizamos map
modelos_especies %>% 
  map(summary) %>% 
  #Podemos anadir una linea mas y extraemos el r^2 que nos da la correlacion entre
  #variables
  map_dbl("r.squared") #equivalente a map_dbl(~.x$r.squared)


#Esto seria equivalente a utilizar el siguiente codigo por cada especie
ping %>% 
  filter(species == "Adelie") %$% 
  lm(body_mass_g ~ flipper_length_mm) %>% 
  summary


# Lidiando con errores ----------------------------------------------------
#Funcion safely - Utilicemosla en conjunto con la raiz cuadrada
raizCuadrada <- safely(sqrt)

#Aplicamos la funcion a una lista de numeros
raizCuadrada(10)
#Tenemos el resultado mas una lista de errores que en este caso esta vacia

#Si la aplicamos a caracteres
raizCuadrada("10")
#Tenemos un resultado que esta vacia y una explicacion del error en la operacion

glimpse(raizCuadrada("10"))

#Podemos usar safely con las funciones map
miLista <- list(1:3, 4, "x")
miLista %>% 
  map(raizCuadrada)
#El codigo se evalua y nos indica donde hubo errores

#Comparemos al resultado sin safely
miLista %>% 
  map(sqrt)
#No es muy conveniente porque simplemente obtenemos una falla

#Pero podemos mejorar un poco como se muestran los errores
resultados <- miLista %>% 
  map(raizCuadrada) %>% 
  #Asi mostramos a los resultados primero y luego los errores
  transpose()

#Identificamos donde no existen errores - errores = NULL
no_errores <- resultados$error %>% 
  map_lgl(is_null)

#Mostramos los elementos de la lista donde no fueron detectados errores
resultados$result[no_errores] %>% 
  flatten_dbl()

#Otras funciones relevantes incluyen possibly y quietly - Comparemos
#Safely
miLista %>% 
  map(safely(sqrt))

#Possibly
miLista %>% 
  #Con possibly tenemos que incluir el error a ser mostrado
  map(possibly(sqrt, "no es un numero"))

#Quietly - no captura errores, pero si advertencias
list(1, -1) %>% 
  map(quietly(sqrt)) %>%
  transpose()



# Multiples argumentos con map --------------------------------------------
#Supongamos que volvemos a la regresion lineal
grupos <- ping %>% 
  split(.$species)
  
resultados <- grupos %>% 
  map(~lm(body_mass_g ~ flipper_length_mm, data = .))

#Que pasa si quiero obtener predicciones, utilizo los resultados de la regresion
#y los aplico a cada grupo
predicciones <- map2(resultados, grupos, predict)
predicciones

#Esto es equivalente a
seq_along(resultados) %>% 
  map(~predict(resultados[[.x]], grupos[[.x]]))

#O equivalente a repetir la siguiente linea de codigo por cada grupo
predict(resultados$Gentoo, grupos$Gentoo)

#O en un for loop
for(i in seq_along(grupos)){
  print(names(grupos)[i])
  print(predict(resultados[[i]], grupos[[i]]))
}

#Si tenemos mas de dos argumentos, entonces usamos pmap
df <- data.frame(
  x = c("manzana", "banana", "cereza"),
  pattern = c("m", "n", "z"),
  replacement = c("M", "N", "Z"),
  stringsAsFactors = FALSE
)
pmap(df, gsub) %>% flatten_chr()
#En este caso, gsub usa tres argumentos, por lo que usamos pmap

#Esto equivale a
for(i in 1:nrow(df)){
  print(gsub(df$pattern[i], df$replacement[i], df$x[i]))
}
  
  
# Aplicando distintas funciones a distintos datos -------------------------
#Asumamos que queremos obtener el promedio del largo del pico, la mediana de la
#aleta y el maximo del peso
#Creamos una lista con los datos de interes
datos_morfo <- list(list(x = ping$bill_length_mm, na.rm = T),
                    list(x = ping$flipper_length_mm, na.rm = T),
                    list(x = ping$body_mass_g, na.rm = T))

#Luego creamos un vector o lista con las funciones de interes
func <- list(mean, median, max)
#Es necesario que la lista contenga el numero mismo de elementos que argumentos
#necesarios para llevar a cabo la operacion

#Aplicamos la operacion
invoke_map(func, datos_morfo)

#Comparemos con la opcion manual
mean(ping$bill_length_mm, na.rm = T)
median(ping$flipper_length_mm, na.rm = T)
max(ping$body_mass_g, na.rm = T)


#Alternativamente podemos crear una sola tribble
datos_morfo2 <- tribble(~func, ~datos,
                        mean, list(x = ping$bill_length_mm, na.rm = T),
                        median, list(x = ping$flipper_length_mm, na.rm = T),
                        max, list(x = ping$body_mass_g, na.rm = T))

#Dentro del tribble creamos una nueva columna donde guardaremos los resultados
#de las operaciones
datos_morfo2 %>% 
  mutate(datos_morfo = invoke_map(func, datos)) %>% 
  #Seleccionamos la columna que acabamos de crear
  select(datos_morfo) %>% 
  #Extraemos la informacion de la lista para mostrarla como un vector
  flatten() %>% 
  flatten_dbl()


# Funcion Walk ------------------------------------------------------------
#Creemos una figura de puntos para cada especie de pinguinos
fig <- ping %>% 
  split(.$species) %>% 
  map(~ggplot(.x, aes(bill_length_mm, body_mass_g, col = sex)) + geom_point()+
        theme_bw()+
        labs(x = "Largo del pico (mm)", y = "Peso del animal (g)"))

#Creemos los nombres de la figura con la extension pdf
nombres <- str_c(names(fig), ".pdf")

#Guardemos las figuras en la carpeta Figuras
pwalk(list(nombres, fig), ggsave, path = "ClubLectura_R4DS_Sesion4_2021-06-24/Figuras/", height = 8.9)


# Otras funciones utiles --------------------------------------------------
#Keep mantiene las columnas que cumplen una condicion
ping %>% 
  keep(is.double)

#Equivalente
ping %>% 
  select_if(is.double)

#Discard descarta las columnas que cumplen una condicion
ping %>% 
  discard(is.integer)

#Some determinan si algunos elementos cumplen una condicion
ping %>% 
  flatten() %>% 
  some(is.double)

#Every verifica si todos los elementos cumplen una condicion
ping %>% 
  flatten() %>% 
  every(is.double)


#Reduciendo listas basadas en elementos comunes
#Creemos un identificador unico
ping2 <- ping %>% 
  rowid_to_column("id") %>% 
  unite("id", species, id)

#Creamos una lista con el identificador unico y unas columnas adicionales
df <- list(isla = tibble(id = ping2$id, isla = ping$island),
           sexo = tibble(id = ping2$id, sexo = ping$sex),
           peso = tibble(id = ping2$id, peso = ping$body_mass_g))
df

#Creemos un solo data frame con los datos por cada identificador unico unificados
df <- df %>% 
  reduce(full_join)
df


#Si queremos encontrar los pesos que se repiten entre hembras y machos
pesos_comunes <- list(peso_hembras = ping$body_mass_g[ping$sex == "female"],
                      peso_machos = ping$body_mass_g[ping$sex == "male"])
#Encontremos los pesos comunes
pesos_comunes %>% 
  reduce(intersect)

