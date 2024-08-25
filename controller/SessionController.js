const usuario = require('../model/Usuario');

module.exports = {
    login: async (req, res) => {
        const { userEmail, userSenha } = req.body;
        var consulta = await usuario.getUsuarioByEmail(userEmail);
        const userName = consulta.resposta;
      
        try {
          // Verifique se req.session existe e é um objeto
          if (!req.session || typeof req.session !== 'object') {
            console.error('Sessão não configurada corretamente.');
            return res.render('login', { alerta: 'Ocorreu um erro na sessão. Tente novamente.' });
          }
      
          const user = await usuario.getUsuario(userName);
          // Remover a senha do objeto 'user'
          const { senha, ...userWithoutPassword } = user;
      
          if (!user || user.senha !== userSenha) {
            return res.render('login', { alerta: 'Credenciais inválidas. Tente novamente.' });
          }
      
          req.session.user = userWithoutPassword;
          res.redirect('/');
        } catch (error) {
          console.error(error);
          res.render('login', { alerta: 'Ocorreu um erro ao tentar fazer login. Tente novamente.' });
        }
      },


  logout: (req, res) => {
    req.session.destroy(err => {
      if (err) {
        return res.redirect('/'); // Em caso de erro ao destruir a sessão, redireciona para a página de projetos
      }

      res.redirect('/login'); // Redireciona para a página de login após a sessão ser destruída
    });
  }
};
