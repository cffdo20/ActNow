const express = require('express');
const router = express.Router();
const sessionController = require('../controller/SessionController.js');

// Direcionar para Formulário de Criação de Usuario
router.get('/login', (req, res) => {
  res.render('login.ejs');
});