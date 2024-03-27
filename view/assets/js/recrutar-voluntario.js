const cleanFilterBtn = document.querySelector("#trashBtn"); 
<<<<<<< HEAD
const checkboxes = document.querySelectorAll(".form-check-input");
//teste 
/* const filtrarBtn = document.querySelector("#filtrarBtn"); */


/* filtrarBtn.addEventListener("click", (e) => {
    e.preventDefault(); 

    window.alert("funcionando")
})
 */
=======
const checkboxes = document.querySelectorAll(".form-check-input"); 
>>>>>>> 89b1c75ccac3ca29b4a0c34fc5f12c3b54a1a439

cleanFilterBtn.addEventListener("click", () => {
    let inputs = checkboxes.length;

    for(let i = 0; i < inputs; i++){
        checkboxes[i].checked = false;
    }

})


<<<<<<< HEAD




=======
>>>>>>> 89b1c75ccac3ca29b4a0c34fc5f12c3b54a1a439
