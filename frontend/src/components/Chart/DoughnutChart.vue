<script>
import { defineComponent } from 'vue';
import { Doughnut } from 'vue-chartjs';

export default defineComponent({
    name: 'DoughnutChart',
    components: {Doughnut},
    // props: {
    //     userId: {
    //     type: [String, Number],
    //     required: true,
    //     },
    //     workingTimes: {
    //     type: Array,
    //     default: () => [],
    //     },
    // },
    data() {
        return {
        
        loaded: false,
        // Initialize chartData to have the correct structure
        chartData: {
            labels: [],
            datasets: [
            {
                        label: 'Work Duration (Hours)',
                        backgroundColor: ['#f87979', '#ffffff00'],
                        data: [30, 70],
                    },
            {
                label: 'Work Duration (Hours)',
                backgroundColor: ['#f87979', '#ffffff00'],
                data: [100],
            },
            
            ],
        },
        // loaded: true,
        error: null,
        };
      
    }
})

</script>

<template>
    <Doughnut :data="chartData" />
</template>
