const addAtvButton = document.querySelector("#addAtividadeButton");
const atvText = document.querySelector(".add-atv-button"); 
const tooltip = document.querySelector("#tooltip"); 



addAtvButton.addEventListener("mouseover", () => {
    tooltip.style.display = "block"; 

})
addAtvButton.addEventListener("mouseout", () => {
    tooltip.style.display = "none"; 

})

