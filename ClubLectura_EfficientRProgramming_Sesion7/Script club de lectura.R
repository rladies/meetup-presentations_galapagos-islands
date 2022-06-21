#                 ---- Programacion eficiente de datos ----
#"Efficient R programming", de Colin Gillespie y Robin Lovelace.
#Conferencistas: Denisse Fierro Arcos y Danisse Carrascal Polo


#Paquetes necesarios:
#install.packages("dslabs")
library(dplyr)
library(dslabs)

#Procesamiento eficiente de datos con dplyr----
#Revisamos el dataset que vamos a utilizar
?starwars #En la ventana de help se nos mostrara la informacion de la base de datos


#Revisamos la estructura de nuestros datos
str(starwars) #Esta opcion es más compleja visualmente 
glimpse(starwars) #glimpse() nos muestra un resumen más ordenado y amable a la vista

#Tomamos un pequeño conjunto de datos de 10 observaciones y 8 variables
db<-starwars[1:10,1:8]
db

# rename()----
#Nos sirve para cambiar el nombre de las columnas. 
#La estructura es: Nombre nuevo = Nombre original. 
#El nombre original se puede colocar entre ``, entre "" y sin nada
db = rename(db, personajes = name)
db

#Para renombrar mas de una, se separan por comas. 
db=rename(db, altura = height, masa = mass)
db

#Si queremos que en lugar de los nombres originales, las variables sean X1, X2, X3, etc.:
db<-rename(db, X = names(db))
db

# mutate() ----
#Nos ayuda a cambiar las clases de nuestros datos y a crear nuevas columnas a partir
#de las ya existentes

#Para cambiar clase
#Opcion 1
db <- mutate(db, altura = as.numeric(altura))
glimpse(db)

#Opcion 2
cols_to_change = 2:3 
db = mutate_at(db, vars(cols_to_change), as.integer)
#mutate_at() me pide que conjunto de datos quiero editar, las columnas que quiero
#cambiar, y el formato al que los quiero transformar. En este caso podemos modificar
#la clase de la masa porque no posee decimales

#Nota: vea ?mutate y ?mutate_at para obtener mas informacion y ver las posibles 
#opciones


#Opcion 3 db[cols_to_change] = data.matrix(db[cols_to_change])
data.matrix(db[cols_to_change])

#Para crear una nueva columna
#El primer argumento sera el conjunto de datos y luego el nombre de la nueva columna
#igualado a la funcion o formula que queremos calcular
db<-mutate(db, masa2 = masa/2)
db


# filter() ----
#Nos muestra las filas que cumplen con una determinada condición

#Opcion 1
#En esta ocasion queremos saber que personajes miden menos de un metro.
#Asignamos esa informacion a un nuevo dataset
db2 = filter(db, altura<100);db2

#Opcion 2
#Al usar el operador pipe despues de llamar nuestro dataset, ya no 
#tenemos que poner el nombre de este como primer argumento en la funcion. 

#En este caso, utilizamos operadores logicos puesto que tenemos mas de una condicion
db %>%
  filter(altura >= 150 & masa > 70)


# Chaining operations ----
#El operador pipe nos ayuda a conectar distintas funciones y operaciones para un mismo 
#conjunto de datos.Las operaciones se ejecutaran en el orden en que estes escritas.

#Aquí queremos calcular el imc promedio de los personajes femeninos y masculinos, 
#para ello seleccionamos las variables de interes, excluimos a los droides, realizamos 
#la opeacion, agrupamos por sexo y calculamos el promedio

db %>% 
  select(sex, altura, masa) %>% 
  filter(sex != "none") %>% 
  mutate(imc = masa/((altura/100)^2)) %>% 
  group_by(sex) %>%
  summarise(mean(imc, na.rm = T))


# Data agregation ----
#La agregación de datos consiste en crear resúmenes de datos basados en una 
#variable de agrupacion, en un proceso que se ha denominado "dividir-aplicar-combinar". 

#Un ejemplo sencillo de ello es dividir las observaciones por sexo, calcular el 
#promedio y realizar un resumen de los resultados.
group_by(db, sex) %>% 
  summarise(mean(altura))


# Combinando datasets ----

data(murders) #Asesinatos a bala en los EEUU en 2010
data(polls_us_election_2016) #Resultados de las elecciones presidenciales EEUU 2016

tabla <- left_join(murders, results_us_election_2016, by = "state")
View(tabla)
#Vemos que ahora tenemos 9 variables y la informacion agrupada por estados. Por lo que
#podriamos hacer un analisis de las regiones y sus resultados

tabla %>% 
  select(region, electoral_votes, clinton, trump) %>% 
  group_by(region) %>% 
  summarise(mean(clinton), mean(trump), mean(electoral_votes))

#¿que analisis harias tu?
#Libro recomendado: Introducción a la Ciencia de Datos 
#https://rafalab.github.io/dslibro/