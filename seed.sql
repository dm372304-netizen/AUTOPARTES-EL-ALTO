-- Datos de prueba minimos (ejecutar despues de schema.sql)
INSERT INTO usuario (nombre, username, password, rol) VALUES
 ('Dueno AutoPartes', 'admin',    'hash_demo', 'ADMIN'),
 ('Carlos Mamani',    'cmamani',  'hash_demo', 'VENDEDOR'),
 ('Luis Quispe',      'lquispe',  'hash_demo', 'ALMACENERO');

INSERT INTO categoria (nombre, descripcion) VALUES
 ('Filtros',  'Filtros de aceite, aire y combustible'),
 ('Frenos',   'Pastillas, discos y liquido de frenos'),
 ('Motor',    'Bujias, correas y empaques');

INSERT INTO proveedor (nombre, telefono, direccion) VALUES
 ('Importadora Andina', '70011223', 'Av. 6 de Marzo, El Alto'),
 ('Repuestos del Sur',  '71122334', 'Zona Ceja, El Alto');

INSERT INTO producto (codigo_barras, nombre, precio_venta, stock_actual, stock_minimo, id_categoria) VALUES
 ('7700000000011', 'Filtro de aceite Toyota',  45.00, 3, 10, 1),
 ('7700000000028', 'Pastillas de freno delanteras', 180.00, 12, 5, 2),
 ('7700000000035', 'Bujia NGK',                 25.00, 40, 20, 3),
 ('7700000000042', 'Correa de distribucion',   220.00, 2, 4, 3),
 ('7700000000059', 'Filtro de aire universal',  60.00, 15, 6, 1);

INSERT INTO venta (fecha, total, metodo_pago, id_usuario) VALUES
 (CURRENT_TIMESTAMP - INTERVAL '2 days', 205.00, 'EFECTIVO', 2),
 (CURRENT_TIMESTAMP - INTERVAL '1 day',   75.00, 'QR',       2),
 (CURRENT_TIMESTAMP,                     230.00, 'EFECTIVO', 2);

INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES
 (1, 1, 1,  45.00,  45.00),
 (1, 2, 1, 160.00, 160.00),
 (2, 3, 3,  25.00,  75.00),
 (3, 3, 2,  25.00,  50.00),
 (3, 2, 1, 180.00, 180.00);
