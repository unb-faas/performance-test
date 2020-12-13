// https://www.codota.com/code/javascript/modules/%40google-cloud%2Fdatastore
function _delete(id, cb) {
 const key = ds.key([kind, parseInt(id, 10)]);
 ds.delete(key, cb);
}
