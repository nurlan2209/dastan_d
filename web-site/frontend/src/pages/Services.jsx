import { useState, useEffect } from 'react'
import { servicesAPI } from '../services/api'
import toast from 'react-hot-toast'
import { Plus, Edit2, Trash2, X } from 'lucide-react'
import { useAuth } from '../context/AuthContext'

export default function Services() {
  const { user } = useAuth()
  const [services, setServices] = useState([])
  const [loading, setLoading] = useState(true)
  const [showModal, setShowModal] = useState(false)
  const [editingService, setEditingService] = useState(null)
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    price: '',
    duration: '',
    isActive: true,
  })

  useEffect(() => {
    loadServices()
  }, [])

  const loadServices = async () => {
    try {
      const { data } = await servicesAPI.getAll()
      setServices(data)
    } catch (error) {
      toast.error('Ошибка загрузки услуг')
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()

    try {
      if (editingService) {
        await servicesAPI.update(editingService._id, formData)
        toast.success('Услуга обновлена')
      } else {
        await servicesAPI.create(formData)
        toast.success('Услуга создана')
      }

      closeModal()
      loadServices()
    } catch (error) {
      toast.error(error.response?.data?.message || 'Ошибка при сохранении')
    }
  }

  const handleEdit = (service) => {
    setEditingService(service)
    setFormData({
      name: service.name,
      description: service.description,
      price: service.price,
      duration: service.duration,
      isActive: service.isActive,
    })
    setShowModal(true)
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Вы уверены, что хотите удалить эту услугу?')) {
      return
    }

    try {
      await servicesAPI.delete(id)
      toast.success('Услуга удалена')
      loadServices()
    } catch (error) {
      toast.error('Ошибка при удалении')
    }
  }

  const closeModal = () => {
    setShowModal(false)
    setEditingService(null)
    setFormData({
      name: '',
      description: '',
      price: '',
      duration: '',
      isActive: true,
    })
  }

  const isAdmin = user?.role === 'admin'

  if (loading) {
    return <div className="text-center py-8">Загрузка...</div>
  }

  return (
    <div>
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Услуги</h1>
        {isAdmin && (
          <button
            onClick={() => setShowModal(true)}
            className="btn btn-primary flex items-center gap-2"
          >
            <Plus className="w-5 h-5" />
            Добавить услугу
          </button>
        )}
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {services.map((service) => (
          <div key={service._id} className="card">
            <div className="flex justify-between items-start mb-4">
              <div>
                <h3 className="text-xl font-semibold text-gray-900">{service.name}</h3>
                {!service.isActive && (
                  <span className="inline-block mt-1 px-2 py-1 text-xs bg-gray-200 text-gray-600 rounded">
                    Неактивна
                  </span>
                )}
              </div>
              {isAdmin && (
                <div className="flex gap-2">
                  <button
                    onClick={() => handleEdit(service)}
                    className="text-blue-600 hover:text-blue-800"
                  >
                    <Edit2 className="w-5 h-5" />
                  </button>
                  <button
                    onClick={() => handleDelete(service._id)}
                    className="text-red-600 hover:text-red-800"
                  >
                    <Trash2 className="w-5 h-5" />
                  </button>
                </div>
              )}
            </div>

            <p className="text-gray-600 mb-4">{service.description}</p>

            <div className="flex justify-between items-center text-sm">
              <span className="text-gray-500">Длительность: {service.duration} мин</span>
              <span className="text-2xl font-bold text-primary-600">{service.price} ₸</span>
            </div>
          </div>
        ))}
      </div>

      {services.length === 0 && (
        <div className="text-center py-12 text-gray-500">
          Услуг пока нет. {isAdmin && 'Создайте первую услугу!'}
        </div>
      )}

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl p-8 max-w-md w-full mx-4">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-2xl font-bold text-gray-900">
                {editingService ? 'Редактировать услугу' : 'Новая услуга'}
              </h2>
              <button onClick={closeModal} className="text-gray-400 hover:text-gray-600">
                <X className="w-6 h-6" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Название услуги
                </label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="input"
                  required
                  placeholder="Например: Фотосъемка портфолио"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Описание
                </label>
                <textarea
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  className="input"
                  rows="3"
                  placeholder="Описание услуги"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Цена (₸)
                  </label>
                  <input
                    type="number"
                    value={formData.price}
                    onChange={(e) => setFormData({ ...formData, price: e.target.value })}
                    className="input"
                    required
                    min="0"
                    placeholder="10000"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Длительность (мин)
                  </label>
                  <input
                    type="number"
                    value={formData.duration}
                    onChange={(e) => setFormData({ ...formData, duration: e.target.value })}
                    className="input"
                    required
                    min="0"
                    placeholder="60"
                  />
                </div>
              </div>

              <div className="flex items-center gap-2">
                <input
                  type="checkbox"
                  id="isActive"
                  checked={formData.isActive}
                  onChange={(e) => setFormData({ ...formData, isActive: e.target.checked })}
                  className="w-4 h-4 text-primary-600 rounded"
                />
                <label htmlFor="isActive" className="text-sm font-medium text-gray-700">
                  Активная услуга
                </label>
              </div>

              <div className="flex gap-3 mt-6">
                <button type="button" onClick={closeModal} className="btn btn-secondary flex-1">
                  Отмена
                </button>
                <button type="submit" className="btn btn-primary flex-1">
                  {editingService ? 'Сохранить' : 'Создать'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}
