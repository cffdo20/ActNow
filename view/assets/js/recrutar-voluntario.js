const cleanFilterBtn = document.querySelector("#trashBtn"); 
const checkboxes = document.querySelectorAll(".form-check-input");



cleanFilterBtn.addEventListener("click", () => {
    let inputs = checkboxes.length;

    for(let i = 0; i < inputs; i++){
        checkboxes[i].checked = false;
    }

})









