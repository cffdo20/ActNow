const addAtvButton = document.querySelector("#addAtividadeButton");
const atvText = document.querySelector(".add-atv-button"); 
const tooltip = document.querySelector("#tooltip"); 

const trashBtn = document.querySelector("#trashBtn")
const modal = document.querySelector("dialog"); 
const returnBtn = document.querySelector("#returnPopBtn"); 


/* addAtvButton.addEventListener("mouseover", () => {
    tooltip.style.display = "block"; 

})
addAtvButton.addEventListener("mouseout", () => {
    tooltip.style.display = "none"; 

})
 */
trashBtn.addEventListener("click", (e) => {
    e.preventDefault();

    modal.showModal(); 
})

returnBtn.addEventListener("click", () => {
    modal.close(); 
})
