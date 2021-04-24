# Llamar a paquetes -------------------------------------------------------
library(tidyverse)
library(palmerpenguins)
library(magrittr)

# Asignar datos de pinguinos a una variable -------------------------------
ping <- penguins


# Revisar informacion -----------------------------------------------------
ping %>%
  glimpse()
#Equivalente en tidyverse
glimpse(ping)

#Equivalente en base R
str(ping)

# Seleccionando columnas --------------------------------------------------
#Opcion tidyverse con select()
ping %>% 
  select(species)
#Produce un data frame o tibble

#Opciones equivalentes en R base
ping$species
#Produce un vector
ping['species']
#Produce un data frame o tibble

#Seleccionando varias columnas - mencionando cada columna que nos interesa
ping %>% 
  select(c(bill_length_mm, bill_depth_mm, flipper_length_mm))


#Seleccionando columnas que contienen letras o palabras similares
ping %>% 
  select(contains("mm"))

#Similar al anterior, pero puede ser utilizado con expresiones regulares (regex)
ping %>% 
  select(matches("mm"))

#Seleccionando columnas cuyos nombres empezan (starts_with()) o terminan (ends_with()) con las
#mismas palabras o letras
ping %>% 
  select(starts_with("bill"))

ping %>% 
  select(ends_with("mm"))


# Seleccionando filas -----------------------------------------------------
#Selecciona la primera fila
ping %>% 
  slice(1)

ping %>% 
  slice(344)

#Selecciona la ultima fila - Recuerda que n() cuenta las filas en un data frame o tibble
ping %>% 
  slice(n())

#Opcion R base para seleccionar filas
ping[344,]

#Rangos de numeros pueden ser utilizados como argumentos en slice()
ping %>% 
  slice(10:15)

ping %>% 
  slice((n()-3):n())

ping %>% 
  slice(n()-3:n())

#Mostrando la primera fila en el data frame o tibble
ping %>% 
  slice_head()

#slice_tail() muestra la fila final. Al incluir el argumento n, podemos definir el numero
#exacto de filas que queremos ver
ping %>% 
  slice_tail(n = 4)

#slice_max() y slice_min() nos muestran la fila con el valor maximo o minimo de una columna.
#Con estas dos funciones es necesario incluir el nombre de la columna que sera utilizada para
#definir los valores maximos y minimos
ping %>% 
  slice_max(bill_length_mm)

#Noten que pueden utilizar el argumento n para definir el numero de filas que apareceran en el
#resultado
ping %>% 
  slice_min(bill_length_mm, n = 3)

#slice_sample() regresa filas escogidas de manera aleatoria. Puede utilizarse con el argumento
#n para especificar un numero especifico de filas, o el argumento prop que permite establecer el 
#numero de filas que se presentan como una proporcion del numero total de filas en el data frame
#o tibble
ping %>% 
  slice_sample(n = 10)

ping %>% 
  slice_sample(prop = 0.1)



# Operadores logicos ------------------------------------------------------
#Preguntando igualdad
"denisse" == "Denisse"
(5*2)+10 == 5

#Preguntando desigualdad
"denisse" != "Denisse"
(5*2)+10 != 5

#Preguntando si un numero es menor (<), mayor (>), menor o igual (<=), o mayor o igual (>=)
20 < 10
20 > 10
20 <= 10
20 >= 10


# Filtrando informacion ---------------------------------------------------
#Seleccionando filas basadas en una condicion
ping %>% 
  filter(species != 'Gentoo') %>%
  #Agrupando datos basados en la columna species
  group_by(species) %>%
  #Creando una tabla de resumen
  summarise(Numero = n())

#Seleccionando filas basados en dos o mas condiciones
ping %>% 
  filter(sex == "female" & species == "Adelie") %>% 
  group_by(species) %>%
  summarise(Numero = n())

#Revisando valores unicos en una columna
ping %>% 
  distinct(sex)

#Filtrando filas
ping %>% 
  filter(sex == 'female') %>% 
  #Seleccionando dos columnas
  select(c(species, bill_length_mm)) %>% 
  #Agrupando por la columna especies
  group_by(species) %>% 
  #Creando una tabla de resumen
  summarise(prom_pico_largo = mean(bill_length_mm, na.rm = T))

#Creando tabla de resumen con todas las filas
ping %>% 
  group_by(species, sex) %>% 
  summarise(N = n())

