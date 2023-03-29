-- Creación db
DROP DATABASE IF EXISTS money_manager;
CREATE DATABASE money_manager;
USE money_manager;

-- Tables creation
CREATE TABLE tipo_documentos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  tipo VARCHAR(30)
);

CREATE TABLE usuarios (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50),
  direccion VARCHAR(100),
  identificacion VARCHAR(30),
  tipo_documento_id INT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_tipo_doc FOREIGN KEY (tipo_documento_id) REFERENCES tipo_documentos(id) ON DELETE CASCADE
);

CREATE TABLE billetera (
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario_id INT,
  entidad_bancaria VARCHAR(50),
  numero_cuenta VARCHAR(50),
  CONSTRAINT fk_user_cuenta FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE movimientos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(30),
  billetera_id INT,
  CONSTRAINT fk_cuentas_movimientos FOREIGN KEY (billetera_id) REFERENCES billetera(id) ON DELETE CASCADE
);

CREATE TABLE ingresos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  monto DECIMAL(10,2),
  movimiento_id INT,
  descripcion VARCHAR(60),
  CONSTRAINT fk_movimiento_ingresos FOREIGN KEY (movimiento_id) REFERENCES movimientos(id) ON DELETE CASCADE
);

CREATE TABLE tarjetas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario_id INT,
  entidad_emisora VARCHAR(50),
  numero_tarjeta VARCHAR(50),
  tipo varchar(20),
  fecha_vencimiento DATE,
  cvv VARCHAR(5),
  CONSTRAINT fk_user_tarjeta FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE tipos_cambio (
  id INT PRIMARY KEY AUTO_INCREMENT,
  moneda_origen VARCHAR(10),
  moneda_destino VARCHAR(10),
  tasa DECIMAL(10,4),
  interes DECIMAL(10,2),
  movimiento_id int,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_movimiento_cambio FOREIGN KEY (movimiento_id) REFERENCES movimientos(id) ON DELETE CASCADE
);

CREATE TABLE compras (
  id INT PRIMARY KEY AUTO_INCREMENT,
  movimiento_id INT,
  fecha_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  entidad_comerciante VARCHAR(50),
  descripcion VARCHAR(100),
  monto DECIMAL(10,2),
  moneda VARCHAR(10),
  CONSTRAINT fk_movimiento_compra FOREIGN KEY (movimiento_id) REFERENCES movimientos(id) ON DELETE CASCADE
);

CREATE TABLE pagado (
  id INT PRIMARY KEY AUTO_INCREMENT,
  pagado BOOLEAN
);

CREATE TABLE pagos_mensuales (
  id INT PRIMARY KEY AUTO_INCREMENT,
  movimiento_id INT,
  est_pagado INT,
  entidad_servicio VARCHAR(50),
  descripcion VARCHAR(100),
  monto DECIMAL(10,2),
  moneda VARCHAR(10),
  fecha_vencimiento DATE,
  CONSTRAINT fk_movimientos_pagos FOREIGN KEY (movimiento_id) REFERENCES movimientos(id) ON DELETE CASCADE,
  CONSTRAINT fk_estado FOREIGN KEY (est_pagado) REFERENCES pagado(id) ON DELETE CASCADE
);

CREATE TABLE seguimiento_gastos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  billetera_id INT,
  categoria VARCHAR(50),
  monto DECIMAL(10,2),
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_billetera_gastos FOREIGN KEY (billetera_id) REFERENCES billetera(id) ON DELETE CASCADE
);

CREATE TABLE alcanzada (
  id INT PRIMARY KEY AUTO_INCREMENT,
  alcanzada BOOLEAN
);

CREATE TABLE metas_financieras (
  id INT PRIMARY KEY AUTO_INCREMENT,
  presupuesto_id INT,
  descripcion VARCHAR(100),
  monto DECIMAL(10,2),
  moneda VARCHAR(10),
  fecha_limite DATE,
  id_alcanzada INT,
  CONSTRAINT fk_presupuesto_metas FOREIGN KEY (presupuesto_id) REFERENCES presupuesto(id) ON DELETE CASCADE,
  CONSTRAINT fk_alcanzada FOREIGN KEY (id_alcanzada) REFERENCES alcanzada(id) ON DELETE CASCADE
);

CREATE TABLE presupuesto (
  id INT PRIMARY KEY AUTO_INCREMENT,
  seguimiento_gastos_id INT,
  categoria VARCHAR(50),
  monto_limite DECIMAL(10,2),
  monto_gastado DECIMAL(10,2),
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_gastos_presupuesto FOREIGN KEY (seguimiento_gastos_id) REFERENCES seguimiento_gastos(id) ON DELETE CASCADE
);

CREATE TABLE compra_credito (
  id INT PRIMARY KEY AUTO_INCREMENT,
  monto_total DECIMAL(10,2),
  interes INT,
  nombre VARCHAR(40),
  descripcion VARCHAR(60),
  cantidad_cuotas INT
);

