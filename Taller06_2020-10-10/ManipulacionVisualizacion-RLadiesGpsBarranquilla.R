################### Taller de manipulacion y visualizacion de datos ###################
#Organizado por: R-Ladies Barranquilla y R-Ladies Galapagos
#Fecha del evento: 2020-10-10
#Taller por: Denisse Fierro Arcos (R-Ladies Galapagos) 
#            Maria Isabel Arrieta Escobar (R-Ladies Barranquilla)

# Llamando paquetes -------------------------------------------------------
library(tidyverse)
#Tidyverse es una especie de super paquete que contiene a varios paquetes
#Puedes verificar los paquetes incluidos utilizando la siguiente linea
tidyverse_packages()


# Ejercicio 1. Comando basicos --------------------------------------------
#Creamos la tabla del ejemplo con la funcion tribble----
tribble(~Raza,      ~Indicador,  ~`2018`, ~`2019`, 
        "Beagle", "Precio",     300.000,     350.000,
        "Pastor Aleman",   "Precio",     400.000, 340.000,
        "Bulldog", "Precio", 350.000, 400.000
) -> desordenado      
desordenado

#----Ordenar datos I----
desordenado %>% 
  gather() #Empleamos la funcion gather () sin argumentos

#----Ordenar datos II----
desordenado %>% 
  gather(key, value, #Los dos primeros argumentos son los nombres de las columnas que se crearon.
         #Los siguientes las columnas que pasaremos a filas. Estos nombres de columna se repetiran en key y las filas llenaran value.  
         '2018', '2019')  

#----Ordenar datos III----
desordenado %>% 
  gather(Anio, Precio,            #Doy nombres utiles a key y value: quiero los anios y los precios. 
         -Raza, -Indicador) %>%   #Especifico que columnas NO voy a pasar a filas usando "-".
  select(-Indicador)

#----Usar la gramatica de dplyr----
tribble(                         #Creo los datos con la funcion tribble, muy util por su legibilidad al organizar la entrada en columnas. 
  ~Col1,    ~Col2,        ~Col3, #Nombres de columna, se antepone ~
  "Pepita", "Manzana",    48,    #Llenamos las columnas una a una. Mucha atencion a las comas!!
  "Pepita", "Pera"   ,    52,
  "Citrico", "Naranja",   12, 
  "Citrico", "Mandarina", 8,
  "Carozo",  "Durazno",   60,
  "Carozo",  "Ciruela",   55     #En la ultima columna NO usamos la coma. 
)                        #Cierro el parentesis de la funcion tribble. Se genera el data.frame. 
                         #Silenciosamente invoca a la funcion print() y saca el resultado en consola.

#----Renombrar columnas----
tribble(
  ~Col1,    ~Col2,        ~Col3, 
  "Pepita", "Manzana",    48,     
  "Pepita", "Pera"   ,    52,
  "Citrico", "Naranja",   12, 
  "Citrico", "Mandarina", 8,
  "Carozo",  "Durazno",   60,
  "Carozo",  "Ciruela",   55
)  %>%                   #Paso el data.frame a la siguiente funcion.
  rename(Tipo = Col1,              #Cambio los nombres a unos mas faciles de recordar.
         Fruta = Col2,             #Hago un cambio en cada linea para facilitar la legibilidad. 
         Precio = Col3) 

#----Filtrar filas----
tribble(
  ~Col1,    ~Col2,        ~Col3, 
  "Pepita", "Manzana",    48,     
  "Pepita", "Pera"   ,    52,
  "Citrico", "Naranja",   12, 
  "Citrico", "Mandarina", 8,
  "Carozo",  "Durazno",   60,
  "Carozo",  "Ciruela",   55
)  %>%                   
  rename(Tipo = Col1,              
         Fruta = Col2,             
         Precio = Col3) %>% 
  #Conserva solamente las filas en las que Tipo es igual a "Citrico" 
  filter(Tipo == "Citrico") 

