document.getElementById('formProjeto').addEventListener('submit', function(event) {
    event.preventDefault(); // Impede o comportamento padrão do formulário

    const formData = {
        idProjeto: 1,
        tituloProj: document.getElementById('titulo').value,
        descricaoProj: document.getElementById('descricao').value,
        publicoAlvoProj: document.getElementById('publicoAlvo').value,
        justificativaProj: document.getElementById('justificativa').value,
        objetivosProj: document.getElementById('objetivos').value,
        dataInicioProj: document.getElementById('dataInicio').value,
        statusProj: parseInt(document.getElementById('status').value)
    };

    fetch('http://localhost:3000/projetos', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData)
    })
    .then(response => response.json())
    .then(data => {
        console.log('Resposta do servidor:', data);
    })
    .catch(error => {
        console.error('Ocorreu um erro:', error);
    });
});