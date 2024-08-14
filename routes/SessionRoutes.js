const express = require('express');
const router = express.Router();
const sessionController = require('../controller/SessionController');

// Rota para exibir o formulário de login
router.get('/login', (req, res) => {
  res.render('login');
});

// Rota para processar o login do usuário
router.post('/login', sessionController.login);

// Rota para processar o logout do usuário
router.post('/logout', sessionController.logout);

module.exports = router;
