
# Llamando paquetes -------------------------------------------------------
library(tidyverse)

# Accediendo datos de pinguinos -------------------------------------------
pinguinos <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins_raw.csv')
#Mas informacion sobre base de datos:
#https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-07-28/readme.md


# Limpiando datos ---------------------------------------------------------
#Estamos interesados en las siguientes columnas: Species, Island, Culmen length and 
#Depth, Body Mass, Sex
PingLimp <- pinguinos %>%
  select(Species, Island, `Culmen Length (mm)`, `Culmen Depth (mm)`,
                     `Body Mass (g)`, Sex) %>% 
  rename("beakLength_cm" = "Culmen Length (mm)", "beakDepth_cm" = "Culmen Depth (mm)", 
         "Weight_Kg" = "Body Mass (g)") %>% 
  mutate(beakLength_cm = beakLength_cm/10,
         beakDepth_cm = beakDepth_cm/10,
         Weight_Kg = Weight_Kg/1000) %>% 
  drop_na() %>% 
  mutate_if(is.character, factor)


# Visualizacion -----------------------------------------------------------
#Visualizacion simple
#Largo de pico entre hembras y machos - grafico de cajas
PingLimp %>% 
  ggplot(aes(x = Sex, y = beakLength_cm))+
  geom_boxplot()+
  geom_point()+
  labs(x = "Sexo", y = "Largo del pico (cm)")+
  theme_bw()

#Visualizacion con colores diferentes por sexo
#Largo vs ancho de pico entre hembras y machos
PingLimp %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = Sex))+
  geom_point()+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)")+
  theme_bw()

#Visualizacion con colores diferentes por sexo y comparando islas
#Largo vs ancho de pico entre hembras y machos
PingLimp %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = Sex))+
  geom_point()+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)")+
  theme_bw()+
  facet_grid(~Island)

#Visualizacion con colores diferentes por sexo, especies y comparando islas
#Largo vs ancho de pico entre hembras y machos
PingLimp %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = Sex))+
  geom_point()+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)")+
  theme_bw()+
  facet_grid(Species~Island)

PingLimp %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = Sex, shape = Species))+
  geom_point()+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)")+
  theme_bw()+
  facet_grid(~Island)

PingLimp %>% filter(!str_detect(Species, "Gentoo.+")) %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = Sex, shape = Species))+
  geom_point()+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)")+
  theme_bw()+
  facet_grid(~Island)

PingLimp %>% filter(!str_detect(Species, "Gentoo.+")) %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = Sex, shape = Species, 
             size = Weight_Kg))+
  geom_point(alpha = 0.5)+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)")+
  theme_bw()+
  facet_grid(~Island)

PingLimp %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = Sex, shape = Island, 
             size = Weight_Kg))+
  geom_point(alpha = 0.5)+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)")+
  theme_bw()+
  facet_grid(~Species)
