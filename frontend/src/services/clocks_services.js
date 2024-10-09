async function getClocksByUserId(userid) {
    return fetch("http://localhost:4000/api/clocks/"+userid).then(res => res.json());
}

async function createClock(time, status) {
    return fetch("http://localhost:4000/api/clocks", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: {
            "clocks":
            {
                time,
                status
            }
        }
    }).then(res => res.json());
}

console.log(await createClock("12:00", true));



export { getClocksByUserId, createClock };