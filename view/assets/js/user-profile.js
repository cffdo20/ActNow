const openDeleteProfileModal = document.querySelector("#trashBtn");
const deleteProfileModal = document.querySelector("#delete-profile-modal");
const closeDeleteProfileButton = document.querySelector("#returnPopBtn");

/* editar informações (email) */
const openEditProfileModal = document.querySelector("#edit-profile-button"); 
const editProfileModal = document.querySelector("#editUsuarioModal");
const closeEdiProfileButton = document.querySelector("#close-edit-user-dialog");

/* trocar senha  */
const openEditPasswordModal = document.querySelector("#edit-password-button"); 
const editPasswordModal = document.querySelector("#editSenhaModal");
const closeEditPasswordModal = document.querySelector("#close-edit-password-dialog");

/* trocar bio */
const openEditBioModal = document.querySelector(".volunteer-bio");
const editBioModal = document.querySelector("#editBioModal"); 
const closeEditBioModal = document.querySelector("#close-edit-bio-dialog");

/* trocar telefone */
const openEditPhoneModal = document.querySelector(".volunteer-phone");
const editPhoneModal = document.querySelector("#editPhoneModal");
const closeEditPhoneModal = document.querySelector("#close-edit-phone-dialog");

/* trocar cidade */
const openEditCityModal = document.querySelector(".volunteer-location");
const editCityModal = document.querySelector("#editCityModal");
const closeEditCityModal = document.querySelector("#close-edit-city-dialog");



openDeleteProfileModal.addEventListener("click", (e) => {
     e.preventDefault();
    deleteProfileModal.showModal();
})

closeDeleteProfileButton.addEventListener("click", () => {
    deleteProfileModal.close(); 
})

openEditProfileModal.addEventListener("click", () => {
    editProfileModal.showModal();
})

closeEdiProfileButton.addEventListener("click", () => {
    editProfileModal.close();   
})

/* trocar senha */
openEditPasswordModal.addEventListener("click", () => {
    editPasswordModal.showModal();
})

closeEditPasswordModal.addEventListener("click", () => {
    editPasswordModal.close(); 
})

/* trocar bio */
openEditBioModal.addEventListener("click", () => {
    editBioModal.showModal();
})

closeEditBioModal.addEventListener("click", () => {
    editBioModal.close();
})

/* trocar telefone */
openEditPhoneModal.addEventListener("click", () => {
    editPhoneModal.showModal();
})

closeEditPhoneModal.addEventListener("click", () => {
    editPhoneModal.close(); 
})

/* trocar cidade */
openEditCityModal.addEventListener("click", () =>{
    editCityModal.showModal();
})

closeEditCityModal.addEventListener("click", () => {
    editCityModal.close();
})


/* lista dinâmica de cidades */
document.addEventListener("DOMContentLoaded", () => {
    const estadoSelect = document.querySelector('select[name="volEstado"]');
    const cidadeSelect = document.querySelector('select[name="volCidNome"]');

    estadoSelect.addEventListener('change', () => {
        const estado = estadoSelect.value; // Corrigido

        if (estado) {
            fetch(`/voluntarios/cidades/${estado}`) 
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erro de conexão');
                    }
                    return response.json();
                })
                .then(cidades => {
                    cidadeSelect.innerHTML = '<option selected>Cidade</option>';
                    cidades.forEach(cidade => {
                        const option = document.createElement('option');
                        option.value = cidade.cidnome; 
                        option.textContent = cidade.cidnome;

                        cidadeSelect.appendChild(option);
                    });
                })
                .catch(error => console.log('Erro ao buscar cidades', error));
        } else {
            cidadeSelect.innerHTML = '<option selected>Cidade</option>';
        }
    });
});
