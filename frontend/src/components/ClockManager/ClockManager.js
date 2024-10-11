import Services from '@/services'

export default {
  data() {
    return {
      items: [],
      loading: true,
      latestClockStatus: null,
      error: null
    }
  },
  mounted() {
    this.getData()
  },
  methods: {
    async getData() {
      try {
        Services.Clocks.getClocksByUserId(1).then((data) => {
          this.items = data.filter((item) => {
            const date = new Date(item.time)
            const dateNow = new Date()
            return (
              date.getFullYear() === dateNow.getFullYear() &&
              date.getMonth() === dateNow.getMonth() &&
              date.getDate() === dateNow.getDate()
            )
          })
          this.items.sort((latest, item) => new Date(latest.time) - new Date(item.time))
          if (this.items.length > 0) {
            console.log(this.getLastClock())
            this.latestClockStatus = this.getLastClock();
          } else {
            this.loading = false
            this.error = 'No clocks found for today'
          }
          this.loading = false
        })
        if (this == null) {
          this.loading = false
          this.error = 'No clocks found'
        }
      } catch (err) {
        this.error = err.message
        this.loading = false
      }
    },

    getLastClock() {
      return this.items[this.items.length -1].status
    },

    async handleCreateClock() {
      var mock = await Services.Clocks.createClock(
        new Date().toISOString(),
        !this.latestClockStatus,
        1
      )
      this.items.push(mock)
      this.error = null
      this.latestClockStatus = !this.latestClockStatus
    }
  }
}
