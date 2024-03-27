/* Visualizar senha */

const passwordInput = document.querySelector("#login-senha"); 
const passwordBtn = document.querySelector("#password-btn"); 
const passwordSpan = document.querySelector("#password-span");
console.log(passwordSpan)

passwordBtn.addEventListener("click", (e) => {
    e.preventDefault();

    if(passwordInput.type === "password"){
        passwordInput.type = "text"

        passwordSpan.classList.remove("bi-eye");
        passwordSpan.classList.add("bi-eye-slash");


    }
    else{
        passwordInput.type = "password"; 

        passwordSpan.classList.remove("bi-eye-slash");
        passwordSpan.classList.add("bi-eye");
    }
})




