import { createContext, useContext, useState, useEffect } from 'react'
import { authAPI } from '../services/api'
import toast from 'react-hot-toast'

const AuthContext = createContext(null)

export const useAuth = () => {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider')
  }
  return context
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const token = localStorage.getItem('accessToken')
    const userData = localStorage.getItem('user')

    if (token && userData) {
      setUser(JSON.parse(userData))
    }
    setLoading(false)
  }, [])

  const login = async (credentials) => {
    try {
      const { data } = await authAPI.login(credentials)

      localStorage.setItem('accessToken', data.accessToken)
      localStorage.setItem('refreshToken', data.refreshToken)
      localStorage.setItem('user', JSON.stringify({
        id: data.userId,
        name: data.name,
        email: data.email,
        role: data.role,
      }))

      setUser({
        id: data.userId,
        name: data.name,
        email: data.email,
        role: data.role,
      })

      toast.success(`Добро пожаловать, ${data.name}!`)
      return data
    } catch (error) {
      toast.error(error.response?.data?.message || 'Ошибка входа')
      throw error
    }
  }

  const register = async (userData) => {
    try {
      const { data } = await authAPI.register(userData)

      localStorage.setItem('accessToken', data.accessToken)
      localStorage.setItem('refreshToken', data.refreshToken)
      localStorage.setItem('user', JSON.stringify({
        id: data.userId,
        name: data.name,
        email: data.email,
        role: data.role,
      }))

      setUser({
        id: data.userId,
        name: data.name,
        email: data.email,
        role: data.role,
      })

      toast.success('Регистрация успешна!')
      return data
    } catch (error) {
      toast.error(error.response?.data?.message || 'Ошибка регистрации')
      throw error
    }
  }

  const logout = () => {
    localStorage.clear()
    setUser(null)
    toast.success('Вы вышли из системы')
  }

  return (
    <AuthContext.Provider value={{ user, login, register, logout, loading }}>
      {children}
    </AuthContext.Provider>
  )
}
