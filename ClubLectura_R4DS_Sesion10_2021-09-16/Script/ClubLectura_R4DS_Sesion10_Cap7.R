###########################################################################
#Club de Lectura:
#R para Ciencia de Datos (Wickham y Grolemund)
#R-Ladies Barranquilla, Galapagos, Guayaquil y Milagro
#
#Sesion 10: Capitulo 7 (Analisis exploratorio de datos - EDA en ingles)
#Script por: Denisse Fierro Arcos (R-Ladies Galapagos)
###########################################################################


# Llamando bibliotecas ----------------------------------------------------
library(tidyverse)
library(palmerpenguins)


# Cargando datos ----------------------------------------------------------
ping <- penguins
#Veamos nuestros datos
glimpse(ping)

#Pensemos en que preguntas podremos responder con nuestros datos


# Visualizacion de datos --------------------------------------------------

#Variables categoricas - Conteo de pinguinos por especie
ping %>% 
  ggplot(aes(x = species))+
  geom_bar()

#Si quisieramos ver estos valores en una tabla
ping %>% 
  count(species)

#Variable continua - largo del pico
ping %>% 
  ggplot(aes(x = bill_length_mm))+
  geom_histogram()

#Podemos variar el grosor de las barras del histograma
ping %>% 
  ggplot(aes(x = bill_length_mm))+
  geom_histogram(binwidth = 5)

#Podemos crear una tabla con los valores utilizados en
#el histograma
ping %>% 
  count(cut_width(bill_length_mm, width = 5))

#Viendo la distribucion de datos podemos definir grupos
#Usando el largo del pico podemos decir que los pinguinos
#con un pico de <45mm tienen pico pequenio y si es >=45mm
#tienen picos grandes
pico_peq <- ping %>% 
  filter(bill_length_mm <45)

#Veamos el resultado
glimpse(pico_peq)

#Visualicemos los datos
pico_peq %>% 
  ggplot(aes(x = bill_length_mm))+
  geom_histogram()
#De esta manera vemos mas detalles por grupo


#Siguiendo el ejemplo de los picos, si quisieramos comparar
#especies en una misma grafica, podemos hacerlo con otra
#geometria
pico_peq %>% 
  ggplot(aes(x = bill_length_mm, color = species))+
  geom_freqpoly(binwidth = 0.5)

#Podemos aplicar lo mismo a todos los datos
ping %>% 
  ggplot(aes(x = bill_length_mm, color = species))+
  geom_freqpoly(binwidth = 0.5)
#De esta manera vemos que lo mas apropriado es agrupar
#los datos del pico por especie en vez de crear una
#nueva categoria

#Con esta informacion adicional, se te ocurren otras preguntas?


# Variabilidad de los datos -----------------------------------------------
#Veamos nuevamente los histogramas con la informacion de picos
ping %>% 
  ggplot(aes(x = bill_length_mm))+
  geom_histogram(binwidth = 0.5)

#Que observamos aqui? Que patrones vemos? Que valores son mas comunes?
#Que preguntas adicionales surgen?

#Si incluimos mas informacion en nuestro grafico, cambian los patrones?
#Cambian nuestras conclusiones?
ping %>% 
  ggplot(aes(x = bill_length_mm, fill = species))+
  geom_histogram(binwidth = 0.5, position = "dodge2")

#Estos datos no contienen valores atipicos, pero incluyo un ejemplo
#Veamos datos de starwars que son parte del tidyverse
starwars %>% 
  ggplot(aes(x = mass))+
  geom_histogram()

#Podemos ampliar hacer zoom en el area donde se encuentra el valor
#atipico
starwars %>% 
  ggplot(aes(x = mass))+
  geom_histogram()+
  coord_cartesian(ylim = c(0, 5))

#Podemos crear una tabla con los valores
starwars %>% 
  count(cut_width(mass, 25))
#Que hacemos con los valores aberrantes?
#Depende: es posible un valor asi? es posible que sea un error?
#existen mas medidas para esa observacion?

