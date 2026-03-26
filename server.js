// ============================================================
// server.js - Backend Node.js
// Tarea 1, Bases 1
// ============================================================

const express = require('express');
const sql = require('mssql/msnodesqlv8');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

const dbConfig = {
    server: 'localhost',
    database: 'EmpleadosDB',
    options: {
        trustedConnection: true,
        trustServerCertificate: true
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

app.get('/api/health', async (req, res) => {
    try {
        await getPool();
        res.json({ ok: true, mensaje: 'Conexión base establecida.' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ ok: false, mensaje: 'Error de conexión.' });
    }
});

app.get('/api/empleados', async (req, res) => {
    try {
        const pool = await getPool();
 
        const result = await pool.request()
            .output('outResultCode', sql.Int)           // @outResultCode OUTPUT
            .execute('dbo.sp_ObtenerEmpleados');
 
        const resultCode = result.output.outResultCode;
 
        if (resultCode !== 0) {
            return res.status(500).json({
                ok: false,
                mensaje: 'Error interno en la base de datos.',
                codigo: resultCode
            });
        }
 
        res.json({
            ok: true,
            empleados: result.recordset
        });
        
    } catch (err) {
        console.error(err);
        res.status(500).json({ ok: false, mensaje: 'Error interno del servidor.' });
    }
});

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
            .input('inNombre', sql.VarChar(128), nombre)    // @inNombre VARCHAR(128)
            .input('inSalario', sql.Money, salario)         // @inSalario MONEY
            .output('outResultCode', sql.Int)               // @outResultCode OUTPUT
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
        console.error(err);
        res.status(500).json({ ok: false, mensaje: 'Error interno del servidor.' });
    }
});

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});