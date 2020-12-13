// https://www.codota.com/code/javascript/modules/%40google-cloud%2Fdatastore
// [START listby] 
function listBy(userId, limit, token, cb) {
 const q = ds
  .createQuery([kind])
  .filter('createdById', '=', userId)
  .limit(limit)
  .start(token);

 ds.runQuery(q, (err, entities, nextQuery) => {
  if (err) {
   cb(err);
   return;
  }
  const hasMore =
   nextQuery.moreResults !== Datastore.NO_MORE_RESULTS
    ? nextQuery.endCursor
    : false;
  cb(null, entities.map(fromDatastore), hasMore);
 });
}
