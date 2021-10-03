###########################################################################
#R aplicado al analisis de datos ecologicos
#Taller del R Weekend de la Sociedad Ecuatoriana de Estadistica
#Script por: Denisse Fierro Arcos (R-Ladies Galapagos)
###########################################################################


# Llamando bibliotecas ----------------------------------------------------
library(tidyverse)
library(palmerpenguins)
library(corrplot)
library(RColorBrewer)
library(tidymodels)

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
#tienen picos grandes. Pero antes de hacer cambios, veamos
#si las especies tienen algun tipo de efecto
ping %>% 
  ggplot(aes(x = bill_length_mm, fill = species))+
  geom_histogram(binwidth = 0.5, position = "dodge2")

#Otra manera de presentar la misma informacion es con lineas
#en vez de barras
ping %>% 
  ggplot(aes(x = bill_length_mm, color = species))+
  geom_freqpoly(binwidth = 0.5)
#De esta manera vemos que lo mas apropriado es agrupar
#los datos del pico por especie en vez de crear una
#nueva categoria

#Con esta informacion adicional, se te ocurren otras preguntas?


# Variabilidad de los datos -----------------------------------------------
#Podemos verificar si existen valores atipicos utilizando un grafico de cajas
#Este grafico define un valor atipico como aquellos mayores a 1.5 veces el
#rango intercuartil
ping %>% 
  ggplot(aes(y = bill_length_mm, x = species))+
  geom_boxplot()

#Podemos mirar el histograma solo para la especie Gentoo para ver mas detalle
ping %>% 
  filter(species == "Gentoo") %>% 
  ggplot(aes(x = bill_length_mm))+
  #Agreguemos a hembras y machos
  geom_histogram(aes(fill = sex), binwidth = 0.5, position = "dodge2")

#Que hacemos con los valores aberrantes?
#Depende: es posible un valor asi? es posible que sea un error?
#existen mas medidas para esa observacion?

#Noten la advertencia que R nos dio al crear el histograma
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

#Verifiquemos si la diferencia en el largo de los picos varia entre sexos
#para todas las especies
ping %>% 
  ggplot(aes(x = bill_length_mm, fill = species))+
  geom_histogram(binwidth = 0.5, na.rm = T, position = "dodge2")+
  facet_grid(sex~.)
#Al parecer los machos tienden a tener picos mas grandes que las hembras


# Covariacion -------------------------------------------------------------
#Existen variables que varian simultaneamente en nuestro set de datos
#Que asociaciones piensas que son posibles?

#Existe una manera facil de ver las correlaciones entre variables
pairs(ping)

#Tambien podemos cuantificar estas correlaciones
cor_ping <- ping %>% 
  #Seleccionamos solo variables numericas
  select_if(is.numeric) %>% 
  #Removemos valores NA
  drop_na() %>% 
  cor()

#Y verificar si estas correlaciones son significativas
sig_cor_ping <- ping %>% 
  #Seleccionamos solo variables numericas
  select_if(is.numeric) %>% 
  #Removemos valores NA
  drop_na() %>% 
  #El valor de significancia es de 95%
  cor.mtest(conf.level = 0.95)

#Ahora presentamos esta informacion de manera grafica
corrplot(cor_ping, method = "ellipse", type = "lower")
#Podemos tambien hacer un grafico mixto
corrplot.mixed(cor_ping, lower = "number", upper = "ellipse", tl.pos = "lt",
               #con una paleta de colores diferentes
               upper.col = brewer.pal(n = 10, name = 'PRGn'),
               #con los resultados de significancia
               p.mat = sig_cor_ping$p, sig.level = 0.05)

#El largo del pico tiene correlaciones (lineales) significativas y positivas 
#con el largo de la aleta y el peso. Pero la correlacion mas fuerte es entre
#el peso del animal y el largo de la aleta

#Exploremos la relacion del pico y el peso un poco mas 
#Exploremos los datos del peso
ping %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_point(na.rm = T)+
  #Agregemos la linea de tendencia lineal
  geom_smooth(method = "lm")
#Que patrones vemos aqui?

#Existe una influencia de la especie?
ping %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm, col = species))+
  geom_point(na.rm = T)+
  geom_smooth(method = "lm")

#Existe una influencia del sexo del animal?
ping %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm))+
  geom_point(aes(col = species, shape = sex), na.rm = T, size = 3)+
  geom_smooth(method = "lm", aes(col = species, linetype = sex), 
              na.rm = T, se = F)


