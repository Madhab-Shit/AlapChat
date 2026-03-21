import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traychat/chatimageshow.dart';
import 'package:traychat/chatprofile.dart';
import 'package:traychat/controller/chatcontroller.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:traychat/controller/voicechat.dart';
import 'package:traychat/galleryacess.dart';
import 'package:traychat/screen/contact/ui/catactnumber.dart';
import 'package:traychat/screen/location/ui/location.dart';
import 'package:traychat/screen/viewmessagecontact/ui/contectview.dart';

class Chat extends StatefulWidget {
  final String myid;
  final String otherUserId;
  final String profileicon;
  const Chat({
    super.key,
    required this.myid,
    required this.otherUserId,
    required this.profileicon,
  });

  @override
  State<Chat> createState() => _ChatState();
}

chatcontroller chat = Get.put(chatcontroller());

class _ChatState extends State<Chat> {
  Getx getx = Get.find<Getx>();
  Voicechat voice = Get.put(Voicechat());

  final TextEditingController sendsms = TextEditingController();

  final FirebaseFirestore chartdata = FirebaseFirestore.instance;

  FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    chat.time?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F0EA),
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: Text(widget.profileicon, style: TextStyle(fontSize: 25)),
            ),
            SizedBox(width: 10),
            Text(widget.otherUserId),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuEntry>[PopupMenuItem(child: Text("data"))];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: StreamBuilder(
                stream: chat.showmessage(widget.myid, widget.otherUserId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: Text("No Message"));
                  var data = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      bool isMe = data[index]['sender'] == widget.myid;
                      return Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: isMe ? Color(0xffD9FDD3) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              // ...
                              child: data[index]['type'] == 'image'
                                  ? InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => Chatimageshow(
                                            imagepath: data[index]['message'],
                                            imageid: isMe,
                                            otherid: widget.otherUserId,
                                          ),
                                        );
                                      },
                                      // child: con(data[index]['message']),
                                      child: Container(
                                        height: 200,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              data[index]['message'],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : data[index]['type'] == 'contact'
                                  ? InkWell(
                                      onTap: () {
                                        Get.to(
                                          Contectview(
                                            name: data[index]['message'],
                                            phone: data[index]['Phone'],
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            spacing: 10,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircleAvatar(
                                                child: Text(
                                                  data[index]['message']
                                                      .toString()
                                                      .split("")
                                                      .first,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                data[index]['message'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff1B8554),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),

                                          Text(
                                            "View",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff1B8554),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : data[index]['type'] == 'voice'
                                  ? SizedBox(
                                      width: 150,
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => InkWell(
                                              onTap: () {
                                                voice.playAudio(
                                                  data[index]['message'],
                                                  index,
                                                );

                                                if (chat.playindes.value ==
                                                    index) {
                                                  chat.playpush.value =
                                                      !chat.playpush.value;
                                                } else {
                                                  // new item → previous stop
                                                  chat.playindes.value = index;
                                                  chat.playpush.value = true;
                                                }
                                              },
                                              child:
                                                  chat.playindes.value ==
                                                          index &&
                                                      chat.playpush.value
                                                  ? InkWell(
                                                      onTap: () {
                                                        voice.stopAudio();
                                                        chat.playpush.value =
                                                            false;
                                                      },
                                                      child: Icon(
                                                        Icons.pause,
                                                        size: 30,
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.play_arrow,
                                                      size: 30,
                                                    ),
                                            ),
                                          ),

                                          Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                  child: Obx(() {
                                                    if (voice
                                                            .playingIndex
                                                            .value !=
                                                        index) {
                                                      return Container(
                                                        height: 20,
                                                        width:
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            .5,
                                                        color: Colors
                                                            .transparent, // ⭐ empty look when not playing
                                                      );
                                                    }

                                                    return AudioFileWaveforms(
                                                      size: Size(
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            .5,
                                                        60,
                                                      ),
                                                      playerController: voice
                                                          .playerController,
                                                      playerWaveStyle:
                                                          PlayerWaveStyle(
                                                            fixedWaveColor:
                                                                Colors
                                                                    .grey
                                                                    .shade400,
                                                            liveWaveColor:
                                                                Colors.blue,
                                                            spacing: 5,
                                                            waveThickness: 3,
                                                          ),
                                                    );
                                                  }),
                                                ),
                                                SizedBox(height: 5),
                                                Obx(() {
                                                  final total = Duration(
                                                    milliseconds: voice
                                                        .totalDuration
                                                        .value,
                                                  );
                                                  final current = Duration(
                                                    milliseconds: voice
                                                        .currentDuration
                                                        .value,
                                                  );

                                                  String t =
                                                      "${total.inMinutes}:${(total.inSeconds % 60).toString().padLeft(2, '0')}";
                                                  String c =
                                                      "${current.inMinutes}:${(current.inSeconds % 60).toString().padLeft(2, '0')}";

                                                  return Text(
                                                    "$c / $t",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      data[index]['message'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Row(
                      children: [
                        // getx.showEmoji.value
                        //     ? InkWell(
                        //       onTap: () {
                        //         getx.showEmoji.value = !getx.showEmoji.value;
                        //       },
                        //       child: Icon(Icons.keyboard))
                        //     : Icon(Icons.emoji_emotions_outlined),
                        InkWell(
                          onTap: () {
                            if (!getx.showEmoji.value) {
                              FocusScope.of(context).unfocus();
                            } else {
                              focusNode.requestFocus();
                            }
                            setState(() {
                              getx.showEmoji.value = !getx.showEmoji.value;
                            });
                          },
                          child: Obx(
                            () => chat.voice.value
                                ? Icon(Icons.mic, color: Colors.red)
                                : Icon(
                                    getx.showEmoji.value
                                        ? Icons.keyboard
                                        : Icons.emoji_emotions_outlined,
                                  ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Obx(
                            () => chat.voice.value
                                ? Container(
                                    constraints: BoxConstraints(
                                      minHeight: 50,
                                      maxHeight: 80,
                                    ),
                                    child: AudioWaveforms(
                                      recorderController:
                                          voice.recorderController,
                                      size: Size(
                                        MediaQuery.of(context).size.width,
                                        60,
                                      ),
                                      waveStyle: const WaveStyle(
                                        waveColor: Colors.blue,
                                        showMiddleLine: false,
                                      ),
                                    ),
                                  )
                                : TextFormField(
                                    controller: sendsms,

                                    decoration: const InputDecoration(
                                      hintText: "Message",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      chat.chat.value = value.isNotEmpty;
                                    },
                                  ),
                          ),
                        ),
                        chat.voice.value
                            ? Text(TimeOfDay.now().format(context))
                            : InkWell(
                                onTap: () {
                                  attechfile(
                                    context,
                                    widget.myid,
                                    widget.otherUserId,
                                  );
                                },
                                child: Icon(Icons.attach_file_outlined),
                              ),
                        SizedBox(width: 15),
                        chat.voice.value
                            ? Text("")
                            : InkWell(
                                onTap: () {
                                  cameraopen(widget.myid, widget.otherUserId);
                                },
                                child: Icon(Icons.camera_alt_outlined),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Obx(
                  () => CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.green,
                    child: chat.chat.value
                        ? InkWell(
                            onTap: () {
                              chat.chatdata(
                                widget.myid,
                                widget.otherUserId,
                                sendsms.text.toString(),
                              );
                              sendsms.clear();
                              chat.chat.value = false;
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 26,
                            ),
                          )
                        : InkWell(
                            // onLongPress: () {
                            //   chat.timer();
                            //   chat.voice.value = true;
                            // },
                            // onLongPressUp: () {
                            //   chat.time.cancel();
                            //   chat.countvoice.value = 0;
                            //   chat.voice.value = false;
                            // },
                            onTapDown: (details) {
                              // log("message");
                              chat.timer();
                              chat.voice.value = true;
                              // chat.startListening();
                              voice.startRecord();
                            },
                            onTapUp: (details) async {
                              chat.time?.cancel();

                              chat.voice.value = false;
                              // chat.stopListening(
                              //   widget.myid,
                              //   widget.otherUserId,
                              // );
                              voice.stopRecord(widget.myid, widget.otherUserId);
                            },
                            onTapCancel: () {
                              chat.time?.cancel();
                              chat.countvoice.value = 0;
                              chat.voice.value = false;
                            },
                            child: Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          if (getx.showEmoji.value)
            SizedBox(
              height: 280,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  sendsms.text += emoji.emoji;
                  chat.chat.value = true;
                },
              ),
            ),
        ],
      ),
    );
  }
}

void attechfile(BuildContext context, String myid, String otherid) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        height: 200,
        padding: EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 4,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();

                chat.pickImage(context, myid, otherid);
              },
              child: attechfilecategory(
                Icon(Icons.photo, color: Colors.blue, size: 25),
                "Gallery",
              ),
            ),
            GestureDetector(
              onTap: () {
                cameraopen(myid, otherid);
                Get.back();
              },
              child: attechfilecategory(
                Icon(Icons.camera_alt, color: Colors.pink, size: 25),
                "Camera",
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.off(() => Location());
              },
              child: attechfilecategory(
                Icon(Icons.location_on, color: Colors.green, size: 25),
                "Location",
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.to(() => Catactnumber(myid: myid, otherid: otherid));
              },
              child: attechfilecategory(
                Icon(Icons.person, color: Colors.blueAccent, size: 25),
                "Contact",
              ),
            ),
            GestureDetector(
              onTap: () async {
                chat.pickAndViewFile();
              },
              child: attechfilecategory(
                Icon(
                  Icons.insert_drive_file,
                  color: Colors.blueAccent,
                  size: 25,
                ),
                "Document",
              ),
            ),
            attechfilecategory(
              Icon(Icons.headphones, color: Colors.blueAccent, size: 25),
              "Audio",
            ),
          ],
        ),
      );
    },
  );
}

Future<void> cameraopen(String myid, String otherid) async {
  final XFile? photo = await getx.opencamera.pickImage(
    source: ImageSource.camera,
  );

  if (photo == null) {
    return;
  } else if (photo.path.isNotEmpty) {
    chat.file = File(photo.path);
    Get.to(() => GalleryPickerPage(myid: myid, otherid: otherid));

    // chat.chatimage(myid, otherid, photo.path);
  }
}

Widget attechfilecategory(Icon icons, String name) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(64, 0, 0, 0),
              offset: Offset(0, 1),
              blurRadius: 5,
            ),
          ],
        ),
        child: icons,
      ),
      SizedBox(height: 5),
      Text(name, style: TextStyle(fontWeight: FontWeight.w400)),
    ],
  );
}

void galleryasscess(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(height: 200);
    },
  );
}

// Future<String> decodeimage()
// {
//   return
// }

Widget con(String imagepath) {
  Uint8List bytes = base64Decode(imagepath);

  return Image.memory(
    bytes,
    width: 100, // Optional: Set desired width
    height: 100, // Optional: Set desired height
    fit: BoxFit.cover, // Optional: Adjust the fit
  );
}
