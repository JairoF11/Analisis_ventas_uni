Análisis de ventas de uniformes escolares 

Este proyecto analiza las ventas de uniformes escolares de un negocio local, explorando patrones de compra, productos más vendidos y comportamiento de los clientes. Se utilizaron herramientas de SQL, Python y Power BI para extraer, transformar y visualizar los datos.
Fuente de Datos

Los datos provienen de una base de datos en MySQL, con información de:

•	Clientes: Identificadores y detalles básicos (sin datos sensibles).
•	Facturas: Registros de ventas realizadas.
•	Productos: Catálogo de uniformes.
•	Ventas: Detalle de productos vendidos por factura.
Herramientas Utilizadas:

•	Excel: Para limpieza de datos para SQL
•	SQL (MySQL): Para consultas y extracción de datos.
•	Python (Pandas, Matplotlib, Seaborn): Para  análisis y visualización de datos.
•	Power BI: Creación de dashboards interactivos.

Análisis Realizados

1.	Análisis de Ventas Generales:
o	Tendencias de ventas en la temporada.
o	Volumen de ventas total.
2.	Análisis de Productos:
o	Identificación de los uniformes con mayor demanda.
o	Identificación de prendas con mayor valor de ventas
o	Categoría con mayor ventas
3.	Clientes y Facturas:
o	Clientes con mayor volumen de compra.
o	Ticket de venta promedio.
o	Clientes con mayor número de facturas
o	Conteo de productos en facturas
4.	Uniformes pendientes por falta de stock:
o	Identificación de prendas con pendientes.
o	Identificación de categorías con mas pendientes
o	Discriminación de valor de ventas pendientes y porcentajes de estos

Dashboards en Power BI:

Se crearon 4 dashboards interactivos:

1.	General:  Visión general de las ventas y tendencias.
2.	Productos: Análisis detallado de los productos más vendidos.
3.	Clientes y Facturas: Patrón de compra de clientes y volumen de facturas.
4.	Pendientes: Ventas de productos que quedaron pendientes por falta de stock
Cómo Reproducir el Proyecto:
1.	Base de Datos: Importar las tablas en MySQL de CSV.
2.	SQL: Ejecutar las consultas para extraer datos.
3.	Python: Correr los scripts para análisis y visualización.
4.	Power BI: Cargar los datos y explorar los dashboards.

Conclusiones
•	Patrones de Venta: Se observó que la demanda de uniformes es altamente estacional, con un pico significativo previo al inicio del año escolar.

•	Productos Más Vendidos: Las camisetas de educación física y ciertos uniformes específicos destacaron como los más vendidos, representando un porcentaje importante del total de ventas.

•	Impacto del Stock en las Ventas: Se identificó que la falta de stock generó una cantidad considerable de ventas pendientes, especialmente en la categoría "La Salle". Esto sugiere una oportunidad de optimización en la gestión de inventario.

•	Comportamiento de Clientes: La mayoría de los clientes realizaron una sola compra, pero un grupo reducido generó múltiples facturas, lo que podría representar una oportunidad para estrategias de fidelización.

•	Ticket Promedio: Se calculó un valor promedio por factura, lo que permite estimar ingresos esperados y ajustar estrategias de ventas.

•	Optimización del Negocio: Con base en estos análisis, se pueden tomar decisiones informadas sobre abastecimiento, promociones y planificación de compras para mejorar la rentabilidad.

Nota: Este repositorio es solo para fines educativos y demostración de habilidades. No tiene licencia específica, pero puedes explorarlo libremente.
