/* Visualizar senha */

const passwordInput = document.querySelector("#user-senha"); 
const passwordSpan = document.querySelector("#password-btn");
console.log(passwordSpan)

passwordSpan.addEventListener("click", (e) => {
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




