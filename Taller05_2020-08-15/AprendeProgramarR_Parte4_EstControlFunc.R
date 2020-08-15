#Taller: Aprende a programar en R - Parte 4: Estructuras de control y funciones
#Autor: Denisse Fierro Arcos, R-Ladies Galapagos
#Fecha: 2020-08-08
#Detalles: En este script veremos estructuras de control: bucles (for, while) y 
#continuamos con funciones


# Bibliotecas -------------------------------------------------------------
#Llamamos a bibliotecas relevantes para este taller
library(tidyverse)

# Accediendo a subconjunto de datos ---------------------------------------
#Primero vamos a acceder a datos de Partidos de las Copas del Mundo de Fútbol
#(1930 a 2018) disponibles en Datos de Miercoles. Mas informacion aqui: 
#https://github.com/cienciadedatos/datos-de-miercoles/tree/master/datos/2019/2019-04-10

#Aqui le damos el vinculo donde los datos estan guardados y a traves de delim le 
#decimos que el delimitador utilizado en esta base de datos en un tab
df <- read_delim("https://bit.ly/31wcrt9", delim = "\t") %>% 
  #Aqui especificamos que queremos que sea guardado como un data frame
  data.frame()

# Subconjuntos de datos utilizando subset() -------------------------------
#Queremos acceder a los partidos en los que participo Brasil desde el 2010
#Ademas, solo estamos interesados en acceder las siguientes columnas: anio,
#anfitrion, estadio, ciudad, fecha, equipo_1 y equipo_2
TotalPartidos <- subset(df, subset = anio >= 2010 & 
                          (equipo_1 == "Brasil" | equipo_2 == "Brasil"), 
       select = c(anio:ciudad, fecha:equipo_2))

# Estructuras de control  -------------------------------------------------


# If, else (Si, de otra manera) -------------------------------------------
#Queremos utilizar la clasificacion muy bueno, bueno y malo a los
#equipos de futbol basados en el numero de veces que han jugado en un mundial
#Definimos que malo es un equipo que solo aparece tres veces o menos, bueno si aparece 
#hasta 15 veces y muy bueno si aparece mas de 15 veces
if(nrow(TotalPartidos) <= 3){
  print("Malo")
}else if(nrow(TotalPartidos) > 3 & nrow(TotalPartidos) <= 15){
  print("Bueno")
}else{
  print("Muy bueno")
}

#Aplicando if else en vectores
if(df$equipo_1_final == 0){
  print("Malo")
}else if(df$equipo_1_final !=0){
  print("Bueno")
}
#No nos da el resultado esperado

#Podemos intentar utilizar ifelse()
ifelse(test = df$equipo_1_final == 0, yes = "Malo", no = "Bueno")



# Bucles con For ----------------------------------------------------------
#Ejemplo simple
Vec <- c(1:10)
Vec
length(Vec)

#Para programar nuestro bucle necesitamos un contador, lo llamaremos i
for(i in Vec){
  print(i)
}

for(i in 1:10){
  print(i)
}

for(i in 1:length(Vec)){
  print(i)
}

#Podemos agregar mas operaciones
for(i in Vec){
  j <- i*2
  print(j)
}

#Puedo guardar los resultados en un vector
#Creemos un vector vacio
NuevoVec <- vector()

#Ahora corramos el mismo bucle, pero con unos ligeros cambios
for(i in Vec){
  #El i provee el indice del elemento dentro del vector
  NuevoVec[i] <- i*2
}
NuevoVec

#Si queremos reemplazar una letra dentro de un palabra por otra letra o caracter
#Vamos a utilizar el data frame df para nuestro contador
for(i in 1:nrow(df)){
  #Miramos todas las filas dentro de la columna anfitrion y reeplazamos 'a' por '1'
  #Esto sera guardado en un vector llamado x
  x[i] <- stringr::str_replace_all(df$anfitrion[i], "a", "1")
}

