import { getWorkingTimesByUserId } from '@/services/workingtimeServices'

export default {
  props: {
    userId: {
      type: [String, Number],
      required: true
    },
    workingTimes: {
      type: Array,
      default: () => [] // Défaut : tableau vide s'il n'y a pas de données
    }
  },
  data() {
    return {
      loading: true,
      error: null,
      startDate: null,
      endDate: null,
      totalHoursByDay: {} // Calcul des heures totales par jour
    }
  },
  methods: {
    /**
     * Récupère les heures de travail pour un utilisateur donné dans une plage de dates optionnelle.
     * @returns {Promise<void>}
     */
    async getWorkingTimes() {
      try {
        this.loading = true
        this.error = null

        // Si les workingTimes sont passés par props, on les utilise
        if (this.workingTimes.length > 0) {
          this.totalHoursByDay = this.calculateTotalHoursByDay(this.workingTimes)
        } else {
          // Sinon, on fait l'appel API pour récupérer les heures de travail
          const fetchedWorkingTimes = await getWorkingTimesByUserId(
            this.userId,
            this.startDate,
            this.endDate
          )
          this.totalHoursByDay = this.calculateTotalHoursByDay(fetchedWorkingTimes)
        }
      } catch (err) {
        this.error = err.message || 'An error occurred'
      } finally {
        this.loading = false
      }
    },

    /**
     * Calcule le total des heures travaillées par jour à partir des heures de travail.
     * @param {Array} workingTimes - Tableau des heures de travail
     * @returns {Object} - Objet avec les dates comme clés et les heures totales travaillées comme valeurs
     */
    calculateTotalHoursByDay(workingTimes) {
      const totalHoursByDay = {}

      workingTimes.forEach((time) => {
        const startDate = new Date(time.start)
        const endDate = new Date(time.end)
        const dateKey = startDate.toLocaleDateString()
        const hoursWorked = (endDate - startDate) / (1000 * 60 * 60) // Convertir en heures

        if (totalHoursByDay[dateKey]) {
          totalHoursByDay[dateKey] += hoursWorked
        } else {
          totalHoursByDay[dateKey] = hoursWorked
        }
      })

      return totalHoursByDay
    }
  },

  mounted() {
    this.getWorkingTimes()
  },

  watch: {
    workingTimes: {
      handler(newWorkingTimes) {
        this.totalHoursByDay = this.calculateTotalHoursByDay(newWorkingTimes)
      },
      deep: true, // Permet de surveiller les changements à l'intérieur de l'objet
      immediate: true // Recalculer immédiatement si workingTimes existe déjà
    }
  }
}
