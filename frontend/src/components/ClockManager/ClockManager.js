import { computed, ref, onMounted } from 'vue'
import LoaderComponent from '@components/Loader/LoaderComponent.vue'
import { useClockStore } from '@store/Clock/ClockStore.js'

//TODO : Refactor this component to use the new composition API and the ClockStore
export default {
    components: {
        LoaderComponent
    },
    props: {
        userId: {
            type: [String, Number],
            required: true
        }
    },
    setup(props) {
        const clockStore = useClockStore()

        const clocks = computed(() => clockStore.clocks)
        const isLoading = computed(() => clockStore.isLoading)
        const storeError = computed(() => clockStore.error)

        const filteredClocks = computed(() => {
            return clocks.value
                .filter((item) => {
                    const date = new Date(item.time)
                    const dateNow = new Date()
                    return (
                        date.getFullYear() === dateNow.getFullYear() &&
                        date.getMonth() === dateNow.getMonth() &&
                        date.getDate() === dateNow.getDate()
                    )
                })
                .sort((current, item) => new Date(current.time) - new Date(item.time))
        })

        const handleCreateClock = async () => {
            const newClockData = {
                time: new Date().toISOString(),
                status: !filteredClocks.value.length ? false : !filteredClocks.value[filteredClocks.value.length - 1].status,
                userId: props.userId
            }
            await clockStore.createClock(newClockData)
        }

        const getTime = (item) => {
            const rowDate = new Date(item.time)
            return rowDate.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' })
        }

        onMounted(() => {
            clockStore.loadClocks(props.userId)
        })

        return {
            filteredClocks,
            isLoading,
            storeError,
            handleCreateClock,
            getTime
        }
    }
}
