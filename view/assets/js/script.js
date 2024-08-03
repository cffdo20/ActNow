/* Elementos */

const btnTema = document.querySelector("#btn-tema"); 
const body = document.body; 
const mainImg = document.querySelector("#index-main-img"); 
const textToChange = document.querySelector(".text-to-change"); 


const addAtvButton = document.querySelector("#addAtividadeButton");
const atvText = document.querySelector(".add-atv-button"); 
console.log(addAtvButton)

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


