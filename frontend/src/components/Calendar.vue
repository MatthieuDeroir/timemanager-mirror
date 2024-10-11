<script>
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import timeGridPlugin from '@fullcalendar/timegrid'

export default {
  name: 'CalendarCompo',
  components: {
    FullCalendar// make the <FullCalendar> tag available
  },
  data() {
    return {
      calendarOptions: {
        plugins: [ dayGridPlugin, interactionPlugin, timeGridPlugin],
        initialView: 'dayGridMonth',
        dateClick: this.handleDateClick,
        selectable: true,
        events: [
          { title: 'event 1', start: '2024-10-01 12:30:00', end: '2024-10-01 13:30:00'},
          { title: 'in', date: '2024-10-12' },
          { title: 'out', date: '2024-10-12' }

        ]
      }
    }
  },
  methods: {
    handleDateClick: function(arg) {
      alert('Clicked on: ' + arg.dateStr);
      alert('Coordinates: ' + arg.jsEvent.pageX + ',' + arg.jsEvent.pageY);
      alert('Current view: ' + arg.view.type);
    },
    handleEventClick: function(){

    }
  }
}
</script>
<template>
  <FullCalendar :options="calendarOptions" />
</template>

<style scoped>
    
</style>
