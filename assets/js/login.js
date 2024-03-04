/* Visualizar senha */

const passwordInput = document.querySelector("#login-senha"); 
const passwordBtn = document.querySelector("#password-btn"); 

passwordBtn.addEventListener("click", (e) => {
    e.preventDefault();

    if(passwordInput.type === "password"){
        passwordInput.type = "text"
    }
    else{
        passwordInput.type = "password"; 
    }
})




