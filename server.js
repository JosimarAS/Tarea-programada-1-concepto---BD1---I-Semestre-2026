// ============================================================
// server.js - Backend Node.js
// Tarea 1, Bases 1
// ============================================================

const express = require('express');
const sql = require('mssql');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Configuración de los datos de la BD
const dbConfig = {
    server: 'localhost',
    database: 'EmpleadosDB',
    user: 'developer_tarea1',
    password: 'Tarea1',
    options: {
        trustServerCertificate: true,
        encrypt: false
    }
};

let pool = null;

async function getPool() {
    if (!pool) {
        pool = await sql.connect(dbConfig);
    }
    return pool;
}

app.use(cors());
app.use(express.json());
app.use(express.static(__dirname));

// Ruta para listar empleados
app.get('/api/empleados', async (req, res) => {
    try {
        const pool = await getPool();
 
        const result = await pool.request()
            .output('outResultCode', sql.Int) 
            .execute('dbo.sp_ObtenerEmpleados');
 
        if (result.output.outResultCode !== 0) {
            return res.status(500).json({
                ok: false,
                mensaje: 'Error interno en la base de datos al listar.'
            });
        }
 
        res.json({
            ok: true,
            empleados: result.recordset
        });
        
    } catch (err) {
        console.error("Error al listar", err);
        res.status(500).json({ ok: false, mensaje: 'Error al conectar con el servidor SQL.' });
    }
});


// Ruta para guardar los empleados
app.post('/api/empleados', async (req, res) => {
    const { nombre, salario } = req.body;

    if (!nombre || salario === undefined || salario === null) {
        return res.status(400).json({
            ok: false,
            mensaje: 'Nombre y salario son requeridos.'
        });
    }

    try {
        const pool = await getPool();
 
        const result = await pool.request()
            .input('inNombre', sql.VarChar(64), nombre)   
            .input('inSalario', sql.Money, salario)         
            .output('outResultCode', sql.Int)               
            .execute('dbo.sp_InsertarEmpleado');
 
        const resultCode = result.output.outResultCode;
 
        if (resultCode === 50002) {
            return res.status(409).json({
                ok: false,
                mensaje: 'Ya existe un empleado con ese nombre.'
            });
        }
 
        if (resultCode !== 0) {
            return res.status(500).json({
                ok: false,
                mensaje: 'Error interno en la base de datos.',
                codigo: resultCode
            });
        }
 
        res.json({
            ok: true,
            mensaje: 'Empleado insertado correctamente.'
        });
    } catch (err) {
        console.error("Error al insertar:", err);
        res.status(500).json({ ok: false, mensaje: 'Error interno del servidor.' });
    }
});


// Esto de acá abajo está hecho así para que se pueda conectar desde otra máquina
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Servidor Node encendido en http://0.0.0.0:${PORT}`);
    console.log(`Acceso local:  http://localhost:${PORT}`);

    // Este último se deja de lado por ahora
    // console.log(`Acceso en red: http:// IP VPN :${PORT}`);
});
