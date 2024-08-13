function ensureAuthenticated(req, res, next) {
    if (req.session.user) {
        return next(); // Se o usuário está autenticado, prossegue para a próxima função middleware/rota
    }
    res.redirect('/login'); // Se não estiver autenticado, redireciona para a página de login
}

module.exports = ensureAuthenticated;
