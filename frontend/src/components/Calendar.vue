
<script>
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import timeGridPlugin from '@fullcalendar/timegrid'
import {useWorkingTimeStore} from '@store/WorkingTime/WorkingTimeStore'


export default {
  name: 'CalendarCompo',
  components: {
    FullCalendar// make the <FullCalendar> tag available
  },
  props:{
    userId: {
      type: [String, Number],
      required: true
    },
  },
  data() {
    return {
      calendarOptions: {
        plugins: [ dayGridPlugin, interactionPlugin, timeGridPlugin],
        initialView: 'dayGridMonth',
        timeZone:'UTC',
        dateClick: this.handleDateClick, 
        eventClick: this.handleEventClick,
        selectable: true,
        events: [],
       
       
      }
      
    }
  },
  methods: {
    handleDateClick (arg) {
      const event= arg.event
      // alert('Clicked on: ' + arg.dateStr);
      // alert('Coordinates: ' + arg.jsEvent.pageX + ',' + arg.jsEvent.pageY);
      // alert('Current view: ' + arg.view.type);
      
    },
    handleEventClick (arg){
      const event = arg.event
      // alert('Event title: ' + event.title);
      // alert('Event start time: ' + event.start);
      // alert('Event end time: ' + event.start);
    },
    async getEvent(){
      try {
        const workingTimeStore = useWorkingTimeStore()
        await workingTimeStore.loadWorkingTimes(this.userId);
        const userEvents = workingTimeStore.workingTimes 

        this.calendarOptions.events = userEvents.map(event => ({
          id: event.id,
          title: "Working Time",
          start: event.start.replace("Z",""), 
          end: event.end.replace("Z",""),
          allDay: false,
        }));
     
        console.log(this.calendarOptions.events)
      
      } catch (error) {
        console.error("Failed to load events:", error);
      }
    },
    async createEvent(){
      const workingTimeStore = useWorkingTimeStore()
      await workingTimeStore.createWorkingTime(this.userId, "2024-10-08:08:00:00", "2024-10-10:16:00:00")

    }
  },
  mounted(){
    this.getEvent()
  }
}
</script>

<template>
  <FullCalendar :options="calendarOptions" />
</template>

<style scoped>   
</style>
