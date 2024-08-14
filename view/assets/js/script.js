/* Elementos */

/* const e = require("express"); */ /* Causando erro no script. */

const btnTema = document.querySelector("#btn-tema"); 
const body = document.body; 
const mainImg = document.querySelector("#index-main-img"); 
const textToChange = document.querySelector(".text-to-change"); 


const addAtvButton = document.querySelector("#addAtividadeButton");
const atvText = document.querySelector(".add-atv-button"); 

const createProjDemoButton = document.querySelector("#create-proj-demo-button"); 
const hiddenParagraph = document.querySelector(".hidden"); 


document.addEventListener("DOMContentLoaded", function(){
    mainImg.classList.remove("team-img")
    mainImg.classList.add("fade-in")
})

const textLoad = () => {
    setTimeout(() => {
        textToChange.textContent = "Aja agora!"
        
    }, 0);
    setTimeout(() => {
        textToChange.textContent = "Act Now!"
        
    }, 4000);
    setTimeout(() => {
        textToChange.textContent = "ActNow"
        
    }, 8000);
}

textLoad(); 
setInterval(textLoad, 12000)


createProjDemoButton.addEventListener("click", (e) => {
    e.preventDefault();

    hiddenParagraph.classList.remove('hidden'); 
    hiddenParagraph.classList.add('active'); 

})