#Volvamos a los pinguinos
#Veamos nuevamente los histogramas con la informacion de picos
ping %>% 
  ggplot(aes(x = bill_length_mm))+
  geom_histogram(binwidth = 0.5)
#Noten la advertencia que R nos da al crear el histograma
#Por que ocurre esto?

#Se debe a los valores NA
ping %>% 
  filter(is.na(bill_length_mm))
#Tenemos dos en nuestros datos

#Podemos borrar estas observaciones, o
#podemos simplmente excluirlas de nuestros datos
ping %>% 
  ggplot(aes(x = bill_length_mm))+
  geom_histogram(binwidth = 0.5, na.rm = T)

#Esto es equivalente a
ping %>% 
  drop_na(bill_length_mm) %>% 
  ggplot(aes(x = bill_length_mm))+
  geom_histogram(binwidth = 0.5)


# Covariacion -------------------------------------------------------------
#Existen variables que varian simultaneamente
#Vimos un ejemplo antes
ping %>% 
  ggplot(aes(x = bill_length_mm, fill = species))+
  geom_histogram(binwidth = 0.5, na.rm = T, position = "dodge")
#Los pinguinos Adelie tienen picos mas pequenios que los gentoo y chinstrap

#por que ocurre esto? tiene relacion al tamanio del animal?
#Exploremos los datos del peso
ping %>% 
  ggplot(aes(x = body_mass_g, fill = species))+
  geom_histogram(na.rm = T, position = "dodge")
#Que patrones vemos aqui?

#Otra forma de ver la distribucion de datos es el grafico de cajas
ping %>% 
  ggplot(aes(y = body_mass_g, x = species))+
  geom_boxplot(na.rm = T)

#Podemos reordenar las cajas para que la especie con el promedio de masa
#mas alto aparezca primero
ping %>% 
  ggplot(aes(y = body_mass_g, 
             x = fct_reorder(species, body_mass_g, .fun = median, 
                             na.rm = T, .desc = T)))+
  geom_boxplot(na.rm = T)


#Comparando dos variables categoricas
#Sexo por especies
ping %>% 
  ggplot(aes(x = species, y = sex))+
  geom_count()

#Especie por isla
ping %>% 
  count(species, island) %>% 
  ggplot(aes(x = species, y = island))+
  geom_tile(aes(fill = n))


#Comparando dos variables continuas
#Que pasa si comparamos el peso con el largo del pico?
ping %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_point()
#Al parecer los pinguinos mas pequenios tienen picos mas pequenios

#Podemos mostrar los mismos datos de otra manera
#Creamos pequenio cuadros en nuesrto grafico y el color variara
#de acuerdo a la cantidad de observaciones en cada cuadro
ping %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_bin2d()
#De esta manera podemos ver que combinaciones de peso y largo de
#pico son mas comunes

#Podemos crear graficos de cajas si transformamos una variable
#continua en categorica
#Podemos crear grupos de acuerdo al peso, por ejemplo
ping %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  #Definimos los grupos por la masa, cada 500 g
  geom_boxplot(aes(group = cut_width(body_mass_g, 500)))

#Si queremos tener una idea de la cantidad de datos incluidos en
#cada grupo podemos usar el parametro varwidth = TRUE en geom_boxplot
ping %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  #Definimos los grupos por la masa, cada 500 g
  geom_boxplot(aes(group = cut_width(body_mass_g, 500)), 
               varwidth = T)


# Identificando patrones --------------------------------------------------
#Veamos la relacion entre masa y pico
ping %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_point(na.rm = T)
#Que podemos decir? Que correlaciones pueden existir?

#Como sabemos que existe un correlacion significativa?
#Usemos una regresion linear simple
modelo <- lm(bill_length_mm ~ body_mass_g, data = ping)
summary(modelo)
plot(modelo)


#Agreguemos informacion sobre especies
ping %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_point(aes(col = species), na.rm = T)
#Que patrones podemos observar? Esta el peso relacionado al tamanio 
#del pico?

#Verifiquemos si nuestro nuevo modelo es mejor
modelo2 <- lm(bill_length_mm ~ body_mass_g+species, data = ping)
summary(modelo2)
plot(modelo2)


