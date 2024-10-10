import {
  getWorkingTimesByUserId,
  createWorkingTime as createTime,
  updateWorkingTime as updateTime,
  deleteWorkingTime as deleteTime
} from '../../services/workingtimeServices'

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
      startDate: null,
      endDate: null,
      newWorkingTime: {
        start: '',
        end: ''
      },
      isEditing: false,
      editingTime: null
    }
  },
  methods: {
    async getWorkingTimes() {
      try {
        this.loading = true
        this.error = null
        this.workingTimes = await getWorkingTimesByUserId(this.userId, this.startDate, this.endDate)
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
    async createWorkingTime() {
      try {
        await createTime(this.newWorkingTime.start, this.newWorkingTime.end, this.userId)
        this.getWorkingTimes() // Rafraîchir la liste des working times
        this.resetForm()
      } catch (err) {
        this.error = err.message || 'Failed to create working time'
      }
    },
    openEditModal(time) {
      // Ouvre la modal de modification avec les données sélectionnées
      this.newWorkingTime = { ...time }
      this.isEditing = true
      this.editingTime = time
    },
    async updateWorkingTime() {
      try {
        await updateTime(this.newWorkingTime.id, this.newWorkingTime)
        this.getWorkingTimes() // Rafraîchir la liste après modification
        this.resetForm()
      } catch (err) {
        this.error = err.message || 'Failed to update working time'
      }
    },
    async deleteWorkingTime(id) {
      try {
        await deleteTime(id)
        this.getWorkingTimes() // Rafraîchir la liste après suppression
      } catch (err) {
        this.error = err.message || 'Failed to delete working time'
      }
    },
    resetForm() {
      this.newWorkingTime = { start: '', end: '' }
      this.isEditing = false
      this.editingTime = null
    }
  },
  mounted() {
    this.getWorkingTimes()
  }
}
