import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'serverDataControl.dart';
import 'addGroup.dart';
import 'productList.dart';
import 'authController.dart';
import 'authScreen.dart';

class elementGroups extends StatefulWidget {

  final int currentUserId; //id пользователя
  const elementGroups({super.key, required this.currentUserId});

  @override
  _ElementGroupsState createState() => _ElementGroupsState();
}

class _ElementGroupsState extends State<elementGroups> {
  List<Map<String, dynamic>> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    setState(() {
      _isLoading = true;
    });
    try {
      //final groups = await ServerDataControl.getGroups();
      final groups = await ServerDataControl.getGroups(widget.currentUserId);
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching groups: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /*void _addNewGroup(Map<String, dynamic> newGroup) {
    setState(() {
      _groups.add(newGroup);
    });
  }*/

  // выйти из профиля
  Future<void> _logout() async {
    try {
      await AuthController.logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при выходе из профиля')),
      );
    }
  }

  // Копировать ID в буфер обмена
  void _copyIdToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.currentUserId.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ID скопирован в буфер обмена')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Активные группы"),
            GestureDetector(
              onTap: _copyIdToClipboard,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ваш личный ID: ${widget.currentUserId}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.copy,
                    size: 16,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          final group = _groups[index];
          final bool isOwner = ServerDataControl.isGroupOwner(
              group['id'],
              widget.currentUserId
          );

          return ListTile(
            title: Text(group['name']),
            subtitle: Row(
              children: [
                Text(group['isPublic'] ? 'Публичная' : 'Личная'),
                const SizedBox(width: 10),
                Text('• ${isOwner ? "Владелец" : "Участник"}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${group['members'].length}'),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => addGroup(
                          currentUserId: widget.currentUserId,
                          existingGroup: group,
                        ),
                      ),
                    );
                    if (result == true) {
                      _fetchGroups();
                    }
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    groupId: group['id'],
                    groupName: group['name'],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => addGroup(
                currentUserId: widget.currentUserId,
              ),
            ),
          );
          if (result == true) {
            _fetchGroups();
          }
        },
        label: const Text("Добавить"),
        icon: const Icon(Icons.add),
      ),
    );
  }

}




// СТАРОЕ
/*
class elementGroups extends StatelessWidget {
  var _value;
  DataControl dc = new DataControl();
  final _biggerFont = const TextStyle(fontSize: 28.0);
  elementGroups({var value}):_value = value;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Группы"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dc.getLength()*2,
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd) return Divider();
          final li = position ~/ 2;
          //return _listRow(context, li);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {btnPress(context);},
        label: Text("Добавить"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.lightGreenAccent,
        foregroundColor: Colors.black54,
        elevation: 10,
      ),
    );
  }

  */
/*Widget _listRow(BuildContext context, int i) {
    return ListTile(
      title: Text("${dc.GetItem(i)['login']}", style: _biggerFont),
      //onTap: () => Navigator.pushNamed(context, "/elementForm/$i"),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotesList(userId: i),
        ),
      ),

      //обновить

    );
  }*//*

  */
/*btnPress1(BuildContext context) {
  }*//*


  */
/*btnPress(BuildContext context) async {
    print("-------");
    await dc.addItem('Новый человек', '234');
    print("press " + "${dc.getLength()}");
    dc.printData();
    //было
    //Navigator.pushNamed(context, '/elementList/').then((value) => Navigator.pop(context));
    Navigator.pushNamed(context, '/elementGroups/${dc.getLength() - 1}');
  }*//*


  //добавленное


}
*/


