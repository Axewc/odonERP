import React from 'react';
import { Routes, Route, Link, useNavigate } from 'react-router-dom';
import './Dashboard.css';

// Componentes placeholder para los módulos
const ModulePlaceholder = ({ name }) => (
  <div className="module-placeholder">
    <h2>Módulo de {name}</h2>
    <p>Módulo en desarrollo</p>
  </div>
);

function Dashboard() {
  const navigate = useNavigate();
  const user = JSON.parse(localStorage.getItem('user'));

  // Verificar si el usuario está autenticado
  React.useEffect(() => {
    if (!user) {
      navigate('/login');
    }
  }, [user, navigate]);

  const handleLogout = () => {
    localStorage.removeItem('user');
    navigate('/');
  };

  const modules = [
    { path: 'pacientes', name: 'Pacientes' },
    { path: 'doctores', name: 'Doctores' },
    { path: 'citas', name: 'Citas' },
    { path: 'facturacion', name: 'Facturación' },
    { path: 'inventarios', name: 'Inventarios' }
  ];

  return (
    <div className="dashboard">
      <nav className="sidebar">
        <div className="user-info">
          <h3>Bienvenido</h3>
          <p>{user?.nombre}</p>
        </div>
        <ul className="nav-links">
          {modules.map((module) => (
            <li key={module.path}>
              <Link to={module.path}>{module.name}</Link>
            </li>
          ))}
        </ul>
        <button onClick={handleLogout} className="logout-btn">
          Cerrar Sesión
        </button>
      </nav>

      <main className="main-content">
        <Routes>
          <Route path="/" element={<h2>Seleccione un módulo</h2>} />
          {modules.map((module) => (
            <Route
              key={module.path}
              path={module.path}
              element={<ModulePlaceholder name={module.name} />}
            />
          ))}
        </Routes>
      </main>
    </div>
  );
}

export default Dashboard;
