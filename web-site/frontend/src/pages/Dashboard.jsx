import { useState, useEffect } from 'react'
import { useAuth } from '../context/AuthContext'
import { useNavigate } from 'react-router-dom'
import { ordersAPI, servicesAPI, usersAPI } from '../services/api'
import { Camera, Users, ShoppingBag, Star, Briefcase, Plus, ArrowRight } from 'lucide-react'

export default function Dashboard() {
  const { user } = useAuth()
  const navigate = useNavigate()
  const [stats, setStats] = useState({
    orders: 0,
    clients: 0,
    photographers: 0,
    services: 0,
  })
  const [recentOrders, setRecentOrders] = useState([])
  const [recentServices, setRecentServices] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    loadDashboardData()
  }, [])

  const loadDashboardData = async () => {
    try {
      const [ordersRes, servicesRes] = await Promise.all([
        ordersAPI.getAll(),
        servicesAPI.getAll(),
      ])

      // Загружаем пользователей только для админа
      let users = []
      if (user?.role === 'admin') {
        const usersRes = await usersAPI.getAll()
        users = usersRes.data
      }

      const orders = ordersRes.data
      const services = servicesRes.data

      setStats({
        orders: orders.length,
        clients: users.filter(u => u.role === 'client').length,
        photographers: users.filter(u => u.role === 'photographer').length,
        services: services.filter(s => s.isActive).length,
      })

      // Последние 5 заказов
      setRecentOrders(orders.slice(0, 5))

      // Последние 4 услуги для админа
      if (user?.role === 'admin') {
        setRecentServices(services.slice(0, 4))
      }
    } catch (error) {
      console.error('Ошибка загрузки данных:', error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusColor = (status) => {
    const colors = {
      new: 'bg-blue-100 text-blue-800',
      assigned: 'bg-yellow-100 text-yellow-800',
      in_progress: 'bg-purple-100 text-purple-800',
      completed: 'bg-green-100 text-green-800',
      cancelled: 'bg-red-100 text-red-800',
    }
    return colors[status] || 'bg-gray-100 text-gray-800'
  }

  const getStatusText = (status) => {
    const statusMap = {
      new: 'Новый',
      assigned: 'Назначен',
      in_progress: 'В работе',
      completed: 'Завершен',
      cancelled: 'Отменен',
    }
    return statusMap[status] || status
  }

  if (loading) {
    return <div className="text-center py-8">Загрузка...</div>
  }

  return (
    <div>
      <h1 className="text-3xl font-bold text-gray-900 mb-2">Дашборд</h1>
      <p className="text-gray-600 mb-8">Добро пожаловать, {user?.name}!</p>

      {/* Статистика */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard
          title="Всего заказов"
          value={stats.orders}
          icon={<ShoppingBag />}
          color="bg-blue-500"
          onClick={() => navigate('/orders')}
        />
        {user?.role === 'admin' && (
          <>
            <StatCard
              title="Клиентов"
              value={stats.clients}
              icon={<Users />}
              color="bg-green-500"
            />
            <StatCard
              title="Фотографов"
              value={stats.photographers}
              icon={<Camera />}
              color="bg-purple-500"
            />
          </>
        )}
        <StatCard
          title="Активных услуг"
          value={stats.services}
          icon={<Briefcase />}
          color="bg-orange-500"
          onClick={() => navigate('/services')}
        />
      </div>

      {/* Услуги для админа */}
      {user?.role === 'admin' && (
        <div className="mb-8">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-semibold text-gray-900">Управление услугами</h2>
            <button
              onClick={() => navigate('/services')}
              className="text-primary-600 hover:text-primary-700 flex items-center gap-1 text-sm font-medium"
            >
              Все услуги
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            {recentServices.map((service) => (
              <div
                key={service._id}
                className="card hover:shadow-lg transition-shadow cursor-pointer"
                onClick={() => navigate('/services')}
              >
                <div className="flex justify-between items-start mb-2">
                  <h3 className="font-semibold text-gray-900">{service.name}</h3>
                  {!service.isActive && (
                    <span className="px-2 py-1 text-xs bg-gray-200 text-gray-600 rounded">
                      Неактивна
                    </span>
                  )}
                </div>
                <p className="text-2xl font-bold text-primary-600 mb-1">{service.price} ₸</p>
                <p className="text-xs text-gray-500">{service.duration} мин</p>
              </div>
            ))}

            {/* Кнопка добавить услугу */}
            <div
              className="card border-2 border-dashed border-gray-300 hover:border-primary-400 hover:bg-primary-50 transition-all cursor-pointer flex items-center justify-center"
              onClick={() => navigate('/services')}
            >
              <div className="text-center">
                <Plus className="w-8 h-8 text-gray-400 mx-auto mb-2" />
                <p className="text-sm text-gray-600 font-medium">Добавить услугу</p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Последние заказы */}
      <div className="card">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-semibold text-gray-900">Последние заказы</h2>
          <button
            onClick={() => navigate('/orders')}
            className="text-primary-600 hover:text-primary-700 flex items-center gap-1 text-sm font-medium"
          >
            Все заказы
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>

        {recentOrders.length > 0 ? (
          <div className="space-y-3">
            {recentOrders.map((order) => (
              <div
                key={order._id}
                className="p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer"
                onClick={() => navigate('/orders')}
              >
                <div className="flex justify-between items-start mb-2">
                  <div>
                    <h3 className="font-semibold text-gray-900">{order.service}</h3>
                    <p className="text-sm text-gray-600">
                      {new Date(order.date).toLocaleDateString('ru-RU')}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-primary-600">{order.price} ₸</p>
                    <span className={`inline-block mt-1 px-2 py-1 text-xs font-medium rounded-full ${getStatusColor(order.status)}`}>
                      {getStatusText(order.status)}
                    </span>
                  </div>
                </div>
                {order.clientId && (
                  <p className="text-xs text-gray-500">
                    Клиент: {order.clientId.name}
                  </p>
                )}
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center py-8">
            <ShoppingBag className="w-12 h-12 text-gray-300 mx-auto mb-3" />
            <p className="text-gray-500 mb-4">Заказов пока нет</p>
            {user?.role === 'client' && (
              <button
                onClick={() => navigate('/orders')}
                className="btn btn-primary"
              >
                Создать заказ
              </button>
            )}
          </div>
        )}
      </div>
    </div>
  )
}

function StatCard({ title, value, icon, color, onClick }) {
  return (
    <div
      className={`card ${onClick ? 'cursor-pointer hover:shadow-lg transition-shadow' : ''}`}
      onClick={onClick}
    >
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
        </div>
        <div className={`p-4 rounded-lg ${color} text-white`}>
          {icon}
        </div>
      </div>
    </div>
  )
}