#Podemos tambien hacer guardar resultados en un data frame
#Supongamos que queremos crear una columna llamada ID para identificar las filas
#de nuestro data frame TotalPartidos
for(i in 1:nrow(TotalPartidos)){
  TotalPartidos$ID[i] <- i
}
head(TotalPartidos)


# Bucles con while --------------------------------------------------------
#Queremos imprimir los equipos que se enfrenran en las 5 primeras filas de nuestro 
#data frame TotalPartidos

#Primero creamos un contador
i <- 10
#Ahora creamos nuestro bucle
while(i <= 50){
  print(df[i,c("equipo_1", 'equipo_2')])
  i <- i+10
}


# Bucles con break y next -------------------------------------------------
#Equivalente a lo que intentamos anteriormente
for(i in 3:length(TotalPartidos$anio)){
  if(i > 5){
    break
  } else{print(TotalPartidos[i,c("equipo_1", 'equipo_2')])
  }}

#Queremos correr un bucle si nuestro contador es mayor a 10, pero queremos pararlo 
#si es igual a 15
i <- nrow(TotalPartidos)
while(i > 10){
  print(TotalPartidos[i,])
  if(i == 15){
    break
  }
  print(TotalPartidos[i,])
  i <- i-1
}

#Queremos correr el bucle solo si el contador es un numero par
#Podemos identificar un numero par utilizando %%. Esto nos dara el resto de la division

#Por ej., el resto de 10 dividido para dos es 0. Esto se representa
500%%2
#Ahora revisemos el resto de 11/2
1071%%2
#Los numeros pares siempre tendran 0 como resto cuando son dividos para dos

#Ahora armemos el bucle
for(i in 1:length(TotalPartidos$anio)){
  #Si la condicion que es si el resto del numero divido para dos NO es cero, debemos
  #saltar este paso (next)
  if(i%%2 != 0){
    next
  }
  #Si la condicion no se cumple entonces la operacion abajo se realiza
  print(TotalPartidos[i,])
}

#Podemos juntar while y next Por ej, quiero imprimir las 5 primeras filas, pero
#solo si su ID es impar
for(i in TotalPartidos$ID){
  #Si el ID es par entonces seguir al siguiente paso
  if(i%%2 == 0){
    next
  }
  #Si el ID es mayor a 5 romper
  if(i > 5){
    break
  }
  #En cualquier otro caso imprimir
  print(TotalPartidos[i,])
}


# Bucles con repeat -------------------------------------------------------
#Si nuevamente queremos solamente mostrar el contenido de las cinco primeras filas de
#nuestro data frame
i <- 1
repeat{
  print(TotalPartidos[i,])
  i <- i+1
  if(i > 5){
    break
  }
}


# Funciones ---------------------------------------------------------------
#Queremos crear una funcion que nos permite escoger el equipo nacional y anios que
#queramos y nos dara como resultado el numero total de partidos jugados, asi como la
#proporcion de empates, partidos ganados y perdidos

#Primero dividamos el problema
#Como escogemos el equipo nacional - Practiquemos con Ecuador
df[df$equipo_1 == "Ecuador" | df$equipo_2 == "Ecuador",]

#Como escogemos los anios
df[df$anio == 2006,]
df[df$anio >= 2006 & df$anio <= 2010,]

#Practiquemos con el data frame Total Partidos
df[(df$anio == 2006) & (df$equipo_1 == "Ecuador" | df$equipo_2 == "Ecuador"),]

df[(df$anio >= 2006 & df$anio <= 2010) & 
     (df$equipo_1 == "Ecuador" | df$equipo_2 == "Ecuador"),]

#Identifiquemos que argumentos necesitamos hasta ahora para filtrar el data frame
#Equipo o pais
#Anio o anios de interes

prueba <- function(pais, anioInicio, anioFin){
  #Si tenemos todos los parametros solo tendriamo que seguir un paso
  x <- df[(df$anio >= anioInicio & df$anio <= anioFin) &
            (df$equipo_1 == pais | df$equipo_2 == pais),]
  return(x)
}

