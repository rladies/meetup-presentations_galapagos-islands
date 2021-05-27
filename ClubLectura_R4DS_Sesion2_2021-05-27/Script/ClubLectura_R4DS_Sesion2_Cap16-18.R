###########################################################################
#Club de Lectura:
#R para Ciencia de Datos (Wickham y Grolemund)
#R-Ladies Barranquilla, Galapagos, Guayaquil y Milagro
#
#Sesion 2: Capitulos 16 (Fechas y horas), y 18 (Pipes)
#Script por: Denisse Fierro Arcos (R-Ladies Galapagos)
###########################################################################

# Llamando bibliotecas ----------------------------------------------------
library(tidyverse)
library(lubridate)


# Capitulo 16: Fechas y horas ---------------------------------------------
#Datos tipo fecha
today()

#Datos tipo fecha-hora
now()

# Creando fechas/horas con caracteres ####
#Diferentes opciones dependiendo del orden de la fecha
ymd("2021-05-22") # Anio-mes-dia
ymd(20210522)

mdy("May 22, 2021") # Mes-dia-anio
mdy(05222021)

dmy("22 may 2021") # Dia-mes-anio
dmy(22052021)

#Si utilizamos algo que no indique una fecha
dmy("hola")

#Podemos utilizar un numero que represente los segundos desde 1970-01-01
as_datetime((60*60*2)+(60*30)) #Por ejemplo, 2 horas y 30 minutos
#O como dias desde 1970-01-01
as_date((30*3)+15) #3 meses y 15 dias

#Para agregar horas usa un guion bajo y especifica si incluyes hora, minutos
#y/o segundos
ymd_h("2021-05-22 8pm")
mdy_hm("may 22, 2021 20:01")
dmy_hms("22 may 2021 8:01:20 pm")

#Si quieres anadir un huso horario utiliza el parametro tz (timezone)
ymd_h("2021-05-22 8pm", tz = "Pacific/Galapagos")
dmy_hms("22 may 2021 8:01:20 pm", tz = "America/Guayaquil")
#Para ver la lista de zonas horarias disponibles usa la funcion OlsonNames()

#Podemos agregar el parametro tzone a today() o now
now(tzone = "Pacific/Galapagos")
today(tzone = "Australia/Sydney")


# Creando fechas/horas con componentes individuales de fecha/hora ####
#Carguemos un set de datos
erupciones <- read_csv("ClubLectura_R4DS_Sesion2_2021-05-27/Datos/volcano_data_2010.csv")
#Revisemos los datos
erupciones

#Creemos la fecha en una nueva columna
erupciones %>% 
  mutate(Fecha = make_date(Year, Month, Day)) %>% 
  #Revisemos el resultado
  select(Year:Day, Fecha) %>% 
  head()
#Algo no esta bien

#Intentemos otra cosa
erupciones %>% 
  mutate(Fecha = make_date(Year, Month)) %>% 
  select(Year:Day, Fecha) %>% 
  head()
#Tampoco esta bien

#Pongamos condiciones que se apliquen de acuerdo a si existe un dia o no
erupciones %>% 
  mutate(Fecha = case_when(is.na(Day) ~ make_date(Year, Month),
                           TRUE ~ make_date(Year, Month, Day))) %>% 
  select(Year:Day, Fecha) %>% 
  head()
#Mucho mejor

#Tambien podriamos crear fecha hora con componentes individuales
erupciones %>% 
  #Crearemos columnas adicionales con horas y minutos. Todas tendran la misma
  #informacion
  mutate(hora = 13, minuto = 30) %>%
  #Ahora creemos la fecha-hora
  mutate(fecha_hora = make_datetime(Year, Month, Day, hora, minuto)) %>% 
  select(Year:Day, fecha_hora)
  

# Creando fechas/horas con fechas/horas existentes ####
#Recordemos
today()
#Para cambiar a fecha-hora
as_datetime(today())

#Fecha-hora a fecha
now()
as_date(now())


# Componentes de fecha-hora ####
year(today())
month(today())
#Si queremos el nombre del mes anade label = T
month(today(), label = T)
day(today())
hour(now())
minute(now())
second(now())

#Dia del mes
mday(today())
#Dia del anio
yday(today())
#Dia de la semana
wday(today())
#Tambien tiene la opcion de mostrar el nombre escrito
wday(today(), label = T)

#Con las funciones arriba podemos cambiar el componente de una fecha
fecha_hora <- now()
fecha_hora
#Cambiemos el anio
year(fecha_hora) <- 2022
fecha_hora
hour(fecha_hora) <- hour(fecha_hora)-5
fecha_hora

#Update tambien es util 
update(fecha_hora, year = 2020, month = 2, mday = 2, hour = 2)
fecha_hora
fecha_hora %>% update(hour = 48)

#Si queremos ver el dia de la semana con mas erupciones
erupciones %>% 
  #Las filas sin dia se convertiran en NA
  mutate(Fecha = make_date(Year, Month, Day),
         Dia_semana = wday(Fecha, label = T)) %>% 
  ggplot(aes(Dia_semana))+
  geom_bar()

