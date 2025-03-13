# `odonERP` - Proyecto ERP para Consultorios Odontológicos


## 📌 **Introducción al ERP y Configuración del Proyecto en GitHub**  

### 🏆 **Objetivo**  

- Comprender qué es un **ERP** y su importancia en la industria.  
- Configurar el **repositorio en GitHub** y establecer la estructura del proyecto.  
- Documentar los primeros detalles del **modelo de datos** y los **requerimientos** en archivos `.md`.  
- Familiarizarse con el **flujo de trabajo en GitHub** (clonar, hacer commits, push).  

---

## 1️⃣ **¿Qué es un ERP y por qué es importante?**  

Un **ERP (Enterprise Resource Planning)** es un sistema que permite administrar todos los procesos de una empresa en una sola plataforma.  
📌 **Ejemplos de ERPs populares**: SAP, Odoo, NetSuite, Microsoft Dynamics.  

**🔹 Características principales de un ERP**:  
✅ Integra módulos como **Finanzas, Ventas, Inventarios, Recursos Humanos**.  
✅ Permite automatizar procesos y mejorar la **eficiencia** de una empresa.  
✅ Facilita la **toma de decisiones** mediante reportes y análisis de datos.  

**📍 Nuestro Proyecto**: Desarrollaremos un **ERP para el sector salud**, pensado para **consultorios y clínicas**, incluyendo:  

- **Manejo de Pacientes** (historial médico, citas).  
- **Gestión de Doctores y Sucursales**.  
- **Facturación y Finanzas**.  
- **Análisis de Datos para reportes y optimización**.  

---


## 2️⃣ **Configuración del Proyecto en GitHub**  

🔹 **Pasos para comenzar:**  

1. **Clonar el repositorio**  

```bash
git clone https://github.com/usuario/odonoERP.git
cd proyecto-erp
```

2. **Estructura inicial del repositorio**  
📂 `proyecto-erp/`  
   ├── 📂 `docs/` → Contendrá la documentación en `.md`  
   │   ├── `requerimientos.md` → Definición del proyecto  
   │   ├── `modelo_datos.md` → Explicación de la base de datos  
   ├── 📂 `sql/` → Scripts de base de datos  
   ├── 📜 `README.md` → Introducción general del proyecto  

3. **Configurar Git y hacer el primer commit**  

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tuemail@example.com"
git add .
git commit -m "Inicialización del repositorio con estructura base"
git push origin main
``` 



📌 **Explicación del Modelo**  
🔹 `inventarios`: Almacena los productos médicos disponibles.  
🔹 `movimientos_inventario`: Registra **entradas y salidas** de productos.  
🔹 `citas`: Relaciona **pacientes con doctores**.  
🔹 `facturas`: Conecta **pacientes con pagos y consumos de insumos**.  

📌 **Ejemplo de Consulta**:  
Obtener los **productos más usados en la clínica**.  

```sql
SELECT i.nombre, SUM(m.cantidad) AS total_usado
FROM movimientos_inventario m
JOIN inventarios i ON m.inventario_id = i.id
WHERE m.tipo_movimiento = 'salida'
GROUP BY i.nombre
ORDER BY total_usado DESC
LIMIT 5;
```

---
