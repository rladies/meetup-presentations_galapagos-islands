library(tidyverse)
library(magrittr)

#Grafico
vivienda <- read.csv("Datos/DatosCensoViviendaGalapagos2015.csv")
vivienda %<>% 
  group_by(area, canton, tipo_vivienda) %>% 
  summarise(N = n()) %>% 
  group_by(area, canton) %>% 
  mutate(tot = sum(N),
         prop = (N/tot)*100)

vivienda %>% 
  ggplot(aes(y = tipo_vivienda, x = prop, fill = area))+
  geom_bar(stat = "identity", position = "dodge")+
  facet_grid(canton~.)+
  labs(x = "Proporcion", fill = "Area")+
  theme_bw()+
  theme(axis.title.y = element_blank())

#Tabla
pob <- read.csv("Datos/DatosCensoPoblacionGalapagos2015.csv")
pob %<>% 
  group_by(sexo, grupo_edad, canton) %>% 
  summarise(N = n()) %>% 
  pivot_wider(names_from = sexo, values_from = N)
