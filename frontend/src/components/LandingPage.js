import React from 'react';
import { Link } from 'react-router-dom';
import './LandingPage.css';

function LandingPage() {
  const modules = [
    { name: 'Pacientes', desc: 'Registro, historial médico' },
    { name: 'Doctores', desc: 'Registro, especialidades' },
    { name: 'Citas', desc: 'Agendamiento, disponibilidad de doctores' },
    { name: 'Facturación', desc: 'Control de pagos, reportes financieros' },
    { name: 'Inventarios', desc: 'Administración de insumos médicos' }
  ];

  return (
    <div className="landing-page">
      <header>
        <h1>odontoERP</h1>
        <p className="subtitle">Gestión simple para odontólogos</p>
      </header>

      <section className="auth-buttons">
        <Link to="/login" className="btn">Iniciar Sesión</Link>
        <Link to="/register" className="btn">Registrarse</Link>
      </section>

      <section className="modules">
        <h2>Módulos del Sistema</h2>
        <div className="modules-grid">
          {modules.map((module, index) => (
            <div key={index} className="module-card">
              <h3>{module.name}</h3>
              <p>{module.desc}</p>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}

export default LandingPage;
