const cleanFilterBtn = document.querySelector("#trashBtn"); 
const checkboxes = document.querySelectorAll(".form-check-input");
//teste 
/* const filtrarBtn = document.querySelector("#filtrarBtn"); */


/* filtrarBtn.addEventListener("click", (e) => {
    e.preventDefault(); 

    window.alert("funcionando")
})
 */

cleanFilterBtn.addEventListener("click", () => {
    let inputs = checkboxes.length;

    for(let i = 0; i < inputs; i++){
        checkboxes[i].checked = false;
    }

})






