import { toRefs } from "vue";
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
      type: String
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
    return toRefs(props);
  }
};
