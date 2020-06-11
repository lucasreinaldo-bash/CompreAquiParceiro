import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:compreaquiparceiros/app/bloc/user_bloc.dart';
import 'package:compreaquiparceiros/app/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: "Pesquisar",
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none),
            onChanged: _userBloc.onChangedSearch,
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
              stream: _userBloc.outUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                    ),
                  );
                else if (snapshot.data.length == 0)
                  return Center(
                    child: Text(
                      "Nenhum usuário encontrado!",
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                  );
                else
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return UserTile(snapshot.data[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: snapshot.data.length);
              }),
        )
      ],
    );
  }
}
