const openDeleteProfileModal = document.querySelector("#trashBtn");
const deleteProfileModal = document.querySelector("#delete-profile-modal");
const closeDeleteProfileButton = document.querySelector("#returnPopBtn");

/* editar informações (email) */
const openEditProfileModal = document.querySelector("#edit-profile-button"); 
const editProfileModal = document.querySelector("#editUsuarioModal");
const closeEdiProfileButton = document.querySelector("#close-edit-user-dialog");

openDeleteProfileModal.addEventListener("click", (e) => {
    e.preventDefault(); 
    deleteProfileModal.showModal();
})

closeDeleteProfileButton.addEventListener("click", () => {
    deleteProfileModal.close(); 
})

openEditProfileModal.addEventListener("click", (e) => {
    e.preventDefault();
    editProfileModal.showModal();
})

closeEdiProfileButton.addEventListener("click", () => {
    editProfileModal.close();   
})

