###################################################################
# Taller de Introduccion a Programacion en R - FCD, R-Ladies, SEE
# Sesion 3: 
# Incluye paquetes e importacion de datos, y estructuras de control
###################################################################


# Activando paquetes ------------------------------------------------------
# Si no tienen un paquete instalado, pueden llamarlo utilizando install.packages()
# Recuerden que solo debe instalar el paquete una sola vez
install.packages("readr")


# Noten que a pesar que un paquete este instalado en su computadora,
# tienen que llamarlo a su sesion utilizando library(nombre paquete)
library(openxlsx)
library(readr)
library(readxl)


# Importando datos en hoja de Excel a R -----------------------------------
# Existen varias funciones que permite importar datos a R. Aqui incluimos 
# algunas opciones. La funcion que utilicen dependera de sus necesidades,
# no existe una respuesta unico sobre el "mejor paquete"

# Abrir archivos xlsx
# Con el paquete openxlsx
DatosBanco <- read.xlsx("Datos/Data_Banco.xlsx", 
                        #Podemos especificar el numero de pagina con un numero
                        #o con el nombre la pagina de excel
                        sheet = 1)

# Opcion con el paquete readxl
DatosBanco2 <- read_excel("Datos/Data_Banco.xlsx", 
                         #Al igual que la opcion de arriba, podemos utilizar un
                         #numero o el nombre de la pagina de excel
                         sheet = "Data")



# Importando datos en archivos csv a R ------------------------------------
# Abrir archivos csv
# Opciones R base - Incluimos ubicacion del archivo como primer argumento
DatosBanco3 <- read.csv("Datos/Data_Banco.csv", sep = ";")
# Noten que debemos especificar la opcion del separador porque el valor por default
# en la funcion read.csv() es una coma (sep = ",")

# Con read.csv2() no es necesario especificar el separador porque el valor por default
# es un punto y coma (sep = ";")
DatosBanco4 <- read.csv2("Datos/Data_Banco.csv")

# Con read.delim() tambien debemos especificar el separador
DatosBanco5 <- read.delim("Datos/Data_Banco.csv", sep = ";")

# Opcion readr - El separador es referido como delim en esta funcion
DatosBanco6 <- read_delim("Datos/Data_Banco.csv", delim = ";")



# Importando datos disponibles en la web a R ------------------------------
#Opcion readr - Se incluye la direccion web de los datos
Mundial <- read_delim("https://raw.githubusercontent.com/cienciadedatos/datos-de-miercoles/master/datos/2019/2019-04-10/partidos.txt",
                      #Se especifica el separador
                      delim = "\t")

#Opcion R base - Argumentos similares son necesarios: direccion web
Mundial2 <- read.csv("https://raw.githubusercontent.com/cienciadedatos/datos-de-miercoles/master/datos/2019/2019-04-10/partidos.txt",
                     #y el separador
                     sep = "\t", 
                     #Adicionalmente incluimos el formato que deberia ser utilizado para
                     #codificar los caracteres para que aparezcan las tildes de manera
                     #correcta
                     encoding = "UTF-8")


# Escribiendo datos desde R al disco duro ---------------------------------
# R base
# Escribe archivos en formato csv - El primer argumento es la variable que sera guardada
write.csv(Mundial2, 
          #Luego incluimos el nombre (y carpeta de ser necesario) donde se guardara
          #la variable que especificamos en el primer argumento
          "ArchivosSalida/Mundial.csv")

# El argumento row.names nos permite decidir si queremos guardar los nombres de las filas.
# El valor default es row.names = TRUE, al utilizar F o FALSE no guardara los nombres de
# las filas en el archivo csv
write.csv(Mundial2, "ArchivosSalida/Mundial.csv", row.names = F)

# Escribiendo archivos en formato excel
write.xlsx(Mundial2, "ArchivosSalida/Mundial.xlsx")

# Opcion readr
write_excel_csv(Mundial, "ArchivosSalida/Mundial2.csv", delim = ",")

# Opcion openxlsx
write.xlsx(Mundial, "ArchivosSalida/Mundial2.xlsx")



