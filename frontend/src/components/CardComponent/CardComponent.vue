<template>
  <div class="card large medium">
    <div class="card-header-container">
      <div class="card-header">
        <div class="card-logo">logo</div>
        <div class="card-titles">
          <div class="card-title">Title</div>
          <div class="card-subtitle">subtitle</div>
        </div>
      </div>
    </div>
    <div class="card-body">
      <slot> </slot>
    </div>
  </div>
</template>
<style src="./CardComponent.css" />
<script src="./CardComponent.js" />