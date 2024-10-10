import Services from "@/services"

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
        Services.Clocks.getClocksByUserId(1).then(data => {
          this.items = data.filter(item => {
            const date = new Date(item.time);
            const dateNow = new Date();
            return (
              date.getFullYear() === dateNow.getFullYear() &&
              date.getMonth() === dateNow.getMonth() &&
              date.getDate() === dateNow.getDate()
            );
          })
          if (this.items.length > 0) {
            this.latestClockStatus = this.getLastClock(this.items);
          } else { 
            this.loading = false;
            this.error = 'No clocks found for today';
          }
          this.loading = false;
        })
          if (this==null) {
              this.loading = false;
              this.error = 'No clocks found';
          }
      } catch (err) {
        this.error = err.message;
        this.loading = false;
      }
    },

    getLastClock(items) {
      return items.reduce((latest, item) => {
        if (!item || !item.time || !latest || !latest.time)
          return latest;
        const currentClockDate = new Date(item.time);
        const latestClockDate = new Date(latest.time);
        return currentClockDate > latestClockDate ? item.status : latest.status;
      },);
    },

    async handleCreateClock(){
      await Services.Clocks.createClock(new Date().toISOString(), !this.latestClockStatus, 1);
      await this.getData();
    }
  }
}