###########################################################################
#Club de Lectura:
#R para Ciencia de Datos (Wickham y Grolemund)
#R-Ladies Barranquilla, Galapagos, Guayaquil y Milagro
#
#Sesion 12: Capitulo 25 (Muchos modelos)
#Script por: Denisse Fierro Arcos (R-Ladies Galapagos)
###########################################################################


# Llamando bibliotecas ----------------------------------------------------
library(tidyverse)
library(modelr)
library(palmerpenguins)
library(broom)


# Explorando datos --------------------------------------------------------
#Cargando datos sobre pinguinos
ping <- penguins

#Revisando datos
glimpse(ping)

#Relacion entre peso y largo de la aleta
ping %>% 
  ggplot(aes(body_mass_g, flipper_length_mm))+
  geom_point(aes(col = species))
#Que patrones podemos observar?

#Existen otras relaciones entre variables?
ping %>% 
  ggplot(aes(body_mass_g, bill_depth_mm))+
  geom_point(aes(col = species))

#Podemos ver todas las correlaciones de manera mas sencilla
pairs(ping)


# Aplicando modelos lineales ----------------------------------------------
#Filtrar datos para una especie
Gentoo <- ping %>% 
  filter(species == "Gentoo")

#Visualizamos datos
Gentoo %>% 
  ggplot(aes(body_mass_g, flipper_length_mm))+
  geom_point()

#Aplicamos modelos lineal
mod_gentoo <- lm(flipper_length_mm ~ body_mass_g, data = Gentoo)
#Miramos los resultados
summary(mod_gentoo)

#Graficamos las predicciones y los datos iniciales
Gentoo %>% 
  add_predictions(mod_gentoo) %>% 
  ggplot(aes(body_mass_g, flipper_length_mm))+
  geom_point()+
  geom_line(aes(y = pred), col = "red")

#Ahora debemos hacer lo mismo para cada especies

#######
# Automatizar aplicacion de modelos ---------------------------------------
#Anidamos datos
ping_especies <- ping %>% 
  #Removemos observaciones con valores NA
  drop_na() %>% 
  #Agrupamos por especie y sexo
  group_by(species, sex) %>% 
  #Anidamos
  nest()

#Equivalente
ping %>% 
  drop_na() %>% 
  #Especificamos las columnas que deben ser anidadas
  nest(data = -c(species, sex))


#Veamos resultados de anidacion
glimpse(ping_especies)

#Como accedo a esa tabla?
ping_especies$data[[1]]

#Equivalente
ping_especies %>% 
  filter(species == "Adelie" & sex == "male") %>% 
  pull(data)

#Equivalente
ping_especies$data[(ping_especies$species == "Adelie" & ping_especies$sex == "male")]


# Apliquemos el modelo ----------------------------------------------------
#Creamos una funcion con nuestro modelo lineal
modelo_aleta_peso <- function(datos){
  lm(flipper_length_mm ~ body_mass_g, data = datos)}

#Aplicamos modelos
ping_especies <- ping_especies %>% 
  #Podemos agregar una nueva columna con los resultados del modelo
  #Map aplica nuestra funcion a la columna data
  mutate(modelo = map(data, modelo_aleta_peso))

#Veamos nuestro set de datos
ping_especies

#Podemos agregar los residuales
ping_especies <- ping_especies %>% 
  #Creamos una nueva columna
  #Usamos map2 porque necesitamos dos columnas para calcular residuales
  mutate(residuales = map2(data, modelo, add_residuals))

#Veamos resultados
ping_especies


# Comparando residuales ---------------------------------------------------
#Desanidamos los datos primero
residuos <- ping_especies %>% 
  unnest(residuales)

#Veamos resultados
residuos

#Grafiquemos residuales
residuos %>% 
  ggplot(aes(body_mass_g, resid))+
  geom_point(aes(col = species))+
  geom_smooth(se = F)
#Vemos algun patron en los residuos?

#Veamos el efecto del sexo y la especie
residuos %>% 
  ggplot(aes(body_mass_g, resid))+
  geom_point(aes(col = species))+
  geom_smooth(se = F)+
  facet_grid(sex~.)
#Vemos diferencias entre el sexo del animal?


# Evaluando la calidad del modelo -----------------------------------------
#Podemos ver medidas de calidad con glance
glance(mod_gentoo)

#Pero como lo automatizamos?
cal_mod <- ping_especies %>% 
  #Usamos map para aplicar glance a todas las categorias en la tabla anidada
  mutate(cal_modelo = map(modelo, glance)) %>% 
  #Removemos columnas que no necesitamos
  select(-(data:residuales)) %>% 
  #Desanidamos
  unnest(cal_modelo)

#Veamos resultados
cal_mod

#Ordenemos los datos de acuerdo al r cuadrado
cal_mod %>% 
  arrange(adj.r.squared)

#Podemos ver en un grafico las predicciones y datos originales de los modelos
#menos buenos
cal_mod %>% 
  mutate(calidad = case_when(adj.r.squared < 0.25 ~ "mala",
                             T ~ "buena")) %>% 
  left_join(ping, by = c("species", "sex")) %>%
  ggplot(aes(body_mass_g, flipper_length_mm))+
  geom_point(aes(col = species))+
  facet_grid(~calidad)
#Que patrones podemos observar?

