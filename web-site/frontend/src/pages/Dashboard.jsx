import { useAuth } from '../context/AuthContext'
import { Camera, Users, ShoppingBag, Star } from 'lucide-react'

export default function Dashboard() {
  const { user } = useAuth()

  return (
    <div>
      <h1 className="text-3xl font-bold text-gray-900 mb-2">Дашборд</h1>
      <p className="text-gray-600 mb-8">Добро пожаловать, {user?.name}!</p>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard
          title="Всего заказов"
          value="0"
          icon={<ShoppingBag />}
          color="bg-blue-500"
        />
        <StatCard
          title="Клиентов"
          value="0"
          icon={<Users />}
          color="bg-green-500"
        />
        <StatCard
          title="Фотографов"
          value="0"
          icon={<Camera />}
          color="bg-purple-500"
        />
        <StatCard
          title="Отзывов"
          value="0"
          icon={<Star />}
          color="bg-orange-500"
        />
      </div>

      <div className="card">
        <h2 className="text-xl font-semibold mb-4">Последние заказы</h2>
        <p className="text-gray-500">Заказов пока нет</p>
      </div>
    </div>
  )
}

function StatCard({ title, value, icon, color }) {
  return (
    <div className="card">
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
