import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from scipy import stats



# Conexión a MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="lobo",
    database="tienda_uniformes"
)

# Cargar datos en DataFrames
query_ventas_uni = "SELECT * FROM ventas_uni"
query_facturas = "SELECT * FROM facturas"
query_clientes = "SELECT * FROM clientes"

# Query con el JOIN
query_ventas = """
SELECT
 v.id_venta_uni,
 v.id_factura,
 f.fecha_factura,
 c.nombre,
 p.descripcion,
 v.cantidad,
 v.total
FROM ventas_uni AS v
JOIN clientes AS c ON v.id_cliente = c.id_cliente
JOIN productos AS p ON v.id_producto = p.id_producto
JOIN facturas AS f ON v.id_factura = f.id_factura
ORDER BY v.id_venta_uni ASC;
"""


df_ventas_uni = pd.read_sql(query_ventas, conn)
df_facturas = pd.read_sql(query_facturas, conn)
df_clientes = pd.read_sql(query_clientes, conn)
df_ventas = pd.read_sql(query_ventas, conn)

# Cerrar conexión
conn.close()

print(df_ventas.columns)
print(df_ventas.head())
print(df_ventas.info())  # Ver tipos de datos
print(df_ventas.describe())  # Estadísticas de las ventas
print(df_ventas.dtypes)
print(df_ventas.info())

#######EDA######

###ventas por dia###

df_ventas["fecha_factura"] = pd.to_datetime(df_ventas["fecha_factura"])
print(df_ventas["fecha_factura"])

ventas_por_dia = df_ventas.groupby("fecha_factura")["id_venta_uni"].count()
print(ventas_por_dia.head())  # Verifica los resultados
ventas_por_dia.plot(kind="line", title="Ventas por Día")
plt.xlabel("Fecha")
plt.ylabel("Total Ventas")
plt.grid(True)

plt.show()  

###histograma distribucion de ventas por precio###
plt.figure(figsize=(10, 5))
sns.histplot(df_ventas["total"], bins=30, kde=True)
plt.title("Distribución de Ventas")
plt.show()

### estadisticas de valores de las facturas###
ventas_por_factura = df_facturas["total_factura"]
# Estadísticas descriptivas
stats = ventas_por_factura.describe()
print("📊 Estadísticas descriptivas de las ventas por factura:\n")
print(stats)

####### clientes con una sola compra ########
# Contar el número de compras por cliente
compras_por_cliente = df_facturas["id_cliente"].value_counts()

# Filtrar clientes con solo una compra
clientes_una_compra = compras_por_cliente[compras_por_cliente == 1].index

# Obtener los detalles de estos clientes
clientes_unicos = df_facturas[df_facturas["id_cliente"].isin(clientes_una_compra)][["id_cliente"]].drop_duplicates()

print("📋 Lista de clientes que solo han comprado una vez:")
print(clientes_unicos)

##### diagrama de caja y bigotes ####

plt.figure(figsize=(8, 6))  # Ajustamos el tamaño de la figura

# Creamos el boxplot
ax = sns.boxplot(y=df_facturas["total_factura"], width=0.3, color="lightblue", fliersize=5)

# Extraemos estadísticos para mostrar en la gráfica
Q1 = df_facturas["total_factura"].quantile(0.25)  # Primer cuartil (Q1)
Q2 = df_facturas["total_factura"].median()        # Mediana (Q2)
Q3 = df_facturas["total_factura"].quantile(0.75)  # Tercer cuartil (Q3)
IQR = Q3 - Q1                                     # Rango intercuartil (IQR)
min_val = Q1 - 1.5 * IQR                          # Límite inferior (bigote)
max_val = Q3 + 1.5 * IQR                          # Límite superior (bigote)

# Agregar líneas y etiquetas
plt.axhline(Q1, color="red", linestyle="--", xmax=0.55, label="Q1 (25%)")
plt.axhline(Q2, color="green", linestyle="-", xmax=0.55, label="Mediana (Q2, 50%)")
plt.axhline(Q3, color="blue", linestyle="--", xmax=0.55, label="Q3 (75%)")

# Anotaciones en la gráfica
plt.text(0.4, Q1, f"Q1\n{Q1:.0f}", ha="left", va="center", color="red", fontsize=10)
plt.text(0.4, Q2, f"Mediana\n{Q2:.0f}", ha="left", va="center", color="green", fontsize=10)
plt.text(0.4, Q3, f"Q3\n{Q3:.0f}", ha="left", va="center", color="blue", fontsize=10)

plt.title("Distribución de Ventas por Factura")
plt.ylabel("Total Factura")
plt.legend()
plt.show()