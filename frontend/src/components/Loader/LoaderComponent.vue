<template>
  <div v-show="loading" class="v-spinner">
    <div class="v-sync v-sync1" v-bind:style="[spinnerStyle, spinnerDelay1]"></div>
    <div class="v-sync v-sync2" v-bind:style="[spinnerStyle, spinnerDelay2]"></div>
    <div class="v-sync v-sync3" v-bind:style="[spinnerStyle, spinnerDelay3]"></div>
  </div>
</template>

<script src="./LoaderComponent.js"></script>

<style src="./LoaderComponent.css"></style>
