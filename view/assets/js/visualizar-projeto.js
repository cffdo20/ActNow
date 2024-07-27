const addAtvButton = document.querySelector("#addAtividadeButton");
const atvText = document.querySelector(".add-atv-button"); 
const tooltip = document.querySelector("#tooltip"); 

const trashBtn = document.querySelector("#trashBtn")
const modal = document.querySelector("dialog"); 
const returnBtn = document.querySelector("#returnPopBtn"); 

const descriptionContainer = document.querySelector("#description-container"); 
const editDescriptionModal = document.querySelector("#edit-description-dialog"); 
const closeDescriptionModal = document.querySelector("#close-description-dialog");

const justifyContainer = document.querySelector("#justify-container"); 
const editJustifyModal = document.querySelector("#edit-justify-dialog"); 
const closeJustifyModal = document.querySelector("#close-justify-dialog");

const goalsContainer = document.querySelector("#goals-container"); 
const editGoalsModal = document.querySelector("#edit-goals-dialog"); 
const closeGoalsModal = document.querySelector("#close-goals-dialog");

const audienceContainer = document.querySelector("#audience-container"); 
const editAudienceModal = document.querySelector("#edit-audience-dialog"); 
const closeAudienceModal = document.querySelector("#close-audience-dialog");

const createActivityButton = document.querySelector("#new-activity-button"); 
const createActivityModal = document.querySelector("#create-new-activity"); 
const closeActivityModal = document.querySelector("#close-activity-dialog"); 



console.log(closeDescriptionModal); 


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

descriptionContainer.addEventListener("click", () => {
    editDescriptionModal.showModal(); 
})

closeDescriptionModal.addEventListener("click", () => {
    editDescriptionModal.close(); 
})

justifyContainer.addEventListener("click", () => {
    editJustifyModal.showModal(); 
})

closeJustifyModal.addEventListener("click", () => {
    editJustifyModal.close(); 
})

goalsContainer.addEventListener("click", () => {
    editGoalsModal.showModal(); 
})

closeGoalsModal.addEventListener("click", () => {
    editGoalsModal.close(); 
})

audienceContainer.addEventListener("click", () => {
    editAudienceModal.showModal(); 
})

closeAudienceModal.addEventListener("click", () => {
    editAudienceModal.close(); 
})

createActivityButton.addEventListener("click", () => {
    createActivityModal.showModal(); 
})

closeActivityModal.addEventListener("click", () => {
    createActivityModal.close(); 
})

