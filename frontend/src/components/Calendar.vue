
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
        eventClick: this.handleEventClick,
        selectable: true,
        events: [],
       
       
      },
      selectedEvent: null,
      showEventModal:false
      
    }
  },
  methods: {
    
    handleEventClick (arg){
      const event = arg.event
      this.selectedEvent={
        title:event.title,
        start:event.start,
        end:event.end
      }
      this.showEventModal=true

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
     
        // console.log(this.calendarOptions.events)
      
      } catch (error) {
        console.error("Failed to load events:", error);
      }
    },
    async closeModal(){
      this.showEventModal=false
      this.selectedEvent=null

    }
  },
  mounted(){
    this.getEvent()
  }
}
</script>

<template>
  <div>
    <FullCalendar :options="calendarOptions" />
    <div v-if="showEventModal" class="modal">
      <div class="modal-content">
        <span class="close" @click="closeModal">&times;</span>
        <h2>{{ selectedEvent.title }}</h2>
        <p><strong>Start:</strong> {{ selectedEvent.start }}</p>
        <p><strong>End:</strong> {{ selectedEvent.end }}</p>
      </div>
    </div>

  </div>
</template>

<style scoped>  
  .modal {
    display: block;
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1000;
  }

  .modal-content {
    background-color: #fff;
    margin: 15% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 50%;
    text-align: center;
  }

  .close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
  }

  .close:hover,
  .close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
  } 
</style>