# Aplicando modelos lineales ----------------------------------------------
#Usando R base
#Modelo simple
modelo <- lm(bill_length_mm ~ body_mass_g, data = ping)
summary(modelo)
plot(modelo)

#Modelo mas complejo
modelo2 <- lm(bill_length_mm ~ body_mass_g + species + sex, data = ping)
summary(modelo2)
anova(modelo2)
plot(modelo2)


#Opcion tidymodels
#Dividamos nuestros datos en dos: entrenamiento y prueba
div_ping <- initial_split(ping, prop = 3/4, strata = species)
#Entrenamiento
ping_ent <- training(div_ping)
ping_prueba <- testing(div_ping)

#Remuestro de los datos de entrenamiento
set.seed(123)
ping_boot <- bootstraps(ping_ent)
ping_boot

#Regresion lineal simple
#Como sabemos que existe un correlacion significativa entre el peso y el
#largo del pico?
#Usemos una regresion linear simple (https://www.tidymodels.org/find/parsnip/)
espec_lm <- linear_reg() %>% 
  set_engine("lm") %>% 
  set_mode("regr")

#El flujo de trabajo necesita una formula para la regresion
flujo_trabajo_lm <- workflow() %>% 
  add_formula(bill_length_mm ~ body_mass_g)

#Aplicamos el flujo de trabajo y modelo a nuestro remuestreo
resultados_lm <- flujo_trabajo_lm %>% 
  add_model(espec_lm) %>% 
  fit_resamples(resamples = ping_boot,
                control = control_resamples(save_pred = T))

#Evaluamos el modelo
collect_metrics(resultados_lm)

#RMSE (Root Mean Square Error - error cuadritico medio de las 
#predicciones, desviacion estandar de residuales)
#RSQ (R squared - r cuadrado, proporcion de la varianza de la 
#variable dependiente explicada por la variable independiente)

#Ajustemos el modelo una vez mas y evaluemos en relacion a los
#datos de prueba
resultados_lm_final <- flujo_trabajo_lm %>% 
  add_model(espec_lm) %>%
  last_fit(div_ping) 

resultados_lm_final %>% 
  collect_metrics()

resultados_lm_final$.predictions[[1]] %>% 
  ggplot(aes(x = .pred, y = bill_length_mm))+
  geom_point()+
  geom_abline(slope = 1, intercept = 0, color = "red")+
  coord_cartesian(ylim = c(30, 55))

#Regresion lineal multiple
#Incluyamos las dos variables adicionales que identificamos en nuestra
#exploracion de datos
flujo_trabajo_lm2 <- workflow() %>% 
  add_formula(bill_length_mm ~ body_mass_g + species + sex)

#Aplicamos el flujo de trabajo y modelo a nuestro remuestreo
resultados_lm2 <- flujo_trabajo_lm2 %>% 
  add_model(espec_lm) %>% 
  fit_resamples(resamples = ping_boot,
                control = control_resamples(save_pred = T))

#Evaluamos el modelo
collect_metrics(resultados_lm2)

#Evaluacion final
resultados_lm_final2 <- flujo_trabajo_lm2 %>% 
  add_model(espec_lm) %>%
  last_fit(div_ping) 

resultados_lm_final2 %>% 
  collect_metrics()

resultados_lm_final2$.predictions[[1]] %>% 
  ggplot(aes(x = .pred, y = bill_length_mm))+
  geom_point()+
  geom_abline(slope = 1, intercept = 0, color = "red")+
  coord_cartesian(ylim = c(30, 55))

#Comparando ambos modelos
glance(resultados_lm_final$.workflow[[1]])
glance(resultados_lm_final2$.workflow[[1]])
#AIC - Akaike Information Criterion, usado para comparar modelos
#AIC identifica el mejor modelo basado en la mayor cantidad de 
#variabilidad explicada con el menor numero posible de variables
#Un menor valor AIC indica que el modelo es mejor


#Comparando tidymodels y R base
collect_metrics(resultados_lm_final)
resultados_lm_final$.workflow[[1]] %>% 
  tidy(exponentiate = T)
summary(modelo)

collect_metrics(resultados_lm_final2)
resultados_lm_final2$.workflow[[1]] %>% 
  tidy(exponentiate = T)
summary(modelo2)
