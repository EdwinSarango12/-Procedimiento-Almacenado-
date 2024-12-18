create database Tienda;
use Tienda;

CREATE TABLE cliente (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,  -- Campo para el ID único del cliente
    Nombre VARCHAR(100),                      -- Campo para el nombre del cliente
    Estatura DECIMAL(5,2),                    -- Campo para la estatura del cliente con dos decimales
    FechaNacimiento DATE,                     -- Campo para la fecha de nacimiento del cliente
    Sueldo DECIMAL(10,2)                      -- Campo para el sueldo del cliente con dos decimales
);


DELIMITER //

CREATE PROCEDURE SeleccionarClientes()
BEGIN
    SELECT * FROM cliente;
END //

DELIMITER ;
CALL SeleccionarClientes();

DELIMITER //

CREATE PROCEDURE InsertarCliente(
    IN p_Nombre VARCHAR(100),
    IN p_Estatura DECIMAL(5,2),
    IN p_FechaNacimiento DATE,
    IN p_Sueldo DECIMAL(10,2)
)
BEGIN
    INSERT INTO cliente (Nombre, Estatura, FechaNacimiento, Sueldo)
    VALUES (p_Nombre, p_Estatura, p_FechaNacimiento, p_Sueldo);
END //

DELIMITER ;
CALL InsertarCliente('Juan Pérez', 1.75, '1990-05-15', 30000.50);

-- update
DELIMITER //

CREATE PROCEDURE ActualizarSueldo(
    IN p_ClienteID INT,
    IN p_NuevoSueldo DECIMAL(10,2)
)
BEGIN
    UPDATE cliente
    SET Sueldo = p_NuevoSueldo
    WHERE ClienteID = p_ClienteID;
END //

DELIMITER ;
CALL ActualizarSueldo(1, 35000.00);

-- Delete
DELIMITER //

CREATE PROCEDURE EliminarCliente(
    IN p_ClienteID INT
)
BEGIN
    DELETE FROM cliente
    WHERE ClienteID = p_ClienteID;
END //

DELIMITER ;
CALL EliminarCliente(1);


-- Condicionales 

DELIMITER //

CREATE FUNCTION CalcularEdad(p_FechaNacimiento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_FechaNacimiento, CURDATE());
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE VerificarEdadCliente(
    IN p_ClienteID INT
)
BEGIN
    DECLARE edad INT;
    SELECT CalcularEdad(FechaNacimiento) INTO edad
    FROM cliente
    WHERE ClienteID = p_ClienteID;
    
    IF edad >= 22 THEN
        SELECT CONCAT('El cliente con ID ', p_ClienteID, ' tiene ', edad, ' años, y es mayor o igual a 22.');
    ELSE
        SELECT CONCAT('El cliente con ID ', p_ClienteID, ' tiene ', edad, ' años, y es menor de 22.');
    END IF;
END //

DELIMITER ;

CALL VerificarEdadCliente(1);

CREATE TABLE ordenes (
    OrdenID INT AUTO_INCREMENT PRIMARY KEY,  -- ID único de la orden
    ClienteID INT,                           -- ID del cliente (relación)
    FechaOrden DATE,                         -- Fecha de la orden
    MontoTotal DECIMAL(10,2),                -- Monto total de la orden
    Estado VARCHAR(50),                      -- Estado de la orden (ej: 'Pendiente', 'Completada')
    FOREIGN KEY (ClienteID) REFERENCES cliente(ClienteID) -- Relación con la tabla cliente
);

DELIMITER //

CREATE PROCEDURE InsertarOrden(
    IN p_ClienteID INT,
    IN p_FechaOrden DATE,
    IN p_MontoTotal DECIMAL(10,2),
    IN p_Estado VARCHAR(50)
)
BEGIN
    INSERT INTO ordenes (ClienteID, FechaOrden, MontoTotal, Estado)
    VALUES (p_ClienteID, p_FechaOrden, p_MontoTotal, p_Estado);
END //

DELIMITER ;
CALL InsertarOrden(1, '2024-12-17', 500.00, 'Pendiente');



DELIMITER //

CREATE PROCEDURE ActualizarOrden(
    IN p_OrdenID INT,
    IN p_NuevoEstado VARCHAR(50)
)
BEGIN
    UPDATE ordenes
    SET Estado = p_NuevoEstado
    WHERE OrdenID = p_OrdenID;
END //

DELIMITER ;
CALL ActualizarOrden(1, 'Completada');


DELIMITER //

CREATE PROCEDURE EliminarOrden(
    IN p_OrdenID INT
)
BEGIN
    DELETE FROM ordenes
    WHERE OrdenID = p_OrdenID;
END //

DELIMITER ;
CALL EliminarOrden(1);

















