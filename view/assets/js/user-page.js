const mainImg = document.querySelector("#homepage-main-img"); 

document.addEventListener("DOMContentLoaded", function(){
    mainImg.classList.remove("team-img")
    mainImg.classList.add("fade-in")
})

/* em caso de erros */
document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const alerta = urlParams.get('alerta');

    if (alerta) {
        try {
            // Decodifica a string do alerta
            const decodedAlerta = decodeURIComponent(alerta);
            
            // Inicializa a mensagem de alerta como a string decodificada
            let alertaMessage = decodedAlerta;

            // Tenta analisar o alerta como JSON
            try {
                // Verifica se é um JSON válido
                const parsedAlerta = JSON.parse(decodedAlerta);
                // Se o JSON contiver a propriedade 'alerta', usa-a
                alertaMessage = parsedAlerta.alerta || decodedAlerta;
            } catch (jsonError) {
                // Se não for um JSON válido, mantém a string simples
                console.warn('Alerta não é um JSON válido, usando como string simples.');
            }

            // Exibe a mensagem de alerta na div
            const alertaDiv = document.getElementById('alerta');
            alertaDiv.textContent = alertaMessage;
            alertaDiv.style.display = 'block';

            setTimeout(() => {
                alertaDiv.style.display = 'none';
            }, 2000)
        } catch (e) {
            console.error('Erro ao processar o alerta:', e);
        }
    }
});
