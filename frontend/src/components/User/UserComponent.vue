<template>
    <div class="user-component">
        <h2>{{ user.name }}</h2>
        <p>Email: {{ user.mail }}</p>
        <p>Age: {{ user.age }}</p>
        <p>adresse : {{ user.address }}</p>
        <p>adresse : {{ user.zipcode }}</p>
    </div>

    <div>
        
    </div>
</template>

<script>
    
export default {
    name: 'UserComponent',
    props: {
        user: {
            type: Object,
            required: true
        }
    }
}
</script>

<style scoped>
.user-component {
    border: 1px solid #ccc;
    padding: 16px;
    border-radius: 8px;
    max-width: 300px;
    margin: 0 auto;
}
</style>