#----Filtrado negativo.----
tribble(
  ~Col1,    ~Col2,        ~Col3, 
  "Pepita", "Manzana",    48,     
  "Pepita", "Pera"   ,    52,
  "Citrico", "Naranja",   12, 
  "Citrico", "Mandarina", 8,
  "Carozo",  "Durazno",   60,
  "Carozo",  "Ciruela",   55
)  %>%                   
  rename(Tipo = Col1,              
         Fruta = Col2,             
         Precio = Col3) %>% 
  #Usando != conserva solamente las filas en las que Tipo NO es igual a "Citrico"
  filter(Tipo != "Citrico")    

#----Filtrado para datos numericos. filter()----
tribble(
  ~Col1,    ~Col2,        ~Col3, 
  "Pepita", "Manzana",    48,     
  "Pepita", "Pera"   ,    52,
  "Citrico", "Naranja",   12, 
  "Citrico", "Mandarina", 8,
  "Carozo",  "Durazno",   60,
  "Carozo",  "Ciruela",   55
)  %>%                   
  rename(Tipo = Col1,              
         Fruta = Col2,             
         Precio = Col3) %>% 
  #Usando >= conservo solamente las filas en las que el precio es mayor a igual a 12. <, >, y <= tambien son validos.
  filter(Precio >= 12)    

#----Seleccionar columnas select()----
tribble(
  ~Col1,    ~Col2,       ~Col3, 
  "Pepita", "Manzana",   48,     
  "Pepita", "Pera"   ,   52,
  "Citrico","Naranja",   12, 
  "Citrico","Mandarina", 8,
  "Carozo", "Durazno",   60,
  "Carozo", "Ciruela",   55
)  %>%                   
  rename(Tipo = Col1,              
         Fruta = Col2,             
         Precio = Col3) %>% 
  #Filtro los que NO son citricos usando != en lugar de ==
  filter(Tipo != "Citrico")  %>%   
  #Selecciono las columnas Precio y Fruta, saldran en ese orden. Notese que cada funcion opera sobre el output de la anterior.
  select(Precio, Fruta)

#----Calculos agrupados ----
tribble(
  ~Col1,    ~Col2,        ~Col3, 
  "Pepita", "Manzana",    48,     
  "Pepita", "Pera"   ,    52,
  "Citrico", "Naranja",   12, 
  "Citrico", "Mandarina", 8,
  "Carozo",  "Durazno",   60,
  "Carozo",  "Ciruela",   55
)  %>%                   
  rename(Tipo = Col1,              
         Fruta = Col2,             
         Precio = Col3) %>%        #Retomo los datos originales, renombradas las columnas. 
  #Agrupo por tipo. Las siguientes operaciones se haran por este grupo.
  group_by(Tipo) %>%             
  #Nombre de la columna que se creara con el sumario. Opcional, pero recomendable. 
  summarise(promedio =            
              #Funcion que utilizaremos, mean, regresa la media. 
              mean(              
                #Columna sobre la que opera la funcion.
                Precio)
            #Cierro el parentesis que abri en summarise()
            )  %>%               
  #Ordeno de menor a mayor.
  arrange(promedio)


# Transformaciones de columnas  -------------------------------------------
tribble(
  ~Col1,    ~Col2,        ~Col3, ~Col4, #Cree una nueva columna. 
  "Pepita", "Manzana",    48,     12,   
  "Pepita", "Pera"   ,    52,     7, 
  "Citrico", "Naranja",   12,     50,
  "Citrico", "Mandarina", 8,      40,
  "Carozo",  "Durazno",   60,     3, 
  "Carozo",  "Ciruela",   55,     10
)  %>%
  #La nueva columna son los kilos en el inventario.
  rename(Tipo = Col1,             
         Fruta = Col2,            
         Precio = Col3,
         Kilos = Col4) %>%            
  #Recodifico una variable categorica. 
  mutate(Fruta = recode(Fruta,          
                        #categoria_vieja="categoria_nueva". Atencion a las comillas!
                      Manzana = "Manzana Verde")) %>%
  #Creo una nueva columna numerica a partir de otras dos.Uso * para multiplicacion. Tambien podria usar +, -, / y ^ para potencia.
  mutate(Capital = Precio*Kilos)        