CREATE TABLE pagos_pendientes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  compra_credito_id int,
  movimiento_id int,
  subtotal DECIMAL(10,2),
  estado BOOLEAN,
  plazo_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  plazo_fin TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_user_pagos_pendientes FOREIGN KEY (compra_credito_id) REFERENCES compra_credito(id) ON DELETE CASCADE,
  CONSTRAINT fk_movimiento_pago FOREIGN KEY (movimiento_id) REFERENCES movimientos(id) ON DELETE CASCADE
);

-- Inserts
INSERT INTO tipo_documentos (tipo) VALUES
('Cédula de ciudadanía'),
('Cédula de extranjería'),
('Pasaporte'),
('Tarjeta de identidad'),
('Registro civil');

INSERT INTO usuarios (nombre, direccion, identificacion, tipo_documento_id) VALUES
('María MarquezA', 'Calle 123 # 45-67', '123456789', 1),
('Alan Pérez', 'Carrera 45 # 78-90', '987654321', 2),
('Pedro Rodríguez', 'Avenida 67 # 12-34', '456789123', 3),
('Ana Ramírez', 'Calle 89 # 56-78', '789123456', 4),
('Luis Ambrogio', 'Carrera 12 # 34-56', '321654987', 5);

INSERT INTO billetera (usuario_id, entidad_bancaria, numero_cuenta) VALUES
(1, 'Banco ABC', '1234567890'),
(2, 'Banco XYZ', '0987654321'),
(3, 'Banco DEF', '4567890123'),
(4, 'Banco GHI', '7890123456'),
(5, 'Banco JKL', '3216549870');

INSERT INTO movimientos (nombre, billetera_id) VALUES
('Transferencia', 1),
('Depósito', 2),
('Retiro', 3),
('Compra', 4),
('Pago', 5);

INSERT INTO ingresos (monto, movimiento_id, descripcion) VALUES
(1000.00, 2, 'Salario'),
(500.00, 2, 'Bonificación'),
(1500.00, 2, 'Incentivo'),
(800.00, 2, 'Comisión'),
(2000.00, 2, 'Pago por servicios');

INSERT INTO tarjetas (usuario_id, entidad_emisora, numero_tarjeta, tipo, fecha_vencimiento, cvv) VALUES
(1, 'Banco ABC', '1234567812345678', 'Visa', '2025-12-31', '123'),
(2, 'Banco XYZ', '9876543298765432', 'Mastercard', '2024-11-30', '456'),
(3, 'Banco DEF', '4567890145678901', 'Visa', '2023-10-31', '789'),
(4, 'Banco GHI', '7890123478901234', 'Mastercard', '2022-09-30', '012'),
(5, 'Banco JKL', '3216549832165498', 'Visa', '2021-08-31', '345');

INSERT INTO tipos_cambio (moneda_origen, moneda_destino, tasa, interes, movimiento_id) VALUES
('USD', 'EUR', 0.8465, 2.50, 1),
('USD', 'JPY', 110.35, 3.00, 2),
('EUR', 'JPY', 130.24, 2.75, 3),
('USD', 'CAD', 1.25, 2.25, 4),
('EUR', 'CAD', 1.48, 2.50, 5);

INSERT INTO compras (movimiento_id, entidad_comerciante, descripcion, monto, moneda) VALUES
(1, 'Amazon', 'Compra de libros', 50.00, 'USD'),
(2, 'iTunes', 'Suscripción a Apple Music', 9.99, 'USD'),
(3, 'Netflix', 'Pago de suscripción', 15.99, 'USD'),
(4, 'Walmart', 'Compra de víveres', 75.00, 'CAD'),
(5, 'Fnac', 'Compra de electrónicos', 200.00, 'EUR');

INSERT INTO alcanzada (alcanzada) VALUES
(0), (1);

INSERT INTO metas_financieras (presupuesto_id, descripcion, monto, moneda, fecha_limite, id_alcanzada) VALUES
(1, 'Ahorrar para un viaje en crucero', 5000.00, 'USD', '2023-12-31', 1),
(2, 'Comprar un auto usado', 10000.00, 'MXN', '2023-06-30', 2),
(3, 'Realizar una inversión en acciones', 25000.00, 'EUR', '2024-12-31', 1),
(4, 'Pagar una deuda con tarjeta de crédito', 500.00, 'USD', '2023-04-30', 2),
(5, 'Ahorrar para la universidad de mi hijo', 15000.00, 'CAD', '2028-12-31', 2);

INSERT INTO compra_credito (monto_total, interes, nombre, descripcion, cantidad_cuotas) VALUES
(500.00, 10, 'Compra 1', 'Descripción de la compra 1', 6),
(1000.00, 5, 'Compra 2', 'Descripción de la compra 2', 12),
(2000.00, 7, 'Compra 3', 'Descripción de la compra 3', 24),
(1500.00, 8, 'Compra 4', 'Descripción de la compra 4', 18),
(3000.00, 12, 'Compra 5', 'Descripción de la compra 5', 36);

INSERT INTO pagado (pagado)
VALUES (true), (false);

