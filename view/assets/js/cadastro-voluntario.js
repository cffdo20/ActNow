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
