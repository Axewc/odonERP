# **🖥️ Introducción a Flask, Jinja y PostgreSQL - Fundamentos Teóricos**  

## **📌 Objetivo de la Clase**  
- Comprender qué es un **framework** y cómo Flask encaja en el ecosistema de desarrollo web.  
- Aprender los conceptos de **Jinja2**, **SQLAlchemy** y **ORM**.  
- Entender la diferencia entre una **API** y una **aplicación web tradicional**.  
- Conocer los fundamentos de **HTTP** y los métodos `GET`, `POST`, etc.  
- Explicar qué es un **CRUD** y su importancia en sistemas de información.  

---

## **📚 1. ¿Qué es un Framework?**  

📌 Un **framework** es un conjunto de herramientas, librerías y convenciones que facilitan el desarrollo de software.  

🔹 **Diferencias entre Framework y Librería:**  
| Característica   | Librería | Framework |
|-----------------|----------|-----------|
| Control de flujo | Lo controlas tú | Lo maneja el framework |
| Independencia   | Se usa cuando lo necesitas | Define la estructura del proyecto |
| Ejemplo        | NumPy (Python) | Flask (Python), Django (Python), React (JS) |

📌 **Ejemplo:**  
- Si usas una **librería**, tú decides cuándo llamarla.  
- Si usas un **framework**, este impone reglas y estructuras para organizar tu código.  

**💡 ¿Por qué usar Flask?**  
- Es un **microframework**, lo que significa que es liviano y flexible.  
- Nos permite construir **aplicaciones web y APIs** con poca configuración inicial.  
- Facilita la integración con bases de datos como **PostgreSQL** a través de **SQLAlchemy**.  

---

## **📚 2. ¿Qué es Flask?**  

📌 **Flask** es un framework web de Python que permite construir aplicaciones web de manera sencilla.  

🔹 **Historia y comparación con otros frameworks:**  
| Framework | Lenguaje | Características |
|-----------|----------|----------------|
| Flask | Python | Microframework, ligero y flexible |
| Django | Python | Full-stack, con ORM y administración integrada |
| Express.js | JavaScript | Popular para backend con Node.js |

📌 **Arquitectura de Flask:**  
Flask se basa en **rutas**, **vistas** y **plantillas HTML** para generar páginas dinámicas.  

- 🔹 **Rutas**: Determinan qué contenido se muestra según la URL.  
- 🔹 **Vistas**: Son funciones en Python que devuelven HTML o JSON.  
- 🔹 **Plantillas HTML**: Se generan dinámicamente con **Jinja2**.  

---

## **📚 3. ¿Qué es Jinja2?**  

📌 **Jinja2** es un motor de plantillas que permite generar HTML dinámico en Flask.  

🔹 **¿Por qué usar Jinja2?**  
- Permite insertar variables de Python en HTML.  
- Facilita la reutilización de código con **herencia de plantillas**.  
- Permite construir interfaces web dinámicas sin necesidad de JavaScript del lado del cliente.  

📌 **Ejemplo:** Código Jinja2 en un template de Flask.  

```html
<ul>
    {% for paciente in pacientes %}
        <li>{{ paciente.nombre }} {{ paciente.apellido }}</li>
    {% endfor %}
</ul>
```

📌 **Beneficios frente a generar HTML manualmente:**  
- Código más limpio y modular.  
- Separación clara entre la lógica y la presentación.  

---

## **📚 4. ¿Qué es SQLAlchemy y un ORM?**  

📌 **SQLAlchemy** es una herramienta que nos permite interactuar con bases de datos en Flask de manera más estructurada.  

🔹 **Definición de ORM (Object-Relational Mapping):**  
- Permite manipular bases de datos mediante **objetos** en lugar de escribir SQL manualmente.  
- Convierte **tablas en clases** y **registros en objetos Python**.  

📌 **Ventajas de usar un ORM:**  
- Evita escribir SQL directamente.  
- Código más portable y mantenible.  
- Protección contra inyecciones SQL.  

