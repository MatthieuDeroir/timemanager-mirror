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

<style src="./Calendar.css" />

<script>
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import timeGridPlugin from '@fullcalendar/timegrid'
import { useWorkingTimeStore } from '@store/WorkingTime/WorkingTimeStore'

export default {
  name: 'CalendarCompo',
  components: {
    FullCalendar
  },
  props: {
    userId: {
      type: [String, Number],
      required: true
    }
  },
  data() {
    return {
      calendarOptions: {
        plugins: [dayGridPlugin, interactionPlugin, timeGridPlugin],
        initialView: 'dayGridMonth',
        timeZone: 'UTC',
        eventClick: this.handleEventClick,
        selectable: true,
        events: []
      },
      selectedEvent: null,
      showEventModal: false
    }
  },
  methods: {
    handleEventClick(arg) {
      const event = arg.event
      this.selectedEvent = {
        title: event.title,
        start: event.start,
        end: event.end
      }
      this.showEventModal = true
    },
    async getEvent() {
      try {
        const workingTimeStore = useWorkingTimeStore()
        await workingTimeStore.loadWorkingTimes(this.userId)
        const userEvents = workingTimeStore.workingTimes

        this.calendarOptions.events = userEvents.map((event) => ({
          id: event.id,
          title: 'Working Time',
          start: event.start.replace('Z', ''),
          end: event.end.replace('Z', ''),
          allDay: false
        }))
      } catch (error) {
        console.error('Failed to load events:', error)
      }
    },
    async closeModal() {
      this.showEventModal = false
      this.selectedEvent = null
    }
  },
  mounted() {
    this.getEvent()
  }
}
</script>
