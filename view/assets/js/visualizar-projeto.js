const addAtvButton = document.querySelector("#addAtividadeButton");
const atvText = document.querySelector(".add-atv-button"); 
const tooltip = document.querySelector("#tooltip"); 

const trashBtn = document.querySelector("#trashBtn")
const modal = document.querySelector("dialog"); 
const returnBtn = document.querySelector("#returnPopBtn"); 

const descriptionContainer = document.querySelector("#description-container"); 
const editDescriptionModal = document.querySelector("#edit-description-dialog"); 
const closeDescriptionModal = document.querySelector("#close-description-dialog");

const justifyContainer = document.querySelector("#justify-container"); 
const editJustifyModal = document.querySelector("#edit-justify-dialog"); 
const closeJustifyModal = document.querySelector("#close-justify-dialog");

const goalsContainer = document.querySelector("#goals-container"); 
const editGoalsModal = document.querySelector("#edit-goals-dialog"); 
const closeGoalsModal = document.querySelector("#close-goals-dialog");

const audienceContainer = document.querySelector("#audience-container"); 
const editAudienceModal = document.querySelector("#edit-audience-dialog"); 
const closeAudienceModal = document.querySelector("#close-audience-dialog");

const createActivityButton = document.querySelector("#new-activity-button"); 
const createActivityModal = document.querySelector("#create-new-activity"); 
const closeActivityModal = document.querySelector("#close-activity-dialog"); 


/* excluir atividade */
const deleteActivityButtons = document.querySelectorAll(".delete-activity-btn");
const closeDeleteActivityModal = document.querySelector("#close-delete-activity-modal"); 

console.log(deleteActivityButtons)

/* editar atividades */
const editActivityButtons = document.querySelectorAll(".edit-activity-btn");
const closeEditActivityModal = document.querySelector("#close-edit-activity-dialog"); 





/* addAtvButton.addEventListener("mouseover", () => {
    tooltip.style.display = "block"; 

})
addAtvButton.addEventListener("mouseout", () => {
    tooltip.style.display = "none"; 

})
 */

trashBtn.addEventListener("click", (e) => {
    e.preventDefault();

    modal.showModal(); 
})

returnBtn.addEventListener("click", () => {
    modal.close(); 
})

descriptionContainer.addEventListener("click", () => {
    editDescriptionModal.showModal(); 
})

closeDescriptionModal.addEventListener("click", () => {
    editDescriptionModal.close(); 
})

justifyContainer.addEventListener("click", () => {
    editJustifyModal.showModal(); 
})

closeJustifyModal.addEventListener("click", () => {
    editJustifyModal.close(); 
})

goalsContainer.addEventListener("click", () => {
    editGoalsModal.showModal(); 
})

closeGoalsModal.addEventListener("click", () => {
    editGoalsModal.close(); 
})

audienceContainer.addEventListener("click", () => {
    editAudienceModal.showModal(); 
})

closeAudienceModal.addEventListener("click", () => {
    editAudienceModal.close(); 
})

createActivityButton.addEventListener("click", () => {
    createActivityModal.showModal(); 
})

closeActivityModal.addEventListener("click", () => {
    createActivityModal.close(); 
})

/* excluir atividade */
deleteActivityButtons.forEach((btn) => {
  btn.addEventListener('click', (e) => {
    const tituloAtividade = btn.getAttribute('data-titulo');
    const modal = document.getElementById('exclusaoFormModal');
    const form = modal.querySelector('form');
    form.querySelector('input[name="tituloAtividade"]').value = tituloAtividade;
    modal.showModal();
  });
});

closeDeleteActivityModal.addEventListener("click", () => {
    const modal = document.getElementById('exclusaoFormModal');
    modal.close(); 
})

editActivityButtons.forEach((btn) => {
    btn.addEventListener('click', (e) => {
        const tituloAtividade = btn.getAttribute('data-titulo');
        const modal = document.getElementById('editAtividadeModal');
        const form = modal.querySelector('form');
        form.querySelector('input[name="tituloAtividade"]').value = tituloAtividade;
        modal.showModal(); 
    })
})

closeEditActivityModal.addEventListener("click", () => {
    const modal = document.getElementById('editAtividadeModal');
    modal.close(); 
})


/* teste  */
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
