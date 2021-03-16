class Categorias {
  String id_categoria;
  String cat_descricao;

  Categorias(String id_categoria, String cat_descricao) {
    this.id_categoria = id_categoria;
    this.cat_descricao = cat_descricao;
  }

  Categorias.fromJson(Map json)
      : id_categoria = json['id_categoria'],
        cat_descricao = json['cat_descricao'];
  Map toJson() {
    return {'id_categoria': id_categoria, 'cat_descricao': cat_descricao};
  }
}
