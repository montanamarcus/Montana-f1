window.addEventListener('message', function(event) {
    if (event.data.action === "openMenu") {
        document.getElementById("menu").style.display = "block";
        
        let list = document.getElementById("vehicleList");
        list.innerHTML = ""; // Önce temizle

        event.data.vehicles.forEach(vehicle => {
            let li = document.createElement("li");
            li.textContent = vehicle.name;
            li.onclick = () => spawnVehicle(vehicle.model);
            list.appendChild(li);
        });
    } else if (event.data.action === "closeMenu") {
        document.getElementById("menu").style.display = "none";
    }
});

function spawnVehicle(model) {
    fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ model })
    });
}

function closeMenu() {
    document.getElementById("menu").style.display = "none";
    fetch(`https://${GetParentResourceName()}/closeMenu`, { method: "POST" });
}