#Si los queremos ordernar podemos utilizar factores
erupciones %>% 
  #Las filas sin dia se convertiran en NA
  mutate(Fecha = make_date(Year, Month, Day),
         #Obtengamos el dia de la semana - Recuerda utilizar label para
         #obtener el nombre
         Dia_semana = factor(wday(Fecha, label = T), 
                             #Ordenamos el factor
                             ordered = T)) %>% 
  #Podemos agregar los NA que aparezcan con un grupo llamado 'No dato'
  mutate(Dia_semana = fct_explicit_na(Dia_semana, "No dato")) %>% 
  #Ahora podemos ubicar los 'No dato' antes que los demas dias de la semana
  mutate(Dia_semana = fct_relevel(Dia_semana, "No dato")) %>% 
  #Creamos un grafico de barras
  ggplot(aes(Dia_semana))+
  geom_bar()

#Si queremos la informacion por mes
erupciones %>% 
  #Cambiamos el numero por el nombre del mes
  mutate(Month = month.abb[Month]) %>% 
  ggplot(aes(Month))+
  geom_bar()

#Recordemos sobre factores y reordenemos
erupciones %>% 
  #Creamos un factor con niveles ordenamos
  mutate(Month = factor(month.abb[Month], levels = month.abb, 
                        ordered = T)) %>% 
  ggplot(aes(Month))+
  geom_bar()


# Redondeo ####
#Si podemos redondear fechas hacia abajo o hacia arriba
#Primero hagamos una columna de fecha permanente
erupciones <- erupciones %>% 
  #Las filas sin dia se convertiran en NA
  mutate(Fecha = make_date(Year, Month, Day),
         Dia_semana = wday(Fecha, label = T))

#Imaginemos que queremos contar el numero de erupciones por trimestre
erupciones %>% 
  count(erup_trim = floor_date(Fecha, "quarter")) %>% 
  #Podemos graficar
  ggplot(aes(erup_trim, n)) +
  geom_line()

#Comparemos el grafico si forzamos el redondeo hacia arriba
erupciones %>% 
  mutate(erup_trim_arriba = ceiling_date(Fecha, "quarter"),
        erup_trim_abajo = floor_date(Fecha, "quarter"),
        erup_trim = round_date(Fecha, "quarter")) %>% 
  select(Fecha, starts_with("erup"))


# Lapsos de tiempo 
#Que edad tengo?
edad <- today() - make_date(1987, 4, 2)
edad
#Para saber los anios podria dividir para 365 para obtener un aproximado
edad/365
#Pero no es correcto porque existen anios bisiestos, entonces usamos
#as.duration
as.duration(edad)

#Y si quiero crear duracion en horas o minutos
dminutes(300)
ddays(c(4, 18))

#Podemos sumar entre si sin problema
dyears(34) + dmonths(1) + ddays(25)

# Periodos de tiempo son similares a los lapsos, pero no son afectados por
# diferencias horarias con horarios de verano, por ejemplo o con anios 
# bisiestos
minutes(10)
months(c(2, 20))

ymd("2019-03-01")+dyears(1)
ymd("2019-03-01")+years(1)



# Intervalos ####
siguiente_anio <- today() + years(1)
(today() %--% siguiente_anio) / ddays(1)
(today() %--% siguiente_anio) %/% days(1)



# Zonas horarias ####
Sys.timezone()
ymd_hms("2021-02-02 05:30:00")
a <- ymd_hms("2021-02-02 05:30:00", tz = "Pacific/Galapagos")
b <- ymd_hms("2021-02-02 05:30:00", tz = Sys.timezone())
b - a

#Podemos cambiar un huso horario
c <- today()
#Actualiza el huso horario y la hora
with_tz(c, tzone = "Pacific/Galapagos")
#Actualiza solo el uso horario
force_tz(c, tzone = "Pacific/Galapagos")


# Capitulo 18: Pipes ------------------------------------------------------
library(magrittr)

#Usando pipes
erupciones %>% 
  filter(Location == "Ecuador") %>% 
  count(Year)

#Sin pipes
count(filter(erupciones, Location == "Ecuador"), Year)

# El pipe %$% nos permite escoger columnas especificas en vez del data frame
erupciones %>% 
  drop_na(DAMAGE_MILLIONS_DOLLARS) %$% 
  mean(DAMAGE_MILLIONS_DOLLARS)

#El pipe %<>% permite reemplazar valores en una variable
#Copiemos erupciones
erupciones2 <- erupciones
erupciones2

#Escojamos los datos donde se incluyen el dia de la erupcion
erupciones2 %<>% 
  drop_na(Day)
erupciones2
#Usar con precaucion

#El pipe %T>% nos da resultados intermedios
erupciones %>% 
  group_by(Year, Country) %>% 
  count() %T>%
  print() %>% 
  ggplot(aes(Year, n))+
  geom_col()+
  facet_wrap(~Country)
