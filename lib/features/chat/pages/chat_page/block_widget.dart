import 'package:clinic/features/chat/model/chatter_model.dart';
import 'package:clinic/features/chat/model/message_model.dart';
import 'package:clinic/features/chat/pages/message/message_widget.dart';
import 'package:clinic/global/widgets/containered_text.dart';
import 'package:flutter/material.dart';

class BlockWidget extends StatelessWidget {
  const BlockWidget({
    Key? key,
    required this.chatter1,
    required this.chatter2,
    this.message,
  }) : super(key: key);
  final MessageModel? message;
  final ChatterModel chatter1;
  final ChatterModel chatter2;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (message != null) ? MessageWidget(message: message!) : const SizedBox(),
        (chatter1.blocks)
            ? (chatter1.isBlocked)
                ? (chatter1.blocksTime!.toDate().isBefore(
                          chatter2.blocksTime!.toDate(),
                        ))
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const ContaineredText(
                                text: 'لقد قمت بإيقاف المراسلة'),
                            const SizedBox(
                              height: 5,
                            ),
                            ContaineredText(
                              text: 'قام ${chatter2.name} بإيقاف المراسلة',
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ContaineredText(
                              text: 'قام ${chatter2.name} بإيقاف المراسلة',
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const ContaineredText(
                              text: 'لقد قمت بإيقاف المراسلة',
                            ),
                          ],
                        ),
                      )
                : const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ContaineredText(
                      text: 'لقد قمت بإيقاف المراسلة',
                    ),
                  )
            : chatter1.isBlocked
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ContaineredText(
                      text: 'قام ${chatter2.name} بإيقاف المراسلة',
                    ),
                  )
                : const SizedBox(),
      ],
    );
  }
}
