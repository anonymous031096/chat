import 'dart:convert';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fchat/custom_ui/own_message_card.dart';
import 'package:fchat/custom_ui/reply_card.dart';
import 'package:fchat/models/chat_model.dart';
import 'package:fchat/models/message_model.dart';
import 'package:fchat/storage/jwt_data.dart';
import 'package:fchat/utils/message_service.dart';
import 'package:fchat/utils/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

class IndividualPage extends StatefulWidget {
  IndividualPage({super.key, required this.chatModel});
  ChatModel chatModel;

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;
  FocusNode myFocusNode = FocusNode();
  final SocketService _socketService = SocketService();
  final JwtData _jwtData = JwtData();
  bool sendButton = false;
  List<MessageModel> messages = [];
  final ScrollController _scrollController = ScrollController();
  final MessageService _messageService = MessageService();

  _onEmojiSelected(Emoji emoji) {
    print('_onEmojiSelected: ${emoji.emoji}');
  }

  _onBackspacePressed() {
    print('_onBackspacePressed');
  }

  sendMessage(String message) {
    setMessage("source", message);
    _socketService.socket.emit("SEND_MESSAGE", {
      "message": message,
      "senderId": _jwtData.id,
      "receiverId": widget.chatModel.id
    });
  }

  setMessage(String type, String message) {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent + 55,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    MessageModel messageModel = MessageModel(type: type, message: message);
    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  void initState() {
    super.initState();
    _socketService.socket.on("RECEIVE_MESSAGE", (data) {
      setMessage("destination", data["message"]);
    });
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        setState(() {
          emojiShowing = false;
        });
      }
    });
    getMessage();
  }

  getMessage() async {
    Response response = await _messageService.getMessage(
      _jwtData.id,
      widget.chatModel.id,
    );
    var responseBody = jsonDecode(response.body) as List<dynamic>;
    List<MessageModel> ms = [];
    for (var element in responseBody) {
      ms.add(
        MessageModel(
          type: element['sender'] == _jwtData.id ? "source" : "destination",
          message: element['message'],
        ),
      );
    }
    setState(() {
      messages.addAll(ms);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                      child: SvgPicture.asset(
                        widget.chatModel.isGroup
                            ? "assets/groups.svg"
                            : "assets/person.svg",
                        color: Colors.white,
                        height: 36,
                        width: 36,
                      ),
                    )
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatModel.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "last seen today at 12:00",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: "View contact",
                        child: Text("View contact"),
                      ),
                      const PopupMenuItem(
                        value: "Media, links and docs",
                        child: Text("Media, links and docs"),
                      ),
                      const PopupMenuItem(
                        value: "Whatsapp web",
                        child: Text("Whatsapp web"),
                      ),
                      const PopupMenuItem(
                        value: "Search",
                        child: Text("Search"),
                      ),
                      const PopupMenuItem(
                        value: "Mute notification",
                        child: Text("Mute notification"),
                      ),
                      const PopupMenuItem(
                        value: "Wallpaper",
                        child: Text("Wallpaper"),
                      ),
                    ];
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      if (messages[index].type == "source") {
                        return OwnMessageCard(messageModel: messages[index]);
                      } else {
                        return ReplyCard(messageModel: messages[index]);
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      child: Card(
                        margin:
                            const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: TextFormField(
                          focusNode: myFocusNode,
                          controller: _controller,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty && !sendButton) {
                              setState(() {
                                sendButton = true;
                              });
                            } else if (value.isEmpty) {
                              setState(() {
                                sendButton = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message",
                              prefixIcon: IconButton(
                                  onPressed: () {
                                    myFocusNode.unfocus();
                                    myFocusNode.canRequestFocus = false;
                                    setState(() {
                                      emojiShowing = !emojiShowing;
                                    });
                                  },
                                  icon: const Icon(Icons.emoji_emotions)),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (builder) =>
                                                bottomSheet());
                                      },
                                      icon: const Icon(Icons.attach_file)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.camera_alt)),
                                ],
                              ),
                              contentPadding: const EdgeInsets.all(5)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, right: 5, left: 2),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color(0xFF128C7E),
                        child: sendButton
                            ? IconButton(
                                onPressed: () {
                                  sendMessage(_controller.text);
                                  _controller.clear();
                                },
                                icon:
                                    const Icon(Icons.send, color: Colors.white))
                            : IconButton(
                                onPressed: () {},
                                icon:
                                    const Icon(Icons.mic, color: Colors.white)),
                      ),
                    )
                  ],
                ),
                Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                    height: 300,
                    child: EmojiPicker(
                      textEditingController: _controller,
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          replaceEmojiOnLimitExceed: false,
                          noRecents: const Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  const SizedBox(width: 40),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  const SizedBox(width: 40),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  const SizedBox(width: 40),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  const SizedBox(width: 40),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
