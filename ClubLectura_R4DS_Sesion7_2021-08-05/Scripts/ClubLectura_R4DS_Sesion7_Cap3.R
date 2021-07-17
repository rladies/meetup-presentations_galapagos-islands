###########################################################################
#Club de Lectura:
#R para Ciencia de Datos (Wickham y Grolemund)
#R-Ladies Barranquilla, Galapagos, Guayaquil y Milagro
#
#Sesion 7: Capitulo 3 (Visualizacion de datos)
#Script por: Denisse Fierro Arcos (R-Ladies Galapagos)
###########################################################################

# Llamando bibliotecas ----------------------------------------------------
library(tidyverse)
library(palmerpenguins)
library(magrittr)


# Cargando datos ----------------------------------------------------------
#Vamos a utilizar datos de rescates de animales por la Brigada de Bomberos
#de Londres. Mas informacion sobre estos datos aqui https://bit.ly/3kwK2OL 
rescates <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-29/animal_rescues.csv')

#Veamos la estructura de los datos
glimpse(rescates)


# Creando un grafico simple -----------------------------------------------
#Primero calculamos el numero total de rescates por anio
rescates %>% 
  count(cal_year) %>% 
  #Luego llamamos a ggplot, definimos las variables en los ejes X y Y
  ggplot(aes(x = cal_year, y = n))+
  #Finalmente definimos el tipo de geometria (grafico) que queremos
  geom_col()

  
#Esto es equivalente a:
#Realizar y guardar el conteo en una variable nueva
numeros_rescates <- rescates %>% 
  count(cal_year)

#Llamar a ggplot y definir los datos a ser usados
ggplot(data = numeros_rescates)+
  #Definir al tipo de grafico y los ejes
  geom_col(mapping = aes(x = cal_year, y = n))


# Cambiando las esteticas de un grafico -----------------------------------
#Esto incluye al color, forma y tamanio de un grafico
#Supongamos que al grafico anterior lo queremos colorear de acuerdo al tipo
#de animal rescatado
rescates %>% 
  #Anadimos el tipo de animal a nuestro calculo
  count(cal_year, animal_group_parent) %>% 
  #El eje X y Y siguen siendo los mismo, pero ahora agregamos la opcion fill
  #(llenado) para dar un color diferente dependiendo del animal rescatado
  ggplot(aes(x = cal_year, y = n, fill = animal_group_parent))+
  geom_col()


#Intentemos cambiar el tamanio de un punto en un grafico
#Cargamos la base de datos de pinguinos
pinguinos <- penguins
glimpse(pinguinos)

#Creamos un grafico sencillo
pinguinos %>% 
  #Nota que ahora tenemos la opcion size (tamanio) incluida en la estetica
  ggplot(aes(x = body_mass_g, y = bill_length_mm, size = species))+
  geom_point()

#Nota que podemos incluir varias esteticas en un mismo grafico
pinguinos %>% 
  #Nota que ahora tenemos la opcion size (tamanio) incluida en la estetica
  ggplot(aes(x = body_mass_g, y = bill_length_mm, size = body_mass_g, 
             color = species, shape = sex, alpha = bill_length_mm))+
  geom_point()

#Las esteticas tambien pueden ser incluidas bajo el tipo de grafico si no
#queremos que sean aplicadas de manera global
pinguinos %>% 
  #Nota que ahora tenemos la opcion size (tamanio) incluida en la estetica
  ggplot()+
  geom_point(aes(x = body_mass_g, y = bill_length_mm, size = body_mass_g, 
                 color = species, shape = sex, alpha = bill_length_mm))

#Podemos cambiar las esteticas de manera manual
pinguinos %>% 
  #Nota que ahora las esteticas van fuera de aes, esto es porque los estamos
  #estableciendo de manera manual
  ggplot()+
  geom_point(aes(x = body_mass_g, y = bill_length_mm), color = "red", shape = 0)

#Como recuerdo las opciones en una funcion
?geom_point


# Creando facetas (subgraficos) -------------------------------------------
#Supongamos que queremos volver a la base de datos de rescates, pero en vez
#de tener todos los animales en un solo grafico, los queremos separados
rescates %>% 
  count(cal_year, animal_group_parent) %>% 
  #Definimos los ejes primero
  ggplot(aes(x = cal_year, y =  n))+
  #Elegimos el tipo de grafico
  geom_col()+
  #Definimos las facetas - Nota que usamos ~ para definir "filas" ~ "columnas" 
  facet_wrap(~animal_group_parent)

#Podemos crear facetas basados en dos variables
pinguinos %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_point()+
  facet_grid(island~species)


# Objetos geometricos -----------------------------------------------------
#Volvamos a hacer el grafico del pico y peso de los pinguinos
pinguinos %>% 
  ggplot()+
  geom_point(aes(x = body_mass_g, y = bill_length_mm))