📌 **Ejemplo conceptual:**  

| SQL Tradicional | Con ORM (SQLAlchemy) |
|-----------------|---------------------|
| `SELECT * FROM pacientes;` | `Paciente.query.all()` |

---

## **📚 5. ¿Qué es una API?**  

📌 Una **API (Application Programming Interface)** permite que distintas aplicaciones se comuniquen entre sí.  

🔹 **Ejemplo de APIs comunes:**  
- La API de Google Maps permite integrar mapas en aplicaciones.  
- La API de OpenWeather brinda información climática en tiempo real.  

📌 **Diferencia entre API y Aplicación Web Tradicional**  

| Característica | API REST | Aplicación Web Tradicional |
|--------------|----------|--------------------------|
| Respuesta | JSON o XML | HTML renderizado en el servidor |
| Consumo | Lo usan otras apps o frontend | Lo consume directamente el usuario en el navegador |
| Ejemplo | API de Twitter | Gmail |

📌 **💡 ¿Por qué no construiremos solo una API en esta fase?**  
- Queremos **visualizar** la aplicación desde el navegador sin necesidad de un frontend independiente.  
- En esta etapa, nos enfocamos en aprender Flask con **Jinja2** y SQLAlchemy.  

---

## **📚 6. HTTP y Métodos `GET`, `POST`, etc.**  

📌 **HTTP** es el protocolo de comunicación en la web.  

🔹 **Principales métodos de HTTP:**  
| Método | Función |
|--------|---------|
| `GET` | Obtener información (leer datos) |
| `POST` | Enviar información (crear datos) |
| `PUT` | Modificar un recurso existente |
| `DELETE` | Eliminar un recurso |

📌 **Ejemplo conceptual:**  
| Acción | Método HTTP |
|--------|-------------|
| Consultar la lista de pacientes | `GET /pacientes` |
| Registrar un nuevo paciente | `POST /pacientes` |
| Editar información de un paciente | `PUT /paciente/1` |
| Eliminar un paciente | `DELETE /paciente/1` |

---

## **📚 7. ¿Qué es un CRUD?**  

📌 **CRUD** son las operaciones fundamentales en cualquier aplicación que manipule datos.  

🔹 **Significado de CRUD:**  
| Operación | SQL | Método HTTP |
|-----------|------|-------------|
| **Create** (Crear) | `INSERT INTO` | `POST` |
| **Read** (Leer) | `SELECT` | `GET` |
| **Update** (Actualizar) | `UPDATE` | `PUT` |
| **Delete** (Eliminar) | `DELETE` | `DELETE` |

📌 **Ejemplo de un CRUD en una aplicación médica:**  
- **Create**: Registrar un paciente en la base de datos.  
- **Read**: Mostrar una lista de pacientes en la interfaz web.  
- **Update**: Modificar la información de un paciente.  
- **Delete**: Eliminar un paciente del sistema.  

📌 **Importancia de CRUD en el desarrollo de software:**  
- Es la base de cualquier aplicación interactiva.  
- Permite gestionar datos de manera estructurada y eficiente.  

---

## **📌 Reflexión Final**  

✅ Ahora entendemos la **arquitectura básica** de Flask y cómo interactúa con Jinja2 y SQLAlchemy.  
✅ Conocemos la diferencia entre **APIs y Aplicaciones Web Tradicionales**.  
✅ Hemos aprendido qué es **HTTP, CRUD y cómo se relacionan con SQL**.  
✅ En la próxima clase, **implementaremos un CRUD real** con Flask y PostgreSQL.  

---

## **📅 Próxima Clase: Implementación Práctica de CRUD en Flask**  
📝 **Tarea:** Reflexionar sobre cómo podríamos estructurar el CRUD de pacientes dentro de nuestra aplicación.  

---

📌 **¿Necesitas algún ajuste en la estructura antes de finalizar la clase?** 🚀