#Probemos
prueba("Ecuador", 2006, 2010)
prueba(anioInicio = 2002, pais = "Ecuador", anioFin = 2010)
prueba(2002, "Ecuador", 2010)


#Ahora debemos considerar que haremos si no nos dan un anio de fin
#Simplemente utilizamos un if junto con la funcion missing (revisa si un valor fue
#especificado como argumento de una funcion)
prueba2 <- function(pais, anioInicio, anioFin){
  #Si anioFin si ha sido especificada
  if(!missing(anioFin)){
  #El filtro de datos usa el anio de inicio y de fin
  x <- df[(df$anio >= anioInicio & df$anio <= anioFin) &
            (df$equipo_1 == pais | df$equipo_2 == pais),]
  #Si anioFin NO fue especificado
  } else if(missing(anioFin)){
    #Entonces filtramos desde anioInicio hasta el anio incluido en nuestro data frame
    x <- df[df$anio >= anioInicio & (df$equipo_1 == pais | df$equipo_2 == pais),] 
  }
  return(x)
}

#Probemos
prueba2("Ecuador", 2006)
prueba2("Ecuador", 2006, 2010)
prueba("Ecuador", 2006)

#Como podemos clasificar los partidos en empate, ganado o perdido
#Creemos un subconjunto de datos para probar
y <- df[1:30,]

#Partidos empatados son sencillos los resultados de ambos equipos son iguales
#Utilicemos un bucle for en conjunto con una estructura si
for(i in 1:nrow(y)){
  if(y$equipo_1_final[i] == y$equipo_2_final[i]){
    print("Empate")
    print(i)
}}

#Para partidos ganados o perdidos, primero debemos identificar si nuestro equipo fue
#incluido como equipo 1 o 2
#Utilizaremos una estructura similar a la de arriba
pais <- "Argentina"
for(i in 1:nrow(y)){
  #Si el equipo 1 es nuestro equipo de interes y si su resultado es mayor al del equipo
  #2 entonces el partido fue ganado
  if(y$equipo_1[i] == pais & (y$equipo_1_final[i] > y$equipo_2_final[i])){
    print("Ganado")
    print(i)
    #Lo mismo ocurre si nuestro equipo es el numero 2 y tiene puntaje mayor al 1
    }else if(y$equipo_2[i] == pais & (y$equipo_1_final[i] < y$equipo_2_final[i])){
      print("Ganado")
      print(i)
    }}

#Ahora unamos todo hasta ahora
prueba3 <- function(pais, anioInicio, anioFin){
  #Primero filtramos los datos relacionados al pais que nos interesa
  if(!missing(anioFin)){
    x <- df[(df$anio >= anioInicio & df$anio <= anioFin) &
              (df$equipo_1 == pais | df$equipo_2 == pais),]
  } else if(missing(anioFin)){
    x <- df[df$anio >= anioInicio & (df$equipo_1 == pais | df$equipo_2 == pais),] 
  }
  #Aplicamos el bucle for con las estructuras si para la clasificacion, y esta sera
  #guardada en una nueva columna clas
  for(i in 1:nrow(x)){
    #Si el equipo 1 es nuestro equipo de interes y si su resultado es mayor al del equipo
    #2 entonces el partido fue ganado
    if(x$equipo_1[i] == pais & (x$equipo_1_final[i] > x$equipo_2_final[i])){
      x$clas[i] <- "Ganado"
    #Lo mismo ocurre si nuestro equipo es el numero 2 y tiene puntaje mayor al 1
    }else if(x$equipo_2[i] == pais & (x$equipo_1_final[i] < x$equipo_2_final[i])){
      x$clas[i] <- "Ganado"
    #Nuestro equipo empata
    }else if(x$equipo_1_final[i] == x$equipo_2_final[i]){
        x$clas[i] <- "Empate"
    #En cualquier otro caso pierde
    }else{
      x$clas[i] <- "Perdido"
    }
  }
  return(x)
}

