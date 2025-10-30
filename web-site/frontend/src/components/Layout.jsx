import { Outlet, Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import { LogOut, Camera, LayoutDashboard, ShoppingBag, BarChart3, Briefcase } from 'lucide-react'

export default function Layout() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Sidebar */}
      <aside className="fixed left-0 top-0 h-full w-64 bg-white border-r border-gray-200 p-6">
        <div className="flex items-center gap-2 mb-8">
          <Camera className="w-8 h-8 text-primary-600" />
          <h1 className="text-xl font-bold text-gray-900">Photo Studio</h1>
        </div>

        <nav className="space-y-2">
          <NavLink to="/" icon={<LayoutDashboard />}>Дашборд</NavLink>
          <NavLink to="/orders" icon={<ShoppingBag />}>Заказы</NavLink>
          <NavLink to="/services" icon={<Briefcase />}>Услуги</NavLink>
          {user?.role === 'admin' && (
            <NavLink to="/reports" icon={<BarChart3 />}>Отчеты</NavLink>
          )}
        </nav>

        <div className="absolute bottom-6 left-6 right-6">
          <div className="p-4 bg-gray-50 rounded-lg mb-4">
            <p className="text-sm font-medium text-gray-900">{user?.name}</p>
            <p className="text-xs text-gray-500">{user?.email}</p>
            <span className="inline-block mt-2 px-2 py-1 bg-primary-100 text-primary-800 text-xs rounded">
              {user?.role}
            </span>
          </div>
          <button
            onClick={handleLogout}
            className="w-full flex items-center gap-2 px-4 py-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
          >
            <LogOut size={18} />
            <span>Выйти</span>
          </button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="ml-64 p-8">
        <Outlet />
      </main>
    </div>
  )
}

function NavLink({ to, icon, children }) {
  return (
    <Link
      to={to}
      className="flex items-center gap-3 px-4 py-3 text-gray-700 hover:bg-primary-50 hover:text-primary-700 rounded-lg transition-all"
    >
      {icon}
      <span>{children}</span>
    </Link>
  )
}