#Transformaciones de columnas mutate ()
tribble(
  ~Col1,    ~Col2,        ~Col3, ~Col4, #Cree una nueva columna. 
  "Pepita", "Manzana",    48,     12,   
  "Pepita", "Pera"   ,    52,     7, 
  "Citrico", "Naranja",   12,     50,
  "Citrico", "Mandarina", 8,      40,
  "Carozo",  "Durazno",   60,     3, 
  "Carozo",  "Ciruela",   55,     10
)  %>%                  
  rename(Tipo = Col1,             
         Fruta = Col2,            
         Precio = Col3,
         #La nueva columna son los kilos en el inventario.
         Kilos = Col4) %>%
  #Recodifico una variable categorica. 
  mutate(Fruta = recode(Fruta,
                        #categoria_vieja="categoria_nueva".  Atencion a las comillas!
                        Manzana = "Manzana Verde")) %>%
  #Creo una nueva columna numerica a partir de otras dos.Uso * para multiplicacion. Tambien podria usar +, -, / y ^ para potencia.
  mutate(Capital = Precio*Kilos)        


#----Ejercicio 2. Empleo de los comando basicos empleando una base de datos mas compleja----
# Accediendo datos sobre pinguinos ----------------------------------------
#Podemos acceder a bases de datos que estan publicadas en linea con read_csv()
pinguinos <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins_raw.csv')
#Mas informacion sobre la base de datos:
#https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-07-28/readme.md

#Podemos revisar la estructura de nuestros datos con str()
str(pinguinos)


# Limpiando datos ---------------------------------------------------------
#Los datos no siempre estan listos para ser analizados. En nuestro caso, solo estamos
#interesados en las siguientes columnas: Species, Island, Culmen length and 
#Depth, Body Mass, Sex
PingLimp <- pinguinos %>%
  #Primero vamos a limpiar un poco los nombres de las columnas
  janitor::clean_names() %>% 
  #Ahora seleccionamos las columnas de nuestro interes
  select(species, island, culmen_length_mm, culmen_depth_mm, body_mass_g, sex) %>% 
  #Vamos a cambiar los nombre de ciertas columnas para que tengan mas sentido y porque
  #vamos a hacer ciertos calculos
  rename("beakLength_cm" = "culmen_length_mm", "beakDepth_cm" = "culmen_depth_mm", 
         "Weight_Kg" = "body_mass_g") %>% 
  #Ahora transformamos mm a cm dividiendo para 10
  mutate(beakLength_cm = beakLength_cm/10,
         beakDepth_cm = beakDepth_cm/10,
         #Y transformamos g a Kg diviendo para 1000
         Weight_Kg = Weight_Kg/1000) %>% 
  #Vamos a ignorar cualquier fila que contenga valores NA
  drop_na() %>% 
  #Por ultimo vamos a transformar las columnas de caracteres en factores
  mutate_if(is.character, factor)


# Visualizacion -----------------------------------------------------------
#Visualizacion simple
#Largo de pico entre hembras y machos - grafico de cajas
PingLimp %>% 
  #Llamamos a ggplot y establecemos las columnas que iran en los ejes x y y
  ggplot(aes(x = sex, y = beakLength_cm))+
  #Ahora utilizaremos un grafico de caja para representar nuestros datos
  geom_boxplot()+
  #Tambien sobrepondremos cada observacion
  geom_point()+
  #Cambiaremos los titulos  de cada eje
  labs(x = "Sexo", y = "Largo del pico (cm)")+
  #Vamos a cambiar el tema por uno en blanco y negro
  theme_bw()+
  #Finalmente removeremos la grilla de fondo
  theme(panel.grid = element_blank())