# Estructura de datos -----------------------------------------------------
# Verificar tipo de datos con la funcion class()
class(DatosBanco)
# Tipo data frame - Tabla o matrix que guarda varios tipos de datos

class(Mundial)
# Tipo tibble (un tipo de tabla) similar al data frame

# Verificar las dimensiones con dim()
dim(DatosBanco)

# Vectores
# Utilizando comando c() para crear un vector
x <- c(1,2,3,4)
# Notan cada elemento esta separado por comas

# Un vector puede ser creado repitiendo un numero varias veces con la funcion rep()
rep(10, 5)

# O podemos utilizar un rango de numeros
y <- c(1:20)

# O podemos juntar ambas funciones
z <- rep(1:5, each = 4)
z
# Mira como el segundo argumento de esta funcion cambia el resultado
z1 <- rep(1:5, times = 4)
z1

# Podemos unir dos vectores y formar un vector mas largo
vectorlargo <- c(x, y)
length(y)
length(z)
length(vectorlargo)


# Data frames
# Podemos crear un data frame con vectores que ya existen, pero estos deben
# tener el mismo tamanio
# Primero damos el nombre del columna seguido por un = y luego el contenido de 
# esa columna
df <- data.frame(col1 = y, 
                 col2 = z)


# Puedo crear nuevos vectores. Esta vez de caracteres
# Nota las comas entre las palabras que estan entre comillas
# Esto indica que cada palabra en comillas en un elemento diferente
nombres <- c("Denisse", "Zulemma", "Antonio")

# Comparemos como se ve si no ponemos comillas para cada palabra
nombres2 <- c("Denisse, Zulemma, Antonio")
# El resultado no es lo mismo

# Creo otro vector con edades - Noten como se usan varias funciones en la misma linea
edades <- c(34, rep(25, 2))

# Ahora creo mi data frame con los vectores de caracteres y numeros que acabo de crear
df2 <- data.frame(nombres, edades)


# Tambien puedo de crear un data frame definiendo el contenido de cada columna cuando
# creo el data frame
df3 <- data.frame(Nombres = c("Patricia", "Dagfin"),
                  Edades = rep(25, 2))


# Si quiero revisar la estructura de mi data frame, uso str()
str(df2)

# Si quiero visualizar el contenido de mi data frame en el visor de datos, uso View()
# Nota la V mayuscula
View(df2)

# Si quiero ver el contenido de mi variable, utilizo print()
print(df2)

# Si quiero un resumen de los datos contenidos en mi data frame, utilizo summary()
summary(df2)


# Accediendo a elementos en vectores --------------------------------------
# Escribo el nombre del vector seguido por []
# Dentro de [] escribo el indice del elemento que quiero
nombres[2]

# Si quiero acceder a varios elementos puedo utilizar c() dentro de []
nombres[c(1, 3)]
# Esto imprime los elementos 1 y 3 del vector nombres

# Si quiero acceder a varios elementos continuos puedo utilizar un rango
nombres[2:3]



# Accediendo a elementos en los data frames -------------------------------
# Para llamar a columnas enteras puedo utilizar $ 
df2$nombres
# Esto produce un vector
class(df2$nombres)

# Tambien puedo utilizar [] y especificar el nombre de la columna entre ""
df2["nombres"]
# Esto produce un data frame
class(df2["nombres"])

# Si se el numero de columna puedo utilizar un numero entero entre []
# Reuerden cuando vimos dim(df2), primero nos dio las filas y luego las columnas
# Aplicamos el mismo patron aqui
df2[,1]
# Tambien produce un vector
# Noten que al no incluir un valor para las filas, todas las filas de la columna 1
# aparecen en la consola

# Todas las opciones presentan la misma informacion, pero en tipos de variables diferentes

# Para acceder a todas las columnas en una fila en especifica
df2[3,]

# Para acceder a un elemento especifico
df2[1,2]

# Tambien podemos llamar varios elementos a la vez
# Por ejemplo, a las dos primeras filas, pero solo para las columnas 1 y 5
DatosBanco[1:2, c(1, 5)]

