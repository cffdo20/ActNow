const db = require("./db");
const express = require("express");
const app = express();
const path = require("path");
const body = require("body-parser");
const PORT = process.env.PORT || 3000;

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.use(express.static(path.join(__dirname, "assets")));

app.use(body.urlencoded({ extended: false }));
app.use(body.json());

var parametros = [];
parametros.push('Teste2','Descricao','Publico','Justificativa','Objetivos','2024-01-02','1','1')
var consultar
db.callProcedureWithParameter('sp_criar_projeto', parametros).then(consulta => {
    console.log(consulta[0][0])
    if (consulta[0][0].erro === undefined) {
        if (consulta[0][0].reposta === undefined) {
            consultar = consulta[0][0].titulo;//receber dados do banco aqui dentro
        }else{
            consultar = consulta[0][0].resposta;
        }
    }else{
        consultar=consulta[0][0].erro;
    }
})
app.get('/', function (req, res) {
    res.send(consultar)
});
app.get('/teste', function (req, res) {
    res.render('teste')
});
app.get('/visual_db', function (req, res) {
    res.render('visual_db', { elementos: consultar });
});
app.listen(PORT, function (err) {
    if (err) console.log(err);
    console.log("Server listening on PORT", PORT);
});