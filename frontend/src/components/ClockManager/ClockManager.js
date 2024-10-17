import { getClocksByUserId } from '@/api/clockServices.js'
import LoaderComponent from '@components/Loader/LoaderComponent.vue'

export default {
  props: {
    userId: {
      type: [String, Number],
      required: true
    }
  },
  components: {
    LoaderComponent
  },
  data() {
    return {
      items: [],
      loading: true,
      currentClockStatus: null,
      error: null,
      date: null
    }
  },
  mounted() {
    this.getData()
  },
  methods: {
    async getData() {
      try {
        Services.Clocks.getClocksByUserId(this.userId).then((data) => {
          this.items = data.filter((item) => {
            const date = new Date(item.time)
            const dateNow = new Date()
            return (
              date.getFullYear() === dateNow.getFullYear() &&
              date.getMonth() === dateNow.getMonth() &&
              date.getDate() === dateNow.getDate()
            )
          })
          this.items.sort((current, item) => new Date(current.time) - new Date(item.time))
          if (this.items.length > 0) {
            this.date = this.getDate()
            this.currentClockStatus = this.getLastClock()
          }
          this.loading = false
        })
      } catch (err) {
        this.error = err.message
        this.loading = false
      }
    },

    getLastClock() {
      return this.items[this.items.length - 1].status
    },

    async handleCreateClock() {
      var mock = await Services.Clocks.createClock(
        new Date().toISOString(),
        !this.currentClockStatus,
        1
      )
      this.items.push(mock)
      this.error = null
      this.currentClockStatus = !this.currentClockStatus
    },

    getDate() {
      const rowDate = new Date(this.items[0].time)
      return rowDate.toLocaleDateString('en-GB', {
        day: '2-digit',
        month: 'long',
        year: 'numeric'
      })
    },
    getTime(item) {
      const rowDate = new Date(item.time)
      return rowDate.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' })
    }
  }
}