#Visualizacion con colores diferentes por sexo
#Largo vs ancho de pico entre hembras y machos
PingLimp %>% 
  #Ahora ademas de definir los ejes, definiremos como variara el color de cada grupo
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = sex))+
  #Utilizaremos puntos por cada observacion
  geom_point()+
  #Podemos cambiar los limites de los ejes, asi como la frecuencia de las etiquetas
  scale_x_continuous(limits = c(0, 7.5), breaks = seq(0, 7.5, 2.5))+
  #Cambiamos titulos de los ejes
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)")+
  theme_bw()

#Visualizacion con colores diferentes por sexo y comparando islas
#Largo vs ancho de pico entre hembras y machos
PingLimp %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = sex))+
  geom_point()+
  #Utilizando labs tambien podemos cambiar el titulo de nuestra leyenda
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)", colour = "Sexo")+
  #Probemos otro tema
  theme_classic()+
  #Con theme podemos cambiar el lugar de la leyenda
  theme(legend.position = "top")+
  #Creamos una faceta para cada isla
  facet_grid(~island)

#Visualizacion con colores diferentes por sexo. Comparando especies e islas.
#Largo vs ancho de pico entre hembras y machos
PingLimp %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = sex))+
  geom_point()+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)", colour = "Sexo")+
  #Probemos otro tema
  theme_light()+
  #Creemos un grafico por especie e isla
  facet_grid(species~island)+
  theme(legend.position = "top")+
  #Vamos a poner la leyenda arriba de las etiquetas y la centraremos
  guides(colour = guide_legend(title.position = "top", title.hjust = 0.5))

#Visualizacion con colores diferentes por sexo, formas diferentes por especies y 
#comparando islas
#Largo vs ancho de pico entre hembras y machos
PingLimp %>% 
  #Ahora las observaciones cambiaran de color por sexo y de forma por especie
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = sex, shape = species))+
  geom_point()+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)",
       #Podemos cambiar el titulo para cada una de las leyendas
       colour = "Sexo", shape = "Especies")+
  #Probemos otro tema
  theme_minimal()+
  #Dividamos los graficos por isla
  facet_grid(~island)+
  #Pongamos las leyendas arriba y que el tecxto este en direccion vertical
  theme(legend.position = "top", legend.direction = "vertical")

#Replicamos el mismo grafico de arriba, pero sin la especie de pinguino Gentoo
PingLimp %>% 
  #Seleccionamos todo excepto Gentoo bajo la columna species
  filter(!str_detect(species, "Gentoo.+")) %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = sex, shape = species))+
  geom_point()+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)", 
       colour = "Sexo", shape = "Especies")+
  theme_dark()+
  facet_grid(~island)+
  theme(legend.position = "top", legend.direction = "vertical",
        #Moveremos el titulo del eje y a la izquierda
        axis.title.y = element_text(vjust = 3),
        #Agrandaremos el margin izquierdo
        plot.margin = unit(c(5.5, 5.5, 5.5, 7), "points"), 
        #Cambiaremos el texto a negrita y blanco
        strip.text = element_text(face = "bold", colour = "white"))

#Visualizacion con colores diferentes por sexo, formas diferentes por especies y 
#comparando islas
#Largo vs ancho de pico entre hembras y machos
PingLimp %>% 
  #Cambiaremos la columna especie y solo mantendremos el nombre comun
  mutate(species = str_extract(species, "\\w+ \\w+")) %>% 
  ggplot(aes(x = beakLength_cm, y = beakDepth_cm, colour = sex, shape = species, 
             #Ahora haremos que el tamano del punto varie de acuerdo al peso
             size = Weight_Kg))+
  #Haremos los puntos transparentes
  geom_point(alpha = 0.5)+
  labs(x = "Largo del pico (cm)", y = "Altura del pico (cm)",
       colour = "Sexo", shape = "Especies", size = "Peso (Kg)")+
  theme_bw()+
  facet_grid(island~.)


