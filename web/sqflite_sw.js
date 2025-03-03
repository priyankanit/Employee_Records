self.importScripts("https://unpkg.com/sql.js/dist/sql-wasm.js");

let db;
self.onmessage = function (event) {
  const data = event.data;
  if (data.action === "open") {
    const sqlPromise = initSqlJs({
      locateFile: filename => `https://unpkg.com/sql.js/dist/${filename}`
    });

    sqlPromise.then(SQL => {
      db = new SQL.Database();
      self.postMessage({ action: "opened" });
    });
  } else if (data.action === "exec") {
    const result = db.exec(data.sql);
    self.postMessage({ action: "exec", result });
  }
};
