<script>
import { defineComponent } from 'vue';
import { Doughnut } from 'vue-chartjs';

export default defineComponent({
    name: 'DoughnutChartOver',
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