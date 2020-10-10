#Ejercicio 2 - Manipulando datos y creando graficos
library(tidyverse)
pinguinos <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins_raw.csv')
str(pinguinos)
glimpse(pinguinos)

read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins_raw.csv') %>% 
  glimpse()


# Limpiando datos ---------------------------------------------------------
PingLimpia <- pinguinos %>% 
  janitor::clean_names() %>% 
  select(species, island, culmen_length_mm, culmen_depth_mm, body_mass_g, sex) %>% 
  rename("beakLength_cm"= "culmen_length_mm",
         "beakDepth_cm" = "culmen_depth_mm",
         "weight_Kg" = "body_mass_g") %>% 
  mutate(beakLength_cm = beakLength_cm/10,
         beakDepth_cm = beakDepth_cm/10,
         weight_Kg = weight_Kg/1000) %>% 
  drop_na() %>% 
  mutate_if(is.character, factor)

#Si queremos crear una columna adicional que defina el color de cada grupo
PingLimpia %>% 
  #case_when nos ayuda a identificar filas que cumplan ciertas condiciones
  mutate(color = case_when(island == "Dream" & species == "Adelie Penguin (Pygoscelis adeliae)" ~ "red",
                           island == "Torgersen" ~ "blue",
                           island == "Biscoe" ~ "green",
                           #TRUE se refiere a cualquier otro caso no definido
                           TRUE ~ "otro nivel"))

#Para crear una nueva categoria en base a otras dos categorias
PingLimpia %>% 
  #interaction() utiliza el contenido de las columnas especificadas
  #con el argumento sep podemos definir el separador que prefiramos
  #si no definimos sep entonces el separador sera un punto "."
  mutate(GrupoUnico = interaction(island, species, sep = "_"))

# Graficos ----------------------------------------------------------------
#Grafico 1
PingLimpia %>% 
  ggplot(aes(x = sex, y = beakLength_cm, colour = sex))+
  geom_boxplot()+
  geom_point()+
  labs(x = "Sexo", y = "Largo del pico (cm)")+
  theme_bw()+
  theme(panel.grid = element_blank())+
  scale_colour_manual(values = c("red", "blue"))

#Grafico 2
g2 <- PingLimpia %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = sex))+
  geom_point()+
  labs(x = "Sexo", y = "Largo del pico (cm)")+
  facet_grid(species~island)+
  theme_bw()

g2+theme(legend.position = "top")

#Grafico 3
g3 <- PingLimpia %>% 
  filter(str_detect(species, "Adelie.+")) %>% 
  mutate(species = str_extract(species, "\\w+ \\w+")) %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = sex,
             size = weight_Kg))+
  geom_point(alpha = 0.5)+
  labs(x = "Sexo", y = "Largo del pico (cm)", size = "Peso (Kg)", 
       colour = "Sexo")+
  theme(legend.position = "top", legend.direction = "horizontal")+
  guides(colour = guide_legend(title.position = "top"),
         size = guide_legend(title.position = "top"))
g3
ggsave("Taller06_2020-10-10/grafico3.tiff", plot = g3, device = "tiff", dpi = 400)
