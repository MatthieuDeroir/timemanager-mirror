import {
  createWorkingTime as createTime,
  deleteWorkingTime as deleteTime,
  getWorkingTimesByUserId,
  updateWorkingTime as updateTime
} from '@/api/workingtimeServices'

export default {
  props: {
    userId: {
      type: [String, Number],
      required: true
    }
  },
  data() {
    return {
      workingTimes: [],
      loading: true,
      error: null,
      nextTempId: 0 // Pour identifier temporairement les nouvelles lignes
    }
  },
  methods: {
    async getWorkingTimes() {
      try {
        this.loading = true
        this.error = null
        this.workingTimes = await getWorkingTimesByUserId(this.userId)
      } catch (err) {
        this.error = err.message || 'An error occurred'
      } finally {
        this.loading = false
      }
    },
    calculateHoursWorked(start, end) {
      const startDate = new Date(start)
      const endDate = new Date(end)
      return ((endDate - startDate) / (1000 * 60 * 60)).toFixed(2)
    },
    addNewWorkingTime() {
      this.workingTimes.push({
        tempId: this.nextTempId++, // Temp ID pour la nouvelle ligne
        start: '',
        end: '',
        isEditing: true
      })
    },
    editWorkingTime(time) {
      // Pré-remplir les champs de date en formatant correctement les dates pour l'input
      time.start = this.formatDateForInput(time.start)
      time.end = this.formatDateForInput(time.end)
      time.isEditing = true
    },
    async saveWorkingTime(time) {
      if (!this.isSameDay(time.start, time.end)) {
        this.error = 'Start and End times must be on the same day.'
        return
      }

      try {
        if (time.id) {
          // Si l'entrée existe déjà, on met à jour
          await updateTime(time.id, { start: time.start, end: time.end })
        } else {
          // Si c'est une nouvelle entrée
          const newTime = await createTime(time.start, time.end, this.userId)
          // Remplacer le tempId par l'ID réel une fois créé
          time.id = newTime.id
        }
        time.isEditing = false
        this.error = null // Effacer l'erreur après une sauvegarde réussie
        this.getWorkingTimes() // Rafraîchir la liste
        this.$emit('workingTimesUpdated', this.workingTimes)
      } catch (err) {
        this.error = err.message || 'Failed to save working time'
      }
    },
    async deleteWorkingTime(idOrTempId) {
      const time = this.workingTimes.find((t) => t.id === idOrTempId || t.tempId === idOrTempId)
      if (time.id) {
        // Si l'entrée existe dans la base, on la supprime
        await deleteTime(time.id)
      }
      // Supprimer l'entrée localement
      this.workingTimes = this.workingTimes.filter(
        (t) => t.id !== idOrTempId && t.tempId !== idOrTempId
      )
      this.$emit('workingTimesUpdated', this.workingTimes)
    },
    isSameDay(start, end) {
      const startDate = new Date(start)
      const endDate = new Date(end)
      // Comparer uniquement l'année, le mois et le jour
      return (
        startDate.getFullYear() === endDate.getFullYear() &&
        startDate.getMonth() === endDate.getMonth() &&
        startDate.getDate() === endDate.getDate()
      )
    },
    formatDateForInput(dateString) {
      const date = new Date(dateString)
      return date.toISOString().slice(0, 16) // Format "YYYY-MM-DDTHH:MM"
    }
  },
  mounted() {
    this.getWorkingTimes()
  }
}