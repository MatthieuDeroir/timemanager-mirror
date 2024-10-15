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
      default: 'https://via.placeholder.com/150'
    },
    height: {
      type: String,
      default: 'medium'
    },
    width: {
      type: String,
      default: 'short'
    }
  },
  setup(props) {
    // You can access props directly inside the setup function
    return {
      title: props.title,
      subtitle: props.subtitle,
      logo: props.logo,
      height: props.height,
      width: props.width
    }
  }
};