#Podemos graficar estos datos de otra manera para mostrar una tendencia
pinguinos %>% 
  ggplot()+
  geom_smooth(aes(x = body_mass_g, y = bill_length_mm))

#Podriamos mostrar las tendencias por especie
pinguinos %>% 
  ggplot()+
  geom_smooth(aes(x = body_mass_g, y = bill_length_mm, linetype = species))


# Varias geometrias en un grafico -----------------------------------------
pinguinos %>% 
  #Definimos los ejes de manera global
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  #Pero definimos las esteticas por cada tipo de grafico
  geom_smooth(aes(linetype = species, color = species))+
  geom_point(aes(color = species))


#Podemos tambien especificar datos diferentes para cada estetica
pinguinos %>% 
  #Definimos los ejes de manera global
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  #Pero definimos las esteticas por cada tipo de grafico
  geom_point(aes(color = species))+
  geom_smooth(data = filter(pinguinos, sex == "female"), color = "purple")+
  geom_smooth(data = filter(pinguinos, sex == "male"), color = "#029534", se = F)


# Graficos de barras ------------------------------------------------------
#Podemos utilizar los datos crudos sin ningun calculo previo para mostrar
#conteos
rescates %>% 
  ggplot(aes(x = cal_year))+
  geom_bar()

#Esto es equivalente a
rescates %>% 
  count(cal_year) %>% 
  ggplot(aes(x = cal_year, y = n))+
  #La opcion stat en este caso se refiere a una transformacion estadistica
  geom_bar(stat = "identity")

#Tambien podemos calcular proporciones directamente con ggplot
rescates %>% 
  ggplot(aes(x = cal_year, y = stat(prop)))+
  geom_bar()

#Verifiquemos resultados
rescates %>% 
  count(cal_year) %>% 
  mutate(prop = n/sum(n))


#Podemos hacer mas calculos estadisticos
pinguinos %>% 
  ggplot()+
  #Seleccionamos los ejes
  stat_summary(aes(x = species, y = body_mass_g),
               #Establecemos la funciones que vamos a utilizar
               fun.min = min,
               fun.max = max,
               fun = mean)


# Ajustes de posicion -----------------------------------------------------
#Haciendo calculos y cambiando esteticas
rescates %>% 
  ggplot(aes(x = cal_year))+
  geom_bar(aes(fill = animal_group_parent), col = "blue")

#Cambiando la posicion de las columnas
rescates %>% 
  filter(cal_year == 2020) %>% 
  ggplot()+
  geom_bar(aes(x = cal_year, fill = animal_group_parent), position = "dodge", colour = "grey")

#Regresemos al grafico de puntos de los pinguinos
pinguinos %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_point()

#Vemos que hay puntos que se solapan, si queremos verlos mejor, podemos hacer uso 
#de la opcion position = 'jitter' para dar un poco de ruido aletorio a cada punto
pinguinos %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_point(position = "jitter")

#O equivalente
pinguinos %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_jitter()


# Sistemas de coordenadas -------------------------------------------------
#Cambiando posicion de ejes
rescates %>% 
  ggplot(aes(x = cal_year))+
  geom_bar(aes(fill = animal_group_parent), col = "grey")+
  coord_flip()

#Mapas simples
#Buscamos a Ecuador en el mapa del mundo
map_data("world", region = "ecuador", exact = F) %>% 
  #Establecemos a longitud y latitud como ejes
  ggplot(aes(long, lat, group = group))+
  geom_polygon()

#Podemos mejorarlo especificando que es un mapa
map_data("world", region = "ecuador", exact = F) %>% 
  ggplot(aes(long, lat, group = group))+
  geom_polygon(fill = "#bce9b6", colour = "#9a979f")+
  #Esta opcion nos permite aplicar varias proyecciones
  coord_quickmap()

#Coordenadas polares
#Utiles si queremos hacer graficos de torta
rescates %>% 
  mutate(animal_group_parent = case_when(animal_group_parent == "cat" ~ "Cat",
                                         T ~ animal_group_parent)) %>% 
  ggplot(aes(x = animal_group_parent))+
  geom_bar(aes(fill = animal_group_parent), width = 1, show.legend = F)+
  theme(aspect.ratio = 1)+
  coord_polar()

#Comparemos con el grafico de barras
rescates %>% 
  mutate(animal_group_parent = case_when(animal_group_parent == "cat" ~ "Cat",
                                         T ~ animal_group_parent)) %>% 
  ggplot(aes(x = animal_group_parent))+
  geom_bar(aes(fill = animal_group_parent))

#Si queremos un grafico de torta
pinguinos %>% 
  ggplot()+
  #Podemos utilizar 1 como el eje x
  geom_bar(aes(x = factor(1), fill = species))+
  #Theta se refiere al eje que va a ser utilizado para dar el angulo del circulo
  coord_polar(theta = "y")
