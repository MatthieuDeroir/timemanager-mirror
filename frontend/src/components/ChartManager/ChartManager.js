// ChartManager.js

import Services from '../../api/'
import dayjs from 'dayjs'

/**
 * Fetch and prepare chart data for the given userId.
 * @param {number} userId
 * @returns {Promise<{ barChartData, lineChartData, pieChartData }>}
 */
export async function fetchAndPrepareChartData(userId) {
  try {
    const data = await Services.WorkingTime.getWorkingTimesByUserId(userId)

    // Prepare chart data
    const chartData = prepareChartData(data)
    return chartData
  } catch (error) {
    console.error('Error fetching or preparing chart data:', error)
    throw error
  }
}

/**
 * Prepare chart data from raw working times data
 * @param {WorkingTimeDTO[]} data
 * @returns {{ barChartData, lineChartData, pieChartData }}
 */
function prepareChartData(data) {
  // Format dates and calculate durations
  data.forEach((item) => {
    item.start = dayjs(item.start).format('YYYY-MM-DD hh:mm:ss')
    item.end = dayjs(item.end).format('YYYY-MM-DD hh:mm:ss')
    item.duration = dayjs(item.end).diff(dayjs(item.start), 'hour', true)
  })

  // Prepare data for Bar Chart
  const barChartData = {
    labels: data.map((item) => item.start),
    datasets: [
      {
        label: 'Working Hours',
        backgroundColor: '#42b983',
        data: data.map((item) => item.duration)
      }
    ]
  }

  // Prepare data for Line Chart
  const lineChartData = {
    labels: data.map((item) => item.start),
    datasets: [
      {
        label: 'Cumulative Hours',
        borderColor: '#ff6384',
        data: cumulativeSum(data.map((item) => item.duration)),
        fill: false
      }
    ]
  }

  // Prepare data for Pie Chart
  const totalDuration = data.reduce((sum, item) => sum + item.duration, 0)
  const remainingHours = Math.max(0, 40 - totalDuration) // Assuming a 40-hour workweek

  const pieChartData = {
    labels: ['Worked Hours', 'Remaining Hours'],
    datasets: [
      {
        backgroundColor: ['#ff6384', '#36a2eb'],
        data: [totalDuration, remainingHours]
      }
    ]
  }

  return {
    barChartData,
    lineChartData,
    pieChartData
  }
}

/**
 * Helper function to compute cumulative sum of an array
 * @param {number[]} arr
 * @returns {number[]}
 */
function cumulativeSum(arr) {
  const result = []
  arr.reduce((sum, value, index) => {
    result[index] = sum + value
    return result[index]
  }, 0)
  return result
}
