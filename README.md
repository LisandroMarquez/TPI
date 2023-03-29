# Trabajo Práctico Integrador

## Base de Datos II - Año 2023

### Alumnos

- Fernandez, Mateo Emanuel
- Marquez, Lisandro

---

### Explicación del Trabajo

> El proyecto consistía en una billetera virtual en la cual se pudiera agregar las tarjetas del usuario, un presupuesto para gastar, una cierta meta financiera, un seguimiento a los gastos e ingresos (movimientos) e incluso utilizar la billetera como tarjeta de crédito pudiendo realizar pagos que se cobren a futuro como en dicho tipo de tarjetas.

---

### Base de Datos

#### Tablas

- alcanzada
- billetera
- compra_credito
- compras
- ingresos
- movimientos
- pagado
- pagos_mensuales
- pagos_pendientes
- presupuesto
- seguimiento_gastos
- tarjetas
- tipo_documentos
- tipos_cambio
- usuarios

#### Consultas

1. Se desea obtener el balance total de una cuenta, él mismo se calcula haciendo la sumatoria de los movimientos en la cuenta. Se deben sumar todos los balances generalizando a dólares ya que un usuario posee múltiples billeteras en diferentes monedas.
2. Se desea obtener la cantidad total gastada por cuenta en compras por tarjeta de crédito en el último mes, para aquellos usuarios cuyo nombre comience con 'A'.
3. Se desea calcular el monto a pagar para el próximo mes por pagos mensuales, estimando el balance restante al pagar el monto.
4. Se desea conocer si los intercambios de monedas realizados por un usuario generaron ganancia en el último año, comparando el monto gastado con el costo actual.
5. Se desea conocer la moneda más intercambiada en el último mes mostrando, la hora con mayor cantidad de intercambios y un porcentaje de la cantidad intercambiada.

---

> **Copyright © 2023 ITSVillada [*Fernandez & Marquez*].** *All rights reserved.*
