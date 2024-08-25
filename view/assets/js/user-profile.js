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

