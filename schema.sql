-- ============================================================
-- AutoPartes El Alto - Sistema de gestion de ventas e inventario
-- Modelo relacional (PostgreSQL 16)
-- Autor: Andre Ivan Rojas Valeriano - H3 Tarea 3
-- ============================================================

CREATE TABLE usuario (
    id        SERIAL        PRIMARY KEY,
    nombre    VARCHAR(100)  NOT NULL,
    username  VARCHAR(50)   NOT NULL UNIQUE,
    password  VARCHAR(255)  NOT NULL,          -- hash, nunca texto plano
    rol       VARCHAR(20)   NOT NULL
              CHECK (rol IN ('VENDEDOR', 'ALMACENERO', 'ADMIN'))
);

CREATE TABLE categoria (
    id           SERIAL       PRIMARY KEY,
    nombre       VARCHAR(80)  NOT NULL UNIQUE,
    descripcion  VARCHAR(255)
);

CREATE TABLE proveedor (
    id         SERIAL        PRIMARY KEY,
    nombre     VARCHAR(100)  NOT NULL,
    telefono   VARCHAR(20),
    direccion  VARCHAR(200)
);

CREATE TABLE producto (
    id            SERIAL         PRIMARY KEY,
    codigo_barras VARCHAR(50)    NOT NULL UNIQUE,
    nombre        VARCHAR(120)   NOT NULL,
    precio_venta  NUMERIC(10,2)  NOT NULL CHECK (precio_venta >= 0),
    stock_actual  INTEGER        NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo  INTEGER        NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
    id_categoria  INTEGER        NOT NULL,
    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria) REFERENCES categoria (id)
);

CREATE TABLE venta (
    id           SERIAL         PRIMARY KEY,
    fecha        TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total        NUMERIC(12,2)  NOT NULL DEFAULT 0 CHECK (total >= 0),
    metodo_pago  VARCHAR(30)    NOT NULL DEFAULT 'EFECTIVO',
    id_usuario   INTEGER        NOT NULL,
    CONSTRAINT fk_venta_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id)
);

CREATE TABLE detalle_venta (
    id               SERIAL         PRIMARY KEY,
    id_venta         INTEGER        NOT NULL,
    id_producto      INTEGER        NOT NULL,
    cantidad         INTEGER        NOT NULL CHECK (cantidad > 0),
    precio_unitario  NUMERIC(10,2)  NOT NULL CHECK (precio_unitario >= 0),
    subtotal         NUMERIC(12,2)  NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_detventa_venta
        FOREIGN KEY (id_venta) REFERENCES venta (id) ON DELETE CASCADE,
    CONSTRAINT fk_detventa_producto
        FOREIGN KEY (id_producto) REFERENCES producto (id)
);

CREATE TABLE compra (
    id            SERIAL         PRIMARY KEY,
    fecha         TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total         NUMERIC(12,2)  NOT NULL DEFAULT 0 CHECK (total >= 0),
    id_proveedor  INTEGER        NOT NULL,
    id_usuario    INTEGER        NOT NULL,
    CONSTRAINT fk_compra_proveedor
        FOREIGN KEY (id_proveedor) REFERENCES proveedor (id),
    CONSTRAINT fk_compra_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id)
);

CREATE TABLE detalle_compra (
    id             SERIAL         PRIMARY KEY,
    id_compra      INTEGER        NOT NULL,
    id_producto    INTEGER        NOT NULL,
    cantidad       INTEGER        NOT NULL CHECK (cantidad > 0),
    costo_unitario NUMERIC(10,2)  NOT NULL CHECK (costo_unitario >= 0),
    subtotal       NUMERIC(12,2)  NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_detcompra_compra
        FOREIGN KEY (id_compra) REFERENCES compra (id) ON DELETE CASCADE,
    CONSTRAINT fk_detcompra_producto
        FOREIGN KEY (id_producto) REFERENCES producto (id)
);

-- Indices sobre llaves foraneas de consulta frecuente
CREATE INDEX idx_producto_categoria  ON producto (id_categoria);
CREATE INDEX idx_venta_fecha         ON venta (fecha);
CREATE INDEX idx_detventa_producto   ON detalle_venta (id_producto);
