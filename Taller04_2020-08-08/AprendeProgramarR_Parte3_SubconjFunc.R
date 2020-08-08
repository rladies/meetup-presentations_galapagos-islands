#Taller: Aprende a programar en R - Parte 3: Subconjuntos y funciones
#Autor: Denisse Fierro Arcos, R-Ladies Galapagos
#Fecha: 2020-08-07
#Detalles: En este script veremos como acceder a subconjuntos de datos y continuamos
#con las funciones


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

#Veamos su estructura
str(df)
#Tambien podemos ver solo el nombre de las columnas
colnames(df)

#Veamos la primera fila de este data frame
df[1,]

#Ahora veamos columnas - Todas estas opciones son equivalentes
head(df[,7], n = 10)
head(df[,"equipo_1"])
head(df[[7]])
head(df[["equipo_1"]])
head(df$equipo_1)

#Puedo acceder a elementos especificos - Todo esto es equivalente
df[1,7]
df[1,"equipo_1"]
df[[7]][1]
df[["equipo_1"]][1]
df$equipo_1[1]

#Tambien puedo utilizar rangos o secuencias
df$equipo_1[c(1:2, 8, seq(10, 100, by = 20))]
#Si quiero saber las 10 ultimas observaciones
df$equipo_1[(nrow(df)-10):nrow(df)]


# Subconjuntos utilizando comparadores relacionales -----------------------
#Queremos acceder a datos para partidos desde el 2014 en adelante
df$anio >= 2014
#Pero si quiero saber exactamente que filas cumplen este requisito agrego which()
which(df$anio >= 2014)
#Puedo utilizar este resultado como listado de las filas que quiero ver
head(df[which(df$anio >= 2014),])
head(df[df$anio >= 2014,])

#Si quiero solo los elementos de ciertas columnas, simplemente agrego las columnas
#que me interesan
#Por ejemplo, quiero saber los equipos que se enfrentaron (equipo_1 y equipo_2) en el
#mundial celebrado en Inglaterra
df$anfitrion == "Inglaterra"
df$equipo_1
df[df$anfitrion == "Inglaterra", c("equipo_1", "equipo_2")]
df[which(df$anfitrion == "Inglaterra"), 7:8]


# Subconjuntos con operadores logicos -------------------------------------
#Queremos acceder a los partidos en los que participo Ecuador desde el 2010

#Dividamos esto por partes
#Primero accedemos a los partidos despues del 2010
df$anio > 2010
df$anio >= 2011
head(df[df$anio > 2010,])

#Como identificamos los partidos donde jugo Ecuador
df$equipo_1 == "Ecuador"
df[df$equipo_1 == "Ecuador",]
df$equipo_2 == "Ecuador"
df[df$equipo_2 == "Ecuador",]

#Ahora unimos, Ecuador debe aparecer en equipo_1 o en equipo_2
df$equipo_1 == "Ecuador" | df$equipo_2 == "Ecuador"
df[df$equipo_1 == "Ecuador" | df$equipo_2 == "Ecuador",]

#Finalmente agregamos el anio
df$equipo_1 == "Ecuador" | df$equipo_2 == "Ecuador" & df$anio > 2010
df[df$anio > 2010 & (df$equipo_1 == "Ecuador" | df$equipo_2 == "Ecuador"),]


# Funciones ---------------------------------------------------------------
#Creando una funcion con argumentos predefinidos 
#Area del circulo (Area = pi*radio^2)
areaCirculo2 <- function(radio, p = pi){
  p*radio^2
}
areaCirculo2(20)
areaCirculo2(20, 3.14)


IMC <- function(w, h){
  imc <- w/h^2
  return(imc)
}

IMC(70, 1.70)

# Estructuras de control  -------------------------------------------------
#If, else (Si, de otra manera)
#Por ejemplo, queremos utilizar la clasificacion muy bueno, bueno y malo a los
#equipos de futbol basados en el numero de veces que han jugado en un mundial
#Definimos que malo es un equipo que solo aparece tres veces o menos, bueno si aparece 
#hasta 15 veces y muy bueno si aparece mas de 15 veces

#Primero vamos a crear un nuevo data frame que contenga todos los partidos en los
#que ha jugado Ecuador. Podemos utilizar el codigo de arriba.
TotalPartidos <- df[df$equipo_1 == "Ecuador" | df$equipo_2 == "Ecuador",]

#Probemos nuestras condiciones
#Cuantas veces ha jugado Ecuador en un mundial?
nrow(TotalPartidos) #porque cada observacion o fila representa un partido
#Malo si aparece 3 veces
nrow(TotalPartidos) <= 3
#Bueno si aparece mas de 3 veces y hasta 15 veces
nrow(TotalPartidos) > 3 & nrow(TotalPartidos) <= 15
#Muy bueno si aparece mas de 15 veces
nrow(TotalPartidos) > 15

#Ahora creemos la estructura si
if(nrow(TotalPartidos) <= 3){
  print("Malo")
}else if(nrow(TotalPartidos) > 3 & nrow(TotalPartidos) <= 15){
  print("Bueno")
# }else if(nrow(TotalPartidos) > 15){
#   print("Muy bueno")
# }
}else{
  print("Muy bueno")
}

#Probemos con otro pais
TotalPartidos <- df[df$equipo_1 == "Brasil" | df$equipo_2 == "Brasil",
                    c("anio", "ciudad")]
#Ahora vuelve a correr la estructura si de arriba

#Utilizando operadores logicos y relacionales en tidyverse
df %>% filter(equipo_1 == "Brasil") %>% 
  mutate(Class = case_when(equipo_1_final == 0 ~ "malo", 
                           equipo_1_final >= 1 & equipo_1_final <= 3 ~ "bueno", 
                           equipo_1_final > 3 ~ "muy bueno"))

