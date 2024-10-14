
export default {
  props: {
    title: {
      type: String,
      required: true
    },
    subtitle: {
      type: String,
      default: '------'
    },
    logo: {
      type: String,
      default: "../../assets/logo/icons8-image-pulsar-line/icons8-image-48.png"
    },
    height: {
      type: String,
      default: 'medium'
    },
    width: {
      type: String,
      default: 'short'
    },
    logoColor: {
      type: String,
      default: ''
    }
  },
  setup(props) {
    return {
      title: props.title,
      subtitle: props.subtitle,
      logo: props.logo,
      height: props.height,
      width: props.width,
      logoColor: props.logoColor
    }
  }
};