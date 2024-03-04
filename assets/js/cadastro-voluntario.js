/* Máscara para o CPF */
const cpfInput = document.querySelector("#voluntario-cpf"); 

cpfInput.addEventListener("keypress", () =>{
    let inputLength = cpfInput.value.length; 

    if(inputLength === 3 || inputLength === 7){
        cpfInput.value += '.'  /* += mantém os caracteres anteriores e adiciona o ponto no 3 */
    }
    else if(inputLength === 11){
        cpfInput.value += '-'
    }
})