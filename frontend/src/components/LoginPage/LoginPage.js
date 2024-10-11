export default {
  data() {
    return {
      email: '',
      password: '',
    };
  },
  methods: {
    handleSubmit() {

      console.log('Email:', this.email);
      console.log('Password:', this.password);

      if (this.email && this.password) {
        this.$emit('login-success'); 
      }
    },
  },
};