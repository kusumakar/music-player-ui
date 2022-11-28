class Album {
  final String id;
  final String singer;
  final String albumName;
  final String albumImage;
  final List<String> albumList;

  Album({
    required this.id,
    required this.singer,
    required this.albumName,
    required this.albumImage,
    this.albumList = const [""],
  });
  static final albums = [
    Album(id: "1", singer: "Gryffin", albumName: "Mp3 Songs Collection", albumImage: "gryffin_alive.jpg"),
    Album(id: "2", singer: "Jin", albumName: "New English Songs", albumImage: "jin_the_astronaut.jpg"),
    Album(id: "3", singer: "Black Eyed Peas", albumName: "Mp3 Songs Collection", albumImage: "black_eyed_peas_simply_the_best.jpg"),
    Album(id: "4", singer: "Imanbek, Jay Sean", albumName: "New English Songs", albumImage: "imanbek_jay_sean_gone_da_da.jpg"),
  ];
}

class RelatedAlbum {
  final String singer;
  final String albumName;
  final String albumImage;

  RelatedAlbum(
      {required this.singer,
      required this.albumName,
      required this.albumImage});
}

class Category {
  final String name;
  final bool selected;
  Category({required this.name, this.selected = false});
  static final category = [
    Category(name: "Rock", selected: true),
    Category(name: "Soul"),
    Category(name: "Reggae"),
    Category(name: "Funky")
  ];
}
