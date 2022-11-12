import 'database_helper.dart';
import 'item_model.dart';

class ItemHelper {
  final dbHelper = DatabaseHelper.instance;
  List itemList = <ItemModel>[
    // ItemModel(1, 'apad', 70, 'Edibles'),
    // ItemModel(2, 'epad', 20, 'Edibles'),
    // ItemModel(3, 'epad', 30, 'Edibles'),
    // ItemModel(4, 'epad', 40, 'Edibles'),
    // ItemModel(5, 'apad', 50, 'Edibles'),
    // ItemModel(6, 'apad', 70, 'Edibles'),
    // ItemModel(7, 'apad', 20, 'Edibles'),
    // ItemModel(8, 'bpad', 30, 'Edibles'),
    // ItemModel(9, 'bpad', 40, 'Edibles'),
    // ItemModel(10, 'bpad', 50, 'Edibles'),
    // ItemModel(11, 'dado', 80, 'Household Products'),
    // ItemModel(12, 'cpado', 60, 'Bathing Products'),
    // ItemModel(13, 'eado', 30, 'Edibles'),
    // ItemModel(14, 'gado', 40, 'Household Products'),
    // ItemModel(15, 'fado', 20, 'Bathing Products'),
    // ItemModel(16, 'bpado', 10, 'Bathing Products')
  ];

  List initialSort() {
    List<ItemModel> finalList = [], edible = [], household = [], product = [];
    for (var item in itemList) {
      if (item.category == 'Edibles') {
        edible.add(item);
      } else if (item.category == 'Household Products') {
        household.add(item);
        print("household true");
      } else if (item.category == 'Bathing Products') {
        product.add(item);
      }
    }
    print("____sort list___");
    print(itemList.length);
    for (var element in itemList) {
      print(element.itemName);
    }
    edible = sortByNameAndUnit(edible);
    household = sortByNameAndUnit(household);
    product = sortByNameAndUnit(product);

    finalList.addAll(edible);
    finalList.addAll(household);
    finalList.addAll(product);

    // for (var item in itemList) {
    //   print("${item.category} ${item.itemName}");
    // }
    itemList = finalList;

    for (var pado in itemList) {
      // print(pado);
      print("asfter sort ${pado.itemName} ${pado.unit} ${pado.category}");
    }
    return itemList;
  }

  List<ItemModel> sortByNameAndUnit(List<ItemModel> list) {
    List<ItemModel> tempLetterList = [], tempProductList = [];
    int alphaCount = 0;
    int index = 0;
    if (list.length > 1) {
      list.sort((itemA, itemB) =>
          itemA.itemName.toLowerCase().compareTo(itemB.itemName.toLowerCase()));

      for (int i = 97; i <= 122; i++) {
        for (int j = 0; j < list.length; j++) {
          if (list[j].itemName.codeUnitAt(0) == i) {
            alphaCount++;
          }
        }

        if (alphaCount != 0) {
          tempLetterList = list.sublist(index, index + alphaCount);
          tempLetterList
              .sort((itemA, itemB) => itemA.unit.compareTo(itemB.unit));
          tempProductList.addAll(tempLetterList);

          index = index + alphaCount;
          alphaCount = 0;
        }
      }
      list = tempProductList;
    }

    return list;
  }

  Future<int> insert(itemName, category, units) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnItemName: itemName,
      DatabaseHelper.columnCategory: category,
      DatabaseHelper.columnUnits: units,
    };
    final id = await dbHelper.insert(row);
    // print('inserted row id: $id');
    return id;
  }

  Future<void> query() async {
    String itemName, category;
    dynamic units;
    int id;
    final allRows = await dbHelper.queryAllRows();
    for (var dbMapObject in allRows) {
      id = dbMapObject['_id'];
      itemName = dbMapObject['item_name'];
      category = dbMapObject['category'];
      if (dbMapObject['units'].runtimeType == String) {
        units = int.parse(dbMapObject['units']);
      } else {
        units = dbMapObject['units'];
      }

      itemList.add(ItemModel(id, itemName, units, category));

      // print('me ${units.runtimeType}');
    }

    // for (var pado in itemList) {
    //   print(pado);
    //   print("${pado.itemName} ${pado.unit} ${pado.category}");
    // }

    for (var pado in allRows) {
      print(pado);
      // print("${pado.itemName} ${pado.unit} ${pado.category}");
    }
  }

  Future<void> queryLastRow(int id) async {
    String itemName, category;
    dynamic units;
    int itemId;
    final lastRow = await dbHelper.queryRow(id);
    for (var dbMapObject in lastRow) {
      itemId = dbMapObject['_id'];
      itemName = dbMapObject['item_name'];
      category = dbMapObject['category'];
      units = dbMapObject['units'];

      itemList.add(ItemModel(itemId, itemName, units, category));

      // print('me ${units.runtimeType}');
    }

    print(lastRow);

    // for (var pado in lastRow) {
    //   print(pado);
    //   // print("${pado.itemName} ${pado.unit} ${pado.category}");
    // }
  }
  // print("____query list___");
  // print(itemList.length);

  // for (var pado in itemList) {
  //   // print(pado);
  //   print("${pado.itemName} ${pado.unit} ${pado.category}");
  // }

  Future<void> update(
      int id, int index, itemName, itemCategory, itemUnits) async {
    print(
        "update function ${id} ${index} ${itemName} ${itemCategory} ${itemUnits} ");
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnItemName: itemName,
      DatabaseHelper.columnCategory: itemCategory,
      DatabaseHelper.columnUnits: itemUnits
    };
    final rowsAffected = await dbHelper.update(row);

    itemList.add(ItemModel(id, itemName, itemUnits, itemCategory));

    // ItemModel(id, itemName, itemUnits, itemCategory);
    print('updated $rowsAffected row(s)');
  }

  Future<void> delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    // final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  Future<void> delete2() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete2();
    print('deleted $rowsDeleted row(s): row $id');
  }
} // class end

