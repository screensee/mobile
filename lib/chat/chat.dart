import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:screensee/chat/chat_presenter.dart';
import 'package:screensee/chat/message.dart';
import 'package:screensee/cookie.dart';
import 'package:screensee/room.dart';

class Chat extends StatefulWidget {
  final Room room;

  Chat({Key key, this.room}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State<Chat> implements ChatView {
  final CookieStorage storage = CookieStorage();

  ChatPresenter presenter;

  List<Message> messages = List();
  ViewModel viewModel;

  TextEditingController textController;
  ScrollController scrollController;

  @override
  void initState() {
    presenter = ChatPresenter(storage);

    viewModel = ViewModel();
    textController = TextEditingController();

    presenter.initRoom(widget.room);

    presenter.view = this;

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
      controller: scrollController,
      reverse: true,
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
              enabled: !viewModel.messageProgress,
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
          viewModel.messageProgress
              ? CircularProgressIndicator()
              : IconButton(
                  icon: Icon(
                    Icons.send,
                    color:
                        viewModel.sendEnabled ? Colors.white : Colors.white54,
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
      viewModel.sendEnabled = false;
      presenter.sendMessage(value);
    });
  }

  @override
  void addMessage(Message message) {
    setState(() {
      messages.insert(0, message);

      textController.clear();

      viewModel.messageText = null;
      viewModel.messageProgress = false;
    });

    scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  @override
  void showChat(List<Message> messages) {
    setState(() {
      this.messages.addAll(messages.reversed);
    });
  }

  @override
  void showError() {}

  @override
  void showProgress() {}

  @override
  void showMessageProgress() {
    setState(() {
      viewModel.messageProgress = true;
    });
  }

  @override
  void hideMessageProgress() {
    setState(() {
      viewModel.messageProgress = false;
    });
  }
}

class ViewModel {
  String messageText;
  bool sendEnabled = false;
  bool messageProgress = false;
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
            color: Color(0xff333333),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message.text,
              softWrap: true,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
