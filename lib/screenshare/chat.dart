import 'package:flutter/material.dart';
import 'package:screensee/screenshare/message.dart';

class Chat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Message> messages = List();
  ViewModel viewModel;

  TextEditingController textController;

  @override
  void initState() {
    viewModel = ViewModel();
    textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child:
              Align(alignment: Alignment.bottomCenter, child: _buildChatList()),
        ),
        _buildEdit(),
      ],
    );
  }

  _buildChatList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ChatItem(messages[index]);
      },
      itemCount: messages.length,
    );
  }

  _buildEdit() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: textController,
              onChanged: (value) {
                setState(() {
                  viewModel.messageText = value;
                  viewModel.sendEnabled = value.isNotEmpty;
                });
              },
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Message",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: viewModel.sendEnabled ? Colors.white : Colors.white54,
            ),
            onPressed: viewModel.sendEnabled
                ? () {
                    _send(viewModel.messageText);
                  }
                : null,
          )
        ],
      ),
    );
  }

  _send(String value) {
    setState(() {
      messages.add(Message(value));
      textController.clear();
      viewModel.sendEnabled = false;
      viewModel.messageText = null;
    });
  }
}

class ViewModel {
  String messageText;
  bool sendEnabled = false;
}

class ChatItem extends StatelessWidget {
  final Message message;

  const ChatItem(this.message, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: Color(0xff1a1a1a),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message.message,
              softWrap: true,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
