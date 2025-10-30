import { useState, useEffect } from 'react'
import { ordersAPI, servicesAPI } from '../services/api'
import toast from 'react-hot-toast'
import { Plus, X, Calendar, MapPin, DollarSign, Clock } from 'lucide-react'
import { useAuth } from '../context/AuthContext'

export default function Orders() {
  const { user } = useAuth()
  const [orders, setOrders] = useState([])
  const [services, setServices] = useState([])
  const [loading, setLoading] = useState(true)
  const [showModal, setShowModal] = useState(false)
  const [formData, setFormData] = useState({
    serviceId: '',
    date: '',
    location: '',
  })

  useEffect(() => {
    loadData()
  }, [])

  const loadData = async () => {
    try {
      const [ordersRes, servicesRes] = await Promise.all([
        ordersAPI.getAll(),
        servicesAPI.getAll(),
      ])
      setOrders(ordersRes.data)
      setServices(servicesRes.data)
    } catch (error) {
      toast.error('Ошибка загрузки данных')
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()

    const selectedService = services.find(s => s._id === formData.serviceId)
    if (!selectedService) {
      toast.error('Выберите услугу')
      return
    }

    try {
      await ordersAPI.create({
        serviceId: formData.serviceId,
        service: selectedService.name,
        price: selectedService.price,
        date: formData.date,
        location: formData.location,
      })
      toast.success('Заказ создан')
      closeModal()
      loadData()
    } catch (error) {
      toast.error(error.response?.data?.message || 'Ошибка при создании заказа')
    }
  }

  const closeModal = () => {
    setShowModal(false)
    setFormData({
      serviceId: '',
      date: '',
      location: '',
    })
  }

  const getStatusColor = (status) => {
    const colors = {
      new: 'bg-blue-100 text-blue-800',
      assigned: 'bg-yellow-100 text-yellow-800',
      in_progress: 'bg-purple-100 text-purple-800',
      completed: 'bg-green-100 text-green-800',
      cancelled: 'bg-red-100 text-red-800',
      archived: 'bg-gray-100 text-gray-800',
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
      archived: 'Архивирован',
    }
    return statusMap[status] || status
  }

  if (loading) {
    return <div className="text-center py-8">Загрузка...</div>
  }

  return (
    <div>
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Заказы</h1>
        {user?.role === 'client' && (
          <button
            onClick={() => setShowModal(true)}
            className="btn btn-primary flex items-center gap-2"
          >
            <Plus className="w-5 h-5" />
            Создать заказ
          </button>
        )}
      </div>

      <div className="grid grid-cols-1 gap-6">
        {orders.map((order) => (
          <div key={order._id} className="card">
            <div className="flex justify-between items-start mb-4">
              <div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">{order.service}</h3>
                <span className={`inline-block px-3 py-1 text-xs font-medium rounded-full ${getStatusColor(order.status)}`}>
                  {getStatusText(order.status)}
                </span>
              </div>
              <div className="text-right">
                <div className="text-2xl font-bold text-primary-600">{order.price} ₸</div>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-gray-600">
              <div className="flex items-center gap-2">
                <Calendar className="w-4 h-4" />
                <span>{new Date(order.date).toLocaleDateString('ru-RU', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric',
                  hour: '2-digit',
                  minute: '2-digit'
                })}</span>
              </div>
              <div className="flex items-center gap-2">
                <MapPin className="w-4 h-4" />
                <span>{order.location}</span>
              </div>
              {order.clientId && (
                <div className="flex items-start gap-2">
                  <span className="font-medium">Клиент:</span>
                  <span>{order.clientId.name} ({order.clientId.email})</span>
                </div>
              )}
              {order.photographerId && (
                <div className="flex items-start gap-2">
                  <span className="font-medium">Фотограф:</span>
                  <span>{order.photographerId.name}</span>
                </div>
              )}
            </div>

            {order.comment && (
              <div className="mt-4 p-3 bg-gray-50 rounded-lg">
                <p className="text-sm text-gray-700">{order.comment}</p>
              </div>
            )}
          </div>
        ))}
      </div>

      {orders.length === 0 && (
        <div className="text-center py-12 text-gray-500">
          Заказов пока нет. {user?.role === 'client' && 'Создайте первый заказ!'}
        </div>
      )}

      {/* Modal для создания заказа */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl p-8 max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-2xl font-bold text-gray-900">Новый заказ</h2>
              <button onClick={closeModal} className="text-gray-400 hover:text-gray-600">
                <X className="w-6 h-6" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-6">
              {/* Выбор услуги */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Выберите услугу
                </label>
                <div className="grid grid-cols-1 gap-3">
                  {services.filter(s => s.isActive).map((service) => (
                    <label
                      key={service._id}
                      className={`
                        relative flex items-start p-4 border-2 rounded-xl cursor-pointer transition-all
                        ${formData.serviceId === service._id
                          ? 'border-primary-500 bg-primary-50'
                          : 'border-gray-200 hover:border-primary-300'
                        }
                      `}
                    >
                      <input
                        type="radio"
                        name="service"
                        value={service._id}
                        checked={formData.serviceId === service._id}
                        onChange={(e) => setFormData({ ...formData, serviceId: e.target.value })}
                        className="mt-1 mr-3"
                        required
                      />
                      <div className="flex-1">
                        <div className="flex justify-between items-start mb-1">
                          <h4 className="font-semibold text-gray-900">{service.name}</h4>
                          <span className="text-lg font-bold text-primary-600 ml-4">
                            {service.price} ₸
                          </span>
                        </div>
                        {service.description && (
                          <p className="text-sm text-gray-600 mb-2">{service.description}</p>
                        )}
                        <div className="flex items-center gap-4 text-xs text-gray-500">
                          <div className="flex items-center gap-1">
                            <Clock className="w-3 h-3" />
                            <span>{service.duration} мин</span>
                          </div>
                        </div>
                      </div>
                    </label>
                  ))}
                </div>
                {services.filter(s => s.isActive).length === 0 && (
                  <p className="text-sm text-gray-500 text-center py-4">
                    Нет доступных услуг
                  </p>
                )}
              </div>

              {/* Дата и время */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Дата и время
                </label>
                <div className="relative">
                  <Calendar className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                  <input
                    type="datetime-local"
                    value={formData.date}
                    onChange={(e) => setFormData({ ...formData, date: e.target.value })}
                    className="input pl-10"
                    required
                  />
                </div>
              </div>

              {/* Место проведения */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Место проведения
                </label>
                <div className="relative">
                  <MapPin className="absolute left-3 top-3 w-5 h-5 text-gray-400" />
                  <textarea
                    value={formData.location}
                    onChange={(e) => setFormData({ ...formData, location: e.target.value })}
                    className="input pl-10"
                    rows="2"
                    required
                    placeholder="Укажите адрес или место проведения съемки"
                  />
                </div>
              </div>

              <div className="flex gap-3 pt-4">
                <button type="button" onClick={closeModal} className="btn btn-secondary flex-1">
                  Отмена
                </button>
                <button type="submit" className="btn btn-primary flex-1">
                  Создать заказ
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}