#Seleccionando filas de manera aleatoria
ping %>% 
  slice_sample(prop = 0.2) %>% 
  #Ordenando por la columna isla
  arrange(island)

#Creando una copia de pingu
ping2 <- ping

#El pipe %<>% permite cambiar el data frame o tibble 
#Noten que %>% no cambia el data frame o tibble original
ping2 %<>% 
  filter(sex == 'female') %>% 
  select(c(species, bill_length_mm)) %T>% 
  print() %>% 
  group_by(species) %>% 
  summarise(prom_pico_largo = mean(bill_length_mm, na.rm = T)) 

#La opcion de arriba es equivalente a lo siguiente
ping2 <- ping

ping2 <- ping2 %>% 
  filter(sex == 'female') %>% 
  select(c(species, bill_length_mm)) %T>% 
  print() %>% 
  group_by(species) %>% 
  summarise(prom_pico_largo = mean(bill_length_mm, na.rm = T)) 

#O equivalente a 
ping2 <- ping

ping2 %>% 
  filter(sex == 'female') %>% 
  select(c(species, bill_length_mm)) %T>% 
  print() %>% 
  group_by(species) %>% 
  summarise(prom_pico_largo = mean(bill_length_mm, na.rm = T)) -> ping2

#Removiendo columnas con valores NA con drop_na()
ping %>% 
  #El pipe %$% permite seleccionar columnas especificas en vez de el data frame o tibble entero
  drop_na(bill_length_mm) %$% 
  #La funcion cor() solo acepta columnas, no data frames
  cor(bill_length_mm, bill_depth_mm)

#Esto producira un error
ping %>% 
  drop_na(bill_length_mm) %>% 
  cor(bill_length_mm, bill_depth_mm)

#Llamando a filas de manera aleatoria (10% de todas las filas en ping)
ping %>% 
  slice_sample(prop = 0.01) %>% 
  #Ordenando por isla de manera descendiente (desde la Z hasta la A) y de manera alfabetica por
  #especies
  arrange(desc(island), species)


# Visualizacion -----------------------------------------------------------
#Manipulando datos y produciendo graficos en un solo grupo de codigo (chunk)
ping %>% 
  #Filtramos filas de la especie Adelie
  filter(species == 'Adelie') %>% 
  #Sacamos filas que contengan valores NA en dos columnas especificas
  drop_na(body_mass_g, flipper_length_mm) %>% 
  #Cambiando a la columna anio de un entero a un factor
  mutate(year = as.factor(year)) %>% 
  #Creando grafico con ggplot - dentro de aes() definimos los ejes (x, y)
  ggplot(aes(x = body_mass_g, y = flipper_length_mm, 
             #Ademas definimos que los colores cambiaran de acuerdo a la isla
             col = island))+
  #Nota que ggplot() utiliza un + para anadir parametros
  #Ahora definimos el tipo de grafico (o geometria) que queremos mostrar
  geom_point() #En este caso utilizamos puntos

#Igual a arriba
ping %>% 
  filter(species == 'Adelie') %>%
  drop_na(body_mass_g, flipper_length_mm) %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm, col = sex))+
  geom_point()+
  #Esta opcion dos permite crear facetas o subgraficos dentro del grafico
  facet_grid(island~sex) #islas aparecen como filas y sexo como columnas

#Creamos una tabla de resumen con el numero de individuos por especie
ping %>% 
  group_by(species) %>% 
  summarise(N = n()) %T>% 
  #Nota que  %T>% nos permite dar un paso intermedio sin afectar el resultado final
  print() %>%  #Imprimimos la tabla de resumen y proseguimos con el grafico
  ggplot(aes(x = species, y = N))+
  #Utilizamos barras. La opcion stat = "identity" significa que la variable en el eje Y
  #sera graficada de acuerdo al valor que contiene cada fila
  geom_bar(stat = "identity")

#Aqui no manipulamos el tibble o data frame
ping %>% 
  ggplot(aes(x = species, fill = species))+
  #Si stat no se define, el grafico de barra considera que cada fila tiene un valor de 1
  geom_bar()+
  #Utilizamos facetas para cada isla
  facet_grid(~ island)+
  #Cambiamos el tema (como se ve, color de fondo, letras, lineas, etc.) del grafico
  theme_dark()

#Guardando el ultimo grafico
ggsave("ArchivosSalida/MiPrimerGrafico.tiff", device = "tiff")
