/*async function connect(){
    if(global.connection && global.connection.state !== 'disconnected')
        return global.connection;
 
    const mysql = require("mysql2/promise");
    const connection = await mysql.createConnection("mysql://root:root@localhost:3306/actnow2024");
    console.log("Conectou no MySQL!");
    global.connection = connection;
    return connection;
}
async function callSelectProcedure(nomeProcedure){
    const conn = await connect();
    const [rows] = await conn.query('CALL '+nomeProcedure+';');
    return rows;
}
async function callProcedureWithParameter(nomeProcedure, parametros=[]){
    const conn = await connect();
    return await conn.query('CALL '+nomeProcedure+'('+concatParametros(parametros)+')'+';');
}*/
function concatParametros(parametros = []) {
  var conpar = '';
  var i = 0
  do {
    if (i == parametros.length - 1) {
      conpar = conpar + String(parametros[i]) + ','
    } else {
      conpar = conpar + String(parametros[i]) + ','
    }
    i++
  } while (i < parametros.length)
  return conpar
}
var par = []
par.push(1, 'teste')
var concpar = concatParametros(par)
alert(concpar)
/* 
//index.js
(async () => {
    const db = require("./db");
    console.log('Começou!');
    const projetos = await db.selectProjetos();
    console.log(clientes);
})();


*/