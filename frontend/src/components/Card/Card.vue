<template>
  <div class="card">
    <div class="card-header-container">
      <div class="card-header">
        <div class="card-logo" :style="{ 'background': 'var(--linear-' + color + ')'}">
          <img :src="logo" alt="logo" class="icon">
        </div>
        <div class="card-titles">
          <div class="card-title-container">
            <div class="card-title">{{ title }}&nbsp;</div>
            <div class="other-info">{{ otherInfo }}</div>
          </div>
          <div class="card-subtitle">{{ subtitle }}</div>
        </div>
      </div>
    </div>
    <div class="card-body">
      <slot></slot>
    </div>
  </div>
</template>
<style src="./Card.css"/>
<script>
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
    otherInfo:{
      type: String
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
    color: {
      type: String,
      default: '' // or any default color you prefer
    }
  },
  setup(props) {
    return toRefs(props);
  }
};
</script>