class Annotation {
  const Annotation();
}

// @Annotation()
// class Data {
//   const Data(this.id);
//   final String id;
// }

// class DataRepository {
//   final _cache = <String, Data>{};

//   Data? getById(String id) => _cache[id];

//   void save(Data obj) => _cache[obj.id] = obj;
// }

// class Repository<T> {
//   Repository(this.getId);

//   final String Function(T) getId;

//   final _cache = <String, T>{};

//   T? getById(String id) => _cache[id];

//   void save(T obj) => _cache[getId(obj)] = obj;
// }

// final dataRepo = Repository<Data>(
//   (data) => data.id,
// );
