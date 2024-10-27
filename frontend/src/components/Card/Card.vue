<template>
  <div class="card">
    <div class="card-header-container">
      <div class="card-header">
        <div :style="{ background: 'var(--linear-' + color + ')' }" class="card-logo">
          <img :src="logo" alt="logo" class="icon" />
        </div>
        <div class="card-titles">
          <div class="card-title-container">
            <div class="card-title">{{ title }}&nbsp;</div>
            <div class="other-info">{{ otherInfo }}</div>
          </div>
          <div class="card-subtitle">{{ subtitle }}</div>
        </div>
      </div>
      <div
        v-if="actionButton"
        :style="{ fill: 'var(--color-' + color + ')' }"
        class="card-action"
        @click="triggerAction"
        v-html="actionButton"
      ></div>
    </div>
    <div class="card-body">
      <slot></slot>
    </div>
  </div>
</template>
<style src="./Card.css" />
<script>
import { toRefs } from 'vue'

export default {
  props: {
    title: {
      type: String,
      required: true
    },
    subtitle: {
      type: String
    },
    otherInfo: {
      type: String
    },
    logo: {
      type: String
    },
    color: {
      type: String
    },
    actionButton: {
      type: String
    },
    actionFunction: {
      type: Function
    }
  },
  setup(props) {
    return toRefs(props)
  },
  methods: {
    triggerAction() {
      if (this.actionFunction) {
        this.actionFunction()
      }
    }
  }
}
</script>