INSERT INTO pagos_mensuales (movimiento_id, est_pagado, entidad_servicio, descripcion, monto, moneda, fecha_vencimiento) VALUES
(1, 1, 'Entidad 1', 'Pago mensual 1', 100.00, 'USD', '2023-04-10'),
(2, 2, 'Entidad 2', 'Pago mensual 2', 200.00, 'USD', '2023-04-15'),
(3, 1, 'Entidad 3', 'Pago mensual 3', 150.00, 'USD', '2023-04-20'),
(4, 2, 'Entidad 4', 'Pago mensual 4', 300.00, 'USD', '2023-04-25'),
(5, 1, 'Entidad 5', 'Pago mensual 5', 250.00, 'USD', '2023-04-30');

INSERT INTO presupuesto (seguimiento_gastos_id, categoria, monto_limite, monto_gastado) VALUES
(1, 'Comida', 500.00, 0.00),
(1, 'Transporte', 200.00, 50.00),
(2, 'Ropa', 300.00, 200.00),
(2, 'Entretenimiento', 100.00, 0.00),
(1, 'Salud', 1000.00, 250.00);

INSERT INTO seguimiento_gastos (billetera_id, categoria, monto) VALUES
(1, 'Alimentación', 50.00),
(1, 'Transporte', 20.00),
(2, 'Entretenimiento', 100.00),
(2, 'Ropa', 60.00),
(3, 'Comida', 70.00);

INSERT INTO pagos_pendientes (compra_credito_id, movimiento_id, subtotal, estado, plazo_inicio, plazo_fin) VALUES
(1, 2, 150.00, false, '2023-03-29', '2023-04-29'),
(2, 2, 250.00, true, '2023-03-29', '2023-04-29'),
(3, 2, 350.00, false, '2023-03-29', '2023-04-29'),
(4, 2, 450.00, true, '2023-03-29', '2023-04-29'),
(5, 2, 550.00, false, '2023-03-29', '2023-04-29');

-- Querries
-- (1)
SELECT u.nombre,
SUM(IF(tc.moneda_origen = 'USD', i.monto, i.monto/tc.tasa)) + SUM(IF(tc.moneda_origen = 'USD', c.monto, c.monto/tc.tasa)) AS balance_total_usd
FROM usuarios u
JOIN billetera b ON u.id = b.usuario_id
JOIN movimientos m ON b.id = m.billetera_id
JOIN ingresos i ON m.id = i.movimiento_id
JOIN compras c ON m.id = c.movimiento_id
JOIN tipos_cambio tc ON m.id = tc.movimiento_id
GROUP BY u.id;

-- (2)
SELECT u.nombre, SUM(pp.subtotal) AS total_credito
FROM usuarios u
JOIN billetera b ON u.id = b.usuario_id
JOIN movimientos m ON b.id = m.billetera_id
JOIN pagos_pendientes pp ON m.id = pp.movimiento_id
WHERE pp.estado = 1
AND u.nombre like 'A%'
AND pp.plazo_fin >= DATE_ADD(NOW(), INTERVAL 1 MONTH)
GROUP BY u.nombre;

-- (3)
SELECT pm.entidad_servicio, pm.descripcion, pm.monto, pm.moneda, pm.fecha_vencimiento, 
COALESCE(SUM(CASE WHEN pp.estado = 1 THEN pp.subtotal ELSE 0 END), 0) AS pagado, 
COALESCE(SUM(CASE WHEN pp.estado = 0 THEN pp.subtotal ELSE 0 END), 0) AS pendiente, 
COALESCE(SUM(CASE WHEN pp.estado = 0 THEN pp.subtotal ELSE 0 END), 0) - pm.monto AS balance_restante
FROM pagos_mensuales pm
JOIN pagos_pendientes pp ON pm.id = pp.movimiento_id
WHERE pm.fecha_vencimiento >= CURDATE()
AND pm.fecha_vencimiento < DATE_ADD(CURDATE(), INTERVAL 1 MONTH)
GROUP BY pm.id;

-- (4)
SELECT SUM(c.monto) AS monto_gastado,
SUM(c.monto * tc.tasa * (1 + tc.interes)) AS costo_actual,
SUM(c.monto * tc.tasa * (1 + tc.interes)) - SUM(c.monto) AS ganancia
FROM compras c
JOIN movimientos m ON c.movimiento_id = m.id
JOIN tipos_cambio tc ON m.id = tc.movimiento_id
JOIN billetera b ON m.billetera_id = b.id
JOIN usuarios u ON b.usuario_id = u.id
WHERE tc.fecha_actualizacion >= DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- (5)
SELECT moneda_origen,
COUNT(*) AS cantidad_intercambios,
CONCAT(
  ROUND(COUNT(*) * 100 / (
    SELECT COUNT(*) FROM tipos_cambio WHERE fecha_actualizacion >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
  ), 2), '%') AS porcentaje_cantidad_intercambios,
DATE_FORMAT(fecha_actualizacion, '%H:%i') AS hora
FROM tipos_cambio
WHERE fecha_actualizacion >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
GROUP BY moneda_origen,
DATE_FORMAT(fecha_actualizacion, '%H:%i')
ORDER BY cantidad_intercambios
LIMIT 1;
