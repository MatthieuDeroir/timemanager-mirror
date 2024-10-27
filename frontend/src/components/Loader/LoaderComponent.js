export default {
  props: {
    loading: {
      type: Boolean,
      default: true
    },
    color: {
      type: String,
      default: 'var(--color-labelPrimary)'
    },
    size: {
      type: String,
      default: '13px'
    },
    margin: {
      type: String,
      default: '3px'
    },
    radius: {
      type: String,
      default: '100%'
    }
  },
  data() {
    return {
      spinnerStyle: {
        backgroundColor: this.color,
        height: this.size,
        width: this.size,
        margin: this.margin,
        borderRadius: this.radius,
        display: 'inline-block',
        animationName: 'v-syncStretchDelay',
        animationDuration: '1s',
        animationIterationCount: 'infinite',
        animationTimingFunction: 'ease-in-out',
        animationFillMode: 'both'
      },
      spinnerDelay1: {
        animationDelay: '0.07s'
      },
      spinnerDelay2: {
        animationDelay: '0.14s'
      },
      spinnerDelay3: {
        animationDelay: '0.21s'
      }
    }
  }
}
