<template>
  <div class="card">
    <div class="card-header-container">
      <div class="card-header">
        <div class="card-logo" :style="{ 'background': logoColor }">
          <img :src="logo" alt="logo" class="icon">
        </div>
        <div class="card-titles">
          <div class="card-title">{{ title }}</div>
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
<script src="./Card.js"/>