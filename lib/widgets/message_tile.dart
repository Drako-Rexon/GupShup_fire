import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: widget.sentByMe
            ? const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(1.00, 0.00),
                  end: Alignment(-1, 0),
                  colors: [Color(0xFF008052), Color(0xFF0ADD9D)],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              )
            : ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
        //  BoxDecoration(
        //     borderRadius: widget.sentByMe
        //         ? const BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             topRight: Radius.circular(20),
        //             bottomLeft: Radius.circular(20),
        //           )
        //         : const BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             topRight: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //     color: widget.sentByMe
        //         ? Theme.of(context).primaryColor
        //         : Colors.grey[700]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: widget.sentByMe ? Colors.white : Colors.black54,
                  letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                color: widget.sentByMe ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