#Probemos
prueba3("Ecuador", 2006, 2010)
prueba3("Ecuador", 2006)

#Finalmente, como hacemos un resumen de esta informacion
#Podemos utilizar algo como ddply y summarise
#Probemos en el data frame TotalPartidos, utilizando la columna anfitrion para agrupar
#nuestros datos. Finalmente el resumen dara como resultado la longitud de la columna
#anfitrion que esta agrupada por pais

plyr::ddply(TotalPartidos, "anfitrion", summarise, N = length(anfitrion))

#Incluyamos esto en nuestra funcion
prueba4 <- function(pais, anioInicio, anioFin){
#Primero filtramos los datos relacionados al pais que nos interesa
if(!missing(anioFin)){
  x <- df[(df$anio >= anioInicio & df$anio <= anioFin) &
              (df$equipo_1 == pais | df$equipo_2 == pais),]
    #Guardemos el numero de partidos jugados
    NPartidos <- nrow(x)
    #Agregemos una linea adicional en la que revisemos si el pais esta incluido en esta
    #base de datos
    if(NPartidos == 0){
      print("Este pais no tiene partidos registrados en el Mundial de Futbol entre 1930 y 2018")
    } else {print(paste0(pais, " ha jugado ", NPartidos, " partidos entre el ", anioInicio, " y ", anioFin))}
  } else if(missing(anioFin)){
    x <- df[df$anio >= anioInicio & (df$equipo_1 == pais | df$equipo_2 == pais),]
    #Guardemos el numero de partidos jugados
    NPartidos <- nrow(x)
    if(NPartidos == 0){
      print("Este pais no tiene partidos registrados en el Mundial de Futbol entre 1930 y 2018")
    } else {print(paste0(pais, " ha jugado ", NPartidos, " partidos entre el ", anioInicio, " hasta el 2018"))}
  }
  #Aplicamos el bucle for con las estructuras si para la clasificacion, y esta sera
  #guardada en una nueva columna clas
  for(i in 1:nrow(x)){
    #Si el equipo 1 es nuestro equipo de interes y si su resultado es mayor al del equipo
    #2 entonces el partido fue ganado
    if(x$equipo_1[i] == pais & (x$equipo_1_final[i] > x$equipo_2_final[i])){
      x$clas[i] <- "Ganado"
      #Lo mismo ocurre si nuestro equipo es el numero 2 y tiene puntaje mayor al 1
    }else if(x$equipo_2[i] == pais & (x$equipo_1_final[i] < x$equipo_2_final[i])){
      x$clas[i] <- "Ganado"
      #En cualquier otro caso pierde
      #Nuestro equipo empata
    }else if(x$equipo_1_final[i] == x$equipo_2_final[i]){
      x$clas[i] <- "Empate"
    }else{
      x$clas[i] <- "Perdido"
    }}
  #Aqui vamos a considerar el data frame x, solo la columa Clas y vamos a crear un resumen de estos datos que van a ser guardados en una columna llamada Porcentajes
  #donde vamos a considerar el largo por cada factor dentro de Clas (Ganado, Perdido, Empate) y lo dividimos para el numero de filas total de x y mutiplicamos por 100.
  #Finalmente vamos a redondear este valor utilizando round
  y <- plyr::ddply(x, "clas", summarise, Porcentajes = round(length(clas)/nrow(x)*100, 2))
  return(y)
}  

#Probemos
prueba4("Francia", 2006, 2010)
prueba4("Ecuador", 2006)
#Verifiquemos con resultados anteriores
prueba3("Francia", 2006, 2010)
prueba3("Ecuador", 2006)

#Probemos con otros paises y fechas
prueba4("Peru", 2000)
#Comprobemos nuestra base
unique(c(df$equipo_1, df$equipo_2))
#Peru lleva tilde, asi que ahora si funciona 
prueba4("Perú", 2000)
