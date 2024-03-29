async function connect() {
  if (global.connection && global.connection.state !== 'disconnected')
    return global.connection;

  const mysql = require("mysql2/promise");
  const connection = await mysql.createConnection("mysql://root:root@localhost:3306/actnow24");
  console.log("Conectou no MySQL!");
  global.connection = connection;
  return connection;
}
async function callSelectProcedure(nomeProcedure) {
  const conn = await connect();
  const resposta = await conn.query('CALL ' + nomeProcedure + ';');
  return resposta;
}
async function callProcedureWithParameter(nomeProcedure, parametros = []) {
  const conn = await connect();
  const sql = 'Call ' + nomeProcedure + '(?);';
  const values = concatParametros(parametros);
  const [resposta] = await conn.query(sql, values);
  return resposta;
}
function concatParametros(parametros = []) {
  var conpar = '';
  var i = 0
  do {
    if (i == parametros.length - 1) {
      conpar = conpar + String(parametros[i]) + '|'
    } else {
      conpar = conpar + String(parametros[i]) + '|'
    }
    i++
  } while (i < parametros.length)
  return conpar
}
module.exports = { callProcedureWithParameter }
